module Frusdl
  module Low
    module IMG
      extend FFI::Library
      ffi_lib('SDL_image')
      attach_function :IMG_Load, [:string], :pointer
      attach_function :IMG_Load_RW, [:pointer, :int], :pointer
    end
  end
end    
