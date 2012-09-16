module Frusdl
  module SDL
    class VideoInfo
      attr_reader :pointer
        
      include Frusdl::Wrap
      include Frusdl::Low::SDL
      extend  Frusdl::Low::SDL
      
      def initialize(ptr)
        initialize_pointer(ptr, Frusdl::Low::SDL::SDL_VideoInfo)
      end
      
      def pixel_format
        return Frusdl::SDL::PixelFormat.new(@struct[:vfmt])
      end
      
      struct_reader :video_mem 
      struct_reader :current_w
      struct_reader :current_h 
    end
  end
end