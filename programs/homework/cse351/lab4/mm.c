/*-------------------------------------------------------------------
 *  UW CSE 351 Sprint 2010 Lab 7 Starter code: 
 *        single doubly-linked free block list with LIFO policy
 *        with support for coalescing adjacent free blocks
 *
 * Terminology:
 * We use "next" and "previous" to refer to blocks as ordered in the
 * free list.
 * We use "following" and "preceding" to refer to adjacent blocks in
 * memory.
 *-------------------------------------------------------------------- */

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>

#include "memlib.h"
#include "mm.h"

/* Alignment of blocks returned by mm_malloc. */
#define ALIGNMENT 8

/* Size of a word on this architecture. */
#define WORD_SIZE sizeof(void*)

/* Macros for pointer arithmetic to keep other code cleaner.  Casting
   to a char* has the effect that pointer arithmetic happens at the
   byte granularity (i.e. POINTER_ADD(0x1, 1) would be 0x2).  (By
   default, incrementing a pointer in C has the effect of incrementing
   it by the size of the type to which it points (e.g. BlockInfo).) */
#define POINTER_ADD(p,x) ((char*)p + x) 
#define POINTER_SUB(p,x) ((char*)p - x)


/******** FREE LIST IMPLEMENTATION ***********************************/


/* A BlockInfo contains information about a block, including the size
   and usage tags, as well as pointers to the next and previous blocks
   in the free list. 
   
   Note that the next and prev pointers are only needed when the block
   is free.  To achieve better utilization, mm_malloc would use the
   space for next and prev as part of the space it returns.

   +-------------+
   | sizeAndTags |  <-  BlockInfo pointers in free list point here
   +-------------+
   |     next    |  <-  Pointers returned by mm_malloc point here
   +-------------+
   |     prev    |
   +-------------+
   |    space    |
   |     ...     |
*/
struct BlockInfo {
  /* Size of the block (log(ALIGNMENT) high bits) and tags for whether
     the block and its predecessor in memory are in use. */
  int sizeAndTags;
  // Pointer to the next block in the free list.
  struct BlockInfo* next;
  // Pointer to the previous block in the free list.
  struct BlockInfo* prev;
};
typedef struct BlockInfo BlockInfo;


/* Pointer to the first BlockInfo in the free list, the list's
   head. You can treat this as a BlockInfo*.
   
   A pointer to the head of the free list in this implementation is
   always stored in the first word in the heap.  mem_heap_lo() returns
   a pointer to the first word in the heap, so we cast the result of
   mem_heap_lo() to a BlockInfo** (a pointer to a pointer to
   BlockInfo) and dereference this to get a pointer to the first
   BlockInfo in the free list. */
#define FREE_LIST_HEAD *((BlockInfo **)mem_heap_lo())


/* Minimum block size (to account for size header, next ptr, prev ptr,
   and boundary tag) */
#define MIN_BLOCK_SIZE 4*WORD_SIZE

/* SIZE(x) selects just the higher bits of x to ensure that it is
   properly aligned.  Additionally, the low bits of the sizeAndTags
   member are used to tag a block as free/used, etc. */
#define SIZE(x) (x & ~(ALIGNMENT - 1))

/* TAG_USED is the bit mask used in sizeAndTags to mark a block as
   used. */
#define TAG_USED 1 

/* TAG_PRECEDING_USED is the bit mask used in sizeAndTags to indicate
   that the block preceding it in memory is used. (used in turn for
   coalescing) */
#define TAG_PRECEDING_USED 2



/* Find a free block of the requested size in the free list.  Returns
   NULL if no free block is large enough. */
static void * searchFreeList(int reqSize) {   
  BlockInfo* freeBlock;

  freeBlock = FREE_LIST_HEAD;
  while (freeBlock != NULL){
	if (SIZE(freeBlock->sizeAndTags) >= reqSize) {
      return freeBlock;
	} else {
      freeBlock = freeBlock->next;
	}
  }
  return NULL;
}

           
/* Insert freeBlock at the head of the list.  (LIFO) */
static void insertFreeBlock(BlockInfo* freeBlock) {
  BlockInfo* oldHead = FREE_LIST_HEAD;
  freeBlock->next = oldHead;
  if (oldHead != NULL) {
	oldHead->prev = freeBlock;
  }
  //  freeBlock->prev = NULL;
  FREE_LIST_HEAD = freeBlock;
}      

/* Remove a free block from the free list. */
static void removeFreeBlock(BlockInfo* freeBlock) {
  BlockInfo *nextFree, *prevFree;
  
  nextFree = freeBlock->next;
  prevFree = freeBlock->prev;

  // If the next block is not null, patch its prev pointer.
  if (nextFree != NULL) {
	nextFree->prev = prevFree;
  }

  // If we're removing the head of the free list, set the head to be
  // the next block, otherwise patch the previous block's next pointer.
  if (freeBlock == FREE_LIST_HEAD) {
    FREE_LIST_HEAD = nextFree;
  } else {
	prevFree->next = nextFree;
  }
}



static void coalesceFreeBlock(BlockInfo* oldBlock) {
  BlockInfo *blockCursor;
  BlockInfo *newBlock;
  BlockInfo *freeBlock;
  // size of old block
  int oldSize = SIZE(oldBlock->sizeAndTags);
  // running sum to be size of final coalesced block
  int newSize = oldSize;

  // Coalesce with any preceding free block
  blockCursor = oldBlock;

  while ((blockCursor->sizeAndTags & TAG_PRECEDING_USED)==0) { 
	// While the block preceding this one in memory (not the
	// prev. block in the free list) is free:

	// Get the size of the previous block from its boundary tag.
	int size = SIZE(*((int*)POINTER_SUB(blockCursor, WORD_SIZE)));
	// Use this size to find the block info for that block.
	freeBlock = (BlockInfo*)POINTER_SUB(blockCursor, size);
	// Remove that block from free list.

	removeFreeBlock(freeBlock);

	// Count that block's size and update the current block pointer.
	newSize += size;
	blockCursor = freeBlock;
  }
  newBlock = blockCursor;

  // Coalesce with any following free block.
  // Start with the block following this one in memory
  blockCursor = (BlockInfo*)POINTER_ADD(oldBlock, oldSize);
  while ((blockCursor->sizeAndTags & TAG_USED)==0) {
	// While the block is free:

	int size = SIZE(blockCursor->sizeAndTags);
	// Remove it from the free list.
	removeFreeBlock(blockCursor);
	// Count its size and step to the following block.
	newSize += size;
	blockCursor = (BlockInfo*)POINTER_ADD(blockCursor, size);
  }
  
  // If the block actually grew, remove the old entry from the free
  // list and add the new entry.
  if (newSize != oldSize) {
	// Remove the original block from the free list
	removeFreeBlock(oldBlock);

	// Save the new size in the block info and in the boundary tag
	// and tag it to show the preceding block is used (otherwise, it
	// would have become part of this one!).
	newBlock->sizeAndTags = newSize | TAG_PRECEDING_USED;
    // The boundary tag of the preceding block is the word immediately
    // preceding block in memory where we left off advancing blockCursor.
	*(int*)POINTER_SUB(blockCursor, WORD_SIZE) = newSize | TAG_PRECEDING_USED;  

	// Put the new block in the free list.
	insertFreeBlock(newBlock);
  }
  return;
}

/* Get more heap space of size at least reqSize. */
static void requestMoreSpace(int reqSize) {
  int pagesize = mem_pagesize();
  int numPages = (reqSize + pagesize - 1) / pagesize;
  BlockInfo *newBlock;
  int totalSize = numPages * pagesize;
  unsigned int prevLastWordMask;

  void* mem_sbrk_result = mem_sbrk(totalSize);
  if ((int)mem_sbrk_result == -1) {
	printf("ERROR: mem_sbrk failed in requestMoreSpace\n");
	exit(0);
  }
  newBlock = (BlockInfo*)POINTER_SUB(mem_sbrk_result, WORD_SIZE);

  /* initialize header, inherit TAG_PRECEDING_USED status from the
     previously useless last word however, reset the fake TAG_USED
     bit */
  prevLastWordMask = newBlock->sizeAndTags & TAG_PRECEDING_USED;
  newBlock->sizeAndTags = totalSize | prevLastWordMask;
  // Initialize boundary tag.
  ((BlockInfo*)POINTER_ADD(newBlock, totalSize - WORD_SIZE))->sizeAndTags = 
    totalSize | prevLastWordMask;

  /* initialize "new" useless last word
     the previous block is free at this moment
     but this word is useless, so its use bit is set
	 This trick lets us do the "normal" check even at the end of
	 the heap and avoid a special check to see if the following
	 block is the end of the heap... */
  *((int*)POINTER_ADD(newBlock, totalSize)) = TAG_USED;

  // Add the new block to the free list and immediately coalesce newly
  // allocated memory space
  insertFreeBlock(newBlock);
  coalesceFreeBlock(newBlock);
}


int mm_init () {
  // Head of the free list.
  BlockInfo *firstFreeBlock;
  // Initial heap size: WORD_SIZE byte header (stores pointer to head
  // of free list), MIN_BLOCK_SIZE bytes of space, WORD_SIZE byte footer.
  int initsize = WORD_SIZE+MIN_BLOCK_SIZE+WORD_SIZE;

  int totalSize;

  void* mem_sbrk_result = mem_sbrk(initsize);
  //  printf("mem_sbrk returned %p\n", mem_sbrk_result);
  if ((int)mem_sbrk_result == -1) {
	printf("ERROR: mem_sbrk failed in mm_init, returning %p\n", 
           mem_sbrk_result);
	exit(1);
  }

  firstFreeBlock = (BlockInfo*)POINTER_ADD(mem_heap_lo(), WORD_SIZE);

  // total usable size is full size minus header and footer words.
  totalSize = initsize - WORD_SIZE - WORD_SIZE;
  // initialize the free block
  firstFreeBlock->sizeAndTags = totalSize | TAG_PRECEDING_USED;
  firstFreeBlock->next = NULL;
  firstFreeBlock->prev = NULL;
  // boundary tag
  *((int*)POINTER_ADD(firstFreeBlock, totalSize - WORD_SIZE)) = totalSize | TAG_PRECEDING_USED;
  
  // Tag "useless" word at end of heap as used.
  *((int*)POINTER_SUB(mem_heap_hi(), 3)) = TAG_USED;

  // set the head of the free list to this new free block.
  FREE_LIST_HEAD = firstFreeBlock;
  return 0;
}


// TOP-LEVEL ALLOCATOR INTERFACE ------------------------------------



/* Allocate a block of size size and return a pointer to it. */
/* This is done by first retrieving a block of free space from the 
 * list of free space. The heap is increased accordingly. Depending
 * on the size of the block, the block will be split and extra space
 * will be returned to the list. */
void* mm_malloc (size_t size) {
  int reqSize;
  BlockInfo * ptrFreeBlock = NULL;

  // Zerp-size requests get NULL.
  if (size == 0) {
	return NULL;
  }

  // Add one word for the initial size header.
  size += WORD_SIZE;
  if (size <= MIN_BLOCK_SIZE) {
	// Minimum size... one for next, one for prev, one for
	// boundary tag, one for the size header.
	reqSize = MIN_BLOCK_SIZE;
  } else {
	// Round up for correct alignment
	reqSize = ALIGNMENT * ((size + ALIGNMENT - 1) / ALIGNMENT);
  }

  // Implement mm_malloc.  You can change or remove any of the above
  // code.  It is included as a suggestion of where to start.
  // You will want to replace this return statement...

  // Retrieves a BlockInfo with at least reqSize. If there are no BlockInfo
  // with enough space, then the heap is increased by reqSize.
  ptrFreeBlock = searchFreeList(reqSize);
  if (ptrFreeBlock == NULL) {
	  requestMoreSpace(reqSize);
  	  ptrFreeBlock = searchFreeList(reqSize);
  }
  removeFreeBlock(ptrFreeBlock);
  
  // If extra space in the block is less than the minimum block size, then
  // the entire block is returned for usage.
  if (SIZE(ptrFreeBlock->sizeAndTags) - reqSize < MIN_BLOCK_SIZE) {
     BlockInfo * followingBlock;

	  // If the list is empty, then add a new free block of minimim size from heap.
	  if (FREE_LIST_HEAD == NULL) {
		  // Sets tag at end of heap, so new block from extra heap will have this tag.
		  *((int*)POINTER_SUB(mem_heap_hi(), 7)) = TAG_PRECEDING_USED;
		  requestMoreSpace(MIN_BLOCK_SIZE);
	  }
	  
	  followingBlock = POINTER_ADD(ptrFreeBlock, SIZE(ptrFreeBlock->sizeAndTags));
	  followingBlock->sizeAndTags = followingBlock->sizeAndTags | TAG_PRECEDING_USED;
	  ptrFreeBlock->sizeAndTags = ptrFreeBlock->sizeAndTags | TAG_USED;
	  return POINTER_ADD(ptrFreeBlock, WORD_SIZE);
  }

  BlockInfo * extraBlock;

  // Splits the given block, so that extra space can be returned to the
  // free list.
  extraBlock = POINTER_ADD(ptrFreeBlock, reqSize);
  extraBlock->sizeAndTags = (SIZE(ptrFreeBlock->sizeAndTags) - reqSize) | TAG_PRECEDING_USED;
  // Sets footer.
  *((int*)POINTER_ADD(extraBlock, SIZE(extraBlock->sizeAndTags) - WORD_SIZE)) = extraBlock->sizeAndTags;
  insertFreeBlock(extraBlock);
  coalesceFreeBlock(extraBlock);
  
  ptrFreeBlock->sizeAndTags = reqSize | TAG_USED;
  return POINTER_ADD(ptrFreeBlock, WORD_SIZE);
}

/* Free the block referenced by ptr. */
/* This is done by returning the block into the free list and setting appropriate
 * tags to appropriate blocks. */
void mm_free (void *ptr) {
  int payloadSize;
  BlockInfo * blockInfo;
  BlockInfo * followingBlock;

  // Implement mm_free.  You can change or remove the declaraions
  // above.  They are included as minor hints.
  blockInfo = (BlockInfo *)POINTER_SUB(ptr, WORD_SIZE);

  // Sets proper tagging.
  payloadSize = SIZE(blockInfo->sizeAndTags);
  blockInfo->sizeAndTags = payloadSize | TAG_PRECEDING_USED;
  followingBlock = POINTER_ADD(blockInfo, payloadSize);
  followingBlock->sizeAndTags = followingBlock->sizeAndTags ^ TAG_PRECEDING_USED;

  insertFreeBlock(blockInfo);
  coalesceFreeBlock(blockInfo);
}


// Implement a heap consistency checker as needed.
int mm_check() {
  return 0;
}
