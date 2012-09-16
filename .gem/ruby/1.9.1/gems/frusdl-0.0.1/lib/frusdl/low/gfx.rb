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
    # Alternative graphics primitives library 
    module GFX
      extend FFI::Library
      ffi_lib('SDL_gfx')  
    
      attach_function :pixelColor   , [:pointer, :short, :short, :ulong], :int
      attach_function :pixelRGBA    , [:pointer, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :hlineColor   , [:pointer, :short, :short, :short, :ulong], :int
      attach_function :hlineRGBA    , [:pointer, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :vlineColor   , [:pointer, :short, :short, :short, :ulong], :int
      attach_function :vlineRGBA    , [:pointer, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :rectangleColor, [:pointer, :short, :short, :short, :short, :ulong], :int
      attach_function :rectangleRGBA , [:pointer, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :boxColor     , [:pointer, :short, :short, :short, :short, :ulong], :int
      attach_function :boxRGBA      , [:pointer, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :lineColor    , [:pointer, :short, :short, :short, :short, :ulong], :int
      attach_function :lineRGBA     , [:pointer, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :aalineColor  , [:pointer, :short, :short, :short, :short, :ulong], :int
      attach_function :aalineRGBA   , [:pointer, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int  
      attach_function :circleColor  , [:pointer, :short, :short, :short, :ulong], :int
      attach_function :circleRGBA   , [:pointer, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :aacircleColor, [:pointer, :short, :short, :short, :ulong], :int
      attach_function :aacircleRGBA , [:pointer, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :filledCircleColor,  [:pointer, :short, :short, :short, :ulong], :int
      attach_function :filledCircleRGBA , [:pointer, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :ellipseColor     , [:pointer, :short, :short, :short, :short, :ulong], :int
      attach_function :ellipseRGBA      , [:pointer, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :aaellipseColor   , [:pointer, :short, :short, :short, :short, :ulong], :int
      attach_function :aaellipseRGBA    , [:pointer, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
    
      attach_function :pieColor   , [:pointer, :short, :short, :short, :short, :short, :ulong], :int
      attach_function :pieRGBA    , [:pointer, :short, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :filledPieColor, [:pointer, :short, :short, :short, :short, :short, :ulong], :int
      attach_function :filledPieRGBA , [:pointer, :short, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :trigonColor   , [:pointer, :short, :short, :short, :short, :short, :short, :ulong], :int
      attach_function :trigonRGBA    , [:pointer, :short, :short, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :aatrigonColor , [:pointer, :short, :short, :short, :short, :short, :short, :ulong], :int
      attach_function :aatrigonRGBA  , [:pointer, :short, :short, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :filledTrigonColor, [:pointer, :short, :short, :short, :short, :short, :short, :ulong], :int
      attach_function :filledTrigonRGBA , [:pointer, :short, :short, :short, :short, :short, :short, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :polygonColor, [:pointer, :pointer, :pointer, :int, :ulong], :int
      attach_function :polygonRGBA , [:pointer, :pointer, :pointer, :int, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :aapolygonColor, [:pointer, :pointer, :pointer, :int, :ulong], :int
      attach_function :aapolygonRGBA , [:pointer, :pointer, :pointer, :int, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :filledPolygonColor, [:pointer, :pointer, :pointer, :int, :ulong], :int
      attach_function :filledPolygonRGBA , [:pointer, :pointer, :pointer, :int, :uchar, :uchar, :uchar, :uchar], :int
      attach_function :texturedPolygon, [:pointer, :pointer, :pointer, :int, :pointer, :int, :int], :int
      attach_function :bezierColor, [:pointer, :pointer, :pointer, :int, :int, :ulong], :int
      attach_function :bezierRGBA , [:pointer, :pointer, :pointer, :int, :int, :uchar, :uchar, :uchar, :uchar], :int
    
      SMOOTHING_OFF = 0
      SMOOTHING_ON  = 1
    
      # Rotates and zoomes a 32bit or 8bit 'src' surface to newly created 'dst' surface.
      attach_function :rotozoomSurface  , [:pointer, :double, :double, :int], :pointer
      attach_function :rotozoomSurfaceXY, [:pointer, :double, :double, :double, :int], :pointer
      # Returns the size of the target surface for a rotozoomSurface() call
      attach_function :rotozoomSurfaceSize, [:int, :int, :double, :double, :pointer, :pointer], :void
      attach_function :rotozoomSurfaceSizeXY, [:int, :int, :double, :double, :double, :pointer, :pointer], :void
      # Zoomes a 32bit or 8bit 'src' surface to newly created 'dst' surface.
      attach_function :zoomSurface, [:pointer, :double, :double, :int], :pointer
      # Returns the size of the target surface for a zoomSurface() call
      attach_function :zoomSurfaceSize, [:int, :int, :double, :double, :pointer, :pointer], :void
      # Shrinks a 32bit or 8bit 'src' surface to a newly created 'dst' surface.
      attach_function :shrinkSurface, [:pointer, :int, :int], :pointer 
    
    
    end



  end
end    
