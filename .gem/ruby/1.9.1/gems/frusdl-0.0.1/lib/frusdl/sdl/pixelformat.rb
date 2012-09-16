module Frusdl
  module SDL
    class PixelFormat
      include Frusdl::Wrap
    
      extend  Frusdl::Low::SDL
      include Frusdl::Low::SDL
      
      attr_reader :pointer
      
      def initialize(ptr)
        initialize_pointer(ptr, Frusdl::Low::SDL::SDL_PixelFormat) 
      end
      
      # Map a RGB color value to a pixel format.
      def map_rgb(r, g, b)
        return SDL_MapRGB(@pointer, r, g, b)
      end
      
      # Map a RGBA color value to a pixel format.
      def map_rgba(r, g, b, a)
        return SDL_MapRGBA(@pointer, r, g, b, a)
      end
      
      # Get RGB values from a pixel in the specified pixel format.
      # XXX: not implemented
      def get_rgb()
        return [-1, -1, -1, -1]
      end

      
      # Get RGBA values from a pixel in the specified pixel format.
      # XXX: not implemented
      def get_rgba()
        return [-1, -1, -1, -1]
      end
      
      struct_accessor :Rmask  , :rmask
      struct_accessor :Gmask  , :gmask
      struct_accessor :Bmask  , :bmask
      struct_accessor :Amask  , :amask
      struct_accessor :Rloss  , :rloss
      struct_accessor :Gloss  , :gloss
      struct_accessor :Bloss  , :bloss
      struct_accessor :Aloss  , :aloss
      struct_accessor :Rshift , :rshift
      struct_accessor :Gshift , :gshift
      struct_accessor :Bshift , :bshift
      struct_accessor :Ashift , :ashift
      struct_accessor :colorkey , :colorkey
      struct_accessor :alpha    , :alpha
      struct_accessor :bpp      , :bitsperpixel

    
=begin
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
=end
    end
  end
end