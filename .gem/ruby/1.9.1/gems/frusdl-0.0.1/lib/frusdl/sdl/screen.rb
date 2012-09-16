module Frusdl
  module SDL
    class Screen 
      include Frusdl::Wrap
      include Frusdl::Low::SDL
      extend  Frusdl::Low::SDL
      
      
      struct_accessor :w
      struct_accessor :h
      
      attr_reader :pointer
      
      def initialize(ptr)
        initialize_pointer(ptr, Frusdl::Low::SDL::SDL_Surface)
      end
    
      # Wraps a low level ponter in a higher level struct 
      def self.wrap(ptr)
        return Frusdl::Low::SDL::SDL_Surface.new(ptr)
      end
    
      # Returns the current display surface
      def self.get
        ptr = SDL_GetVideoSurface()
        self.new(ptr)
      end
      
      # Returns information about the video hardware
      def self.info
        ptr = SDL_GetVideoInfo()
        Frusdl::SDL::VideoInfo.new(ptr)
      end 
      
      # Set up a video mode with the specified width, height and bits-per-pixel.
      def self.open(width, height, bbp, flags)
        ptr = SDL_SetVideoMode(width, height, bbp, flags)
        self.new(ptr)  
      end
      
      #  Obtain the name of the video driver
      def self.driver_name
        size = 256
        cstr = FFI::MemoryPointer.new(size)
        SDL_VideoDriverName(cstr, size)
        str   = cstr.read_string
        return str
      end
        
      # Check to see if a particular video mode is supported.
      # Returns supported bbp, or 0 if unsupported
      def self.check_mode(width, height, depth, flags)
        return SDL_VideoModeOK(width, height, depth, flags)
      end
      
      # Returns an array of available screen dimensions for the given format and video flags
      def self.list_modes(format, flags)
        formptr     = format ? format.pointer : nil  
        rectptrptr  = SDL_ListModes(formptr, flags)
        return nil  if rectptrptr.null?
        return true if rectptrptr.address == 4294967295 
        # This address means "all sizes allowed". Gotta love C! >_<          
        aid         = rectptrptr.get_int(0)
        return nil  if aid == 0
        return true if aid == -1 
        index       = 0
        result      = []
        ptrsize     = FFI.type_size(:pointer)
        rectptr     = rectptrptr.get_pointer(index * ptrsize)
        until rectptr.null? do
          rect      = Frusdl::Low::SDL::SDL_Rect.new(rectptr)
          result  << [ rect[:w], rect[:h] ]           
          index    += 1
          rectptr   = rectptrptr.get_pointer(index * ptrsize) 
        end
        return result   
        
      end 
    
      # Swaps screen buffers
      def flip
        SDL_Flip(@pointer)      
      end
      
      # Makes sure the given area is updated on the given screen.
      def update_rect(x, y, w, h)
        SDL_UpdateRect(@pointer, x, y, w, h) 
      end
      
      # Makes sure the given list of rectangles is updated on the given screen
      def update_rects(*rects)
        count       = rects.size
        rectptr     = MemoryPointer.new(:pointer, count)
        index       = 0
        for rect in rects do
          rectptr.set_pointer(index, rect.pointer)
          index    += 1  
        end            
        SDL_UpdateRects(@pointer, index, rectptr) 
      end
      
      # Sets the color gamma function for the display
      def self.set_gamma(rgamma, ggamma, bgammma)
        res = SDL_SetGamma(rgamma, ggamma, bgamma)
        raise_error if res < 0
      end
      
      # Gets the color gamma lookup tables for the display
      # XXX: doesn't work
      def self.get_gamma_ramp
        res = SDL_SetGammaRamp(rgammas, ggammas, bgammas)
        raise_error if res < 0
        return rgammas, ggammas, bgammas     
      end
      
      # Sets the color gamma lookup tables for the display
      # XXX: doesn't work like this 
      def self.set_gamma_ramp(rgammas, ggammas, bgammas) 
        res = SDL_SetGammaRamp(rgammas, ggammas, bgammas)
        raise_error if res < 0
      end
      
     
    
    
=begin    
    * Video Subsystem Outline
    * SDL::Screen
    * SDL::Surface
    * SDL::VideoInfo
    * Color, PixelFormat and Pixel value
    * Methods
          o SDL::PixelFormat#map_rgb -- RGB Map a RGB color value to a pixel format.
          o SDL::PixelFormat#map_rgba -- Map a RGBA color value to a pixel format.
          o SDL::PixelFormat#get_rgb -- Get RGB values from a pixel in the specified pixel format.
          o SDL::PixelFormat#get_rgba -- Get RGBA values from a pixel in the specified pixel format.
          o SDL::PixelFormat#Rmask -- Get binary mask used to retrieve red color value
          o SDL::PixelFormat#Gmask -- Get binary mask used to retrieve green color value
          o SDL::PixelFormat#Bmask -- Get binary mask used to retrieve blue color value
          o SDL::PixelFormat#Amask -- Get binary mask used to retrieve alpla value
          o SDL::PixelFormat#Rloss -- Precision loss of red component
          o SDL::PixelFormat#Gloss -- Precision loss of green component
          o SDL::PixelFormat#Bloss -- Precision loss of blue component
          o SDL::PixelFormat#Aloss -- Precision loss of alpha component
          o SDL::PixelFormat#Rshift -- Binary left shift of red component in the pixel value
          o SDL::PixelFormat#Gshift -- Binary left shift of green component in the pixel value
          o SDL::PixelFormat#Bshift -- Binary left shift of blue component in the pixel value
          o SDL::PixelFormat#Ashift -- Binary left shift of alpha component in the pixel value
          o SDL::PixelFormat#colorkey -- Pixel value of transparent pixels.
          o SDL::PixelFormat#alpha -- Overall surface alpha value
          o SDL::PixelFormat#bpp -- The number of bits used to represent each pixel in a surface
 
          
          o SDL::Surface#set_colors -- Sets a portion of the colormap for the given 8-bit surface.
          o SDL::Surface#set_palette -- Sets the colors in the palette of an 8-bit surface
          o SDL::Surface.new -- Create an empty SDL::Surface
          o SDL::Surface.new_from -- Create an SDL::Surface object from pixel data
          o SDL::Surface#lock -- Lock a surface for directly access.
          o SDL::Surface#unlock -- Unlocks a previously locked surface.
          o SDL::Surface#must_lock? -- Get whether the surface require locking or not.
          o SDL::Surface.load_bmp -- Load a Windows BMP file into an SDL_Surface.
          o SDL::Surface.load_bmp_from_io -- Load a Windows BMP file into an Surface from IO object.
          o SDL::Surface#save_bmp -- Save an SDL_Surface as a Windows BMP file.
          o SDL::Surface#set_color_key -- Sets the color key (transparent pixel) in a blittable surface and RLE acceleration.
          o SDL::Surface#set_alpha -- Adjust the alpha properties of a surface
          o SDL::Surface#set_clip_rect -- Sets the clipping rectangle for a surface.
          o SDL::Surface#get_clip_rect -- Gets the clipping rectangle for a surface.
          o SDL::Surface.blit -- This performs a fast blit from the source surface to the destination surface.
          o SDL::Surface#fill_rect -- This function performs a fast fill of the given rectangle with some color
          o SDL::Surface#display_format -- Convert a surface to the display format
          o SDL::Surface#display_format_alpha -- Convert a surface to the display format
          o SDL::Surface#flags -- Get surface flags
          o SDL::Surface#format -- Get surface pixel format
          o SDL::Surface#w -- Get surface width
          o SDL::Surface#h -- Get surface height
          o SDL::Surface#pixels -- Get the actual pixel data
          o SDL::Surface#colorkey -- Pixel value of transparent pixels
          o SDL::Surface#alpha -- Overall surface alpha value
          o SDL::Surface.load -- Load image into an surface
          o SDL::Surface.load_from_io -- Load a image file into an Surface from IO object.
          o SDL::Surface#put_pixel -- Writes a pixel to the specified position
          o SDL::Surface#get_pixel -- Gets the color of the specified pixel.
          o SDL::Surface#put -- Performs a fast blit from entire surface.
          o SDL::Surface#copy_rect -- Copies a part of surface.
          o SDL::Surface.auto_lock? -- Get whether surface is automatically locked
          o SDL::Surface.auto_lock_on -- Switch on auto locking
          o SDL::Surface.auto_lock_off -- Switch off auto locking.
          o SDL::Surface.transform_draw -- Draw a rotated and scaled image.
          o SDL::Surface.transform_blit -- Draw a rotated and scaled image with colorkey and blending
          o SDL::Surface#draw_line -- Draw a line
          o SDL::Surface#draw_rect -- Draws a rect
          o SDL::Surface#draw_circle -- Draws a circle
          o SDL::Surface#draw_ellipse -- Draws an ellipse.
          o SDL::Surface#draw_bezier -- Draws a bezier curve
          o SDL::Surface#transform_surface -- Creates an rotated an scaled surface
=end
    end # class Screen
  end # module SDL
end # module Frusdl
