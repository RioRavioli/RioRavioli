# Copyright (c) 2008, Bjorn De Meyer
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#    1. The origin of this software must not be misrepresented; you must not
#   claim that you wrote the original software. If you use this software
#   in a product, an acknowledgment in the product documentation would be
#   appreciated but is not required.
#
#   2. Altered source versions must be plainly marked as such, and must not be
#   misrepresented as being the original software.
#
#   3. This notice may not be removed or altered from any source
#   distribution.

module Frusdl
  module Low
    module TTF
      extend FFI::Library
      ffi_lib('SDL_ttf')
      
      class TTF_Font < FFI::Struct
        # Private 
      end 
        
      # This function tells the library whether UNICODE text is generally byteswapped.  
      attach_function :TTF_ByteSwappedUNICODE, [:int], :void 
      # Initialize the TTF engine - returns 0 if successful, -1 on error 
      attach_function :TTF_Init           , [], :int
      # Open a font file and create a font of the specified point size.
      attach_function :TTF_OpenFont       , [:string, :int], :pointer
      attach_function :TTF_OpenFontIndex  , [:string, :int, :int], :pointer
      attach_function :TTF_OpenFontRW     , [:pointer, :int], :pointer
      attach_function :TTF_OpenFontIndexRW, [:pointer, :int, :int], :pointer
      # 
      # Set and retrieve the font style
      TTF_STYLE_NORMAL    = 0x00
      TTF_STYLE_BOLD      = 0x01
      TTF_STYLE_ITALIC    = 0x02
      TTF_STYLE_UNDERLINE = 0x04
        
      attach_function :TTF_GetFontStyle   , [:pointer], :int
      attach_function :TTF_SetFontStyle   , [:pointer, :int], :void
      # Font dimensions
      attach_function :TTF_FontHeight     , [:pointer], :int
      attach_function :TTF_FontAscent     , [:pointer], :int
      attach_function :TTF_FontDescent    , [:pointer], :int
      attach_function :TTF_FontLineSkip   , [:pointer], :int
      # Get the number of faces of the font 
      attach_function :TTF_FontFaces      , [:pointer], :long
      
      # Get the font face attributes, if any
      attach_function :TTF_FontFaceIsFixedWidth , [:pointer], :int
      attach_function :TTF_FontFaceFamilyName   , [:pointer], :string
      attach_function :TTF_FontFaceStyleName    , [:pointer], :string
    
      # Get the metrics (dimensions) of a glyph
      attach_function :TTF_GlyphMetrics         , [:pointer, :int, :pointer, :pointer, :pointer, :pointer, :pointer], :int
    
      # Get the dimensions of a rendered string of text
      attach_function :TTF_SizeText, [:pointer, :string, :pointer, :pointer]    , :pointer
      attach_function :TTF_SizeUTF8, [:pointer, :string, :pointer, :pointer]    , :pointer
      attach_function :TTF_SizeUNICODE, [:pointer, :pointer, :pointer, :pointer], :pointer
      
      # Render text with different levels of smoothing.  
      # XXX: SDL_Color is needed here everywhere, but it is of same size as :ulong
      attach_function :TTF_RenderText_Solid, [:pointer, :string, :ulong]        , :pointer 
      attach_function :TTF_RenderUTF8_Solid, [:pointer, :string, :ulong]        , :pointer 
      attach_function :TTF_RenderUNICODE_Solid, [:pointer, :pointer, :ulong]    , :pointer 
      attach_function :TTF_RenderGlyph_Solid, [:pointer, :ushort, :ulong]       , :pointer
      attach_function :TTF_RenderText_Shaded, [:pointer, :string, :ulong, :ulong], :pointer   
      attach_function :TTF_RenderUTF8_Shaded, [:pointer, :string, :ulong, :ulong], :pointer
      attach_function :TTF_RenderUNICODE_Shaded, [:pointer, :pointer, :ulong, :ulong], :pointer
      attach_function :TTF_RenderGlyph_Shaded, [:pointer, :ushort, :ulong, :ulong]   , :pointer
      attach_function :TTF_RenderText_Blended, [:pointer, :string, :ulong]        , :pointer 
      attach_function :TTF_RenderUTF8_Blended, [:pointer, :string, :ulong]        , :pointer 
      attach_function :TTF_RenderUNICODE_Blended, [:pointer, :pointer, :ulong]    , :pointer 
      attach_function :TTF_RenderGlyph_Blended, [:pointer, :ushort, :ulong]       , :pointer
    
      # Close an opened font file 
      attach_function :TTF_CloseFont, [:pointer], :void
      # De-initialize the TTF engine
      attach_function :TTF_Quit     , [], :void
      # Check if SDL_TTF was initialized.
      attach_function :TTF_WasInit  , [], :int
    end

  end
end    

