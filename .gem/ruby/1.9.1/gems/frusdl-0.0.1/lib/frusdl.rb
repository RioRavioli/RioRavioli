# 
# Frusdl : Wafer-thin bindings to SDL, SDL_image, SDL_ttf, SDL_mixer, SDL_gfx,
#          and SGE for MRI, Jruby, Rubinius, ... using FFI
#
# Goal: source code compatibility with Ruby/SDL 2.0.1, 
#       but with lower level functions available.
# 
# Version: 0.0.1
#
# Requirements:
# * Ruby ( MRI or JRUBY 1.1.6 or higher)
# * FFI  ( version 0.2.0 or higher or MRI) 
# * The shared libraries for SDL 1.2.x, SDL_image, SDL_ttf, SDL_mixer, SDL_gfx 
#   or SGE should be installed properly on your system.
#
# Licence: ZLIB license. 
#       
# Frusdl
# 
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



begin
  require 'rubygems' 
rescue 
  # try to load Rubygems, but don't care if it fails. 
end

require 'ffi'
# We need FFI


module Frusdl
  # Low level FFI functions and structures
  autoload :Low     , 'frusdl/low'
  # Meta programming helper that makes writing wrappers easier.
  autoload :Wrap    , 'frusdl/wrap'
  # High level SDL wrapper, compatible with Ruby/SDL, unimplemented for now.
  autoload :SDL     , 'frusdl/sdl'
end 


# Source code compatibility with Ruby/SDL
unless defined? SDL
#  SDL = Frusdl
end






if $0 == __FILE__
  
  def peek_at_proc
      puts `ps u -p #{Process.pid}`
  end

  

  include Frusdl::Low
  
  puts SDL.SDL_getenv('HOME')
  
  
  fontname = '/usr/share/fonts/liberation/LiberationSerif-Regular.ttf'
  Frusdl::SDL.init(Frusdl::SDL::INIT_EVERYTHING)
  p Frusdl::SDL::Screen.driver_name
  p Frusdl::SDL::Screen.list_modes(nil, SDL::SDL_FULLSCREEN)
  info = Frusdl::SDL::Screen.info
  p info.video_mem
  p info.current_w
  p info.current_h
  p info.pixel_format.alpha
  # at_exit { SDL.SDL_Quit() }
  TTF.TTF_Init()
  at_exit { TTF.TTF_Quit() }
  fontp     = TTF.TTF_OpenFont(fontname, 20)
  screen2   = Frusdl::SDL::Screen.open(640, 480, 32, SDL::SDL_HWSURFACE | SDL::SDL_DOUBLEBUF )
  p screen2.w
  p screen2.h
  screenp   = screen2.pointer   
  # screenp   = SDL.SDL_SetVideoMode(640, 480, 32, SDL::SDL_HWSURFACE | SDL::SDL_DOUBLEBUF )
  # surf = SDL.SDL_CreateRGBSurface(0, 32, 32, 32, 0x000000FF,  0x0000FF00,  0x00FF0000,  0xFF000000)
  
  njoy      =  SDL.SDL_NumJoysticks()
  puts "You have a joystick: " if njoy == 1
  puts "You have #{njoy} joysticks: " if njoy > 1
  puts "No joysticks found!" if njoy < 1
  for i in (0...njoy) do
    puts SDL.SDL_JoystickName(i)
  end 
  
  peek_at_proc

  screen        = SDL::SDL_Surface.new(screenp)
  rect          = SDL::SDL_Rect.new
  screen_format = SDL::SDL_PixelFormat.new(screen[:format])
  white         = SDL::SDL_MapRGB(screen_format, 255,255,255)
  blue          = SDL::SDL_MapRGB(screen_format, 0, 0, 128)
  p screen_format[:bitsperpixel]  
  rect[:w]      = 640
  rect[:h]      = 20  
  mesg          = "SDL and Ruby are sitting on a tree... K I S S I N G!"
  textp         = TTF.TTF_RenderUTF8_Blended(fontp, mesg, white)
  event         = SDL::SDL_Event.new
  
  loop do
    polled = SDL.SDL_PollEvent(event.pointer)
      if polled > 0 
        break if event[:type] == SDL::SDL_QUIT
      end   
    SDL.SDL_FillRect(screen.pointer, rect.pointer, blue)
    # SGE.sge_FilledEllipse(screenp, 300, 100, 10, 20, blue) 
    SDL.SDL_UpperBlit(textp, nil, screen, rect)       
    screen2.flip
    # And flip the screen
  end

  SDL.SDL_FreeSurface(textp)
  # Free the rendered text surface.
  GC.start # force collection
  puts "End" 
  peek_at_proc
end

