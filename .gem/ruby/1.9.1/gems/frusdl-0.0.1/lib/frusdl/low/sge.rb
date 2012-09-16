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
# SDL graphical extensions. Useful addon lib 
module SGE 
  extend FFI::Library
  ffi_lib('SGE')
  # collision data 
  class Sge_cdata < FFI::Struct
    layout :map => :pointer,
           :w   => :ushort, 
           :h   => :ushort
  end
  
  
  attach_function :sge_make_cmap    , [:pointer], :pointer
  attach_function :sge_bbcheck      , [:pointer, :short, :short, :pointer, :short, :short], :int 
  attach_function :sge_cmcheck      , [:pointer, :short, :short, :pointer, :short, :short], :int
  attach_function :sge_get_cx       , [], :short
  attach_function :sge_get_cy       , [], :short
  attach_function :sge_destroy_cmap , [:pointer], :pointer
  attach_function :sge_unset_cdata  , [:pointer, :short, :short, :short, :short], :void
  attach_function :sge_set_cdata    , [:pointer, :short, :short, :short, :short], :void
  attach_function :sge_HLine        , [:pointer, :short, :short, :short, :ulong], :void
  attach_function :sge_HLineAlpha   , [:pointer, :short, :short, :short, :ulong , :uchar], :void
  attach_function :sge_VLine        , [:pointer, :short, :short, :short, :ulong], :void
  attach_function :sge_VLineAlpha   , [:pointer, :short, :short, :short, :ulong , :uchar], :void
  attach_function :sge_Line         , [:pointer, :short, :short, :short, :short , :ulong], :void
  attach_function :sge_LineAlpha    , [:pointer, :short, :short, :short, :short , :ulong, :uchar], :void
  attach_function :sge_AALine       , [:pointer, :short, :short, :short, :short , :ulong], :void
  attach_function :sge_AALineAlpha  , [:pointer, :short, :short, :short, :short , :ulong, :uchar], :void

  attach_function :sge_mcLine, [:pointer, :short, :short, :short, :short , :uchar, :uchar, :uchar, :uchar, :uchar, :uchar], :void 
  attach_function :sge_mcLineAlpha, [:pointer, :short, :short, :short, :short , :uchar, :uchar, :uchar, :uchar, :uchar, :uchar, :uchar], :void  
  attach_function :sge_AAmcLine, [:pointer, :short, :short, :short, :short , :uchar, :uchar, :uchar, :uchar, :uchar, :uchar], :void 
  attach_function :sge_AAmcLineAlpha, [:pointer, :short, :short, :short, :short , :uchar, :uchar, :uchar, :uchar, :uchar, :uchar, :uchar], :void



  attach_function :sge_DoLine   , [:pointer, :short, :short, :short, :short , :ulong, :pointer], :void
  attach_function :sge_DomcLine , [:pointer, :short, :short, :short, :short , :uchar, :uchar, :uchar, :uchar, :uchar, :uchar, :pointer], :void
  attach_function :sge_DoEllipse, [:pointer, :short, :short, :short, :short , :ulong, :pointer], :void
  attach_function :sge_DoCircle , [:pointer, :short, :short, :short, :ulong, :pointer], :void        
  # should use Callback(SDL_Surface *Surf, Sint16 X, Sint16 Y, Uint32 Color) 
  # in stead of :pointer 

  attach_function :sge_Rect             , [:pointer, :short, :short, :short, :short, :ulong]        , :void
  attach_function :sge_RectAlpha        , [:pointer, :short, :short, :short, :short, :ulong, :uchar], :void
  attach_function :sge_FilledRect       , [:pointer, :short, :short, :short, :short, :ulong]        , :void
  attach_function :sge_FilledRectAlpha  , [:pointer, :short, :short, :short, :short, :ulong, :uchar], :void
  attach_function :sge_Ellipse          , [:pointer, :short, :short, :short, :short, :ulong]        , :void
  attach_function :sge_EllipseAlpha     , [:pointer, :short, :short, :short, :short, :ulong, :uchar], :void
  attach_function :sge_FilledEllipse    , [:pointer, :short, :short, :short, :short, :ulong]        , :void
  attach_function :sge_FilledEllipseAlpha,[:pointer, :short, :short, :short,  :ulong, :uchar], :void
  attach_function :sge_Circle           , [:pointer, :short, :short, :short, :ulong]        , :void
  attach_function :sge_CircleAlpha      , [:pointer, :short, :short, :short, :ulong, :uchar], :void
  attach_function :sge_FilledCircle     , [:pointer, :short, :short, :short, :ulong]        , :void
  attach_function :sge_FilledCircleAlpha, [:pointer, :short, :short, :short, :ulong, :uchar], :void
  attach_function :sge_AACircle         , [:pointer, :short, :short, :short, :ulong]        , :void
  attach_function :sge_AACircleAlpha    , [:pointer, :short, :short, :short, :ulong, :uchar], :void
  attach_function :sge_AAFilledCircle   , [:pointer, :short, :short, :short, :ulong]        , :void
  attach_function :sge_Bezier           , [:pointer, :short, :short, :short, :short, :short, :short, :short, :short, :ulong]        , :void
  attach_function :sge_BezierAlpha      , [:pointer, :short, :short, :short, :short, :short, :short, :short, :short, :int, :ulong, :uchar], :void
  attach_function :sge_AABezier         , [:pointer, :short, :short, :short, :short, :short, :short, :short, :short, :ulong]        , :void
  attach_function :sge_AABezierAlpha    , [:pointer, :short, :short, :short, :short, :short, :short, :short, :short, :int, :ulong, :uchar], :void


  # Transformation flags
  SGE_TAA    = 0x1
  SGE_TSAFE  = 0x2
  SGE_TTMAP  = 0x4
  attach_function :sge_transform, [:pointer, :pointer, :float, :float, :float, :ushort, :ushort, :ushort, :ushort, :uchar], :pointer  # XXX should be SDL_rect
  
  attach_function :sge_transform_surface, [:pointer, :ulong, :float, :float, :float, :ushort, :uchar], :pointer 


end

  end # module Low
end # module Frusdl  