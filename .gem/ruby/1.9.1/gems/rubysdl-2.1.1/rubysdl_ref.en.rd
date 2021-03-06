= Contents
* ((<"Ruby/SDL Outline">))
* ((<Initialize>))
* ((<Video>))
* ((<OpenGL>))
* ((<Window Management>))
* ((<Event>))
* ((<Joystick>))
* ((<CD-ROM>))
* ((<Audio>))
* ((<Time>))
* ((<Font>))
* ((<Collision Detection>))
* ((<SDLSKK>))
* ((<MPEG playback>))

= Ruby/SDL Outline
Ruby/SDL is Ruby extension library for
((<SDL|URL:http://www.libsdl.org/>)).
This library enables you to create games, demo, or so on.

Ruby/SDL has following functions.
* ((<access to 2D video framebuffer|Video>))
* Access ((<Keyboard and mouse|Event>)), ((<Joystick>)) input
* ((<Audio Playback|Audio>)) with ((<SDL_mixer|URL:http://www.libsdl.org/projects/SDL_mixer/index.html>))
* ((<Control CD-ROM|CD-ROM>))
* ((<Font drawing |Font>)) with ((<SDL_ttf|URL:http://www.libsdl.org/projects/SDL_ttf/index.html>)),
  ((<SDL_kanji|URL:http://shinh.skr.jp/sdlkanji/>)) and
  ((<SGE|URL:http://www.etek.chalmers.se/~e8cal1/sge/index.html>))
* ((<Using OpenGL|OpenGL>)) via ((<OpenGL Interface|URL:http://www2.giganet.net/~yoshi/>))
* ((<Dealing with time|Time>))
* ((<SKK like Japanese input|SDLSKK>)) with ((<SDLSKK|URL:http://www.kmc.gr.jp/~ohai/sdlskk.html>))
* ((<MPEG playback>)) with ((<SMPGE|URL:http://www.icculus.org/smpeg/>))
* ((<Window Management>)) and ((<Collision Detection>))

= m17n on Ruby 1.9
On ruby 1.9, strings have encoding information
but many methods of Ruby/SDL ignore this information
since SDL doesn't define the treatment of multibyte 
encodings. 
Only some methods use encoding information such as
((<SDL::WM.set_caption>)) and ((<SDL::Kanji#put>)).

Please see items in this reference for more details.

You can enable/disable Ruby/SDL m17n support 
to use --enable-m17n/--disable-m17n when you
run extconf.rb.

== SDL::Error
A Exception class for SDL specific errors.
This class is subclass of StandardError.

== SDL::VERSION
Ruby/SDL version string.



= Initialize
  * ((<SDL.init>)) -- Initializes SDL
  * ((<SDL.quit>)) -- Shut down SDL
  * ((<SDL.inited_system>)) -- Check which subsystems are initialized
  * ((<SDL.getenv>)) -- Get an environmental variable
  * ((<SDL.putenv>)) -- Change or add an  environmental variable

Before SDL can be used in a program it must be initialized
with ((<SDL.init>)). ((<SDL.init>)) initializes all the subsystems that
 the user requests (video, audio, joystick, timers and/or cdrom).

== Methods

--- SDL.init(flags)

    Initializes SDL. This should be called before all other 
    Ruby/SDL methods. The ((|flags|)) parameter specifies what
     part(s) of SDL to initialize.
    :SDL::INIT_AUDIO
      Initialize autio subsystems.
    :SDL::INIT_VIDEO
      Initialize ((<Video>)) subsystem.
    :SDL::INIT_CDROM
      Initialize ((<CD-ROM>)) subsystem.
    :SDL::INIT_JOYSTICK
      Initialize ((<Joystick>)) subsystem.
    :SDL::INIT_EVERYTHING
      Initialize all of the avobe.

    Raises ((<SDL::Error>)) on failure
--- SDL.quit

    This method shots down all SDL subsystem and frees the resources
    allocated to them. Because this method is automatically called 
    when ruby stops, you don't have to call this function normally.
    
    You should know SDL and Ruby/SDL very well when you use
    this method.

--- SDL.inited_system(flags)
--- SDL.initedSystem(flags)

    This method allows you to see which SDL subsytems have
     been ((<initialized|SDL.init>)). ((|flags|)) is a bitwise OR'd 
    combination of the subsystems you wish to check 
    (see ((<SDL.init>)) for a list of subsystem flags).

    Returns a bitwised OR'd combination of the initialized subsystems.


    EXAMPLE
      # Here are several ways you can use SDL.inited_system
      
      # Get init data on all the subsystem
      subsystem_init = SDL.inited_system(SDL::INIT_EVERYTHING)
      
      if subsystem_init & SDL::INIT_VIDEO
        puts "video is initialized"
      else
        puts "video is not initialized"
      end
      
      # Just check for one specfic subsystem
      
      if SDL.inited_system(SDL::INIT_VIDEO) != 0
        puts "Video is initialized"
      else
        puts "Video is not initialized        "
      end
      
      # Check for two subsystem
      
      subsystem_mask = SDL::INIT_VIDEO|SDL::INIT_AUDIO;
      
      if SDL.inited_system(subsystem_mask) == subsystem_mask
        puts "Video and Audio initialized."
      else
        puts "Video and Audio not initialized"
      end

    * See Also
      
      ((<SDL.init>))

--- SDL.getenv(var)

    Returns the environment variable string matched by ((|var|)).

--- SDL.putenv(string)

    Add or Change the value of environmental variables.
    The argument ((|string|)) is of the form "name=value"
    
    If you want to change SDL_WINDOWID or SDL_VIDEODRIVER environmental variable 
    to modify the behavior of SDL in your program, you should use 
    this function instead of ENV.

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      # from http://moriq.tdiary.net/20051006.html 
      # Apollo with Ruby/SDL
      require 'phi'
      require 'sdl'
      
      # Create form
      form = Phi::Form.new
      $terminated = false
      form.on_close{ $terminated = true }
      form.caption = "Ruby/SDL on Phi::Form"
      # Create a panel on new form
      panel = Phi::Panel.new(form)
      panel.align = Phi::AL_LEFT
      
      # Put SDL window on panel with WINDOWID hack
      SDL.putenv("SDL_VIDEODRIVER=windib")
      SDL.putenv("SDL_WINDOWID=#{panel.handle}")
      form.show
      
      # initialize SDL
      SDL.init(SDL::INIT_VIDEO)
      screen = SDL.setVideoMode(640, 480, 16, SDL::SWSURFACE)
      
      # main loop
      unless $terminated
        while event = SDL::Event2.poll
          case event
          when SDL::Event2::KeyDown, SDL::Event2::Quit
            exit
          end
        end
      
        sleep 0.05
      end

= Video
* ((<Video Subsystem Outline>))
* ((<SDL::Screen>))
* ((<SDL::Surface>))
* ((<SDL::VideoInfo>))
* ((<Color, PixelFormat and Pixel value>))

* Methods
  * ((<SDL::Screen.get>)) -- returns the current display surface
  * ((<SDL::Screen.info>)) -- returns information about the video hardware
  * ((<SDL::Screen.driver_name>)) -- Obtain the name of the video driver
  * ((<SDL::Screen.list_modes>)) -- Returns an array of available screen dimensions for the given format and video flags
  * ((<SDL::Screen.check_mode>)) -- Check to see if a particular video mode is supported.
  * ((<SDL::Screen.open>)) -- Set up a video mode with the specified width, height and bits-per-pixel.
  * ((<SDL::Screen#update_rect>)) -- Makes sure the given area is updated on the given screen.
  * ((<SDL::Screen#update_rects>)) -- Makes sure the given list of rectangles is updated on the given screen
  * ((<SDL::Screen#flip>)) -- Swaps screen buffers
  * ((<SDL::Surface#set_colors>)) -- Sets a portion of the colormap for the given 8-bit surface.
  * ((<SDL::Surface#set_palette>)) -- Sets the colors in the palette of an 8-bit surface
  * ((<SDL::Screen.set_gamma>)) -- Sets the color gamma function for the display
  * ((<SDL::Screen.get_gamma_ramp>)) -- Gets the color gamma lookup tables for the display
  * ((<SDL::Screen.set_gamma_ramp>)) -- Sets the color gamma lookup tables for the display
  * ((<SDL::PixelFormat#map_rgb>)) -- RGB Map a RGB color value to a pixel format.
  * ((<SDL::PixelFormat#map_rgba>)) -- Map a RGBA color value to a pixel format.
  * ((<SDL::PixelFormat#get_rgb>)) -- Get RGB values from a pixel in the specified pixel format.
  * ((<SDL::PixelFormat#get_rgba>)) -- Get RGBA values from a pixel in the specified pixel format.
  * ((<SDL::Surface.new>)) -- Create an empty ((<SDL::Surface>))
  * ((<SDL::Surface.new_from>)) -- Create an ((<SDL::Surface>)) object from pixel data
  * ((<SDL::Surface#lock>)) -- Lock a surface for directly access.
  * ((<SDL::Surface#unlock>)) -- Unlocks a previously locked surface.
  * ((<SDL::Surface#must_lock?>)) -- Get whether the surface require locking or not.
  * ((<SDL::Surface.load_bmp>)) -- Load a Windows BMP file into an SDL_Surface.
  * ((<SDL::Surface.load_bmp_from_io>)) -- Load a Windows BMP file into an Surface from IO object.
  * ((<SDL::Surface#save_bmp>)) -- Save an SDL_Surface as a Windows BMP file.
  * ((<SDL::Surface#destroy>)) -- Frees a Surface
  * ((<SDL::Surface#destroyed?>)) -- Returns whether surface is destoryed or not.
  * ((<SDL::Surface#set_color_key>)) -- Sets the color key (transparent pixel) in a blittable surface and RLE acceleration.
  * ((<SDL::Surface#set_alpha>)) -- Adjust the alpha properties of a surface
  * ((<SDL::Surface#set_clip_rect>)) -- Sets the clipping rectangle for a surface.
  * ((<SDL::Surface#get_clip_rect>)) -- Gets the clipping rectangle for a surface.
  * ((<SDL::Surface.blit>)) -- This performs a fast blit from the source surface to the destination surface.
  * ((<SDL::Surface#fill_rect>)) -- This function performs a fast fill of the given rectangle with some color
  * ((<SDL::Surface#display_format>)) -- Convert a surface to the display format
  * ((<SDL::Surface#display_format_alpha>)) -- Convert a surface to the display format
  * ((<SDL::Surface#flags>)) -- Get surface flags
  * ((<SDL::Surface#format>)) -- Get surface pixel format
  * ((<SDL::Surface#w>)) -- Get surface width
  * ((<SDL::Surface#h>)) -- Get surface height
  * ((<SDL::Surface#pixels>)) -- Get the actual pixel data
  * ((<SDL::PixelFormat#Rmask>)) -- Get binary mask used to retrieve red color value
  * ((<SDL::PixelFormat#Gmask>)) -- Get binary mask used to retrieve green color value
  * ((<SDL::PixelFormat#Bmask>)) -- Get binary mask used to retrieve blue color value
  * ((<SDL::PixelFormat#Amask>)) -- Get binary mask used to retrieve alpla value
  * ((<SDL::PixelFormat#Rloss>)) -- Precision loss of red component
  * ((<SDL::PixelFormat#Gloss>)) -- Precision loss of green component
  * ((<SDL::PixelFormat#Bloss>)) -- Precision loss of blue component
  * ((<SDL::PixelFormat#Aloss>)) -- Precision loss of alpha component
  * ((<SDL::PixelFormat#Rshift>)) -- Binary left shift of red component in the pixel value
  * ((<SDL::PixelFormat#Gshift>)) -- Binary left shift of green component in the pixel value
  * ((<SDL::PixelFormat#Bshift>)) -- Binary left shift of blue component in the pixel value
  * ((<SDL::PixelFormat#Ashift>)) -- Binary left shift of alpha component in the pixel value
  * ((<SDL::Surface#colorkey>)) -- Pixel value of transparent pixels
  * ((<SDL::Surface#alpha>)) -- Overall surface alpha value
  * ((<SDL::PixelFormat#colorkey>)) -- Pixel value of transparent pixels.
  * ((<SDL::PixelFormat#alpha>)) -- Overall surface alpha value
  * ((<SDL::PixelFormat#bpp>)) -- The number of bits used to represent each pixel in a surface
  * ((<SDL::Surface.load>)) -- Load image into an surface
  * ((<SDL::Surface.load_from_io>)) -- Load a image file into an Surface from IO object.
  * ((<SDL::Surface#put_pixel>)) -- Writes a pixel to the specified position
  * ((<SDL::Surface#get_pixel>)) -- Gets the color of the specified pixel.
  * ((<SDL::Surface#put>)) -- Performs a fast blit from entire surface.
  * ((<SDL::Surface#copy_rect>)) -- Copies a part of surface.
  * ((<SDL::Surface.auto_lock?>)) -- Get whether surface is automatically locked
  * ((<SDL::Surface.auto_lock_on>)) -- Switch on auto locking
  * ((<SDL::Surface.auto_lock_off>)) -- Switch off auto locking.
  * ((<SDL::Surface.transform_draw>)) -- Draw a rotated and scaled image.
  * ((<SDL::Surface.transform_blit>)) -- Draw a rotated and scaled image with colorkey and blending
  * ((<SDL::Surface#draw_line>)) -- Draw a line
  * ((<SDL::Surface#draw_rect>)) -- Draws a rect
  * ((<SDL::Surface#draw_circle>)) -- Draws a circle
  * ((<SDL::Surface#draw_ellipse>)) -- Draws an ellipse.
  * ((<SDL::Surface#draw_bezier>)) -- Draws a bezier curve
  * ((<SDL::Surface#transform_surface>)) -- Creates an rotated an scaled surface

== Video Subsystem Outline
SDL presents a very simple interface to the display framebuffer.
The framebuffer is represented as an offscreen surface to which
you can write directly. If you want the screen to show what you
have written, call the ((<update|SDL::Screen#update_rect>))
function which will guarantee that
the desired portion of the screen is updated.

Before you call any of the SDL video functions, you must first
call ((<SDL.init>))(SDL::INIT_VIDEO), which initializes the video and
events in the SDL library. 

If you use both sound and video in your application, you need to
call ((<SDL.init>))(SDL::INIT_AUDIO | SDL::INIT_VIDEO) before opening
the sound device, otherwise under Win32 DirectX, you won't be
able to set full-screen display modes.

After you have initialized the library, you can start up the
video display in a number of ways. The easiest way is to pick a
common screen resolution and depth and just initialize the
video, checking for errors. You will probably get what you want,
but SDL may be emulating your requested mode and converting the
display on update. The best way is to ((<query|SDL::Screen.info>)), 
for the best video
mode closest to the desired one, and then 
((<convert|SDL::Surface#display_format>)) your images to 
that pixel format.

SDL currently supports any bit depth >= 8 bits per pixel. 8 bpp
formats are considered 8-bit palettized modes, while 12, 15, 16,
24, and 32 bits per pixel are considered "packed pixel" modes,
meaning each pixel contains the RGB color components packed in
the bits of the pixel.

After you have initialized your video mode, you can take the
surface that was returned, and write to it like any other
framebuffer, calling the update routine as you go.

== SDL::Surface
Graphical Surface class.

This class represent areas of "graphical" memory, memory that
can be drawn to. 

* ((<SDL::Surface#set_colors>)) -- Sets a portion of the colormap for the given 8-bit surface.
* ((<SDL::Surface#set_palette>)) -- Sets the colors in the palette of an 8-bit surface
* ((<SDL::Surface.new>)) -- Create an empty ((<SDL::Surface>))
* ((<SDL::Surface.new_from>)) -- Create an ((<SDL::Surface>)) object from pixel data
* ((<SDL::Surface#lock>)) -- Lock a surface for directly access.
* ((<SDL::Surface#unlock>)) -- Unlocks a previously locked surface.
* ((<SDL::Surface#must_lock?>)) -- Get whether the surface require locking or not.
* ((<SDL::Surface.load_bmp>)) -- Load a Windows BMP file into an SDL_Surface.
* ((<SDL::Surface.load_bmp_from_io>)) -- Load a Windows BMP file into an Surface from IO object.
* ((<SDL::Surface#save_bmp>)) -- Save an SDL_Surface as a Windows BMP file.
* ((<SDL::Surface#destroy>)) -- Frees a Surface
* ((<SDL::Surface#destroyed?>)) -- Returns whether surface is destoryed or not.
* ((<SDL::Surface#set_color_key>)) -- Sets the color key (transparent pixel) in a blittable surface and RLE acceleration.
* ((<SDL::Surface#set_alpha>)) -- Adjust the alpha properties of a surface
* ((<SDL::Surface#set_clip_rect>)) -- Sets the clipping rectangle for a surface.
* ((<SDL::Surface#get_clip_rect>)) -- Gets the clipping rectangle for a surface.
* ((<SDL::Surface.blit>)) -- This performs a fast blit from the source surface to the destination surface.
* ((<SDL::Surface#fill_rect>)) -- This function performs a fast fill of the given rectangle with some color
* ((<SDL::Surface#display_format>)) -- Convert a surface to the display format
* ((<SDL::Surface#display_format_alpha>)) -- Convert a surface to the display format
* ((<SDL::Surface#flags>)) -- Get surface flags
* ((<SDL::Surface#format>)) -- Get surface pixel format
* ((<SDL::Surface#w>)) -- Get surface width
* ((<SDL::Surface#h>)) -- Get surface height
* ((<SDL::Surface#pixels>)) -- Get the actual pixel data
* ((<SDL::Surface#colorkey>)) -- Pixel value of transparent pixels
* ((<SDL::Surface#alpha>)) -- Overall surface alpha value
* ((<SDL::Surface.load>)) -- Load image into an surface
* ((<SDL::Surface.load_from_io>)) -- Load a image file into an Surface from IO object.
* ((<SDL::Surface#put_pixel>)) -- Writes a pixel to the specified position
* ((<SDL::Surface#get_pixel>)) -- Gets the color of the specified pixel.
* ((<SDL::Surface#put>)) -- Performs a fast blit from entire surface.
* ((<SDL::Surface#copy_rect>)) -- Copies a part of surface.
* ((<SDL::Surface.auto_lock?>)) -- Get whether surface is automatically locked
* ((<SDL::Surface.auto_lock_on>)) -- Switch on auto locking
* ((<SDL::Surface.auto_lock_off>)) -- Switch off auto locking.
* ((<SDL::Surface.transform_draw>)) -- Draw a rotated and scaled image.
* ((<SDL::Surface.transform_blit>)) -- Draw a rotated and scaled image with colorkey and blending
* ((<SDL::Surface#draw_line>)) -- Draw a line
* ((<SDL::Surface#draw_rect>)) -- Draws a rect
* ((<SDL::Surface#draw_circle>)) -- Draws a circle
* ((<SDL::Surface#draw_ellipse>)) -- Draws an ellipse.
* ((<SDL::Surface#draw_bezier>)) -- Draws a bezier curve
* ((<SDL::Surface#transform_surface>)) -- Creates an rotated an scaled surface

== SDL::Screen
Video framebuffer class. 

This class is subclass of ((<SDL::Surface>)), and contents 
is shown in display.

The video framebuffer is returned by 
((<SDL::Screen.open>)) and ((<SDL::Screen.get>)).

* ((<SDL::Screen.get>)) -- returns the current display surface
* ((<SDL::Screen.info>)) -- returns information about the video hardware
* ((<SDL::Screen.driver_name>)) -- Obtain the name of the video driver
* ((<SDL::Screen.list_modes>)) -- Returns an array of available screen dimensions for the given format and video flags
* ((<SDL::Screen.check_mode>)) -- Check to see if a particular video mode is supported.
* ((<SDL::Screen.open>)) -- Set up a video mode with the specified width, height and bits-per-pixel.
* ((<SDL::Screen#update_rect>)) -- Makes sure the given area is updated on the given screen.
* ((<SDL::Screen#update_rects>)) -- Makes sure the given list of rectangles is updated on the given screen
* ((<SDL::Screen#flip>)) -- Swaps screen buffers
* ((<SDL::Screen.set_gamma>)) -- Sets the color gamma function for the display
* ((<SDL::Screen.get_gamma_ramp>)) -- Gets the color gamma lookup tables for the display
* ((<SDL::Screen.set_gamma_ramp>)) -- Sets the color gamma lookup tables for the display

== SDL::VideoInfo
Video Target information class.

The instance of this class is returned by ((<SDL::Screen.info>)). It
contains information on either the 'best' available mode (if
called before ((<SDL::Screen.open>))) or the current video mode.

This class has following methods.

--- SDL::VideoInfo#hw_available

    Is it possible to create hardware surfaces?

--- SDL::VideoInfo#wm_available
    
    Is there a window manager available?

--- SDL::VideoInfo#blit_hw
    
    Are hardware to hardware blits accelerated?

--- SDL::VideoInfo#blit_hw_CC
    
    Are hardware to hardware colorkey blits accelerated?

--- SDL::VideoInfo#blit_hw_A
    
    Are hardware to hardware alpha blits accelerated?

--- SDL::VideoInfo#blit_sw
    
    Are software to hardware blits accelerated?

--- SDL::VideoInfo#blit_sw_CC
    
    Are software to hardware colorkey blits accelerated?

--- SDL::VideoInfo#blit_sw_A
    
    Are software to hardware alpha blits accelerated?

--- SDL::VideoInfo#blit_fill
    
    Are color fills accelerated?

--- SDL::VideoInfo#video_mem
    
    Total amount of video memory in Kilobytes

--- SDL::VideoInfo#bpp
    
    bits per pixel of the video device

== SDL::PixelFormat
Surface format information class.
Please see ((<Color, PixelFormat and Pixel value>)).

* ((<SDL::PixelFormat#map_rgb>)) -- RGB Map a RGB color value to a pixel format.
* ((<SDL::PixelFormat#map_rgba>)) -- Map a RGBA color value to a pixel format.
* ((<SDL::PixelFormat#get_rgb>)) -- Get RGB values from a pixel in the specified pixel format.
* ((<SDL::PixelFormat#get_rgba>)) -- Get RGBA values from a pixel in the specified pixel format.
* ((<SDL::PixelFormat#Rmask>)) -- Get binary mask used to retrieve red color value
* ((<SDL::PixelFormat#Gmask>)) -- Get binary mask used to retrieve green color value
* ((<SDL::PixelFormat#Bmask>)) -- Get binary mask used to retrieve blue color value
* ((<SDL::PixelFormat#Amask>)) -- Get binary mask used to retrieve alpla value
* ((<SDL::PixelFormat#Rloss>)) -- Precision loss of red component
* ((<SDL::PixelFormat#Gloss>)) -- Precision loss of green component
* ((<SDL::PixelFormat#Bloss>)) -- Precision loss of blue component
* ((<SDL::PixelFormat#Aloss>)) -- Precision loss of alpha component
* ((<SDL::PixelFormat#Rshift>)) -- Binary left shift of red component in the pixel value
* ((<SDL::PixelFormat#Gshift>)) -- Binary left shift of green component in the pixel value
* ((<SDL::PixelFormat#Bshift>)) -- Binary left shift of blue component in the pixel value
* ((<SDL::PixelFormat#Ashift>)) -- Binary left shift of alpha component in the pixel value
* ((<SDL::PixelFormat#colorkey>)) -- Pixel value of transparent pixels.
* ((<SDL::PixelFormat#alpha>)) -- Overall surface alpha value
* ((<SDL::PixelFormat#bpp>)) -- The number of bits used to represent each pixel in a surface

== Color, PixelFormat and Pixel value

=== Outline
In Ruby/SDL, color is described as four elements
of 8-bit unsigned interger(from 0 to 255), Red, Green,
Blue and Alpha. In Ruby/SDL, this values are
packed as unsigned n-bit integer(n=8,16,24,32).
The rules of this conversion is called PixelFormat
and converted n-bit integer is called pixel value.
Each surface has one PixelFormat, and you can use
((<SDL::Surface#format>)) to get PixelFormat from surface object.
You can also covert from or to pixel values calling
((<SDL::PixelFormat#map_rgb>)), ((<SDL::PixelFormat#map_rgba>)),
((<SDL::PixelFormat#get_rgb>)) and ((<SDL::PixelFormat#get_rgba>)).
You can use pixel value or 3 elements array 
or 4 elements array as color parameter.
Return values are normally pixel values.

=== Details
Not documented yet.

== Video Methods 

--- SDL.get_video_surface
--- SDL.getVideoSurface

    This method is obsolete. Please use ((<SDL::Screen.get>)) instead.

--- SDL::Screen.get

    This method returns the current display surface.
    If SDL is doing format conversion on the display surface, this
    method returns the publicly visible surface, not the real
    video surface.

    Returns the instance of ((<SDL::Screen>)).

    Raises ((<SDL::Error>)) on failure
--- SDL.video_info
--- SDL.videoInfo

    This method is obsolete. Please use ((<SDL::Screen.info>)) instead.

--- SDL::Screen.info

    This function returns a ((<information|SDL::VideoInfo>)) about
    the video hardware. If this is called before ((<SDL::Screen.open>)),
    bpp attribute of the returned object will contain the pixel
    format of the "best" video mode.

    Returns the instance of ((<SDL::VideoInfo>)).

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Screen.open>)), ((<SDL::VideoInfo>))

--- SDL.video_driver_name
--- SDL.videoDriverName

    This method is obsolete. Please use ((<SDL::Screen.driver_name>)) instead.

--- SDL::Screen.driver_name
--- SDL::Screen.driverName

    The driver name is a simple one
    word identifier like "x11" or "windib".

    Returns driver name as string.

    Raises ((<SDL::Error>)) if video has not been initialized with 
    ((<SDL.init>)).

    * See Also
      
      ((<SDL.init>))

--- SDL.list_modes(flags)
--- SDL.listModes(flags)

    This method is obsolete. Please use ((<SDL::Screen.list_modes>)) instead.

--- SDL::Screen.list_modes(flags)
--- SDL::Screen.listModes(flags)

    Return an array of available screen dimensions for
    the given format and video flags, sorted largest to smallest.
    
    Returns nil if there are no dimensions available for a
    particular format, or true if any dimension is okay for the given
    format.
    The flag parameter is an OR'd
    combination of surface flags. The flags are the same as those
    used ((<SDL::Screen.open>)) and they play a strong role in deciding
    what modes are valid.
    For instance, if you pass SDL::HWSURFACE as
    a flag only modes that support hardware video surfaces will be
    returned.


    EXAMPLE
      # Get available fullscreen/hardware modes
      modes = SDL::Screen.list_modes(SDL::FULLSCREEN|SDL::HWSURFACE)
      
      # Check is there are any modes available
      if modes == nil
        puts "No modes available!"
        exit 1
      end
      
      # Check is there are any modes available
      if modes == true
        puts "All resolutions available."
      else
        # Print valid modes
        puts "Available Modes"
        modes.each{|w, h| puts "  #{w} x #{h}"}
      end

    * See Also
      
      ((<SDL::Screen.open>)), ((<SDL::Screen.info>))

--- SDL.check_video_mode(w,h,bpp,flags)
--- SDL.checkVideoMode(w,h,bpp,flags)

    This method is obsolete. Please use ((<SDL::Screen.check_mode>)) instead.

--- SDL::Screen.check_mode(w,h,bpp,flags)
--- SDL::Screen.checkMode(w,h,bpp,flags)

    Returns 0 if the requested mode is not supported
    under any bit depth,
    or returns the bits-per-pixel of the
    closest available mode with the given width, height and
    requested surface flags (see ((<SDL::Screen.open>))).
    
    The bits-per-pixel value returned is only a suggested mode. You
    can usually request and bpp you want when 
    ((<setting|SDL::Screen.opn>)) the video mode
    and SDL will emulate that color depth with a shadow video
    surface.


    EXAMPLE
      puts "Checking mode 640x480@16bpp."
      bpp = SDL::Screen.check_mode(640, 480, 16, SDL::HWSURFACE)
      if bpp == 0
        puts "Mode not available."
        exit 1
      end
      
      puts "SDL Recomemends 640x480@#{bpp}bpp."
      screen = SDL::Screen.open(640, 480, bpp, SDL_HWSURFACE)

    * See Also
      
      ((<SDL::Screen.open>)), ((<SDL::Screen.info>))

--- SDL.setVideoMode(w,h,bpp,flags)
--- SDL.set_video_mode(w,h,bpp,flags)

    This method is obsolete. Please use ((<SDL::Screen.open>)) instead.

--- SDL::Screen.open(w,h,bpp,flags)

    Set up a video mode with the specified width, height and
    bits-per-pixel.
    
    If bpp is 0, it is treated as the current display bits per
    pixel.
    
    The flags parameter is the same as the ((<SDL::Surface#flags>))
    OR'd combinations of the following values
    are valid.
    
    :SDL::SWSURFACE
      Create the video surface in system memory
    :SDL::HWSURFACE
      Create the video surface in video memory
    :SDL::ASYNCBLIT
      Enables the use of asynchronous updates of the
      display surface. This will usually slow down
      blitting on single CPU machines, but may
      provide a speed increase on SMP systems.
    :SDL::ANYFORMAT
      Normally, if a video surface of the requested
      bits-per-pixel (((|bpp|))) is not available, SDL will
      emulate one with a shadow surface. Passing
      SDL_ANYFORMAT prevents this and causes SDL to
      use the video surface, regardless of its pixel
      depth.
    :SDL::HWPALETTE
      Give SDL exclusive palette access. Without this
      flag you may not always get the the colors you
      request with ((<SDL::Surface#set_colors>)) or ((<SDL::Surface#set_palette>)).
    :SDL::DOUBLEBUF
      Enable hardware double buffering; only valid
      with SDL::HWSURFACE. Calling ((<SDL::Screen#flip>)) will flip
      the buffers and update the screen. All drawing
      will take place on the surface that is not
      displayed at the moment. If double buffering
      could not be enabled then ((<SDL::Screen#flip>)) will just
      perform a ((<SDL::Screen#update_rect>)) on the entire screen.
    :SDL::FULLSCREEN
      SDL will attempt to use a fullscreen mode. If a
      hardware resolution change is not possible (for
      whatever reason), the next higher resolution
      will be used and the display window centered on
      a black background.
    :SDL::OPENGL
      Create an OpenGL rendering context. You should
      have previously set OpenGL video attributes
      with ((<SDL::GL.set_attr>)).
    :SDL::OPENGLBLIT
      Create an OpenGL rendering context, like above,
      but allow normal blitting operations. The
      screen (2D) surface may have an alpha channel,
      and ((<SDL::Screen.update_rect>)) must be used for updating
      changes to the screen surface. NOTE: This
      option is kept for compatibility only, and is
      ((*not recommended*)) for new code.
    
    :SDL::RESIZABLE
      Create a resizable window. When the window is
      resized by the user a ((<SDL::Event::VideoResize>)) event is
      generated and ((<SDL::Screen.open>)) can be called
      again with the new size.
    :SDL::NOFRAME
      If possible, SDL::NOFRAME causes SDL to create a
      window with no title bar or frame decoration.
      Fullscreen modes automatically have this flag
      set.

    Returns the framebuffer surface as instace of ((<SDL::Screen>)).

    Raises ((<SDL::Error>)) on failure
    * NOTES

      Whatever flags ((<SDL::Screen.open>)) could satisfy are set
      in the ((|Surface#flags|)) of the returned surface.
      
      The ((|bpp|)) parameter is the number of bits per pixel, so
      a ((|bpp|)) of 24 uses the packed representation of 3 bytes/pixel.
      For the more common 4 bytes/pixel mode, use a ((|bpp|)) of 32.
      Somewhat oddly, both 15 and 16 will request a 2 bytes/pixel
      mode, but different pixel formats.

    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL::Surface#set_colors>)), ((<SDL::Screen#flip>)), ((<SDL::Screen>))

--- SDL::Screen#updateRect(x,y,w,h)
--- SDL::Screen#update_rect(x,y,w,h)

    Makes sure the given area is updated on the given screen. The
    rectangle must be confined within the screen boundaries (no
    clipping is done).
    
    If ((|x|)), ((|y|)), ((|w|)) and ((|h|)) are all 0, this method
    update the entire screen.
    
    This method should not be called while screen is
    ((|locked|Surface#lock|)).

    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL::Screen#update_rects>))

--- SDL::Screen#update_rects(*rects)
--- SDL::Screen#updateRects(*rects)

    Makes sure the given list of rectangles is updated on the given
    screen. Each rectangle parameter should be an array
    of 4 elements as [x, y, w, h].
    The rectangles must all be confined within the screen
    boundaries (no clipping is done).
    
    This method should not be called while screen(((|self|))),
    is ((<locked|SDL::Surface#lock>)).

    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL::Screen#update_rect>))

--- SDL::Screen#flip

    On hardware that supports double-buffering, this function sets
    up a flip and returns. The hardware will wait for vertical
    retrace, and then swap video buffers before the next video
    surface blit or lock will return. On hardware that doesn't
    support double-buffering, this is equivalent to calling 
    ((|self|)).((<update_rect|SDL::Screen#update_rect>))(0, 0, 0, 0)

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL.set_video_mode>)), ((<SDL::Screen#update_rect>))

--- SDL::Surface#set_colors(colors,firstcolor)
--- SDL::Surface#setColors(colors,firstcolor)

    Sets a portion of the colormap for the given 8-bit surface.
    
    When ((|self|)) is the surface associated with the current display,
    the display colormap will be updated with the requested colors.
    If SDL::HWPALETTE was set in ((<SDL::Screen.open>)) flags,
    this method will always return true, and the palette is
    guaranteed to be set the way you desire, even if the window
    colormap has to be warped or run under emulation.
    
    ((|colors|)) is array of colors, one color has three componets,
    R, G, B and each component is 8-bits in size.
    
    Palettized (8-bit) screen surfaces with the SDL::HWPALETTE flag
    have two palettes, a logical palette that is used for mapping
    blits to/from the surface and a physical palette (that
    determines how the hardware will map the colors to the display).
    SDL_SetColors modifies both palettes (if present), and is
    equivalent to calling ((<SDL::Surface#set_palette>)) 
    with the flags set to (SDL::OGPAL | SDL::PHYSPAL).

    If ((|self|)) is not a palettized surface, this method does
    nothing, returning false.
    If all of the colors were set as passed to
    this method, it will return true.
    If not all the color entries
    were set exactly as given, it will return false,
    and you should look
    at the surface palette to determine the actual color palette.


    EXAMPLE
      # Create a display surface with a grayscale palette
      
      # Fill colors with color information
      colors = Array.new(256){|i| [i, i, i]}
      # Create display
      screen = SDL::Screen.open(640, 480, 8, SDL::HWPALETTE)
      
      # Set palette
      screen.set_colors(colors, 0)

    * See Also
      
      ((<SDL::Surface#set_palette>)), ((<SDL::Screen.open>))

--- SDL::Surface#set_palette(flags,colors,firstcolor)
--- SDL::Surface#setPalette(flags,colors,firstcolor)

    Sets a portion of the palette for the given 8-bit surface.
    
    Palettized (8-bit) screen surfaces with the SDL::HWPALETTE flag
    have two palettes, a logical palette that is used for mapping
    blits to/from the surface and a physical palette (that
    determines how the hardware will map the colors to the display).
    ((<SDL::Surface.blit>)) always uses the logical palette when blitting
    surfaces (if it has to convert between surface pixel formats).
    Because of this, it is often useful to modify only one or the
    other palette to achieve various special color effects (e.g.,
    screen fading, color flashes, screen dimming).
    
    This method can modify either the logical or physical palette
    by specifing SDL::LOGPAL or SDL::PHYSPALthe in the ((|flags|))
    parameter.
    
    When ((|self|)) is the surface associated with the current display,
    the display colormap will be updated with the requested colors.
    If SDL::HWPALETTE was set in ((<SDL::Screen.open>)) flags,
    this method will always return true, and the palette is
    guaranteed to be set the way you desire, even if the window
    colormap has to be warped or run under emulation.
    
    ((|colors|)) is array of colors, one color has three componets,
    R, G, B and each component is 8-bits in size.

    If surface is not a palettized surface, this function does
    nothing, returning false.
    If all of the colors were set as passed to
    this method, it will return true.
    If not all the color entries
    were set exactly as given, it will return false,
     and you should look
    at the surface palette to determine the actual color palette.


    EXAMPLE
      # Create a display surface with a grayscale palette
      
      # Fill colors with color information
      colors = Array.new(256){|i| [i, i, i]}
      # Create display
      screen = SDL::Screen.open(640, 480, 8, SDL::HWPALETTE)
      
      # Setpalette
      screen.set_palette(SDL::LOGPAL|SDL::PHYSPAL, colors, 0)

    * See Also
      
      ((<SDL::Surface#set_colors>)), ((<SDL::Screen.open>))

--- SDL.set_gamma(redgamma,greengamma,bluegamma)
--- SDL.setGamma(redgamma,greengamma,bluegamma)

    This method is obsolete. Please use ((<SDL::Screen.set_gamma>)) instead.

--- SDL::Screen.set_gamma(redgamma,greengamma,bluegamma)
--- SDL::Screen.setGamma(redgamma,greengamma,bluegamma)

    Sets the "gamma function" for the display of each color
    component. Gamma controls the brightness/contrast of colors
    displayed on the screen. A gamma value of 1.0 is identity (i.e.,
    no adjustment is made).
    
    This function adjusts the gamma based on the "gamma function"
    parameter, you can directly specify lookup tables for gamma
    adjustment with ((<SDL::Screen.set_gamma_ramp>)).

    Raises ((<SDL::Error>)) on failure
    * NOTES

      Not all display hardware is able to change gamma.

    * See Also
      
      ((<SDL::Screen.get_gamma_ramp>)), ((<SDL::Screen.set_gamma_ramp>))

--- SDL.get_gamma_ramp
--- SDL.getGammaRamp

    This method is obsolete. Please use ((<SDL::Screen.get_gamma_ramp>)) instead.

--- SDL::Screen.get_gamma_ramp
--- SDL::Screen.getGammaRamp

    Gets the gamma translation lookup tables currently used by the
    display. Each table is an array of 256 16bit unsigned integer
    values.

    Returns an array of 3 elements of an array of 256 16bit unsigned integer.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      Not all display hardware is able to change gamma.

    * See Also
      
      ((<SDL::Screen.set_gamma>)), ((<SDL::Screen.set_gamma_ramp>))

--- SDL.set_gamma_ramp(table)
--- SDL.setGammaRamp(table)

    This method is obsolete. Please use ((<SDL::Screen.set_gamma_ramp>)) instead.

--- SDL::Screen.set_gamma_ramp(tables)
--- SDL::Screen.setGammaRamp(tables)

    Sets the gamma lookup tables for the display for each color
    component. 
    ((|tables|)) parameter is same as ((<SDL::Screen.get_gamma_ramp>)),
    representing a mapping between the input and output for that
    channel. The input is the index into the array, and the output
    is the 16-bit gamma value at that index, scaled to the output
    color precision. 
    
    This function adjusts the gamma based on lookup tables, you can
    also have the gamma calculated based on a "gamma function"
    parameter with ((<SDL::Screen.set_gamma>)).

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Screen.set_gamma>)), ((<SDL::Screen.get_gamma_ramp>))

--- SDL::Surface#map_rgb(r,g,b)
--- SDL::Surface#mapRGB(r,g,b)

    This method is obsolete. Please use ((<SDL::PixelFormat#map_rgb>)) instead.

--- SDL::PixelFormat#map_rgb(r,g,b)
--- SDL::PixelFormat#mapRGB(r,g,b)

    Maps the RGB color value to the specified pixel format and
    returns the pixel value as a 32-bit integer.
    ((|r|)), ((|g|)), ((|b|)) should be more than and equal to 0,
    and less than or equal to 255.
    
    If the format has a palette (8-bit) the index of the closest
    matching color in the palette will be returned.
    
    If the specified pixel format has an alpha component it will be
    returned as all 1 bits (fully opaque).

    A pixel value best approximating the given RGB color value for a
    given pixel format. If the pixel format bpp (color depth) is
    less than 32-bpp then the unused upper bits of the return value
    can safely be ignored (e.g., with a 16-bpp format the return
    value can be assigned to a 16-bit unsigned integer,
    and similarly a 8-bit unsigned integer for an 8-bpp format).

    * See Also
      
      ((<SDL::PixelFormat#get_rgb>)), ((<SDL::PixelFormat#get_rgba>)), ((<SDL::PixelFormat#map_rgba>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface#map_rgba(r,g,b,a)
--- SDL::Surface#mapRGBA(r,g,b,a)

    This method is obsolete. Please use ((<SDL::PixelFormat#map_rgba>)) instead.

--- SDL::PixelFormat#map_rgba(r,g,b,a)
--- SDL::PixelFormat#mapRGBA(r,g,b,a)

    Maps the RGBA color value to the specified pixel format and
    returns the pixel value as a 32-bit integer.
    ((|r|)), ((|g|)), ((|b|)) should be more than and equal to 0,
    and less than or equal to 255.
    
    If the format has a palette (8-bit) the index of the closest
    matching color in the palette will be returned.
    
    If the specified pixel format has no alpha component the alpha
    value will be ignored (as it will be in formats with a palette).

    A pixel value best approximating the given RGBA color value for a
    given pixel format. If the pixel format bpp (color depth) is
    less than 32-bpp then the unused upper bits of the return value
    can safely be ignored (e.g., with a 16-bpp format the return
    value can be assigned to a 16-bit unsigned integer,
    and similarly a 8-bit unsigned integer for an 8-bpp format).

    * See Also
      
      ((<SDL::PixelFormat#get_rgb>)), ((<SDL::PixelFormat#get_rgba>)), ((<SDL::PixelFormat#map_rgb>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface#get_rgb(pixel)
--- SDL::Surface#getRGB(pixel)

    This method is obsolete. Please use ((<SDL::PixelFormat#get_rgb>)) instead.

--- SDL::PixelFormat#get_rgb(pixel)
--- SDL::PixelFormat#getRGB(pixel)

    Get RGB component values from a pixel stored in the specified
    pixel format. It returns an array of 3 elements.
    
    This function uses the entire 8-bit [0..255] range when
    converting color components from pixel formats with less than
    8-bits per RGB component (e.g., a completely white pixel in
    16-bit RGB565 format would return [0xff, 0xff, 0xff] not [0xf8,
    0xfc, 0xf8]).

    * See Also
      
      ((<SDL::PixelFormat#get_rgba>)), ((<SDL::PixelFormat#map_rgb>)), ((<SDL::PixelFormat#map_rgba>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface#get_rgba(pixel)
--- SDL::Surface#getRGBA(pixel)

    This method is obsolete. Please use ((<SDL::PixelFormat#get_rgba>)) instead.

--- SDL::PixelFormat#get_rgba(pixel)
--- SDL::PixelFormat#getRGBA(pixel)

    Get RGBA component values as array of four elements 
    from a pixel stored in the specified
    pixel format.
    
    This function uses the entire 8-bit [0..255] range when
    converting color components from pixel formats with less than
    8-bits per RGB component (e.g., a completely white pixel in
    16-bit RGB565 format would return [0xff, 0xff, 0xff] not [0xf8,
    0xfc, 0xf8]).
    
    If the surface has no alpha component, the alpha will be
    returned as 0xff (100% opaque).

    * See Also
      
      ((<SDL::PixelFormat#get_rgba>)), ((<SDL::PixelFormat#map_rgb>)), ((<SDL::PixelFormat#map_rgba>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface.new(flags,w,h,depth,Rmask,Gmask,Bmask,Amask)
--- SDL::Surface.new(flags,w,h,format)

    Allocate an empty surface 
    (must be called after ((<SDL::Screen.open>)))
    
    If depth is 8 bits an empty palette is allocated for the
    surface, otherwise a 'packed-pixel' format is created
    using the ((|RGBAmask|))'s provided (see ((<SDL::PixelFormat>))). 
    The ((|flags|))
    specifies the type of surface that should be created, it is an
    OR'd combination of the following possible values.
    
    :SDL::SWSURFACE
      SDL will create the surface in system memory.
      This improves the performance of pixel level
      access, however you may not be able to take
      advantage of some types of hardware blitting.
    :SDL::HWSURFACE
      SDL will attempt to create the surface in
      video memory. This will allow SDL to take
      advantage of Video->Video blits (which are
      often accelerated).
    :SDL::SRCCOLORKEY
      This flag turns on colourkeying for blits from
      this surface. If SDL::HWSURFACE is also
      specified and colourkeyed blits are
      hardware-accelerated, then SDL will attempt to
      place the surface in video memory. Use
      ((<SDL::Surface#set_color_key>)) to set or clear this flag
      after surface creation.
    :SDL::SRCALPHA
      This flag turns on alpha-blending for blits
      from this surface. If SDL::HWSURFACE is also
      specified and alpha-blending blits are
      hardware-accelerated, then the surface will be
      placed in video memory if possible. Use
      ((<SDL::Surface#set_alpha>)) to set or clear this flag after
      surface creation.

    Returns the instance of ((<SDL::Surface>)).

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      # Create a 32-bit surface with the bytes of 
      # each pixel in R,G,B,A order,
      # as expected by OpenGL for textures
      
      big_endian = ([1].pack("N") == [1].pack("L"))
      
      if big_endian
        rmask = 0xff000000
        gmask = 0x00ff0000
        bmask = 0x0000ff00
        amask = 0x000000ff
      else
        rmask = 0x000000ff
        gmask = 0x0000ff00
        bmask = 0x00ff0000
        amask = 0xff000000
      end
      
      surface = SDL::Surface.new(SDL::SWSURFACE, width, height, 32,
                                 rmask, gmask, bmask, amask);

    * NOTES

        Note: If an alpha-channel is specified (that is, if ((|Amask|)) is
        nonzero), then the SDL::SRCALPHA flag is automatically set.
        You may remove this flag by calling ((<SDL::Surface#set_alpha>)) after
        surface creation.

    * See Also
      
      ((<SDL::Surface.new_from>)), ((<SDL::Screen.oepn>)), ((<SDL::Surface#lock>)), ((<SDL::Surface#set_alpha>)), ((<SDL::Surface#set_color_key>))

--- SDL::Surface.new_from(pixels,w,h,depth,pitch,Rmask,Gmask,Bmask,Amask)

    Creates an ((<SDL::Surface>)) object from the provided pixel data.
    
    The data stored in ((|pixels|))(String object)
     is assumed to be of the depth
    specified in the parameter list. 
    ((|pitch|)) is the length of each scanline in bytes.
    
    See ((<SDL::Surface.new>)) for a more detailed description of the
    other parameters.

    Returns the created surface.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface.new>))

--- SDL::Surface#lock

    This method sets up a surface for directly accessing the pixels. Between calls to ((<SDL::Surface#lock>)) 
    and ((<SDL::Surface#unlock>)) you can write to and read from surface directly.
    Once you are done accessing the surface, you should use ((<SDL::Surface#unlock>)) to release it.
    
    Not all surfaces require locking. If ((<SDL::Surface#must_lock?>)) returns false, then you can read and write to
    the surface at any time, and the pixel format of the surface will not change.
    
    No operating system or library calls should be made between lock/unlock pairs, as critical system locks
    may be held during this time.
    
    It should be noted, that since SDL 1.1.8 surface locks are recursive. This means that you can lock a
    surface multiple times, but each lock must have a match unlock.
      surface.lock
      # Surface is locked
      # Direct pixel access on surface here
      surface.lock
      # More direct pixel access on surface
      surface.unlock
      # Surface is still locked
      # Note: Is versions < 1.1.8, the surface would have been
      # no longer locked at this stage
      surface.unlock
      # Surface is now unlocked
    
    You shoud lock before colling following methods:
    * ((<SDL::Surface#pixels>))
    * ((<SDL::Surface#put_pixel>))
    * ((<SDL::Surface#get_pixel>))
    * ((<SDL::Surface#draw_line>))
    * ((<SDL::Surface#draw_aa_line>))
    * ((<SDL::Surface#draw_line_alpha>))
    * ((<SDL::Surface#draw_aa_line_alpha>))
    * ((<SDL::Surface#draw_rect>))
    * ((<SDL::Surface#draw_rect_alpha>))
    * ((<SDL::Surface#draw_filled_rect_alpha>))
    * ((<SDL::Surface#draw_circle>))
    * ((<SDL::Surface#draw_filled_circle>))
    * ((<SDL::Surface#draw_aa_circle>))
    * ((<SDL::Surface#draw_aa_filled_circle>))
    * ((<SDL::Surface#draw_circle_alpha>))
    * ((<SDL::Surface#draw_filled_circle_alpha>))
    * ((<SDL::Surface#draw_aa_circle_alpha>))
    * ((<SDL::Surface#draw_ellipse>))
    * ((<SDL::Surface#draw_filled_ellipse>))
    * ((<SDL::Surface#draw_aa_ellipse>))
    * ((<SDL::Surface#draw_aa_filled_ellipse>))
    * ((<SDL::Surface#draw_ellipse_alpha>))
    * ((<SDL::Surface#draw_filled_ellipse_alpha>))
    * ((<SDL::Surface#draw_aa_ellipse_alpha>))
    * ((<SDL::Surface#draw_bezier>))
    * ((<SDL::Surface#draw_aa_bezier>))
    * ((<SDL::Surface#draw_bezier_alpha>))
    * ((<SDL::Surface#draw_aa_bezier_alpha>))
    * ((<SDL::Surface#transform_surface>))

    Raises ((<SDL::Error>)), if the surface couldn't be locked.

    * NOTES

      If ((<SDL::Surface#auto_lock?>)) returns true, you need not call this method
      because Ruby/SDL automatically locks surface when you call methods that 
      need locking.

    * See Also
      
      ((<SDL::Surface#unlock>)), ((<SDL::Surface#must_lock?>)), ((<SDL.auto_lock?>)), ((<SDL.auto_lock_on>)), ((<SDL.auto_lock_off>)), ((<SDL.auto_lock=>))

--- SDL::Surface#unlock

    Surfaces that were previously locked using ((<SDL::Surfaces#lock>)) must be unlocked with ((<SDL::Surfaces#unlock>)).
    Surfaces should be unlocked as soon as possible.
    
    It should be noted that since 1.1.8, surface locks are recursive.

    * See Also
      
      ((<SDL::Surface#lock>))

--- SDL::Surface#must_lock?
--- SDL::Surface#mustLock?

    Returns true if ((|self|)) require locking for direct access to the pixels, 
    otherwise returns false.

    * See Also
      
      ((<SDL::Surface#lock>))

--- SDL::Surface.load_bmp(filename)
--- SDL::Surface.loadBMP(filename)

    Loads a surface from a named Windows BMP file.

    Returns the new ((<SDL::Surface>)) object.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface#save_bmp>)), ((<SDL::Surface.load>))

--- SDL::Surface.load_bmp_from_io(io)
--- SDL::Surface.loadBMPFromIO(io)

    Loads a surface from a ruby's IO object.
    IO object means the ruby object that has following methods:
    * read
    * rewind
    * tell
    
    For example, instances of IO class, StringIO class and Zlib::GZipReader class
    are IO object.

    Returns the new ((<SDL::Surface>)) object.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface.load_bmp>)), ((<SDL::Surface.load_from_io>))

--- SDL::Surface#save_bmp(filename)
--- SDL::Surface#saveBMP(filename)

    Saves the ((|self|)) surface as a Windows BMP file named ((|filename|)).

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface.load_bmp>))

--- SDL::Surface#destroy

    Frees the resource used by a Surface.
    If a surface is destroyed, all operations are forbidden.

    * See Also
      
      ((<SDL::Surface.new>)), ((<SDL::Surface.new_from>)), ((<SDL::Surface#destroyed?>))

--- SDL::Surface#destroyed?

    Returns whether the surface is destroyed by
    ((<SDL::Surface#destroy>)).

    * See Also
      
      ((<SDL::Surface#destroy>))

--- SDL::Surface#set_color_key(flag,key)
--- SDL::Surface#setColorKey(flag,key)

    Sets the color key (transparent pixel) in a blittable ((|surface|Surface|))
    and enables or disables RLE blit acceleration.
    ((|key|)) parameter should be pixel value or color array.
    
    RLE acceleration can substantially speed up blitting 
    of images with large horizontal runs of transparent
    pixels (i.e., pixels that match the ((|key|)) value). 
    The key must be of the same pixel format as the surface,
    if pixel value is used.
    In that case, ((<SDL::PixelFormat#map_rgb>))
    is often useful for obtaining an acceptable value.
    
    If ((|flag|)) is SDL_SRCCOLORKEY then ((|key|)) is the transparent pixel color in the source image of a blit.
    
    If ((|flag|)) is OR'd with SDL::RLEACCEL then the surface will 
    be draw using RLE acceleration when drawn with 
    ((<SDL::Surface.blit>)). The surface will actually be encoded 
    for RLE acceleration the first time ((<SDL::Surface.blit>))
    or ((<SDL::Surface#display_format>)) is called on the surface.
    
    If ((|flag|)) is 0, this function clears any current color key.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface.blit>)), ((<SDL::Surface#display_format>)), ((<SDL::Surface#map_rgb>)), ((<SDL::Surface#set_alpha>)), ((<SDL::Surface#colorkey>))

--- SDL::Surface#set_alpha(flags,alpha)
--- SDL::Surface#setAlpha(flags,alpha)

    This method is used for setting the per-surface alpha value and/or enabling and disabling alpha
    blending.
    
    The surface parameter specifies which surface whose 
    alpha attributes you wish to adjust. ((|flags|)) is used to
    specify whether alpha blending should be used (SDL::SRCALPHA)
     and whether the surface should use RLE
    acceleration for blitting (SDL::RLEACCEL). ((|flags|)) 
    can be an OR'd combination of these two options, one of
    these options or 0. If SDL::SRCALPHA is not passed as a flag
     then all alpha information is ignored when
    blitting the surface. The alpha parameter is the 
    per-surface alpha value; a surface need not have an
    alpha channel to use per-surface alpha and blitting can still be accelerated with SDL::RLEACCEL.
    
    Alpha effects surface blitting in the following ways:
    
    :RGBA->RGB with SDL::SRCALPHA    
      The source is alpha-blended with the destination, using the alpha channel.
      SDL_SRCCOLORKEY and the per-surface alpha are ignored.
    
    :RGBA->RGB without SDL::SRCALPHA
      The RGB data is copied from the source. The source alpha channel and the per-surface
      alpha value are ignored.
    
    :RGB->RGBA with SDL::SRCALPHA
      The source is alpha-blended with the destination using the per-surface alpha value. If
      SDL::SRCCOLORKEY is set, only the pixels not matching the colorkey value are copied. The
      alpha channel of the copied pixels is set to opaque.
    
    :RGB->RGBA without SDL::SRCALPHA
      The RGB data is copied from the source and the alpha value of the copied pixels is set to
      opaque. If SDL::SRCCOLORKEY is set, only the pixels not matching the colorkey value are
      copied.   
                                                                                                             
    :RGBA->RGBA with  SDL::SRCALPHA
      The source is alpha-blended with the destination using the source alpha channel. The     
      alpha channel in the destination surface is left untouched. SDL::SRCCOLORKEY is ignored.  
    
    RGBA->RGBA witout SDL::SRCALPHA
      The RGBA data is copied to the destination surface. If SDL::SRCCOLORKEY is set, only the  
      pixels not matching the colorkey value are copied.
    
    RGB->RGB with SDL_SRCALPHA
      The source is alpha-blended with the destination using the per-surface alpha value. If
      SDL_SRCCOLORKEY is set, only the pixels not matching the colorkey value are copied.
    
    RGB->RGB witout SDL_SRCALPHA
      The RGB data is copied from the source. If SDL_SRCCOLORKEY is set, only the pixels not
      matching the colorkey value are copied.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      Note: This method and the semantics of SDL alpha blending have changed since version 1.1.4. Up
      until version 1.1.5, an alpha value of 0 was considered opaque and a value of 255 was considered
      transparent. This has now been inverted: 0 (SDL::ALPHA_TRANSPARENT) is now considered transparent and
      255 (SDL::ALPHA_OPAQUE) is now considered opaque.
      The per-surface alpha value of 128 is considered a special case and is optimised, so it's much
      faster than other per-surface values.
      
      Note that RGBA->RGBA blits (with SDL::SRCALPHA set) keep the alpha of the destination surface.
      This means that you cannot compose two arbitrary RGBA surfaces this way and get the result you would
      expect from "overlaying" them; the destination alpha will work as a mask.
      
      Also note that per-pixel and per-surface alpha cannot be combined; the per-pixel alpha is always used
      if available

    * See Also
      
      ((<SDL::Surface#map_rgba>)), ((<SDL::Surface#get_rgba>)), ((<SDL::Surface#display_format>)), ((<SDL::Surface.blit>)), ((<SDL::Surface#alpha>))

--- SDL::Surface#set_clip_rect(x,y,w,h)
--- SDL::Surface#setClipRect(x,y,w,h)

    Sets the clipping rectangle for a surface. 
    When this surface is the destination of a blit, only the area
    within the clip rectangle will be drawn into.
    
    The rectangle pointed to by rect will be clipped to the edges of the surface so that the clip rectangle
    for a surface can never fall outside the edges of the surface.

    * See Also
      
      ((<SDL::Surface#get_clip_rect>)), ((<SDL::Surface.blit>))

--- SDL::Surface#get_clip_rect
--- SDL::Surface#getClipRect

    Gets the clipping rectangle for a surface. When this surface is the destination of a blit, only the area
    within the clip rectangle is drawn into.

    Returns 4 element array as [x, y, w, h].

    * See Also
      
      ((<SDL::Surface#set_clip_rect>)), ((<SDL::Surface.blit>))

--- SDL.blit_surface(src,srcX,srcY,srcW,srcH,dst,dstX,dstY)
--- SDL.blitSurface(src,srcX,srcY,srcW,srcH,dst,dstX,dstY)

    This method is obsolete. Please use ((<SDL::Surface.blit>)) instead.

--- SDL::Surface.blit(src,srcX,srcY,srcW,srcH,dst,dstX,dstY)

    This performs a fast blit from the source surface to the destination surface.
    
    ((|src|)) is source surface, ((|dst|)) is destination surface, 
    ((|srcX|)), ((|srcY|)), ((|srcW|)), ((|srcH|)) is source rectangle, 
    and ((|dstX|)), ((|dstY|)) is destination point.
    If all of ((|srcX|)), ((|srcY|)), ((|srcW|)), ((|srcH|)) is zero, the entire surface is copied.
    
    The blit function should not be called on a locked surface.
    
    The results of blitting operations vary greatly depending on whether SDL::SRCAPLHA is set or not. See 
    ((<SDL::Surface#set_alpha>)) for an explaination of how this 
    affects your results. Colorkeying and alpha attributes also
    interact with surface blitting, as the following pseudo-code should hopefully explain.
    
      if source surface has SDL::SRCALPHA set 
        if source surface has alpha channel (that is, Amask != 0)
          blit using per-pixel alpha, ignoring any colour key
        elsif source surface has SDL::SRCCOLORKEY set
          blit using the colour key AND the per-surface alpha value
        else
          blit using the per-surface alpha value
        end
      elsif source surface has SDL::SRCCOLORKEY se
        blit using the colour key
      else
        ordinary opaque rectangular blit
      end

    If the blit is successful, it returns 0.

    If either of the surfaces were in video memory, 
    and the blit raises SDL::Surface::VideoMemoryLost,
    the video memory was lost, so it
    should be reloaded with artwork and re-blitted.
    
    This happens under DirectX 5.0 when the system switches away from your fullscreen application. Locking
    the surface will also fail until you have access to the video memory again.

--- SDL::Surface#fill_rect(x,y,w,h,color)
--- SDL::Surface#fillRect(x,y,w,h,color)

    This method performs a fast fill of the given rectangle with ((|color|)).
    
    Please see ((<Color, PixelFormat and Pixel value>)) to specify ((|color|)).
    If the color value contains an alpha value then the destination is simply "filled"
    with that alpha information, no blending takes place.
    
    If there is a clip rectangle set on the destination (set via ((<SDL::Surface#set_clip_rect>)))
    then this function will clip based on the intersection of the clip rectangle 
    and the dstrect rectangle and the dstrect rectangle
    will be modified to represent the area actually filled.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface#map_rgb>)), ((<SDL::Surface#map_rgba>)), ((<SDL::Surface.blit>))

--- SDL::Surface#display_format
--- SDL::Surface#displayFormat

    This method copies ((|self|)) to a new surface of the pixel format and colors of the video
    framebuffer, suitable for fast blitting onto the display surface.
    
    If you want to take advantage of hardware colorkey or alpha blit acceleration, you should set the
    colorkey and alpha value before calling this function.
    
    If you want an alpha channel, see ((<SDL::Surface#display_format_alpha>)).

    Returns converted surface object.

    Raises ((<SDL::Error>)) if the conversion fails or runs out of memory.

    * See Also
      
      ((<SDL::Surface#display_format_alpha>)), ((<SDL::Surface#set_alpha>)), ((<SDL::Surface#set_color_key>))

--- SDL::Surface#display_format_alpha
--- SDL::Surface#displaFormatAlpha

    This method copies ((|self|)) to a new surface of the pixel format and colors of the video
    framebuffer plus an alpha channel, suitable for fast blitting onto the display surface.
    
    If you want to take advantage of hardware colorkey or alpha blit acceleration, you should set the
    colorkey and alpha value before calling this function.
    
    This function can be used to convert a colourkey to an alpha channel, if the SDL::SRCCOLORKEY flag is set
    on the surface. The generated surface will then be transparent (alpha=0) where the pixels match the
    colourkey, and opaque (alpha=255) elsewhere.

    Returns converted surface object.

    Raises ((<SDL::Error>)) if the conversion fails or runs out of memory.

    * See Also
      
      ((<SDL::Surface#display_format>)), ((<SDL::Surface#set_alpha>)), ((<SDL::Surface#set_color_key>))

--- SDL::Surface#flags

    Returns the surface flags.
    The following are supported:
    
    :SDL::SWSURFACE
      Surface is stored in system memory
    :SDL::HWSURFACE
      Surface is stored in video memory
    :SDL::ASYNCBLIT
      Surface uses asynchronous blits if possible
    :SDL::ANYFORMAT
      Allows any pixel-format (Display surface)
    :SDL::HWPALETTE
      Surface has exclusive palette
    :SDL::DOUBLEBUF
      Surface is double buffered (Display surface)
    :SDL::FULLSCREEN
      Surface is full screen (Display Surface)
    :SDL::OPENGL
      Surface has an OpenGL context (Display Surface)
    :SDL::OPENGLBLIT
      Surface supports OpenGL blitting (Display Surface)
    :SDL::RESIZABLE
      Surface is resizable (Display Surface)
    :SDL::HWACCEL
      Surface blit uses hardware acceleration
    :SDL::SRCCOLORKEY
      Surface use colorkey blitting
    :SDL::RLEACCEL
      Colorkey blitting is accelerated with RLE
    :SDL::SRCALPHA
      Surface blit uses alpha blending

    Returns OR'd compination of above constants.

    * See Also
      
      ((<SDL::Surface>)), ((<SDL::Screen>))

--- SDL::Surface#format

    Returns ((<SDL::PixelFormat>)) object.

--- SDL::Surface#w

    Returns width of the surface.

    * See Also
      
      ((<SDL::Surface#h>))

--- SDL::Surface#h

    Returns height of the surface

    * See Also
      
      ((<SDL::Surface#w>))

--- SDL::Surface#pixels

    Returns pixel data as String object.
    Examine ((<SDL::Surface#flags>)), ((<SDL::Surface#pitch>)) and ((<SDL::Surface#format>))
    to analyze pixel data.

    * NOTES

      You must ((<lock|SDL::Surface#lock>)) surface before calling this method.

    * See Also
      
      ((<SDL::Surface#flags>)), ((<SDL::Surface#pitch>)), ((<SDL::Surface#format>))

--- SDL::PixelFormat#Rmask

    Returns binary mask allowing us to isolate red component.

--- SDL::PixelFormat#Gmask

    Returns binary mask allowing us to isolate green component.

--- SDL::PixelFormat#Bmask

    Returns binary mask allowing us to isolate blue component.

--- SDL::PixelFormat#Amask

    Returns binary mask allowing us to isolate alpha component.

--- SDL::PixelFormat#Rloss

    Returns the number of bits lost from red component when packing 8-bit color component in a pixel.

--- SDL::PixelFormat#Gloss

    Returns the number of bits lost from green component when packing 8-bit color component in a pixel.

--- SDL::PixelFormat#Bloss

    Returns the number of bits lost from blue component when packing 8-bit color component in a pixel.

--- SDL::PixelFormat#Aloss

    Returns the number of bits lost from alpha component when packing 8-bit color component in a pixel.

--- SDL::PixelFormat#Rshift

    Returns the number of bits to the right of red component in the pixel value.

--- SDL::PixelFormat#Gshift

    Returns the number of bits to the right of green component in the pixel value.

--- SDL::PixelFormat#Bshift

    Returns the number of bits to the right of blue component in the pixel value

--- SDL::PixelFormat#Ashift

    Returns the number of bits to the right of alpha component in the pixel value.

--- SDL::Surface#colorkey

    Returns pixel value of transparent pixels.

    * See Also
      
      ((<SDL::Surface>)), ((<SDL::Surface#set_color_key>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface#alpha

    Returns surface alpha value from 0(transparent) to 255(opaque).

    * See Also
      
      ((<SDL::Surface#set_alpha>))

--- SDL::PixelFormat#colorkey

    Returns pixel value of transparent pixels.

    * See Also
      
      ((<SDL::Surface>)), ((<SDL::Surface#set_color_key>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::PixelFormat#alpha

    Returns surface alpha value from 0(transparent) to 255(opaque).

    * See Also
      
      ((<SDL::Surface#set_alpha>))

--- SDL::Surface#bpp

    This method is obsolete. Please use ((<SDL::PixelFormat#bpp>)) instead.

--- SDL::PixelFormat#bpp

    Returns the number of bits used to represent each pixel in a surface.
    Usually 8, 16, 24 or 32.

--- SDL::Surface.load(filename)

    Load image into an surface and returns ((<surface|SDL::Surface>)) object.
    If image format supports transparent color, colorkey is set into new surfafe.
    
    Supoorted formats are
    BMP, PNM (PPM/PGM/PBM), XPM,
    XCF, PCX, GIF, JPEG, TIFF, TGA, PNG and LBM.

    Raises ((<SDL::Error>)) on failure

    You need SDL_image to use this method.
--- SDL::Surface.load_from_io(io)
--- SDL::Surface.loadFromIO(io)

    Loads a surface from a ruby's IO object.
    IO object means the ruby object that has following methods:
    * read
    * rewind
    * tell
    
    If image format supports transparent color, colorkey is set into new surfafe.
    Supoorted formats are
    BMP, PNM (PPM/PGM/PBM), XPM,
    XCF, PCX, GIF, JPEG, TIFF, TGA, PNG and LBM.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Surface.load>)), ((<SDL::Surface.load_bmp_from_io>))

--- SDL::Surface#put_pixel(x, y, color)
--- SDL::Surface#putPixel(x, y, color)
--- SDL::Surface#[]=(x, y, color)

    Writes ((|color|)) pixel at (((|x|)), ((|y|))).


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.
    * See Also
      
      ((<SDL::Surface#get_pixel>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface#get_pixel(x, y)
--- SDL::Surface#getPixel(x, y)
--- SDL::Surface#[](x, y)

    Returns pixel value at (((|x|)), ((|y|))).


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.
    * See Also
      
      ((<SDL::Surface#put_pixel>)), ((<Color, PixelFormat and Pixel value>))

--- SDL::Surface#put(src, x, y)

    Performs a fast blit from entire ((|src|)) surface to ((|self|)) at (((|x|)), ((|y|))).
    
    This means:
      SDL::Surface.blit(src, 0, 0, src.w, src.h, self, x, y)

    * See Also
      
      ((<SDL::Surface.blit>))

--- SDL::Surface#copy_rect(x,y,w,h)
--- SDL::Surface#copyRect(x,y,w,h)

    Copies a (((|x|)), ((|y|)), ((|w|)), ((|h|))) rectangle from ((|self|)) and return new ((|surface|Surface|)) object.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      This method call ((<SDL::Surface.blit>)) internally, therefore you must unlock surface before calling it.

--- SDL.auto_lock?
--- SDL.autoLock?
--- SDL.auto_lock
--- SDL.autoLock

    This method is obsolete. Please use ((<SDL::Surface.auto_lock?>)) instead.


    You need SGE to use this method.
--- SDL::Surface.auto_lock?
--- SDL::Surface.autoLock?

    Returns true if surface is automatically ((<locked|SDL::Surface#lock>))
    when necessary, otherwise returns false.
    
    Default is ON(true).


    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL::Surface#unlock>)), ((<SDL::Surface.auto_lock_on>)), ((<SDL::Surface.auto_lock_off>))

--- SDL.auto_lock_on
--- SDL.autoLockON

    This method is obsolete. Please use ((<SDL::Surface.auto_lock_on>)) instead.


    You need SGE to use this method.
--- SDL::Surface.auto_lock_on
--- SDL::Surface.autoLockON

    Enables auto surface locking. 


    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL::Surface.auto_lock?>)), ((<SDL::Surface.auto_lock_off>))

--- SDL.auto_lock_off
--- SDL.autoLockOFF

    This method is obsolete. Please use ((<SDL::Surface.auto_lock_off>)) instead.


    You need SGE to use this method.
--- SDL::Surface.auto_lock_off
--- SDL::Surface.autoLockOFF

    Disables auto surface locking. 


    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL::Surface.auto_lock?>)), ((<SDL::Surface.auto_lock_on>))

--- SDL.auto_lock=(locking)
--- SDL.autoLock=(locking)

    This method is obsolete. Please use ((<SDL::Surface.auto_lock_on>)) instead.

    Enables or disables auto surface locking.
    'SDL.auto_lock = true' is same as ((<SDL::Surface.auto_lock_on>))
    and 'SDL.auto_lock = false' is same as 
    ((<SDL::Surface.auto_lock_off>)).


    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#lock>)), ((<SDL.auto_lock?>)), ((<SDL.auto_lock_on>)), ((<SDL.auto_lock_off>))

--- SDL.transform(src,dst,angle,xscale,yscale,px,py,qx,qy,flags)

    This method is obsolete. Please use ((<SDL::Surface.transform_draw>)) instead.


    You need SGE to use this method.
--- SDL::Surface.transform_draw(src,dst,angle,xscale,yscale,px,py,qx,qy,flags)

    Draws a rotated and scaled version of ((|src|)) on ((|dest|)).
    ((|angle|)) the rotation angle in degrees, 
    ((|xscale|)) and ((|yscale|)) are x and y scaling factor,
    (((|px|)), ((|py|))) is the pivot point to rotate around in the ((|src|)),
    and (((|qx|)), ((|qy|))) is the destination point on ((|dst|)) surface.
    
    ((|flags|)) is OR'd combination of follwing values:
    
    :0
      Default
    :SDL::Surface::TRANSFORM_SAFE
      Don't asume that the ((|src|)) and ((|dst|)) surfaces has
      the same pixel format. This is the default when the two
      surfaces don't have the same BPP. This is slower but will
      render wierd pixel formats right.
    :SDL::Surface::TRANSFORM_AA
      Use the interpolating renderer. Much slower but
      can look better.
    :SDL::Surface::TRANSFORM_TMAP
      Use texture mapping. This is a bit faster but
      the result isn't as nice as in the normal mode. This mode
      will also ignore the px/py coordinates and the other flags.


    You need SGE to use this method.
    * NOTES

      To get optimal performance PLEASE make sure that the two
      surfaces has the same pixel format (color depth) and doesn't use
      24-bpp.
      
      You can set source and destination clipping rectangles with
      ((<SDL::Surface#set_clip_rect>)).
      
      If you use the interpolated renderer the image will be
      clipped 1 pixel in hight and width (to optimize the
      performance).
      
      If you want to transform a 32-bpp RGBA (alpha) surface with
      the interpolated renderer, please use the 
      SDL::TRANSFORM_SAFE flag.
      
      This function will not do any alpha blending, but it will
      try to preserve the alpha channel. If you want to rotate and
      alpha blend the result, please use ((<SDL::Surface.transform_blit>))
      and then blit that surface to its destination.

    * See Also
      
      ((<SDL::Surface.transform_blit>)), ((<SDL::Surface#transform_surface>)), ((<SDL::Surface.new>))

--- SDL.transform_blit(src,dst,angle,xscale,yscale,px,py,qx,qy,flags)
--- SDL.transformBlit(src,dst,angle,xscale,yscale,px,py,qx,qy,flags)

    This method is obsolete. Please use ((<SDL::Surface.transform_blit>)) instead.


    You need SGE to use this method.
--- SDL::Surface.transform_blit(src,dst,angle,xscale,yscale,px,py,qx,qy,flags)
--- SDL::Surface.transformBlit(src,dst,angle,xscale,yscale,px,py,qx,qy,flags)

    Draw a rotated and scaled image. 
    This method is same as ((<SDL::Surface.transform_draw>)) except
    colorkey and blending are enabled. 


    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface.transform_draw>)), ((<SDL::Surface#transform_surface>)), ((<SDL::Surface#set_color_key>)), ((<SDL::Surface#set_alpha>))

--- SDL::Surface#draw_line(x1,x2,y1,y2,color, aa=false, alpha=nil)
--- SDL::Surface#drawLine(x1,x2,y1,y2,color, aa=false, alpha=nil)

    Draws a ((|color|)) line from (((|x1|)), ((|y1|))) to (((|x2|)), ((|y2|))).
    If ((|aa|)) is true, draws an antialiased line.
    If ((|alpha|)) is integer, draws blended line with alpha value
    is ((|alpha|)). 
    If ((|alpha|)) is nil, draws a normal line.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_rect>))

--- SDL::Surface#draw_aa_line(x1,x2,y1,y2,color)
--- SDL::Surface#drawAALine(x1,x2,y1,y2,color)

    This method is obsolete. Please use ((<SDL::Surface#draw_line>)) instead.

    Draws a ((|color|)) antialiased line from (((|x1|)), ((|y1|))) to (((|x2|)), ((|y2|))).


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_line>))

--- SDL::Surface#draw_line_alpha(x1,x2,y1,y2,color,alpha)
--- SDL::Surface#drawLineAlpha(x1,x2,y1,y2,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_line>)) instead.

    Draws a ((|color|)) line from (((|x1|)), ((|y1|))) to (((|x2|)), ((|y2|)))
    with blending.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_line>))

--- SDL::Surface#draw_aa_line_alpha(x1,x2,y1,y2,color,alpha)
--- SDL::Surface#drawAALineAlpha(x1,x2,y1,y2,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_line>)) instead.

    Draws a antialiased ((|color|)) line from 
    (((|x1|)), ((|y1|))) to (((|x2|)), ((|y2|))) with blending.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_line>))

--- SDL::Surface#draw_rect(x,y,w,h,color, fill=false, alpha=nil)
--- SDL::Surface#drawRect(x,y,w,h,color, fill=false, alpha=nil)

    Draws a rectangle with color ((|color|)). 
    Draw a filled rectangle if ((|fill|)) is true,
    and a blended rectangle if ((|alpha|)) is integer.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#fill_rect>))

--- SDL::Surface#draw_rect_alpha(x,y,w,h,color,alpha)
--- SDL::Surface#drawRectAlpha(x,y,w,h,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_rect>)) instead.

    Draws a blended rectangle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#fill_rect>)), ((<SDL::Surface#draw_rect>))

--- SDL::Surface#draw_filled_rect_alpha(x,y,w,h,color,alpha)
--- SDL::Surface#drawFilledRectAlpha(x,y,w,h,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_rect>)) instead.

    Draws a filled blended rectangle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#fill_rect>)), ((<SDL::Surface#draw_rect>))

--- SDL::Surface#draw_circle(x,y,r,color,fill=false,aa=false,alpha=0)
--- SDL::Surface#drawCircle(x,y,r,color,fill=false,aa=false,alpha=0)

    Draws a circle. (((|x|)),((|y|))) is center, 
    ((|r|)) is radius and ((|color|)) is drawing color.
    If ((|fill|)) is true, draws a filled circle.
    If ((|aa|)) is true, draws an antialiased circle.
    If ((|alpha|)) is integer, draws a blended circle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * NOTES

      You cannot draw a filled antialiased blended circle.

    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_filled_circle(x,y,r,color)
--- SDL::Surface#drawFilledCircle(x,y,r,color)

    This method is obsolete. Please use ((<SDL.draw_circle>)) instead.

    Draws a filled circle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_aa_circle(x,y,r,color)
--- SDL::Surface#drawAACircle(x,y,r,color)

    This method is obsolete. Please use ((<SDL.draw_circle>)) instead.

    Draws an antialiased circle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_aa_filled_circle(x,y,r,color)
--- SDL::Surface#drawAAFilledCircle(x,y,r,color)

    This method is obsolete. Please use ((<SDL.draw_circle>)) instead.

    Draws a filled antialiased circle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_circle_alpha(x,y,r,color,alpha)
--- SDL::Surface#drawCircleAlpha(x,y,r,color,alpha)

    This method is obsolete. Please use ((<SDL.draw_circle>)) instead.

    Draws blended circle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_filled_circle_alpha(x,y,r,color,alpha)
--- SDL::Surface#drawFilledCircleAlpha(x,y,r,color,alpha)

    This method is obsolete. Please use ((<SDL.draw_circle>)) instead.

    Draws a filled blended circle.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_aa_circle_alpha(x,y,r,color,alpha)
--- SDL::Surface#drawAACircleAlpha(x,y,r,color,alpha)

    This method is obsolete. Please use ((<SDL.draw_circle>)) instead.

    Draws an antialiased blended circle


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_ellipse(x,y,rx,ry,color, fill=false, aa=false, alpha=nil)
--- SDL::Surface#drawEllipse(x,y,rx,ry,color, fill=false, aa=false, alpha=nil) )

    
    Draws an ellipse. (((|x|)),((|y|))) is center, 
    ((|rx|)) is x-radius, ((|ry|)) is y-radius
    and ((|color|)) is drawing color.
    If ((|fill|)) is true, draws a filled ellipse.
    If ((|aa|)) is true, draws an antialiased ellipse.
    If ((|alpha|)) is integer, draws a blended ellipse.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * NOTES

      You cannot draw a filled antialiased blended ellipse.

    * See Also
      
      ((<SDL::Surface#draw_circle>))

--- SDL::Surface#draw_filled_ellipse(x,y,rx,ry,color)
--- SDL::Surface#drawFilledEllipse(x,y,rx,ry,color)

    This method is obsolete. Please use ((<SDL::Surface#draw_ellipse>)) instead.

    Draws a filled ellipse.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_aa_ellipse(x,y,rx,ry,color)
--- SDL::Surface#drawAAEllipse(x,y,rx,ry,color)

    This method is obsolete. Please use ((<SDL::Surface#draw_ellipse>)) instead.

    Draws an antialiased ellipse.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_aa_filled_ellipse(x,y,rx,ry,color)
--- SDL::Surface#drawAAFilledEllipse(x,y,rx,ry,color)

    This method is obsolete. Please use ((<SDL::Surface#draw_ellipse>)) instead.

    Draws a filled antialiased ellipse.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_ellipse_alpha(x,y,rx,ry,color,alpha)
--- SDL::Surface#drawEllipseAlpha(x,y,rx,ry,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_ellipse>)) instead.

    Draws a blended ellipse.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_filled_ellipse_alpha(x,y,rx,ry,color,alpha)
--- SDL::Surface#drawFilledEllipseAlpha(x,y,rx,ry,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_ellipse>)) instead.

    Draws a filled blended ellipse


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_aa_ellipse_alpha(x,y,rx,ry,color,alpha)
--- SDL::Surface#drawAAEllipseAlpha(x,y,rx,ry,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_ellipse>)) instead.

    Draws an antialiased blended ellipse.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_ellipse>))

--- SDL::Surface#draw_bezier(x1,y1,x2,y2,x3,y3,x4,y4,level,color,aa=false,alpha=nil)
--- SDL::Surface#drawBezier(x1,y1,x2,y2,x3,y3,x4,y4,level,color,aa=false,alpha=nil)

    Draws a bezier curve from (((|x1|)), ((|y1|))) to (((|x4|)), ((|y4|)))
    with the control points (((|x2|)), ((|y2|))) and (((|x3|)), ((|y3|))).
    ((|level|)) indicates how
    good precision the function should use, 4-7 is normal.
    If ((|aa|)) is true, draws an antialiased curve.
    If ((|alpha|)) is integer, draws blended curve.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
--- SDL::Surface#draw_aa_bezier(x1,y1,x2,y2,x3,y3,x4,y4,level,color)
--- SDL::Surface#drawAABezier(x1,y1,x2,y2,x3,y3,x4,y4,level,color)

    This method is obsolete. Please use ((<SDL::Surface#draw_bezier>)) instead.

    Draws an antialiased bezier curve.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_bezier>))

--- SDL::Surface#draw_bezier_alpha(x1,y1,x2,y2,x3,y3,x4,y4,level,color,alpha)
--- SDL::Surface#drawBezierAlpha(x1,y1,x2,y2,x3,y3,x4,y4,level,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_bezier>)) instead.

    Draws a blended bezier curve.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_bezier>))

--- SDL::Surface#draw_aa_bezier_alpha(x1,y1,x2,y2,x3,y3,x4,y4,level,color,alpha)
--- SDL::Surface#drawAABezierAlpha(x1,y1,x2,y2,x3,y3,x4,y4,level,color,alpha)

    This method is obsolete. Please use ((<SDL::Surface#draw_bezier>)) instead.

    Draws an antialiased blended bezier curve.


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#draw_bezier>))

--- SDL::Surface#transform_surface(bgcolor,angle,xscale,yscale,flags)
--- SDL::Surface#transformSurface(bgcolor,angle,xscale,yscale,flags)

    Returns a rotated and scaled version of ((|self|)).
    See ((|Surface.transform_draw|)) for more information.
    ((|bgcolor|)) is background color that new surface have.
    
    The new surface object will have the same depth 
    and pixel format as ((|self|)).


    This method needs ((<Locking|SDL::Surface#lock>)).
    If ((<SDL.auto_lock?>)) is true, Ruby/SDL automatically locks/unlocks the surface.
    Raises ((<SDL::Error>)) on failure

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface.transform_draw>)), ((<SDL::Surface.transform_blit>))

= OpenGL
* ((<OpenGL outline>))

* OpenGL related methods
  * ((<SDL::GL.get_attr>)) -- Get the value of a special SDL/OpenGL attribute
  * ((<SDL::GL.set_attr>)) -- Set a special SDL/OpenGL attribute
  * ((<SDL::GL.swap_buffers>)) -- Swap OpenGL framebuffers/Update Display

== OpenGL outline
Ruby/SDL has the ability to create and use OpenGL
contexts on several platforms(Linux/
X11, Win32, Mac OS X, etc).
This allows you to use SDL's audio, event handling and times in your
OpenGL applications (a function often performed by GLUT).

Ruby/SDL has no OpenGL methods, please use
((<ruby-opengl|URL:http://ruby-opengl.rubyforge.org/>)) or
((<riko|URL:http://www.kumaryu.net/?(Ruby)+Riko>))
with Ruby/SDL.

=== Initialisation
Initialising Ruby/SDL to use OpenGL is not very
different to initialising Ruby/SDL normally.
There are three differences; you must pass
SDL::OPENGL to ((<SDL::Screen.open>)), you
must specify several GL attributes (depth buffer size, framebuffer sizes) using 
((<SDL::GL.set_attr>)) and finally, if you wish to use double buffering you must
specify it as a GL attribute, ((*not*)) by passing the SDL::DOUBLEBUF flag to
SDL::DOUBLEBUF.


EXAMPLE
  # First, initialize SDL's video subsystem.
  SDL.init(SDL::INIT_VIDEO)
  # Let's get some video information.
  info = SDL::Screen.info
  # Set our width/height to 640/480 (you would
  # of course let the user decide this in a normal
  # app).
  width = 640
  height = 480
  # We get the bpp we will request from the display.
  bpp = info.bpp
  # Now, we want to setup our requested
  # window attributes for our OpenGL window.
  # We want *at least* 5 bits of red, green
  # and blue. We also want at least a 16-bit
  # depth buffer.
  #
  # The last thing we do is request a double
  # buffered window. '1' turns on double
  # buffering, '0' turns it off.
  #
  # Note that we do not use SDL::DOUBLEBUF in
  # the flags to SDL::Screen.open. That does
  # not affect the GL attribute state, only
  # the standard 2D blitting setup.
  SDL::GL.set_attr(SDL::GL::RED_SIZE, 5)
  SDL::GL.set_attr(SDL::GL::GREEN_SIZE, 5)
  SDL::GL.set_attr(SDL::GL::BLUE_SIZE, 5)
  SDL::GL.set_attr(SDL::GL::DEPTH_SIZE, 16)
  SDL::GL.set_attr(SDL::GL::DOUBLEBUFFER, 1)

  # We want to request that SDL provide us
  # with an OpenGL window, in a fullscreen
  # video mode.
  flags = SDL:;OPENGL | SDL::FULLSCREEN

  # Set the video mode
  SDL::Screen.open(width, height, bpp, flags)

=== GL attribute
You can use ((<SDL::GL.get_attr>)) and ((<SDL::GL.set_attr>)) with following attributes:
* SDL::GL::RED_SIZE         Size of the framebuffer red component, in bits
* SDL::GL::GREEN_SIZE       Size of the framebuffer green component, in bits
* SDL::GL::BLUE_SIZE        Size of the framebuffer blue component, in bits
* SDL::GL::ALPHA_SIZE       Size of the framebuffer alpha component, in bits
* SDL::GL::DOUBLEBUFFER     0 or 1, enable or disable double buffering
* SDL::GL::BUFFER_SIZE      Size of the framebuffer, in bits
* SDL::GL::DEPTH_SIZE       Size of the depth buffer, in bits
* SDL::GL::STENCIL_SIZE     Size of the stencil buffer, in bits
* SDL::GL::ACCUM_RED_SIZE   Size of the accumulation buffer red component, in bits
* SDL::GL::ACCUM_GREEN_SIZE Size of the accumulation buffer green component, in bits
* SDL::GL::ACCUM_BLUE_SIZE  Size of the accumulation buffer blue component, in bits
* SDL::GL::ACCUM_ALPHA_SIZE Size of the accumulation buffer alpha component, in bits

=== Drawing
Apart from initialisation, using OpenGL within Ruby/SDL
is the same as using OpenGL
with any other API, e.g. GLUT. You still use all the same function calls and data
types. However if you are using a double-buffered display, then you must use 
((<SDL::GL.swap_buffers>)) to swap the buffers and update the display. To request
double-buffering with OpenGL, use ((<SDL::GL.set_attr>)) with SDL::GL::DOUBLEBUFFER,
and use ((<SDL::GL.get_attr>)) to see if you actually got it.

== Methods

--- SDL::GL.get_attr(attr)
--- SDL::GL.getAttr(attr)

    Returns the value of the SDL/OpenGL ((<attribute|GL attribute>)) ((|attr|)).
    This is useful after
    a call to ((<SDL::Screen.open>)) to check whether your attributes have been set as you
    expected.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::GL.set_attr>))

--- SDL::GL.set_attr(attr, val)
--- SDL::GL.setAttr(attr, val)

    Sets the OpenGL ((<attribute|GL attribute>)) ((|attr|)) to ((|value|)).
    The attributes you set don't take effect
    until after a call to ((<SDL::Screen.open>)). You should use ((<SDL::GL.get_attr>)) to
    check the values after a ((<SDL::Screen.open>)) call.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      The SDL::DOUBLEBUF flag is not required to enable double buffering when
      setting an OpenGL video mode. Double buffering is enabled or disabled using
      the SDL::GL::DOUBLEBUFFER attribute.

    * See Also
      
      ((<SDL::GL.get_attr>))

--- SDL::GL.swap_buffers()
--- SDL::GL.swapBuffers()

    Swap the OpenGL buffers, if double-buffering is supported.

    * See Also
      
      ((<SDL::GL.set_attr>)), ((<SDL::Screen.open>))

= Window Management
* ((<Window Management Overview>))
* ((<Methods for Window Management>))
  * ((<SDL::WM.caption>)) -- Gets the window title and icon name.
  * ((<SDL::WM.set_caption>)) -- Sets the window tile and icon name.
  * ((<SDL::WM.icon=>)) -- Sets the icon for the display window.
  * ((<SDL::WM.iconify>)) -- Iconify/Minimise the window
  * ((<SDL::WM.grab_input>)) -- Grabs mouse and keyboard input.

== Window Management Overview
SDL provides a small set of window management functions
which allow applications to change their title and toggle
from windowed mode to fullscreen (if available)

== Methods for Window Management

--- SDL::WM.caption

    Returns the window title and icon name as an array with two element.

    * See Also
      
      ((<SDL::WM.set_caption>))

--- SDL::WM.set_caption(title, icon)
--- SDL::WM.setCaption(title, icon)

    Sets the title-bar and icon name of the display window.

    * NOTES

      ((|title|)) and ((|icon|)) must be UTF8 or ASCII string.
      
      If Ruby/SDL m17n support is enabled, 
      ((|title|)) and ((|icon|)) are converted to UTF8 automatically.

    * See Also
      
      ((<SDL::WM.caption>)), ((<SDL::WM.icon=>))

--- SDL::WM.icon=(icon_image)

    Sets the icon for the display window. Win32 icons must be 32x32.
    
    This function must be called before the first call to 
    ((<SDL::Screen.open>)).
    ((|icon_image|)) should be an instance of ((<SDL::Surface>))


    EXAMPLE
      SDL::WM.icon = SDL::Surface.load_bmp("icon.bmp")

    * See Also
      
      ((<SDL.set_video_mode>)), ((<SDL::WM.caption>))

--- SDL::WM.iconify

    If the application is running in a window managed environment
    SDL attempts to iconify/minimise
    it. If this method is successful,
    the application will receive a ((<SDL::Event::APPACTIVE>))
    loss event.

    Raises ((<SDL::Error>)) on failure
--- SDL::WM.grab_input(mode)
--- SDL::WM.grabInput(mode)

    Grabbing means that the mouse is confined to the application window,
    and nearly all keyboard input is passed directly to the application,
    and not interpreted by a window manager, if any.
    
    You can use following three constants as ((|mode|)).
    * SDL::WM::GRAB_QUERY
    * SDL::WM::GRAB_OFF
    * SDL::WM::GRAB_ON
    
    When ((|mode|)) is SDL::WM::GRAB_QUERY, 
    the grab mode is not changed, but the current grab mode is returned.

    Returns the current/new mode.

= Event
* ((<Event system Overview>))
* ((<SDL::Event>))
* ((<SDL::Event::Active>))
* ((<SDL::Event::KeyDown>))
* ((<SDL::Event::KeyUp>))
* ((<SDL::Event::MouseMotion>))
* ((<SDL::Event::MouseButtonDown>))
* ((<SDL::Event::MouseButtonUp>))
* ((<SDL::Event::JoyAxis>))
* ((<SDL::Event::JoyBall>))
* ((<SDL::Event::JoyHat>))
* ((<SDL::Event::JoyButtonDown>))
* ((<SDL::Event::JoyButtonUp>))
* ((<SDL::Event::Quit>))
* ((<SDL::Event::SysWM>))
* ((<SDL::Event::VideoResize>))
* ((<SDL::Event::VideoExpose>))
* ((<SDL::Key>))
* ((<SDL::Mouse>))
* Methdos for Event
  * ((<SDL::Event.poll>)) -- Polls for currently pending events.
  * ((<SDL::Event.wait>)) -- Waits indefinitely for the next available event.
  * ((<SDL::Event.push>)) -- Pushes an event onto the event queue.
  * ((<SDL::Event.app_state>)) -- Get the state of the application.
  * ((<SDL::Event.enable_unicode>)) -- Enable UNICODE translation
  * ((<SDL::Event.disable_unicode>)) -- Disable UNICODE translation
  * ((<SDL::Event.enable_unicode?>)) -- Get whether UNICODE translation is enabled.
  * ((<SDL::Event::Active#gain>)) -- Returns whether gaining visibility or not
  * ((<SDL::Event::Active#state>)) -- Gets the type of visibility event.
  * ((<SDL::Event::KeyDown#press>)) -- Returns true.
  * ((<SDL::Event::KeyDown#sym>)) -- Get the key symbol of pressed key
  * ((<SDL::Event::KeyDown#mod>)) -- Current key modifier
  * ((<SDL::Event::KeyDown#unicode>)) -- Translated character
  * ((<SDL::Event::KeyUp#press>)) -- Whether key is pressed
  * ((<SDL::Event::KeyUp#sym>)) -- Get the key symbol of released key
  * ((<SDL::Event::KeyUp#mod>)) -- Current key modifier
  * ((<SDL::Event::MouseMotion#state>)) -- The current button state
  * ((<SDL::Event::MouseMotion#x>)) -- The X coordinate of the mouse
  * ((<SDL::Event::MouseMotion#y>)) -- the X coordinate of the mouse.
  * ((<SDL::Event::MouseMotion#xrel>)) -- Relative motion in the X direction
  * ((<SDL::Event::MouseMotion#yrel>)) -- Relative motion in the Y direction
  * ((<SDL::Event::MouseButtonDown#button>)) -- The mouse button index
  * ((<SDL::Event::MouseButtonDown#press>)) -- Whether mouse button is pressed or not
  * ((<SDL::Event::MouseButtonDown#x>)) -- The X coordinate of the mouse at press time.
  * ((<SDL::Event::MouseButtonDown#y>)) -- The Y coordinate of the mouse at press time
  * ((<SDL::Event::MouseButtonUp#button>)) -- The mouse button index
  * ((<SDL::Event::MouseButtonUp#press>)) -- Whether mouse button is pressed or not
  * ((<SDL::Event::MouseButtonUp#x>)) -- The X coordinate of the mouse at release time
  * ((<SDL::Event::MouseButtonUp#y>)) -- The Y coordinate of the mouse at release time.
  * ((<SDL::Event::JoyAxis#which>)) -- Joystick device index
  * ((<SDL::Event::JoyAxis#axis>)) -- JoyAxis axis index
  * ((<SDL::Event::JoyAxis#value>)) -- Axis value
  * ((<SDL::Event::JoyBall#which>)) -- Joystick device index
  * ((<SDL::Event::JoyBall#ball>)) -- Joystick trackball index
  * ((<SDL::Event::JoyBall#xrel>)) -- The relative motion in the X direction
  * ((<SDL::Event::JoyBall#yrel>)) -- The relative motion in the Y direction.
  * ((<SDL::Event::JoyHat#which>)) -- Joystick device index
  * ((<SDL::Event::JoyHat#hat>)) -- Joystick hat index
  * ((<SDL::Event::JoyHat#value>)) -- Hat position
  * ((<SDL::Event::JoyButtonDown#which>)) -- Joystick device index
  * ((<SDL::Event::JoyButtonDown#button>)) -- Joystick button index
  * ((<SDL::Event::JoyButtonDown#press>)) -- Joystick button is pressed or released
  * ((<SDL::Event::JoyButtonUp#which>)) -- Joystick device index
  * ((<SDL::Event::JoyButtonUp#button>)) -- Joystick button index
  * ((<SDL::Event::JoyButtonUp#press>)) -- Joystick button is pressed or released
  * ((<SDL::Event::VideoResize#w>)) -- New width of the window.
  * ((<SDL::Event::VideoResize#h>)) -- New height of the window 
  * ((<SDL::Key.scan>)) -- Get a snapshot of the current keyboard state
  * ((<SDL::Key.press?>)) -- Get the current keyboard state.
  * ((<SDL::Key.mod_state>)) -- Get the state of modifier keys.
  * ((<SDL::Key.get_key_name>)) -- Get the name of an SDL virtual keysym
  * ((<SDL::Key.enable_key_repeat>)) -- Set keyboard repeat rate.
  * ((<SDL::Key.disable_key_repeat>)) -- Disable key repeat.
  * ((<SDL::Mouse.state>)) -- Retrieve the current state of the mouse
  * ((<SDL::Mouse.warp>)) -- Set the position of the mouse cursor.
  * ((<SDL::Mouse.show>)) -- Toggle the cursor is shown on the screen.
  * ((<SDL::Mouse.hide>)) -- Hide cursor.
  * ((<SDL::Mouse.show?>)) -- Get the state of mouse cursor.
  * ((<SDL::Mouse.set_cursor>)) -- Set the currently active mouse cursor.

== Event system Overview
Event handling allows your application to receive input from the user.
Event handling is initalised (along with video) with a call to:
  SDL_Init(SDL_INIT_VIDEO);
Internally, SDL stores all the events waiting to be handled in an event queue.
Using functions like ((<SDL::Event.poll>)) and ((<SDL::Event.wait>))
you can observe and handle waiting input events.

The key to event handling in SDL is the subclasses of ((<SDL::Event>)).
The event queue itself is composed of a series of 
instance of (subclasses of) ((<SDL::Event>)), one for each waiting event.
Those objects are read from queue with the ((<SDL::Event.poll>)) and it is
then up to the application to process the information stored with them.

Subclasses of ((<SDL::Event>)) is following:
* ((<SDL::Event::Active>))
* ((<SDL::Event::KeyDown>))
* ((<SDL::Event::KeyUp>))
* ((<SDL::Event::MouseMotion>))
* ((<SDL::Event::MouseButtonDown>))
* ((<SDL::Event::MouseButtonUp>))
* ((<SDL::Event::JoyAxis>))
* ((<SDL::Event::JoyBall>))
* ((<SDL::Event::JoyHat>))
* ((<SDL::Event::JoyButtonDown>))
* ((<SDL::Event::JoyButtonUp>))
* ((<SDL::Event::Quit>))
* ((<SDL::Event::SysWM>))
* ((<SDL::Event::VideoResize>))
* ((<SDL::Event::VideoExpose>))

Those classes have two uses.
* Reading events on the event queue.
* Placing events on the event queue.

Reading events from the event queue is done with ((<SDL::Event.poll>)).
We'll use ((<SDL::Event.poll>)) and step through an example.
((<SDL::Event.poll>)) removes the next event from the event queue, 
if there are no events on the queue it returns nil
otherwise it returns event object. 
We use a while loop to process each event in turn.

  while event = SDL::Event.poll

We know that if ((<SDL::Event.poll>)) removes an event from the queue then the event information will
be placed in returned object, but we also know that the class of that object will represent
the type of event. So we handle each event type seperately we use a switch statement.

  case event

We need to know what kind of events we're looking for ((*and*)) the event type's of those events.
So lets assume we want to detect where the user is moving the mouse pointer within our application.
We look through our event types and notice that ((<SDL::Event::MouseMotion>)) is, more than likely,
the event we're looking for. A little more research tells use that
mouse motion events are handled within the ((<SDL::Event::MouseMotion>)).
We can check for the mouse motion event type within our switch statement like so:

  when SDL::Event::MouseMotion

All we need do now is read the information out of this object as instance 
of ((<SDL::Event::MouseMotion>)).
  
    puts "We got a motion event"
    puts "Current mouse position is: (#{event.x}, #{event.y})"
  else
    puts "Unhandled Event!"
  end
  end
  puts "Event queue is empty."

It is also possible to push events onto the event queue.
[Event.push]  allows you to place events onto the event queue.
You can use it to post fake input events if you wished.

== SDL::Event
This class handle events. All objects returned by ((<SDL::Event.poll>)) are
instances of subclasses of SDL::Event.

== Compatiblity
The class that used to be known as SDL::Event is remove.
The class now called SDL::Event was called SDL::Event2 before.
A constant SDL::Event2 remains as alias of SDL::Event because of compatiblity with older version.

== SDL::Event::Active
Class for Application visibility event.

This event raises when the mouse leaves or enters the window area,
the application loses or gains keyboard focus,
or the application is either minimised/iconified or restored.

((<SDL::Event::Active#state>)) returns which event occurs.

* NOTES

  This event does not occur when an application window is first created.

* ((<SDL::Event::Active#gain>)) -- Returns whether gaining visibility or not
* ((<SDL::Event::Active#state>)) -- Gets the type of visibility event.

== SDL::Event::KeyDown

Class for keyboard down event.

* ((<SDL::Event::KeyDown#press>)) -- Returns true.
* ((<SDL::Event::KeyDown#sym>)) -- Get the key symbol of pressed key
* ((<SDL::Event::KeyDown#mod>)) -- Current key modifier
* ((<SDL::Event::KeyDown#unicode>)) -- Translated character

== SDL::Event::KeyUp

Class for key up event.

* ((<SDL::Event::KeyUp#press>)) -- Whether key is pressed
* ((<SDL::Event::KeyUp#sym>)) -- Get the key symbol of released key
* ((<SDL::Event::KeyUp#mod>)) -- Current key modifier

== SDL::Event::MouseMotion

Class for mouse motion event.

Simply put, a event of this type occurs 
when a user moves the mouse within the application window or when [Mouse.warp] is called.
Both the absolute coordinate (((<SDL::Event::MouseMotion#x>)) and ((<SDL::Event::MouseMotion#y>))) and
relative coordinate (((<SDL::Event::MouseMotion#xrel>)) and ((<SDL::Event::MouseMotion#yrel>))) 
are reported along with the current button states (((<SDL::Event::MouseMotion#state>))).

* ((<SDL::Event::MouseMotion#state>)) -- The current button state
* ((<SDL::Event::MouseMotion#x>)) -- The X coordinate of the mouse
* ((<SDL::Event::MouseMotion#y>)) -- the X coordinate of the mouse.
* ((<SDL::Event::MouseMotion#xrel>)) -- Relative motion in the X direction
* ((<SDL::Event::MouseMotion#yrel>)) -- Relative motion in the Y direction

== SDL::Event::MouseButtonDown
Class for mouse button press event.

This type of event occurs when a mouse button press is detected.

* ((<SDL::Event::MouseButtonDown#button>)) -- The mouse button index
* ((<SDL::Event::MouseButtonDown#press>)) -- Whether mouse button is pressed or not
* ((<SDL::Event::MouseButtonDown#x>)) -- The X coordinate of the mouse at press time.
* ((<SDL::Event::MouseButtonDown#y>)) -- The Y coordinate of the mouse at press time

== SDL::Event::MouseButtonUp
Class for mouse button release event.

This type of event occurs when a mouse button release is detected.

* ((<SDL::Event::MouseButtonUp#button>)) -- The mouse button index
* ((<SDL::Event::MouseButtonUp#press>)) -- Whether mouse button is pressed or not
* ((<SDL::Event::MouseButtonUp#x>)) -- The X coordinate of the mouse at release time
* ((<SDL::Event::MouseButtonUp#y>)) -- The Y coordinate of the mouse at release time.

== SDL::Event::JoyAxis
Class for joystick axis motion event. 

This event occurs when ever a user moves an axis on the joystick. 

* ((<SDL::Event::JoyAxis#which>)) -- Joystick device index
* ((<SDL::Event::JoyAxis#axis>)) -- JoyAxis axis index
* ((<SDL::Event::JoyAxis#value>)) -- Axis value

* SEEALSO
  ((<SDL::Joystick#num_axes>)), ((<SDL::Joystick#axis>))

== SDL::Event::JoyBall
Class for joystick ball motion event.

This type of event occurs when a user moves a trackball on the joystick.

* ((<SDL::Event::JoyBall#which>)) -- Joystick device index
* ((<SDL::Event::JoyBall#ball>)) -- Joystick trackball index
* ((<SDL::Event::JoyBall#xrel>)) -- The relative motion in the X direction
* ((<SDL::Event::JoyBall#yrel>)) -- The relative motion in the Y direction.

* SEEALSO

  ((<SDL::Joystick#num_balls>)), ((<SDL::Joystick#ball>))

== SDL::Event::JoyHat
Class for joystick hat position change event.

* ((<SDL::Event::JoyHat#which>)) -- Joystick device index
* ((<SDL::Event::JoyHat#hat>)) -- Joystick hat index
* ((<SDL::Event::JoyHat#value>)) -- Hat position

* SEEALSO
  
  ((<SDL::Joystick#num_hats>)), ((<SDL::Joystick#hat>))

== SDL::Event::JoyButtonDown
Class for joystick button press event.

This event occurs when a user presses a button on a joystick.

* ((<SDL::Event::JoyButtonDown#which>)) -- Joystick device index
* ((<SDL::Event::JoyButtonDown#button>)) -- Joystick button index
* ((<SDL::Event::JoyButtonDown#press>)) -- Joystick button is pressed or released

* SEEALSO

  ((<SDL::Joystick#num_buttons>)), ((<SDL::Joystick#button>))

== SDL::Event::JoyButtonUp
Class for joystick button release event.

This event occurs when a user releases a button on a joystick.

* ((<SDL::Event::JoyButtonUp#which>)) -- Joystick device index
* ((<SDL::Event::JoyButtonUp#button>)) -- Joystick button index
* ((<SDL::Event::JoyButtonUp#press>)) -- Joystick button is pressed or released

* SEEALSO

  ((<SDL::Joystick#num_buttons>)), ((<SDL::Joystick#button>))

== SDL::Event::Quit
Class for quit reqested event.

This event is very important.
If you filter out or ignore a quit event then it is impossible for the user to
close the window. On the other hand, if you do accept a quit event then the application window will be
closed, and screen updates will still report success event though the application will no longer be
visible.

== SDL::Event::SysWM
Class for platform-dependent window manager event.

Event of this type occurs when unknown window manager event happens.
You can never know the detail of this event.
Only you can to do is to ignore this event.

== SDL::Event::VideoResize
Class for window resize event.

When SDL::RESIZABLE is passed as a ((|flag|)) to 
((<SDL::Screen.open>)) the user is allowed to resize the applications
window. When the window is resized an event of this type is report,
with the new window width and height values stored in ((<SDL::Event::VideoResize#w>)) and
 ((<SDL::Event::VideoResize#h>)) respectively.

When this event is recieved the window should be resized
to the new dimensions using ((<SDL::Screen.open>)).

== SDL::Event::VideoExpose
Class for video expose event.

This event is triggered when the screen has been modified outside of the application, usually by
the window manager and needs to be redrawn.

== SDL::Key
Module for keyboard input.

This module defines some keyboard-related constants and 
module functions.

* ((<SDL::Key.scan>)) -- Get a snapshot of the current keyboard state
* ((<SDL::Key.press?>)) -- Get the current keyboard state.
* ((<SDL::Key.mod_state>)) -- Get the state of modifier keys.
* ((<SDL::Key.get_key_name>)) -- Get the name of an SDL virtual keysym
* ((<SDL::Key.enable_key_repeat>)) -- Set keyboard repeat rate.
* ((<SDL::Key.disable_key_repeat>)) -- Disable key repeat.

=== Key symbol
Key symbol constants definitions.
* SDL::Key::BACKSPACE  '\b'  backspace  
* SDL::Key::TAB  '\t' tab  
* SDL::Key::CLEAR     clear
* SDL::Key::RETURN  '\r'  return
* SDL::Key::PAUSE    pause
* SDL::Key::ESCAPE  '^['  escape
* SDL::Key::SPACE  ' '   space
* SDL::Key::EXCLAIM  '!'   exclaim
* SDL::Key::QUOTEDBL  '"'   quotedbl
* SDL::Key::HASH  '#'   hash
* SDL::Key::DOLLAR  '$'   dollar
* SDL::Key::AMPERSAND  '&'  ampersand
* SDL::Key::QUOTE  '''  quote
* SDL::Key::LEFTPAREN  '('   left parenthesis
* SDL::Key::RIGHTPAREN  ')'  right parenthesis
* SDL::Key::ASTERISK  '*'  asterisk
* SDL::Key::PLUS  '+'  plus sign
* SDL::Key::COMMA  ','  comma
* SDL::Key::MINUS  '-'  minus sign
* SDL::Key::PERIOD  '.'  period
* SDL::Key::SLASH  '/'  forward slash
* SDL::Key::K0  '0'  0
* SDL::Key::K1  '1'  1
* SDL::Key::K2  '2'  2
* SDL::Key::K3  '3'  3
* SDL::Key::K4  '4'  4
* SDL::Key::K5  '5'  5
* SDL::Key::K6  '6'  6
* SDL::Key::K7  '7'  7
* SDL::Key::K8  '8'  8
* SDL::Key::K9  '9'  9
* SDL::Key::COLON  ':'  colon
* SDL::Key::SEMICOLON  ';'  semicolon
* SDL::Key::LESS  '&lt;'  less-than sign
* SDL::Key::EQUALS  '='   equals sign
* SDL::Key::GREATER  '&gt;'   greater-than sign
* SDL::Key::QUESTION  '?'   question mark
* SDL::Key::AT  '@'   at
* SDL::Key::LEFTBRACKET  '['   left bracket
* SDL::Key::BACKSLASH  '\'   backslash
* SDL::Key::RIGHTBRACKET  ']'   right bracket
* SDL::Key::CARET  '^'   caret
* SDL::Key::UNDERSCORE  '_'   underscore
* SDL::Key::BACKQUOTE  '`'   grave
* SDL::Key::A  'a'  a  
* SDL::Key::B  'b'  b  
* SDL::Key::C  'c'  c  
* SDL::Key::D  'd'  d  
* SDL::Key::E  'e'  e  
* SDL::Key::F  'f'  f  
* SDL::Key::G  'g'  g  
* SDL::Key::H  'h'  h  
* SDL::Key::I  'i'  i  
* SDL::Key::J  'j'  j  
* SDL::Key::K  'k'  k  
* SDL::Key::L  'l'  l  
* SDL::Key::M  'm'  m  
* SDL::Key::N  'n'  n  
* SDL::Key::O  'o'  o  
* SDL::Key::P  'p'  p  
* SDL::Key::Q  'q'  q  
* SDL::Key::R  'r'  r  
* SDL::Key::S  's'  s  
* SDL::Key::T  't'  t  
* SDL::Key::U  'u'  u  
* SDL::Key::V  'v'  v  
* SDL::Key::W  'w'  w  
* SDL::Key::X  'x'  x  
* SDL::Key::Y  'y'  y  
* SDL::Key::Z  'z'  z  
* SDL::Key::DELETE  '^?'  delete  
* SDL::Key::KP0     keypad 0
* SDL::Key::KP1     keypad 1
* SDL::Key::KP2     keypad 2
* SDL::Key::KP3     keypad 3
* SDL::Key::KP4     keypad 4
* SDL::Key::KP5     keypad 5
* SDL::Key::KP6     keypad 6
* SDL::Key::KP7     keypad 7
* SDL::Key::KP8     keypad 8
* SDL::Key::KP9     keypad 9
* SDL::Key::KP_PERIOD  '.'   keypad period
* SDL::Key::KP_DIVIDE  '/'   keypad divide
* SDL::Key::KP_MULTIPLY  '*'   keypad multiply
* SDL::Key::KP_MINUS  '-'   keypad minus
* SDL::Key::KP_PLUS  '+'   keypad plus
* SDL::Key::KP_ENTER  '\r'   keypad enter
* SDL::Key::KP_EQUALS  '='   keypad equals
* SDL::Key::UP     up arrow
* SDL::Key::DOWN     down arrow
* SDL::Key::RIGHT     right arrow
* SDL::Key::LEFT     left arrow
* SDL::Key::INSERT    insert  
* SDL::Key::HOME    home  
* SDL::Key::END    end  
* SDL::Key::PAGEUP    page up  
* SDL::Key::PAGEDOWN    page down  
* SDL::Key::F1    F1  
* SDL::Key::F2    F2  
* SDL::Key::F3    F3  
* SDL::Key::F4    F4  
* SDL::Key::F5    F5  
* SDL::Key::F6    F6  
* SDL::Key::F7    F7  
* SDL::Key::F8    F8  
* SDL::Key::F9    F9  
* SDL::Key::F10    F10  
* SDL::Key::F11    F11  
* SDL::Key::F12    F12  
* SDL::Key::F13    F13  
* SDL::Key::F14    F14  
* SDL::Key::F15    F15  
* SDL::Key::NUMLOCK    numlock  
* SDL::Key::CAPSLOCK    capslock  
* SDL::Key::SCROLLOCK    scrollock  
* SDL::Key::RSHIFT     right shift
* SDL::Key::LSHIFT     left shift
* SDL::Key::RCTRL     right ctrl
* SDL::Key::LCTRL     left ctrl
* SDL::Key::RALT     right alt
* SDL::Key::LALT     left alt
* SDL::Key::RMETA     right meta
* SDL::Key::LMETA     left meta
* SDL::Key::LSUPER     left windows key
* SDL::Key::RSUPER     right windows key
* SDL::Key::MODE     mode shift
* SDL::Key::HELP    help  
* SDL::Key::PRINT    print-screen  
* SDL::Key::SYSREQ    SysRq  
* SDL::Key::BREAK    break  
* SDL::Key::MENU    menu  
* SDL::Key::POWER    power  
* SDL::Key::EURO     euro

== SDL::Mouse
Module for mouse input.

This module defines some mouse constants and module functions.

* ((<SDL::Mouse.state>)) -- Retrieve the current state of the mouse
* ((<SDL::Mouse.warp>)) -- Set the position of the mouse cursor.
* ((<SDL::Mouse.show>)) -- Toggle the cursor is shown on the screen.
* ((<SDL::Mouse.hide>)) -- Hide cursor.
* ((<SDL::Mouse.show?>)) -- Get the state of mouse cursor.
* ((<SDL::Mouse.set_cursor>)) -- Set the currently active mouse cursor.
== Methods

--- SDL::Event.poll

    Polls for currently pending events, and returns event object if there
    are any pending events, or nil if there are none
    available.
    
    If event object is returned, the next event is removed from 
    the queue and stored in that area.


    EXAMPLE
      while event = SDL::Event.poll # Loop until there are no events left on the queue
        case event # Process the appropiate event type
        when SDL::Event::KeyDown # Handle a KEYDOWN event
          puts "Oh! Key press"
        when SDL::Event::MouseMotion
          .
          .
          .
        else # Report an unhandled event
          puts "I don't know what this event is!"
        end
      end

    * See Also
      
      ((<SDL::Event>)), ((<SDL::Event.wait>))

--- SDL::Event.wait

    Waits indefinitely for the next available event and return that event.
    
    If event object is returned, the next event is removed
    from the queue and stored in that area.

    Raise ((<SDL::Error>)) if there was an error while waiting
    for events.

    * NOTES

      In Ruby 1.9 and above, this method releases the global VM lock (GVL) prior to
      calling the underlying SDL_WaitEvent function.  This allows other Ruby threads to
      continue executing while waiting for an event.
      
      In Ruby 1.8 and below, there is no way to release the GVL, so all Ruby threads
      suspend execution until this method finishes.

    * See Also
      
      ((<SDL::Event.poll>))

--- SDL::Event.push(event)

    Push ((|event|)) onto event queue.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      Pushing device input events onto the queue doesn't modify the 
      state of the device within SDL.

    * See Also
      
      ((<SDL::Event.poll>))

--- SDL::Event.app_state
--- SDL::Event.appState

    This method returns the current state of the application. 
    The value returned is a bitwise combination of:
    :SDL::Event::APPMOUSEFOCUS
      The application has mouse focus. 
    :SDL::Event::APPINPUTFOCUS
      The application has keyboard focus.
    :SDL::Event::APPACTIVE
      The application is visible.

    * See Also
      
      ((<SDL::Event::Active>))

--- SDL::Event.enable_unicode
--- SDL::Event.enableUNICODE

    To obtain the character codes corresponding to received keyboard events, Unicode translation must first
    be turned on using this function. The translation incurs a slight overhead for each keyboard event and is
    therefore disabled by default. For each subsequently received key down event, 
    ((<SDL::Event::KeyDown#unicode>)) will then contain the corresponding character code, 
    or zero for keysyms that do not correspond to any character code.

    * NOTES

      Note that only key press events will be translated, not release events.

    * See Also
      
      ((<SDL::Event.disable_unicode>)), ((<SDL::Event.enable_unicode?>))

--- SDL::Event.disable_unicode
--- SDL::Event.disableUNICODE

    Disables Unicode keyboard translation. Please see ((<SDL::Event.enable_unicode>))
    in detail.

--- SDL::Event.enable_unicode?
--- SDL::Event.enableUNICODE?

    Returns true if Unicode keyboard translation is enabled, otherwise
    returns false. Please see ((<SDL::Event.enable_unicode>)) in detail.

--- SDL::Event::Active#gain

    Returns true if the mouse enters the window, the application gains keyboard focus, or
    minimized/iconcified window is restored.
    Otherwise returns false.

    * See Also
      
      ((<SDL::Event::Active>)), ((<SDL::Event::Active#state>))

--- SDL::Event::Active#state

    Returns one of following three constants:
    * SDL::Event::APPMOUSEFOCUS
    
      This event occurs when the mouse leaves or enters the window area.
    
    * SDL::Event::APPINPUTFOCUS
    
      THis event occurs when the application loses or gains input focus.
    
    * SDL::Event::APPACTIVE
    
      This event occurs when the application is either minimized/iconcified or restored.

    * See Also
      
      ((<SDL::Event::Active>)), ((<SDL::Event::Active#gain>))

--- SDL::Event::KeyDown#press

    Always returns true.

    * See Also
      
      ((<SDL::Event::KeyUp#press>))

--- SDL::Event::KeyDown#sym

    Returns pressed ((<Key symbol>)).

    * See Also
      
      ((<SDL::Event::KeyDown#unicode>))

--- SDL::Event::KeyDown#mod

    Returns the current state of keyboard modifiers as explained in ((<SDL::Key.mod_state>)).

    * See Also
      
      ((<SDL::Key.mod_state>))

--- SDL::Event::KeyDown#unicode

    Returns the UNICODE character corresponding to the keypress if Unicode translation
    is enabled with ((<SDL::Event.enable_unicode>)). 
    If the high 9 bits of the character are 0, then this
    maps to the equivalent ASCII character:
    
    Returns zero if unicode translation is disabled.

--- SDL::Event::KeyUp#press

    Always returns false.

    * See Also
      
      ((<SDL::Event::KeyDown#press>))

--- SDL::Event::KeyUp#sym

    Returns the released ((<Key symbol>))

--- SDL::Event::KeyUp#mod

    Returns the current state of keyboard modifiers as explained in ((<SDL::Key.mod_state>)).

    * See Also
      
      ((<SDL::Key.mod_state>))

--- SDL::Event::MouseMotion#state

    Returns the current button state.
    The value returned is a bitwise combination of:
    
    :SDL::Mouse::BUTTON_LMASK
      Left button
    :SDL::Mouse::BUTTON_MMASK
      Middle button
    :SDL::Mouse::BUTTON_RMASK
      Right button

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::MouseMotion#x

    Returns the X coordinate of the mouse.

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::MouseMotion#y

    Returns the Y coordinate of the mouse.

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::MouseMotion#xrel

    Returns relative motion in the X direction.

--- SDL::Event::MouseMotion#yrel

    Returns relative motion in the Y direction.

--- SDL::Event::MouseButtonDown#button

    Returns number of the button pressed:
    * SDL::Mouse::BUTTON_LEFT
    * SDL::Mouse::BUTTON_MIDDLE
    * SDL::Mouse::BUTTON_RIGHT

--- SDL::Event::MouseButtonDown#press

    Always returns true.

    * See Also
      
      ((<SDL::Event::MouseButtonUp#press>))

--- SDL::Event::MouseButtonDown#x

    Returns the X coordinate of the mouse.

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::MouseButtonDown#y

    Returns the Y coordinate of the mouse at press time.

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::MouseButtonUp#button

    Returns number of the button released:
    * SDL::Mouse::BUTTON_LEFT
    * SDL::Mouse::BUTTON_MIDDLE
    * SDL::Mouse::BUTTON_RIGHT

--- SDL::Event::MouseButtonUp#press

    Always returns false.

    * See Also
      
      ((<SDL::Event::MouseButtonDown#press>))

--- SDL::Event::MouseButtonUp#x

    Returns the X coordinate of the mouse at release time.

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::MouseButtonUp#y

    Returns the Y coordinate of the mouse at release time.

    * See Also
      
      ((<SDL::Mouse.state>))

--- SDL::Event::JoyAxis#which

    Returns the index of the joystick that reported the event.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#num_axes>))

--- SDL::Event::JoyAxis#axis

    Returns the index of the axis that reported the event.

    * See Also
      
      ((<SDL::Joystick>))

--- SDL::Event::JoyAxis#value

    Returns the position of the axis in -32767 .. 32767.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#axis>))

--- SDL::Event::JoyBall#which

    Returns the index of the joystick that reported the event.

    * See Also
      
      ((<SDL::Joystick>))

--- SDL::Event::JoyBall#ball

    Returns the index of the trackball that reported the event.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#num_balls>))

--- SDL::Event::JoyBall#xrel

    Returns the relative motion in the X direction as Integer.
    This value is the change in position on the ball since it was last polled.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#ball>))

--- SDL::Event::JoyBall#yrel

    Returns the relative motion in the Y direction as Integer.
    This value is the change in position on the ball since it was last polled.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#ball>))

--- SDL::Event::JoyHat#which

    Returns the index of the joystick that reported the event.

    * See Also
      
      ((<SDL::Joystick>))

--- SDL::Event::JoyHat#hat

    Returns the index of the hat that reported the event.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#num_hats>))

--- SDL::Event::JoyHat#value

    Returns the current position of the hat. It is a logically OR'd
    combination of the following values (whose meanings should be pretty obvious:) :
    
    * SDL::Joystick::HAT_CENTERED
    * SDL::Joystick::HAT_UP
    * SDL::Joystick::HAT_RIGHT
    * SDL::Joystick::HAT_DOWN
    * SDL::Joystick::HAT_LEFT
    
    The following defines are also provided:
    * SDL::Joystick::HAT_RIGHTUP
    * SDL::Joystick::HAT_RIGHTDOWN
    * SDL::Joystick::HAT_LEFTUP
    * SDL::Joystick::HAT_LEFTDOWN

--- SDL::Event::JoyButtonDown#which

    Returns the index of the joystick that reported the event.

    * See Also
      
      ((<SDL::Joystick>))

--- SDL::Event::JoyButtonDown#button

    Returns the index of the button that reported the event.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#num_buttons>))

--- SDL::Event::JoyButtonDown#press

    Returns whether this event is button press event.
    Always returns true.

    * See Also
      
      ((<SDL::Event::JoyButtonUp#press>)), ((<SDL::Joystick#button>))

--- SDL::Event::JoyButtonUp#which

    Returns the index of the joystick that reported the event.

    * See Also
      
      ((<SDL::Joystick>))

--- SDL::Event::JoyButtonUp#button

    Returns the index of the button that reported the event.

    * See Also
      
      ((<SDL::Joystick>)), ((<SDL::Joystick#num_buttons>))

--- SDL::Event::JoyButtonUp#press

    Returns whether this event is button press event.
    Always returns false.

    * See Also
      
      ((<SDL::Event::JoyButtonDown#press>)), ((<SDL::Joystick#button>))

--- SDL::Event::VideoResize#w

    Returns the new width of the window when window is resized.

--- SDL::Event::VideoResize#h

    Returns the new width of the window when window is resized.

--- SDL::Key.scan

    Gets a snapshot of the current keyboard state.
    You can check this state with ((<SDL::Key.press?>)).
    
    NOTE
    Call ((<SDL::Event.poll>)) or ((<SDL::Event.wait>)) to update the state.

    * See Also
      
      ((<SDL::Key.press?>)), ((<SDL::Event::KeyDown>)), ((<SDL::Event::KeyUp>)), ((<SDL::Event.poll>))

--- SDL::Key.press?(key)

    Returns true if ((|key|)) is pressed, otherwise returns false.
    Please use ((<Key symbol>)) as parameter.

    * See Also
      
      ((<SDL::Key.scan>)), ((<SDL::Event::KeyDown>)), ((<SDL::Event::KeyUp>))

--- SDL::Key.mod_state
--- SDL::Key.modState

    Returns the current state of the modifier keys (CTRL, ALT, etc.).
    The return value can be an OR'd combination of:
    :SDL::Key::MOD_NONE
    :SDL::Key::MOD_LSHIFT
    :SDL::Key::MOD_RSHIFT
    :SDL::Key::MOD_LCTRL
    :SDL::Key::MOD_RCTRL
    :SDL::Key::MOD_LALT
    :SDL::Key::MOD_RALT
    :SDL::Key::MOD_LMETA
    :SDL::Key::MOD_RMETA
    :SDL::Key::MOD_NUM
    :SDL::Key::MOD_CAPS
    :SDL::Key::MOD_MODE
     
    SDL also defines the following symbols for convenience:
    * SDL::Key::MOD_CTRL = SDL::Key::MOD_LCTRL|SDL::Key::MOD_RCTRL
    * SDL::Key::MOD_SHIFT = SDL::Key::MOD_LSHIFT|SDL::Key::MOD_RSHIFT
    * SDL::Key::MOD_ALT = SDL::Key::MOD_LALT|SDL::Key::MOD_RALT
    * SDL::Key::MOD_META = SDL::Key::MOD_LMETA|SDL::Key::MOD_RMETA

    * See Also
      
      ((<SDL::Key.scan>))

--- SDL::Key.get_key_name(key)
--- SDL::Key.getKeyName(key)

    Returns the SDL-defined name of the ((|key|)) ((<key symbol|Key symbol>)).

--- SDL::Key.enable_key_repeat(delay,interval)
--- SDL::Key.enableKeyRepeat(delay,interval)

    Enables the keyboard repeat rate. ((|delay|)) specifies how long the key must be pressed before it
    begins repeating, it then repeats at the speed specified by ((|interval|)). Both delay and interval are
    expressed in milliseconds.
    
    Good default values are SDL::Key::DEFAULT_REPEAT_DELAY and 
    SDL::Key::DEFAULT_REPEAT_INTERVAL.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Key.disable_key_repeat>))

--- SDL::Key.disable_key_repeat
--- SDL::Key.disableKeyRepeat

    Disables key repeat.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Key.enable_key_repeat>))

--- SDL::Mouse.state

    Returns an array of five element:
      [ X coordinate, Y coordinate, left button is pressed?, middle button is pressed?, right button is pressed?]


    EXAMPLE
      x, y, lbutton, * = SDL::Mouse.state
      if lbutton
        print "Left Mouse Button is pressed \n"
      end

    * See Also
      
      ((<SDL::Event::MouseMotion>)), ((<SDL::Event::MouseButtonDown>)), ((<SDL::Event::MouseButtonUp>))

--- SDL::Mouse.warp(x,y)

    Set the position of the mouse cursor (generates a mouse motion event).

    * See Also
      
      ((<SDL::Event::MouseMotion>))

--- SDL::Mouse.show

    Shows cursor.
    
    The cursor starts off displayed, but can be turned off.

    * See Also
      
      ((<SDL::Mouse.hide>)), ((<SDL::Mouse.show?>))

--- SDL::Mouse.hide

    Hide cursor.

    * See Also
      
      ((<SDL::Mouse.show>)), ((<SDL::Mouse.show?>))

--- SDL::Mouse.show?

    Returns true if mouse cursor is shown, otherwise returns false.

    * See Also
      
      ((<SDL::Mouse.show>)), ((<SDL::Mouse.hide>))

--- SDL::Mouse.set_cursor(bitmap,white,black,transparent,inverted,hot_x=0,hot_y=0)
--- SDL::Mouse.setCursor(bitmap,white,black,transparent,inverted,hot_x=0,hot_y=0)

    Sets the currently active cursor to the specified one. If the cursor is currently visible, the change
    will be immediately represented on the display.
    
    ((|bitmap|)) is shape of cursor, given by the instance of ((<SDL::Surface>)).
    ((|white|)) is white color pixel value in ((|bitmap|)), 
    ((|black|)) is black color pixel value in ((|bitmap|)), 
    ((|transparent|)) is transparent pixel value in ((|bitmap|)), 
    ((|inverted|)) is inverted pixel value in ((|bitmap|)).
    The cursor width must be a multiple of 8 bits.

    * See Also
      
      ((<SDL::Surface>))

= Joystick
* ((<Joystick Overview>))
* ((<SDL::Joystick>))
* Methods for Joystick 
  * ((<SDL::Joystick.num>)) -- Count available joysticks.
  * ((<SDL::Joystick.index_name>)) -- Get joystick name.
  * ((<SDL::Joystick.open>)) -- Opens a joystick for use.
  * ((<SDL::Joystick.open?>)) -- Determine if a joystick has been opened
  * ((<SDL::Joystick#index>)) -- Get the index of an joystick.
  * ((<SDL::Joystick#num_axes>)) -- Get the number of joystick axes
  * ((<SDL::Joystick#num_balls>)) -- Get the number of joystick trackballs
  * ((<SDL::Joystick#num_hats>)) -- Get the number of joystick hats
  * ((<SDL::Joystick#num_buttons>)) -- Get the number of joystick buttons
  * ((<SDL::Joystick.poll=>)) -- Enable/disable joystick event polling
  * ((<SDL::Joystick.poll>)) -- Gets the current state of joysick event polling
  * ((<SDL::Joystick.update_all>)) -- Updates the state of all joysticks
  * ((<SDL::Joystick#axis>)) -- Get the current state of an axis
  * ((<SDL::Joystick#hat>)) -- Get the current state of a joystick hat
  * ((<SDL::Joystick#button>)) -- Get the current state of a given button
  * ((<SDL::Joystick#ball>)) -- Get relative trackball motion
  * ((<SDL::Joystick#close>)) -- Closes a previously opened joystick

== Joystick Overview
Joysticks, and other similar input devices, have a very 
strong role
in game playing and SDL provides comprehensive support for them.
Axes, Buttons, POV Hats and trackballs are all supported.

Joystick support is initialized
by passed the SDL::INIT_JOYSTICK flag
to ((<SDL.init>)). Once initilized joysticks must be opened
using ((<SDL::Joystick.open>)).

While using the functions describe in this secton 
may seem like the best way
to access and read from joysticks, in most cases they aren't.
Ideally joysticks should be read
using the ((<SDL::Event>)) system.
To enable this, you must set the joystick event processing state
with ((<SDL::Joystick.poll=>)).
Joysticks must be ((<opened|SDL::Joystick.open>))
before they can be used of course.

* NOTES

  If you are ((*not*)) handling the joystick
  via the event queue then you must explicitly 
  request a joystick update by calling ((<SDL::Joystick.update_all>)).

  Force Feedback is not yet support.

== SDL::Joystick
The class represents one joystick.

* ((<SDL::Joystick.num>)) -- Count available joysticks.
* ((<SDL::Joystick.index_name>)) -- Get joystick name.
* ((<SDL::Joystick.open>)) -- Opens a joystick for use.
* ((<SDL::Joystick.open?>)) -- Determine if a joystick has been opened
* ((<SDL::Joystick#index>)) -- Get the index of an joystick.
* ((<SDL::Joystick#num_axes>)) -- Get the number of joystick axes
* ((<SDL::Joystick#num_balls>)) -- Get the number of joystick trackballs
* ((<SDL::Joystick#num_hats>)) -- Get the number of joystick hats
* ((<SDL::Joystick#num_buttons>)) -- Get the number of joystick buttons
* ((<SDL::Joystick.poll=>)) -- Enable/disable joystick event polling
* ((<SDL::Joystick.poll>)) -- Gets the current state of joysick event polling
* ((<SDL::Joystick.update_all>)) -- Updates the state of all joysticks
* ((<SDL::Joystick#axis>)) -- Get the current state of an axis
* ((<SDL::Joystick#hat>)) -- Get the current state of a joystick hat
* ((<SDL::Joystick#button>)) -- Get the current state of a given button
* ((<SDL::Joystick#ball>)) -- Get relative trackball motion
* ((<SDL::Joystick#close>)) -- Closes a previously opened joystick

== Methods

--- SDL::Joystick.num

    Counts the number of joysticks attached to the system.

    * See Also
      
      ((<SDL::Joystick.index_name>)), ((<SDL::Joystick.open>))

--- SDL::Joystick.index_name(index)
--- SDL::Joystick.indexName(index)

    Get the implementation dependent name of joystick. 
    The ((|index|)) parameter
    refers to the N'th joystick on the system.


    EXAMPLE
      # Print the names of all attached joysticks
      num_joy = SDL::Joystick.num
      printf("%d joysticks found\n", num_joy)
      num_joy.times do |i|
        puts SDL::Joystick.index_name(i)
      end

    * See Also
      
      ((<SDL::Joystick.open>))

--- SDL::Joystick.open(index)

    Opens a joystick for use within SDL. The ((|index|)) refers to the N'th
    joystick in the system. A joystick must be opened before it can be
    used.

    Returns a ((<SDL::Joystick>)) instance on success.

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      # Check for joystick
      if SDL::Joystick.num > 0
        # Open joystick
        joy = SDL::Joystick.open(0)
      
        printf("Opened Joystick 0\n");
        printf("Name: %s\n", SDL::Joystick.name(0))
        printf("Number of Axes: %d\n", joy.num_axes)
        printf("Number of Buttons: %d\n", joy.num_buttons)
        printf("Number of Balls: %d\n", joy.num_balls)
      end  

--- SDL::Joystick.open?(index)

    Determines whether a joystick has already been opened within the
    application. ((|index|)) refers to the N'th joystick on the system.

    Returns true if the joystick has been opened, or false if it has not.

    * See Also
      
      ((<SDL::Joystick.open>))

--- SDL::Joystick#index

    Returns the index of ((|self|)).

--- SDL::Joystick#num_axes
--- SDL::Joystick#numAxes

    Return the number of axes available.

    * NOTES

      This method counts two dimensional axes as two axes.

    * See Also
      
      ((<SDL::Joystick#axis>))

--- SDL::Joystick#num_balls
--- SDL::Joystick#numBalls

    Return the number of trackballs available.

    * See Also
      
      ((<SDL::Joystick#ball>))

--- SDL::Joystick#num_hats
--- SDL::Joystick#numHats

    Return the number of hats available.

    * See Also
      
      ((<SDL::Joystick#hat>))

--- SDL::Joystick#num_buttons
--- SDL::Joystick#numButtons

    Return the number of buttons available.

    * See Also
      
      ((<SDL::Joystick#button>))

--- SDL::Joystick.poll=(enable)

    This function is used to enable or disable joystick event
    processing. With joystick event processing disabled you will have
    to update joystick states with ((<SDL::Joystick.update_all>)) and read the
    joystick information manually.
    
    Joystick event polling is enabled by default.
    
    NOTE
    Joystick event handling is preferred.
    
    Even if joystick event processing is enabled,
    individual joysticks must be opened before they generate
    events.
    
    Calling this method may delete all events
    currently in SDL's event queue.

    * See Also
      
      ((<SDL::Joystick.update_all>)), ((<SDL::Joystick.poll>)), ((<SDL::Event2::JoyAxis>)), ((<SDL::Event2::JoyBall>)), ((<SDL::Event2::JoyButtonDown>)), ((<SDL::Event2::JoyButtonUp>)), ((<SDL::Event2::JoyHat>))

--- SDL::Joystick.poll

    Returns true if joysick event polling is enabled, otherwise 
    returns false. You will also read ((<SDL::Joystick.poll=>)).

--- SDL::Joystick.update_all
--- SDL::Joystick.updateAll

    Updates the state(position, buttons, etc.) of all open joysticks.
    If joystick events have been enabled with ((<SDL::Joystick.poll=>))
    then this is called automatically in the event loop.

--- SDL::Joystick#axis(axis_index)

    Returns the current state of given ((|axis_index|)) on ((|self|)).
    
    On most modern joysticks the X axis is usually represented by
    axis 0 and the Y axis by axis 1. The value returned by
    this method is a signed integer (-32768 to 32767)
    representing the current position of the axis, it may be
    necessary to impose certain tolerances on these values to account
    for jitter.


    EXAMPLE
      joy = SDL::Joystick.open(0)
        .
        .
      x_move = joy.axis(0)
      y_move = joy.axis(1)

    * See Also
      
      ((<SDL::Joystick#num_axes>))

--- SDL::Joystick#hat(hat_index)

    Returns the current state of the given ((|hat_index|)).

    The current state is returned as a unsinged integer
    which is an OR'd combination of one or more of the following
    
    * SDL::Joystick::HAT_CENTERED
    * SDL::Joystick::HAT_UP
    * SDL::Joystick::HAT_RIGHT
    * SDL::Joystick::HAT_DOWN
    * SDL::Joystick::HAT_LEFT
    * SDL::Joystick::HAT_RIGHTUP
    * SDL::Joystick::HAT_RIGHTDOWN
    * SDL::Joystick::HAT_LEFTUP
    * SDL::Joystick::HAT_LEFTDOWN

    * See Also
      
      ((<SDL::Joystick#num_hats>))

--- SDL::Joystick#button(button_index)

    returns the current state of the given ((|button_index|)).
    Returns true if the button is pressed, otherwise returns false.

    * See Also
      
      ((<SDL::Joystick#num_buttons>))

--- SDL::Joystick#ball(ball_index)

    Get the ball axis change.
    Trackballs can only return relative motion since the last call to
    this method, these motion deltas are returned as 
    an array of two elements, [dx, dy].

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      delta_x, delta_y = joy.ball(0)
      printf("Trackball Delta- X:%d, Y:%d\n", delta_x, delta_y)

--- SDL::Joystick#close

    Close a joystick that was previously opened with ((<SDL::Joystick.open>)).

    * See Also
      
      ((<SDL::Joystick.open>)), ((<SDL::Joystick.open?>))

= CD-ROM
* ((<CD-ROM outline>))
* ((<SDL::CD>))
* ((<CD-ROM methods>))
  * ((<SDL::CD.num_drives>)) -- Returns the number of CD-ROM drives on the system.
  * ((<SDL::CD.index_name>)) -- Returns a human-readable, system-dependent identifier for the CD-ROM.
  * ((<SDL::CD.open>)) -- Opens a CD-ROM drive for access.
  * ((<SDL::CD#status>)) -- Returns the current status of the given drive.
  * ((<SDL::CD#play>)) -- Play a CD
  * ((<SDL::CD#play_tracks>)) -- Play the given CD track(s)
  * ((<SDL::CD#pause>)) -- Pauses a CDROM
  * ((<SDL::CD#resume>)) -- Resumes a CDROM
  * ((<SDL::CD#stop>)) -- Stops a CDROM
  * ((<SDL::CD#eject>)) -- Ejects a CDROM
  * ((<SDL::CD#num_tracks>)) -- Gets number of tracks on the CD.
  * ((<SDL::CD#current_track>)) -- Gets current track.
  * ((<SDL::CD#current_frame>)) -- Gets current frame offset within the track
  * ((<SDL::CD#track_type>)) -- Gets track type.
  * ((<SDL::CD#track_length>)) -- Gets length of track.
  * ((<SDL::CD#in_drive?>)) -- Check disc in drive
  * ((<SDL::CD.frames_to_msf>)) -- Convert frames into minitus/seconds/frames
  * ((<SDL::CD.msf_to_frames>)) -- Convert minitus/seconds/frames into frames
  * ((<SDL::CD#close>)) -- Closes a CD handle
  * ((<SDL::CD#closed?>)) -- Returns whether CD is closed

== CD-ROM outline
SDL supports audio control of up to 32 local CD-ROM drives at once.

You use this API to perform all the basic functions of a CD player, including
listing the tracks, playing, stopping, and ejecting the CD-ROM. (Currently,
multi-changer CD drives are not supported.)

Before you call any of the SDL CD-ROM functions, you must first call
((<SDL.init>))(SDL::INIT_CDROM),
which scans the system for CD-ROM drives, and sets the program
up for audio control.

After you have initialized the library, you can find out how many drives are
available using the ((<SDL::CD.num_drives>)). The first drive listed is the
system default CD-ROM drive. After you have chosen a drive, and have opened it
with ((<SDL::CD.open>)), you can check the status and start playing if there's a CD in
the drive.

A CD-ROM is organized into one or more tracks, each consisting of a certain number
of "frames". Each frame is ~2K in size, and at normal playing speed,
a CD plays 75(SDL::CD::FPS)
frames per second. SDL works with the number of frames on a CD, but this can
easily be converted to the more familiar minutes/seconds format by using
((<SDL::CD.frames_to_msf>)).

== SDL::CD
This class represents opened CDROM device and stores information on the
layout of the tracks on the disc.

== CD-ROM methods

--- SDL::CD.num_drives
--- SDL::CD.numDrives

    Returns the number of CD-ROM drives on the system.

    * See Also
      
      ((<SDL::CD.open>))

--- SDL::CD.index_name(drive)
--- SDL::CD.indexName(drive)

    Returns a human-readable, system-dependent identifier for the CD-ROM. ((|drive|))
    is the index of the drive.
    Drive indices start to 0 and end at ((<SDL::CD.num_drives>))-1.
    
    Examples of return strings.
    * "/dev/cdrom"
    * "E:"
    * "/dev/disk/ide/1/master"

    * See Also
      
      ((<SDL::CD.num_drives>))

--- SDL::CD.open(drive)

    Opens a CD-ROM drive for access. It returns ((<SDL::CD>)) object on success.
    
    Drives are numbered starting with 0. Drive 0 is the system default CD-ROM.

    Raise ((<SDL::Error>)) if the drive was invalid or busy.


    EXAMPLE
      SDL.init SDL::INIT_CDROM
      
      # Check for CD drives
      if SDL::CD.num_drives == 0
        # None found
        STDERR.print "No CDROM devices available\n"
        exit 255
      end
      
      begin
        # Open the default drive
        cdrom = SDL::CD.open(0)
      rescue SDL::Error
        STDERR.puts "Couldn't open drive"
        exit 255
      end
      
      # Print volume info
      printf "Name: %s\n", SDL::CD.index_name(0)
      printf "Tracks: %d\n", cdrom.num_tracks
      num_tracks.times do |cur_track|
        min, sec, frame = SDL::CD.frames_to_msf(cdrom.track_length(cur_track))
        printf "\tTrack %d: Length %d:%d\n", cur_track, min, sec
      end

--- SDL::CD#status

    This method returns the current status of the given drive. Status is described
    like so:
    * SDL::CD::TRAYEMPTY
    * SDL::CD::STOPPED
    * SDL::CD::PLAYING
    * SDL::CD::PAUSED
    * SDL::CD::ERROR
    
    If the drive has a CD in it,
    ((<SDL.current_track>)), ((<SDL.current_frame>)), ((<SDL.num_tracks>)), ((<SDL.track_type>)),
    and ((<SDL.track_length>)) are updated.


    EXAMPLE
      def play_track(track)
        raise "not cd in drive" unless $cdrom.in_drive?
      
        # clamp to the actual number of tracks on the CD
        track = $cdrom.num_tracks-1 if track >= $cdrom.num_tracks
        $cdrom.play_tracks(track, 0, 1, 0)
      end

--- SDL::CD#play(start, length)

    Plays the given cdrom, starting a frame ((|start|)) for length ((|frames|)).

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::CD#play_tracks>))

--- SDL::CD#play_tracks(start_track, start_frame, ntracks, nframes)

    This method plays the given CD starting at track ((|start_track|)), for ((|ntracks|))
    tracks.
    
    ((|start_frame|)) is the frame offset, from the beginning of the ((|start_track|)),
    at which to start. $nframes] is the frame offset, from the beginning
    of the last track
    (((|start_track|))+((|ntracks|))), at which to end playing.
    
    THis methods should only be called after calling ((<SDL::CD#status>)) to get track
    information about the CD.

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      # assuming cdrom is a previously opened device
      # Play the entire CD
      if cdrom.in_drive?
        cdrom.play_tracks 0, 0, 0, 0
      end
      # Play the first track
      if cdrom.in_drive?
        cdrom.play_tracks 0, 0, 1, 0
      end
      # 2 Play first 15 seconds of the 2nd track
      if cdrom.in_drive?
        cdrom.play_tracks 1, 0, 0, SDL::CD::FPS*15
      end

    * NOTES

      Data tracks are ignored.

    * See Also
      
      ((<SDL::CD#play>)), ((<SDL::CD#status>))

--- SDL::CD#pause

    Pauses play on the given cdrom.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::CD#play>)), ((<SDL::CD#resume>))

--- SDL::CD#resume

    Resumes play on the given cdrom.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::CD#play>)), ((<SDL::CD#pause>))

--- SDL::CD#stop

    Stops play on the given cdrom.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::CD#play>))

--- SDL::CD#eject

    Ejects the given cdrom.

    Raises ((<SDL::Error>)) on failure
--- SDL::CD#num_tracks
--- SDL::CD#numTracks

    Returns the number of tracks on the given cdrom.
    ((<SDL::CD#status>)) updates this value.

    * See Also
      
      ((<SDL::CD#status>))

--- SDL::CD#current_track
--- SDL::CD#currentTrack

    Returns the currently playing track.
    ((<SDL::CD#status>)) updates this value.

    * See Also
      
      ((<SDL::CD#status>))

--- SDL::CD#current_frame
--- SDL::CD#currentFrame

    Returns the current frame offset with the playing track.
    ((<SDL::CD#status>)) updates this value.

    * See Also
      
      ((<SDL::CD#status>))

--- SDL::CD#track_type(track)
--- SDL::CD#trackType(track)

    Returns the track type in ((|track|)).
    SDL::CD::AUDIO_TRACK or SDL::CD::DATA_TRACK is returned.

--- SDL::CD#track_length(track)
--- SDL::CD#trackLength(track)

    Returns length, in frame, of ((|track|)).

--- SDL::CD#in_drive?

    Returns true if drive is not empty, otherwise returns false.

    * See Also
      
      ((<SDL::CD#status>))

--- SDL::CD.frames_to_msf(frames)
--- SDL::CD.framesToMSF(frames)

    Converts frames into minitus/seconds/frames, and returns an array like
    [min, sec, frames].

    * See Also
      
      ((<SDL::CD.msf_to_frames>))

--- SDL::CD.msf_to_frames(min, sec, frames)
--- SDL::CD.MSFToFrames(min, sec, frames)

    Convert minitus/seconds/frames into frames and returns frames.

    * See Also
      
      ((<SDL::CD.frames_to_msf>))

--- SDL::CD#close

    Closes ((|self|)).

    * See Also
      
      ((<SDL::CD.open>)), ((<SDL::CD#closed?>))

--- SDL::CD#closed?

    Returns whether CD handle is closed by
    ((<SDL::CD#close>))

    * See Also
      
      ((<SDL::CD#close>))

= Audio
* ((<Audio subsystem outline>))
* ((<Audio Format>))
* ((<SDL::Mixer>))
* ((<SDL::Mixer::Wave>))
* ((<SDL::Mixer::Music>))
* Audio methods
  * ((<SDL::Mixer.open>)) -- Initialize the mixer API.
  * ((<SDL::Mixer.spec>)) -- Get the actual audio format in use by the opened audio device
  * ((<SDL::Mixer.driver_name>)) -- Gets the audio device name
  * ((<SDL::Mixer::Wave.load>)) -- Load file for use as a sample.
  * ((<SDL::Mixer::Wave.load_from_io>)) -- Read IO object for use as a sample.
  * ((<SDL::Mixer::Wave#destroy>)) -- Frees an audio chunk.
  * ((<SDL::Mixer::Wave#destroyed?>)) -- Returns whether an audio chunk is destroyed.
  * ((<SDL::Mixer::Music.load>)) -- Load music file.
  * ((<SDL::Mixer::Music.load_from_string>)) -- Convert string into music data.
  * ((<SDL::Mixer::Music#destroy>)) -- Frees an music data.
  * ((<SDL::Mixer::Music#destroyed?>)) -- Returns whether an music data is destroyed.
  * ((<SDL::Mixer::Wave#set_volume>)) -- Set volume 
  * ((<SDL::Mixer.allocate_channels>)) -- Set the number of channels to mix
  * ((<SDL::Mixer.set_volume>)) -- Set the mix volume of a channel
  * ((<SDL::Mixer.play_channel>)) -- Play loop
  * ((<SDL::Mixer.play_channel_timed>)) -- Play loop and limit by time
  * ((<SDL::Mixer.fade_in_channel>)) -- Play loop with fade in
  * ((<SDL::Mixer.fade_in_channel_timed>)) -- Play loop with fade in and limit by time
  * ((<SDL::Mixer.pause>)) -- Pause the channel
  * ((<SDL::Mixer.resume>)) -- Resume a paused channel
  * ((<SDL::Mixer.halt>)) -- Stop playing on a channel
  * ((<SDL::Mixer.expire>)) -- Change the timed stoppage of a channel
  * ((<SDL::Mixer.fade_out>)) -- Stop playing channel after timed fade out
  * ((<SDL::Mixer.play?>)) -- Get the active playing status of a channel
  * ((<SDL::Mixer.playing_channels>)) -- Get the number of active playing channels
  * ((<SDL::Mixer.pause?>)) -- Get the pause status of a channel
  * ((<SDL::Mixer.fading>)) -- Get the fade status of a channel
  * ((<SDL::Mixer.play_music>)) -- Play music, with looping
  * ((<SDL.fade_in_music>)) -- Play music, with looping, and fade in
  * ((<SDL::Mixer.set_volume_music>)) -- Set music volume
  * ((<SDL::Mixer.pause_music>)) -- Pause music
  * ((<SDL::Mixer.resume_music>)) -- Resume paused music
  * ((<SDL::Mixer.rewind_music>)) -- Rewind music to beginning
  * ((<SDL::Mixer.halt_music>)) -- Stop music playback
  * ((<SDL::Mixer.fade_out_music>)) -- Stop music, with fade out
  * ((<SDL::Mixer.play_music?>)) -- Test whether music is playing
  * ((<SDL::Mixer.pause_music?>)) -- Test whether music is paused
  * ((<SDL::Mixer.fading_music>)) -- Get status of current music fade activity

== Audio subsystem outline
SDL has portable and low-level audio playback system. 
Because this system is too low-level to use from Ruby,
you can use only SDL_mixer functions from Ruby.
So you should install SDL_mixer before using audio playback.

Due to popular demand, here is a simple multi-channel audio mixer. It supports 8 channels of 16 bit
stereo audio, plus a single channel of music, mixed by the popular MikMod MOD, Timidity MIDI and SMPEG
MP3 libraries.

The process of mixing MIDI files to wave output is very CPU intensive, so if playing regular WAVE files
sound great, but playing MIDI files sound choppy, try using 8-bit audio, mono audio, or lower
frequencies.

To play MIDI files, you'll need to get a complete set of GUS patches from:
((<Timidity GUS Patches|URL:http://www.libsdl.org/projects/mixer/timidity/timidity.tar.gz>))
and unpack them in /usr/local/lib under UNIX, and C:\ under Win32.


== Available audio formats

Ruby/SDL supports playing music and sound samples from the following formats:
- WAVE/RIFF (.wav)
- AIFF (.aiff)
- VOC (.voc)
- MOD (.mod .xm .s3m .669 .it .med and more) using included mikmod
- MIDI (.mid) using timidity or native midi hardware
- OggVorbis (.ogg) requiring ogg/vorbis libraries on system
- MP3 (.mp3) requiring SMPEG library on system

== SDL::Mixer
Module for audio playback subsystem.

== SDL::Mixer::Wave
Class for sound samples. Ruby/SDL can play those samples with multi-channel.
Support formats are WAVE, AIFF, RIFF, OGG, VOC.

== SDL::Mixer::Music
Class for audio data.
Suppor formats are WAVE, MOD, MIDI, OGG, MP3.

== Audio methods

--- SDL::Mixer.open(frequency=Mixer::DEFAULT_FREQUENCY,format=Mixer::DEFAULT_FORMAT,cannels=Mixer::DEFAULT_CHANNELS,chunksize=4096)

    Initialize the mixer API.
    This must be called before using other functions in this library.
    SDL must be initialized with SDL::INIT_AUDIO before this call. ((|frequency|))
     would be 44100 for 44.1KHz, which is CD audio rate. Most games use 22050, 
    because 44100 requires too much CPU power on older computers.
    ((|chunksize|)) is the size of each mixed sample. The smaller this is the more your hooks will be called. If
    make this too small on a slow system, sound may skip. If made to large, sound effects will lag behind the
    action more. You want a happy medium for your target computer. You also may make this 4096, or larger, if
    you are just playing music. SDL::Mixer::CHANNELS(8)
     mixing channels will be allocated by default. 
    
    ((|format|)) are the values listed there:
    
    :SDL::Mixer::FORMAT_U8
        Unsigned 8-bit samples
    :SDL::Mixer::FORMAT_S8
        Signed 8-bit samples
    :SDL::Mixer::FORMAT_U16LSB
        Unsigned 16-bit samples, in little-endian byte order
    :SDL::Mixer::FORMAT_S16LSB
        Signed 16-bit samples, in little-endian byte order
    :SDL::Mixer::FORMAT_U16MSB
        Unsigned 16-bit samples, in big-endian byte order
    :SDL::Mixer::FORMAT_S16MSB
        Signed 16-bit samples, in big-endian byte order
    :SDL::Mixer::FORMAT_U16
        same as FORMAT_U16LSB (for backwards compatability probably)
    :SDL::Mixer::FORMAT_S16
        same as FORMAT_S16LSB (for backwards compatability probably)
    :SDL::Mixer::FORMAT_U16SYS
        Unsigned 16-bit samples, in system byte order
    :SDL::Mixer::FORMAT_S16SYS
        Signed 16-bit samples, in system byte order
    
    SDL::DEFAULT_FORMAT is SDL::Mixer::FORMAT_S16SYS.
    
    ((|channels|)) is number of sound channels in output.
    Set to 2 for stereo, 1 for mono. This has nothing to do with mixing channels.
    Mixer::DEFAULT_CHANNELS is 2.

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      # start SDL with audio support
      SDL.init(SDL::INIT_AUDIO)
      # 44.1KHz, signed 16bit, system byte order, stereo audio
      # using 1024 byte chunksize
      SDL::Mixer.open(44100, SDL::Mixer::DEFAULT_FORMAT, 2, 1024)

    * NOTES

      If you observe sound skipping and delaying, you may change some parameters to
      resolve such problems. 
      Please try to change ((|frequency|)), ((|chunksize|)) and ((|format|)) parameter.

    * See Also
      
      ((<SDL::Mixer.spec>)), ((<SDL::Mixer.allocate_channels>))

--- SDL::Mixer.spec

    Returns the actual audio format in use by the opened audio device.
    This may or may not match the parameters you passed to ((<SDL::Mixer.open>)).
    Return value is array of three elements: [frequency, format, channels].

    Raises ((<SDL::Error>)) on failure

    EXAMPLE
      frequency, format, channels = SDL::Mixer.spec
      format_str = case format
      when SDL::Mixer::AUDIO_U8 then "U8"
      when SDL::Mixer::AUDIO_S8 then "S8"
      when SDL::Mixer::AUDIO_U16LSB then "U16LSB"
      when SDL::Mixer::AUDIO_S16LSB then "S16LSB"
      when SDL::Mixer::AUDIO_U16MSB then "U16MSB"
      when SDL::Mixer::AUDIO_S16MSB then "S16MSB"
      end
      
      printf "frequency=%dHz format=%s channels=%d", frequency, format_str, channels

    * See Also
      
      ((<SDL::Mixer.open>))

--- SDL::Mixer.driver_name
--- SDL::Mixer.driverName

    Returns the opened audio device name as String.

    Raises ((<Error] if audio playback system is not @[opened|SDL::Mixer.open>)) yet.

    * See Also
      
      ((<SDL::Mixer.open>))

--- SDL::Mixer::Wave.load(filename)

    Load file for use as a sample and returns the instance of ((<SDL::Mixer::Wave>)).
    ((|filename|)) is name of wave file to use.
    This can load WAVE, AIFF, RIFF, OGG, and VOC files.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      You must call ((<SDL::Mixer.open>)) before calling this method.
      It must know the output characteristics so it can convert the sample for playback, it does
      this conversion at load time. Therefore you should pay attention to memory consumption.

--- SDL::Mixer::Wave.load_from_io(io)
--- SDL::Mixer::Wave.loadFromIO(io)

    Read from Ruby's IO object (IO, StringIO or other objects with read, tell, rewind)
    and returns the instance of ((<SDL::Mixer::Wave>)).
    This can read WAVE, AIFF, RIFF, OGG, and VOC files.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      You must call ((<SDL::Mixer.open>)) before calling this method.
      It must know the output characteristics so it can convert the sample for playback, it does
      this conversion at load time. Therefore you should pay attention to memory consumption.

--- SDL::Mixer::Wave#destroy

    Frees an audio chunk previously loaded.
    If this method is called, all operations are forbidden.

    * See Also
      
      ((<SDL::Mixer::Wave#destroyed?>))

--- SDL::Mixer::Wave#destroyed?

    Returns whether au audio chunk is destroyed by
    ((<SDL::Mixer::Wave#destroy>))

    * See Also
      
      ((<SDL::Mixer::Wave#destroy>))

--- SDL::Mixer::Music.load(filename)

    Load music file to use and returns a instance of ((<SDL::Mixer::Music>)).
    ((|filename|)) is a name of music file to use.
    This can load WAVE, MOD, MIDI, OGG, MP3, and any file that you use a command to
    play with.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      Need SMPEG library to load MP3.

--- SDL::Mixer::Music.load_from_string(str)
--- SDL::Mixer::Music.loadFromString(str)

    Convert ((|str|)) string into music data and returns a instance of ((<SDL::Mixer::Music>)).
    This can load WAVE, MOD and OGG.

    Raises ((<SDL::Error>)) on failure
    * NOTES

      In this method, copy ((|str|)) and store it in returned object.
      Therefore this method may cause the large memory consumption.
      
      On Windows, it may be impossible to use this method.

--- SDL::Mixer::Music#destroy

    Frees an music data previously loaded.
    If this method is called, all operations are forbidden.

    * See Also
      
      ((<SDL::Mixer::Music#destroyed?>)), ((<SDL::Mixer::Wave#destroy>))

--- SDL::Mixer::Music#destroyed?

    Returns whether a music data is destroyed by
    ((<SDL::Mixer::Music#destroy>))

    * See Also
      
      ((<SDL::Mixer::Music#destroy>)), ((<SDL::Mixer::Wave#destroyed?>))

--- SDL::Mixer::Wave#set_volume(volume)
--- SDL::Mixer::Wave#setVolume(volume)

    Set wave volume to ((|volume|)). ((|volume|)) should be in 0..128.

--- SDL::Mixer.allocate_channels(num_channels)
--- SDL::Mixer.allocateChannels(num_channels)

    Set the number of channels being mixed. This can be called
    multiple times, even with sounds playing. If numchans is less
    than the current number of channels, then the higher channels
    will be stopped, freed, and therefore not mixed any longer. It's
    probably not a good idea to change the size 1000 times a second
    though.

    Returns the number of channels allocated.


    EXAMPLE
      # allocate 16 mixing channels
      SDL::Mixer.allocate_channels(16)

    * NOTES

      passing in zero ((*will*)) free all mixing
      channels, however music will still play.

--- SDL::Mixer.set_volume(channel, volume)
--- SDL::Mixer.setVolume(channel, volume)

    Set the ((|volume|)) for any allocated ((|channel|)). 
    If ((|channel|)) is -1 then
    all channels at are set at once. The volume is applied during
    the final mix, along with the sample volume. So setting this
    volume to 64 will halve the output of all samples played on the
    specified channel. All channels default to a volume of 128,
    which is the max. Newly allocated channels will have the max
    volume set, so setting all channels volumes does not affect
    subsequent channel allocations.

    Returns current volume of the channel. If channel is -1, the
    average volume is returned.

    * See Also
      
      ((<SDL::Mixer::Wave#set_volume>)), ((<SDL::Mixer.set_volume_music>))

--- SDL::Mixer.play_channel(channel, wave, loops)
--- SDL::Mixer.playChannel(channel, wave, loops)

    Play ((|wave|))(instance of ((<SDL::Mixer::Wave>))  on ((|channel|)), or 
    if ((|channel|)) is -1, pick the first free
    unreserved channel. The sample will play 
    for ((|loops|))+1 number of
    times, unless stopped by halt, or fade out, or setting a new
    expiration time of less time than it would have originally taken
    to play the loops, or closing the mixer.
    if ((|loops|)) is -1, loops infinitely.

    the channel the sample is played on.


    EXAMPLE
      # play sample on first free unreserved channel
      # play it exactly once through
      SDL::Mixer.play_channel(-1, sample, 0)

    * See Also
      
      ((<SDL::Mixer.play_channel_timed>)), ((<SDL::Mixer.fade_in_channel>)), ((<SDL::Mixer.halt>)), ((<SDL::Mixer.expire>))

--- SDL::Mixer.play_channel_timed(channel, wave, loops, ticks)
--- SDL::Mixer.playChannelTimed(channel, wave, loops, ticks)

    If the ((|wave|)) is long enough and has enough ((|loops|)) then the
    sample will stop after ((|ticks|)) milliseconds. Otherwise this
    function is the same as ((<SDL::Mixer.play_channel>)).


    EXAMPLE
      # play sample on first free unreserved channel
      # play it for half a second
      SDL::Mixer.play_channel(-1, sample, -1, 500)

    * See Also
      
      ((<SDL::Mixer.play_channel>)), ((<SDL::Mixer.fade_in_channel_timed>)), ((<SDL::Mixer.fade_out>)), ((<SDL::Mixer.halt>)), ((<SDL::Mixer.expire>))

--- SDL::Mixer.fade_in_channel(channel, wave, loops, ms)
--- SDL::Mixer.fadeInChannel(channel, wave, loops, ms)

    Play ((|wave|)) on ((|channel|)) with fade in.
    The channel volume starts at 0 and fades up to full volume over
    ((|ms|)) milliseconds of time. The sample may end before the fade-in
    is complete if it is too short or doesn't have enough loops.
    
    Otherwise this function is the same as ((<SDL::Mixer.play_channel>)).


    EXAMPLE
      # play sample on first free unreserved channel
      # play it exactly 3 times through
      # fade in over one second
      SDL::Mixer.fade_in_channel(-1, sample, 2, 1000)

    * See Also
      
      ((<SDL::Mixer.play_channel>)), ((<SDL::Mixer.fade_in_channel_timed>)), ((<SDL::Mixer.fading>)), ((<SDL::Mixer.fade_out>)), ((<SDL::Mixer.halt>)), ((<SDL::Mixer.expire>))

--- SDL::Mixer.fade_in_channel_timed(channel, wave, loops, ms, ticks)
--- SDL::Mixer.fadeInChannelTimed(channel, wave, loops, ms, ticks)

    If the sample is long enough and has enough loops then the
    sample will stop after ticks milliseconds. Otherwise this
    method is the same as ((<SDL::Mixer.play_channel_timed>)).

    * See Also
      
      ((<SDL::Mixer.play_channel_timed>)), ((<SDL::Mixer.fade_in_channel>)), ((<SDL::Mixer.fading>)), ((<SDL::Mixer.fade_out>)), ((<SDL::Mixer.halt>)), ((<SDL::Mixer.expire>))

--- SDL::Mixer.pause(channel)

    Pause ((|channel|)), or all playing channels if -1 is passed in. You
    may still ((|halt|Mixer.halt|)) a paused channel.


    EXAMPLE
      # pause all sample playback
      SDL::Mixer.pause(-1)

    * See Also
      
      ((<SDL::Mixer.resume>)), ((<SDL::Mixer.pause?>)), ((<SDL::Mixer.halt>))

--- SDL::Mixer.resume(channel)

    Unpause ((|channel|)), or all playing and paused channels if -1 is
    passed in.

    * See Also
      
      ((<SDL::Mixer.pause>)), ((<SDL::Mixer.pause?>))

--- SDL::Mixer.halt(channel)

    Halt channel playback, or all channels if -1 is passed in.
    Any callback set by Mix_ChannelFinished will be called.

    * See Also
      
      ((<SDL::Mixer.expire>)), ((<SDL::Mixer.fade_out>))

--- SDL::Mixer.expire(channel, ticks)

    Halt ((|channel|)) playback, or all channels 
    if -1 is passed in, after ((|ticks|)) milliseconds.

    Returns the number of channels set to expire. Whether or not they
    are active.


    EXAMPLE
      # halt playback on all channels in 2 seconds
      SDL::Mixer.expire(-1, 2000)

    * See Also
      
      ((<SDL::Mixer.halt>)), ((<SDL::Mixer.fade_out>))

--- SDL::Mixer.fade_out(channel, ms)
--- SDL::Mixer.fadeOut(channel, ms)

    Gradually fade out which ((|channel|))
     over ((|ms|)) milliseconds starting
    from now. The channel will be halted after the fade out is
    completed. Only channels that are playing are set to fade out,
    including paused channels. 

    Returns the number of channels set to fade out.


    EXAMPLE
      # fade out all channels to finish 3 seconds from now
      printf "starting fade out of %d channels", SDL::Mixer.fade_out(-1, 3000)

    * See Also
      
      ((<SDL::Mixer.fade_in_channel>)), ((<SDL::Mixer.fade_in_channel_timed>)), ((<SDL::Mixer.fading>))

--- SDL::Mixer.play?(channel)

    Returns true if ((|channel|)) is playing, otherwise
    returns false.

    * See Also
      
      ((<SDL::Mixer.pause?>)), ((<SDL::Mixer.fading>)), ((<SDL::Mixer.play_channel>)), ((<SDL::Mixer.pause>))

--- SDL::Mixer.playing_channels
--- SDL::Mixer.playingChannels

    Returns the number of playing.

    * See Also
      
      ((<SDL::Mixer.pause?>)), ((<SDL::Mixer.fading>)), ((<SDL::Mixer.play_channel>)), ((<SDL::Mixer.pause>))

--- SDL::Mixer.pause?(channel)

    Returns true if ((|channel|)) is paused, otherwise 
    returns false.

    * See Also
      
      ((<SDL::Mixer.play?>)), ((<SDL::Mixer.pause>)), ((<SDL::Mixer.resume>))

--- SDL::Mixer.fading(which)

    Tells you if which ((|channel|)) is fading in, out, or not. Does not
    tell you if the channel is playing anything, or paused, so you'd
    need to test that separately.
    Returns the fading status:
    * SDL::Mixer::FADING_OUT
    * SDL::Mixer::FADING_IN
    * SDL::Mixer::NO_FADING

    * See Also
      
      ((<SDL::Mixer.play?>)), ((<SDL::Mixer.pause?>)), ((<SDL::Mixer.fade_in_channel>)), ((<SDL::Mixer.fade_in_channel_timed>)), ((<SDL::Mixer.fade_out>))

--- SDL::Mixer.play_music(music, loops)
--- SDL::Mixer.playMusic(music, loops)

    Play the loaded ((|music|))
    ((|loops|)) times through from start to finish.
    The previous music will be halted, or if fading out it waits
    (blocking) for that to finish.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Mixer.fade_in_music>))

--- SDL.fade_in_music(music, loops, ms)
--- SDL.fadeInMusic(music, loops, ms)

    Fade in over ((|ms|)) milliseconds of time, 
    the loaded ((|music|)), playing
    it ((|loops|)) times through from start to finish.
    The fade in effect only applies to the first loop.
    Any previous music will be halted, or if it is fading out it
    will wait (blocking) for the fade to complete.

    Raises ((<SDL::Error>)) on failure
    * See Also
      
      ((<SDL::Mixer.play_music>))

--- SDL::Mixer.set_volume_music(volume)
--- SDL::Mixer.setVolumeMusic(volume)

    Set the volume to ((|volume|)), if it is 0 or greater.
    Setting the volume during a fade will
    not work, the faders use this function to perform their effect!

    * See Also
      
      ((<SDL::Mixer.fade_in_music>)), ((<SDL::Mixer.fade_out_music>))

--- SDL::Mixer.pause_music
--- SDL::Mixer.pauseMusic

    Pause the music playback. You may ((<halt|SDL::Mixer.halt_music>))
    paused music.

    * See Also
      
      ((<SDL::Mixer.resume_music>)), ((<SDL::Mixer.pause_music?>)), ((<SDL::Mixer.halt_music>))

--- SDL::Mixer.resume_music
--- SDL::Mixer.resumeMusic

    Unpause the music. This is safe to use on halted, paused, and
    already playing music.

    * See Also
      
      ((<SDL::Mixer.pause_music>)), ((<SDL::Mixer.pause_music?>))

--- SDL::Mixer.rewind_music
--- SDL::Mixer.rewindMusic

    Rewind the music to the start. This is safe to use on halted,
    paused, and already playing music. It is not useful to rewind
    the music immediately after starting playback, because it starts
    at the beginning by default.
    
    This function only works for these streams: MOD, OGG, MP3,
    Native MIDI.

--- SDL::Mixer.halt_music
--- SDL::Mixer.haltMusic

    Halt playback of music. This interrupts music fader effects. 

    * See Also
      
      ((<SDL::Mixer.fade_out_music>))

--- SDL::Mixer.fade_out_music(ms)
--- SDL::Mixer.fadeOutMusic(ms)

    Gradually fade out the music over ((|ms|)) milliseconds starting from
    now. The music will be halted after the fade out is completed.
    Only when music is playing and not fading already are set to
    fade out, including paused channels.

--- SDL::Mixer.play_music?
--- SDL::Mixer.playMusic?

    Returns true if music is actively playing, otherwise
    returns false.

    * See Also
      
      ((<SDL::Mixer.pause_music?>)), ((<SDL::Mixer.fading_music>)), ((<SDL::Mixer.play_music>))

--- SDL::Mixer.pause_music?
--- SDL::Mixer.pauseMusic?

    Returns true if music is paused, otherwise returns false.

    * See Also
      
      ((<SDL::Mixer.play_music?>)), ((<SDL::Mixer.pause_music>)), ((<SDL::Mixer.resume_music>))

--- SDL::Mixer.fading_music
--- SDL::Mixer.fadingMusic

    Tells you if music is fading in, out, or not at all. Does not
    tell you if the channel is playing anything, or paused, so you'd
    need to test that separately.
    
    return value is one of follwoing:
    * SDL::Mixer::FADING_OUT
    * SDL::Mixer::FADING_IN
    * SDL::Mixer::NO_FADING

    * See Also
      
      ((<SDL::Mixer.fading>)), ((<SDL::Mixer.pause_music?>)), ((<SDL::Mixer.play_music?>)), ((<SDL::Mixer.fade_out_music>))

= Time
  * ((<SDL.get_ticks>)) -- Get the number of milliseconds since the SDL library initialization
  * ((<SDL.delay>)) -- Wait a specified number of milliseconds before returning
SDL provides several cross-platform functions for dealing with
time.
It provides a way to get the current time
and a way to wait a little while.

==Methods

--- SDL.get_ticks
--- SDL.getTicks

    Get the number of milliseconds since ((<SDL.init>)) is called
    Note that this value wraps if the program runs
    for more than ~49 days.

    * See Also
      
      ((<SDL.delay>))

--- SDL.delay(ms)

    Wait a specified number of milliseconds before returning.
    This method will wait ((*at least*)) the specified time, 
    but possible longer due to OS scheduling.

    * NOTES

      Count on a delay granularity of ((*at least*)) 10 ms. Some
      platforms have shorter clock ticks but this is the most
      common.
      
      Ruby's threads cannot preempt while waiting with this method.
      You can use Kernel#sleep instead.

= Font
* ((< Font drawing outline>))
* ((<SDL::TTF>))
* ((<SDL::BMFont>))
* ((<SDL::Kanji>))
* Font methods
  * ((<SDL::TTF.init>)) -- Initialize TTF APIs
  * ((<SDL::TTF.init?>)) -- Query TTF API initialization status
  * ((<SDL::TTF.open>)) -- Load font From a file
  * ((<SDL::TTF#close>)) -- Closes a font
  * ((<SDL::TTF#closed?>)) -- Returns whether a font is closed or not
  * ((<SDL::TTF#style>)) -- Get font render style
  * ((<SDL::TTF#style=>)) -- Set the rendering style.
  * ((<SDL::TTF#height>)) -- Get font max height
  * ((<SDL::TTF#ascent>)) -- Get font max ascent (y above origin)
  * ((<SDL::TTF#descent>)) -- Get font min descent (y below origin)
  * ((<SDL::TTF#line_skip>)) -- Get font recommended line spacing
  * ((<SDL::TTF#faces>)) -- Get the number of faces in a font
  * ((<SDL::TTF#fixed_width?>)) -- Get whether font is monospaced or not.
  * ((<SDL::TTF#family_name>)) -- Get current font face family name string
  * ((<SDL::TTF#style_name>)) -- Get current font face style name string
  * ((<SDL::TTF#text_size>)) -- Get size of text string as would be rendered
  * ((<SDL::TTF#render_solid_utf8>)) -- Render UTF8 text in solid mode
  * ((<SDL::TTF#render_shaded_utf8>)) -- Render UTF8 text in shaded mode
  * ((<SDL::TTF#render_blended_utf8>)) -- Render UTF8 text in blended mode
  * ((<SDL::TTF#draw_solid_utf8>)) -- Draw UTF8 text in solid mode
  * ((<SDL::TTF#draw_shaded_utf8>)) -- Draw UTF8 text in shaded mode
  * ((<SDL::TTF#draw_blended_utf8>)) -- Draw UTF8 text in blended mode
  * ((<SDL::BMFont.open>)) -- Load a bitmap font from file
  * ((<SDL::BMFont#close>)) -- Closes a font.
  * ((<SDL::BMFont#closed?>)) -- Returns whether a font is closed.
  * ((<SDL::BMFont#set_color>)) -- Change font color
  * ((<SDL::BMFont#height>)) -- Get height of the font
  * ((<SDL::BMFont#width>)) -- Get width of one character in the font
  * ((<SDL::BMFont#text_size>)) -- Get the size of surface needed
  * ((<SDL::BMFont#textout>)) -- Render the given string
  * ((<SDL::Kanji.open>)) -- Load bdf font file
  * ((<SDL::Kanji#close>)) -- Closes bdf font data
  * ((<SDL::Kanji#closed?>)) -- Returns whether bdf font is closed
  * ((<SDL::Kanji#add>)) -- Add font data into already loaded font
  * ((<SDL::Kanji#set_coding_system>)) -- Set character encoding
  * ((<SDL::Kanji#get_coding_system>)) -- Get character encoding
  * ((<SDL::Kanji#height>)) -- Get height of one character
  * ((<SDL::Kanji#textwidth>)) -- Get width of given string
  * ((<SDL::Kanji#width>)) -- Get the width of one character
  * ((<SDL::Kanji#put>)) -- Render text
  * ((<SDL::Kanji#put_tate>)) -- Render tategaki text

== Font drawing outline
Ruby/SDL has three different font drawing system.
First is True Type Font drawing by
((<SDL_ttf|URL:http://www.libsdl.org/projects/SDL_ttf/index.html>)),
second is original bitmap font/SFont drawing by
((<SGE|URL:http://www.etek.chalmers.se/~e8cal1/sge/index.html>)),
and the last is bdf font drawing by
((<SDL_kanji|URL:http://shinh.skr.jp/sdlkanji/>)).

Each system has following features. 
* SDL::TTF

  Extension name of Font file name is ttf and ttc.
  True type font has vector data, therefore you can use arbitrary font size.
  
* SDL::BMFont

  Font files are mere Windows BMP files or PNG image files.
  In original font file format, image data is regarded as 256 character
  images ordered by ASCII.
  Creating your own fonts is more easy than true type fonts.

  You can use ((<SFont|URL:http://www.linux-games.com/sfont/>))
  with this class. This format is also bitmap font, but character width
  is variable.

  You can't use kanji and other Unicode characters.

* SDL::Kanji

  Font files are BDF format. BDF is a kind of bitmap font.
  You can mix multiple font files (for example, alphabet and kanji).

== SDL::TTF
* ((<SDL::TTF.init>)) -- Initialize TTF APIs
* ((<SDL::TTF.init?>)) -- Query TTF API initialization status
* ((<SDL::TTF.open>)) -- Load font From a file
* ((<SDL::TTF#close>)) -- Closes a font
* ((<SDL::TTF#closed?>)) -- Returns whether a font is closed or not
* ((<SDL::TTF#style>)) -- Get font render style
* ((<SDL::TTF#style=>)) -- Set the rendering style.
* ((<SDL::TTF#height>)) -- Get font max height
* ((<SDL::TTF#ascent>)) -- Get font max ascent (y above origin)
* ((<SDL::TTF#descent>)) -- Get font min descent (y below origin)
* ((<SDL::TTF#line_skip>)) -- Get font recommended line spacing
* ((<SDL::TTF#faces>)) -- Get the number of faces in a font
* ((<SDL::TTF#fixed_width?>)) -- Get whether font is monospaced or not.
* ((<SDL::TTF#family_name>)) -- Get current font face family name string
* ((<SDL::TTF#style_name>)) -- Get current font face style name string
* ((<SDL::TTF#text_size>)) -- Get size of text string as would be rendered
* ((<SDL::TTF#render_solid_utf8>)) -- Render UTF8 text in solid mode
* ((<SDL::TTF#render_shaded_utf8>)) -- Render UTF8 text in shaded mode
* ((<SDL::TTF#render_blended_utf8>)) -- Render UTF8 text in blended mode
* ((<SDL::TTF#draw_solid_utf8>)) -- Draw UTF8 text in solid mode
* ((<SDL::TTF#draw_shaded_utf8>)) -- Draw UTF8 text in shaded mode
* ((<SDL::TTF#draw_blended_utf8>)) -- Draw UTF8 text in blended mode

This class represents true type font. 
((<SDL_ttf|URL:http://www.libsdl.org/projects/SDL_ttf/index.html>))
is needed to use this class. Backend of SDL_ttf is 
((<Freetype|URL:http://www.freetype.org/>)).

Note that you should pay attention to font license.

== SDL::BMFont
* ((<SDL::BMFont.open>)) -- Load a bitmap font from file
* ((<SDL::BMFont#close>)) -- Closes a font.
* ((<SDL::BMFont#closed?>)) -- Returns whether a font is closed.
* ((<SDL::BMFont#set_color>)) -- Change font color
* ((<SDL::BMFont#height>)) -- Get height of the font
* ((<SDL::BMFont#width>)) -- Get width of one character in the font
* ((<SDL::BMFont#text_size>)) -- Get the size of surface needed
* ((<SDL::BMFont#textout>)) -- Render the given string

This class represets bitmap font. 
((<SGE|URL:http://www.etek.chalmers.se/~e8cal1/sge/index.html>))
is needed.

== SDL::Kanji
* ((<SDL::Kanji.open>)) -- Load bdf font file
* ((<SDL::Kanji#close>)) -- Closes bdf font data
* ((<SDL::Kanji#closed?>)) -- Returns whether bdf font is closed
* ((<SDL::Kanji#add>)) -- Add font data into already loaded font
* ((<SDL::Kanji#set_coding_system>)) -- Set character encoding
* ((<SDL::Kanji#get_coding_system>)) -- Get character encoding
* ((<SDL::Kanji#height>)) -- Get height of one character
* ((<SDL::Kanji#textwidth>)) -- Get width of given string
* ((<SDL::Kanji#width>)) -- Get the width of one character
* ((<SDL::Kanji#put>)) -- Render text
* ((<SDL::Kanji#put_tate>)) -- Render tategaki text

This class represets bdf font. 

== Font methods

--- SDL::TTF.init

    Initialize the truetype font API. This must be called before using other methods
    of this class, excepting ((<SDL::TTF.init?>)).
    ((<SDL.init>)) does not have to be called before this call.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF.init?>))

--- SDL::TTF.init?

    Returns true if TTF API is already initialize, otherwise returns false.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF.init>))

--- SDL::TTF.open(filename, ptsize, index=0)

    Load ((|filename|)), face ((|index|)), for use as a font, at ((|ptsize|)) size.

    Returns new ((<SDL::TTF>)) object.

    Raises ((<SDL::Error>)) on failure

    You need SDL_ttf to use this method.

    EXAMPLE
      SDL::TTF.init
      font = SDL::TTF.open("font.ttf", 32, 0)

--- SDL::TTF#close

    Closes a font and free related resources.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#closed?>))

--- SDL::TTF#closed?

    Returns whether a font is closed by ((<SDL::TTF#close>))


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#close>))

--- SDL::TTF#style

    Returns the rendering style as a bitmask composed of the follwing masks:
    * SDL::TTF::STYLE_BOLD
    * SDL::TTF::STYLE_ITALIC
    * SDL::TTF::STYLE_UNDERLINE
    If no style is set then SDL::TTF::STYLE_NORMAL is returned.


    You need SDL_ttf to use this method.

    EXAMPLE
      print "The font style is:"
      
      print " normal" if font.style == SDL::TTF::STYLE_NORMAL
      print " bold" if (font.style & SDL::TTF::STYLE_BOLD) != 0
      print " italic" if (font.style & SDL::TTF::STYLE_ITALIC) != 0
      print " italic" if (font.style & SDL::TTF::STYLE_UNDERLINE) != 0
      
      print "\n"

    * See Also
      
      ((<SDL::TTF#style=>))

--- SDL::TTF#style=(new_style)

    Set the rendering style as ((|new_style|)).
    ((|new_style|)) should be a bitmask composed of the follwing masks:
    * SDL::TTF::STYLE_BOLD
    * SDL::TTF::STYLE_ITALIC
    * SDL::TTF::STYLE_UNDERLINE
    or SDL::TTF::STYLE_NORMAL to reset style.


    You need SDL_ttf to use this method.

    EXAMPLE
      # set the loaded font's style to fake bold italics
      font.style = SDL::TTF::STYLE_ITALIC | SDL::TTF::STYLE_BOLD
      
      # render some text in fake bold italics...
      
      # set the loaded font's style back to normal
      font.style = SDL::TTF::STYLE_NORMAL

    * NOTES

      This will flush the internal cache of previously rendered glyphs, even if
      there is no change in style, so it may be best to check the current style using 
      ((<SDL::TTF.style>)) first.

    * See Also
      
      ((<SDL::TTF#style>))

--- SDL::TTF#height

    Returns the maximum pixel height of all glyphs of the font. You may use this
    height for rendering text as close together vertically as possible, though adding
    at least one pixel height to it will space it so they can't touch. Remember that
    Ruby/SDL and SDL_ttf doesn't handle multiline
    printing, so you are responsible for line
    spacing, see the ((<SDL::TTF#line_skip>)) as well.


    You need SDL_ttf to use this method.
--- SDL::TTF#ascent

    Get the maximum pixel ascent (height above baseline)
    of all glyphs of the loaded font. This can also be
    interpreted as the distance from the top of the font to the baseline. It could be
    used when drawing an individual glyph relative to a top point, by combining it
    with the glyph's maxy metric to resolve the top of the rectangle used when
    blitting the glyph on the screen.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#height>)), ((<SDL::TTF#descent>)), ((<SDL::TTF#line_skip>))

--- SDL::TTF#descent

    Get the maximum pixel descent (height below baseline)
    of all glyphs of the loaded font. This can also be
    interpreted as the distance from the baseline to the bottom of the font. It could
    be used when drawing an individual glyph relative to a bottom point, by combining
    it with the glyph's maxy metric to resolve the top of the rectangle used when
    blitting the glyph on the screen.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#height>)), ((<SDL::TTF#ascent>)), ((<SDL::TTF#line_skip>))

--- SDL::TTF#line_skip

    Get the reccomended pixel height of a rendered line of text of the loaded font.
    This is usually larger than the ((<SDL::TTF#height>)) of the font.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#height>)), ((<SDL::TTF#ascent>)), ((<SDL::TTF#descent>))

--- SDL::TTF#faces

    Returns the number of faces(subfonts) in a font.


    You need SDL_ttf to use this method.
--- SDL::TTF#fixed_width?

    Returns true if ((|self|)) font is monospaced, otherwise returns false.
    If font is monospaced, width of the rendered surface is
    (width)*(length of string).


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#faces>)), ((<SDL::TTF#family_name>))

--- SDL::TTF#family_name
--- SDL::TTF#familyName

    Returns current font face family name string.
    Returns nil if that font has no name information.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#faces>)), ((<SDL::TTF#fixed_width?>)), ((<SDL::TTF#style_name>))

--- SDL::TTF#style_name
--- SDL::TTF#styleName

    Returns current font face style name string.
    Returns nil if the font has no name information.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#faces>)), ((<SDL::TTF#fixed_width?>)), ((<SDL::TTF#family_name>))

--- SDL::TTF#text_size(text)
--- SDL::TTF#textSize(text)

    Calculate the resulting surface size of the UTF8 encoded text rendered using font.
    No actual rendering is done, however correct kerning is done to get the actual
    width. The height returned in h is the same as you can get using ((<SDL::TTF#height>)).

    Returns a 2 element array as [w, h].

    Raises ((<SDL::Error>)) on failure

    You need SDL_ttf to use this method.

    EXAMPLE
      w, h = font.size_text("Hello World!")
      puts "width=#{w} height=#{h}"

    * NOTES

      If Ruby/SDL m17n support is enabled, 
      ((|text|)) will be converted to suitable encoding.

    * See Also
      
      ((<SDL::TTF#render_solid_utf8>)), ((<SDL::TTF#render_shaded_utf8>)), ((<SDL::TTF#render_blended_utf8>)), ((<SDL::TTF#draw_solid_utf8>)), ((<SDL::TTF#draw_shaded_utf8>)), ((<SDL::TTF#draw_blended_utf8>))

--- SDL::TTF#render_solid_utf8(text, r, g, b)
--- SDL::TTF#renderSolidUTF8(text, r, g, b)

    This method will render the given ((|text|)) with the given font with
    (((|r|)), [g], ((|b|)))
    color onto a new surface. The Solid mode is used and this is the fastest.
    This method returns new ((<surface|SDL::Surface>)) object.
    
    This method create an 8-bit palettized
    surface and render the given text at fast quality
    with the given font and color. The 0 pixel value is the colorkey, giving a
    transparent background, and the 1 pixel value is set to the text color. The
    colormap is set to have the desired foreground color at index 1, this allows
    you to change the color without having to render the text again. Colormap
    index 0 is of course not drawn, since it is the colorkey, and thus
    transparent, though it's actual color is 255 minus each RGB component of the
    foreground. This is the fastest rendering speed of all the rendering modes.
    This results in no box around the text, but the text is not as smooth. The
    resulting surface should blit faster than
    the ((|Blended|TTF#render_blended_utf8|)) one. Use this mode for
    FPS and other fast changing updating text displays.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#render_shaded_utf8>)), ((<SDL::TTF#render_blended_utf8>)), ((<SDL::TTF#draw_solid_utf8>))

--- SDL::TTF#render_shaded_utf8(text,fg_r,fg_g,fg_b,bg_r,bg_g,bg_b)
--- SDL::TTF#renderShadedUTF8(text,fg_r,fg_g,fg_b,bg_r,bg_g,bg_b)

    This method will render the given ((|text|)) with the given font with
    (((|fg_r|)), [fg_g], ((|fg_b|))) color onto a new surface
    with background color (((|bg_r|)), [bg_g], ((|bg_b|))).
    Returns new ((<surface|SDL::Surface>)) object.
    
    This method create an 8-bit palettized
    surface and render the given text at high quality
    with the given font and colors. The 0 pixel value is background, while other
    pixels have varying degrees of the foreground color from the background color.
    This results in a box of the background color around the text in the
    foreground color. The text is antialiased.
    This will render slower than ((<Solid|SDL::TTF#render_solid_utf8>)),
    but in about the same time as ((<SDL::TTF#render_blended_utf8>)).
    The resulting surface should blit
    as fast as ((<Solid|SDL::TTF#render_solid_utf8>)), once it is made.
    Use this when you need nice text, and can
    live with a box...


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#render_solid_utf8>)), ((<SDL::TTF#render_blended_utf8>)), ((<SDL::TTF#draw_shaded_utf8>))

--- SDL::TTF#render_blended_utf8(text, r, g, b)
--- SDL::TTF#render_blended_utf8(text, r, g, b)

    This method will render the given ((|text|)) with the given font with (((|r|)), [g], ((|b|)))
    color onto a new surface with transparent background. This is
    the slowest but most beautiful.
    
    This method creates a 32-bit ARGB surface and
    render the given text at high quality, using
    alpha blending to dither the font with the given color. This results in a
    surface with alpha transparency, so you don't have a solid colored box around
    the text. The text is antialiased.
    This will render slower than ((<SDL::TTF#render_solid_utf8>)), but in
    about the same time as ((<SDL::TTF#render_shaded_utf8>)).
    The resulting surface will blit slower
    than if you had used ((<SDL::TTF#render_solid_utf8>)) and ((<SDL::TTF#render_shaded_utf8>)).
    Use this when you want high quality, and the text isn't changing too fast.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#render_solid_utf8>)), ((<SDL::TTF#render_shaded_utf8>)), ((<SDL::TTF#draw_blended_utf8>))

--- SDL::TTF#draw_solid_utf8(dest, text, x, y, r, g, b)
--- SDL::TTF#drawSolidUTF8(dest, text, x, y, r, g, b)

    This method will draw the given ((|text|))
    with the given font with (((|r|)), [g], ((|b|)))
    onto ((|dest|)) ((<surface|SDL::Surface>)) at (((|x|)), ((|y|)))
    in ((<solid|SDL::TTF#render_solid_utf8>)) mode.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#draw_shaded_utf8>)), ((<SDL::TTF#draw_blended_utf8>)), ((<SDL::TTF#render_solid_utf8>))

--- SDL::TTF#draw_shaded_utf8(dest, text, x, y, fg_r, fg_g, fg_b, bg_r, bg_g, bg_b)
--- SDL::TTF#drawShadedUTF8(dest, text, x, y, fg_r, fg_g, fg_b, bg_r, bg_g, bg_b)

    This method will draw the given ((|text|))
    with the given font with (((|fg_r|)), [fg_g], ((|fg_b|)))
    color onto onto ((|dest|)) ((<surface|SDL::Surface>)) at (((|x|)), ((|y|)))
    with background color (((|bg_r|)), [bg_g], ((|bg_b|)))
    in ((<shaded|SDL::TTF#render_shaded_utf8>)) mode.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#draw_solid_utf8>)), ((<SDL::TTF#draw_blended_utf8>)), ((<SDL::TTF#render_shaded_utf8>))

--- SDL::TTF#draw_blended_utf8(dest, text, x, y, r, g, b)
--- SDL::TTF#drawBlendedUTF8(dest, text, x, y, r, g, b)

    This method will draw the given ((|text|))
    with the given font with (((|r|)), [g], ((|b|)))
    onto ((|dest|)) ((<surface|SDL::Surface>)) at (((|x|)), ((|y|)))
    in ((<blended|SDL::TTF#render_blended_utf8>)) mode.


    You need SDL_ttf to use this method.
    * See Also
      
      ((<SDL::TTF#draw_solid_utf8>)), ((<SDL::TTF#draw_shaded_utf8>)), ((<SDL::TTF#render_blended_utf8>))

--- SDL::BMFont.open(filename, flags)

    Load a bitmap font from ((|filename|)) file and
    returns new ((<SDL::BMFont>)) object.
    
    ((|flags|)) is OR'd combination of following values:
    :SDL::BMFont::TRANSPARENT
      Transparent (use ((<SDL::Surface#set_color_key>)) internally, should usually be set)
    :SDL::BMFont::NOCONVERT
      Don't ((<convert font surface to display format|SDL::Surface#display_format>))
      for faster blits.
    :SDL::BMFont::SFONT
      If you enabled support for SDL_img when compiling
      SGE you can also set this flag, this enables you to
      load Karl Bartel's SFont files.
    :SDL::BMFont::PALETTE
      Converts the font surface to a palette surface
      (8bit). Don't do this on color fonts or SFonts! Blits from the
      font surface will be a bit slower but ((<SDL::BMFont#set_color>))
      will be faster (O(1) instead of O(n^2)).


    You need SGE to use this method.
--- SDL::BMFont#close

    Closes a font and release the resources.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::BMFont.open>)), ((<SDL::BMFont#closed?>))

--- SDL::BMFont#closed?

    Returns whether a font is closed by ((<SDL::BMFont#close>)).


    You need SGE to use this method.
    * See Also
      
      ((<SDL::BMFont#close>))

--- SDL::BMFont#set_color(r, g, b)
--- SDL::BMFont#setColor(r, g, b)

    Changes the color of the font to (((|r|)), ((|g|)), ((|b|))). 
    Doesn't work on 'color
    fonts' or SFonts. Use ((<SDL::BMFont::PALETTE>))
    when ((<opening|SDL::BMFont.open>)) the font if
    you're going to use this function often.


    You need SGE to use this method.
--- SDL::BMFont#height

    Returns height.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::BMFont#width>))

--- SDL::BMFont#width

    Returns the width of one character in ((|self|)) font.
    Doesn't work on SFonts.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::BMFont#height>))

--- SDL::BMFont#text_size(string)
--- SDL::BMFont#textSize(string)

    Returns the width and height of the ((|string|)) with ((|self|)).


    You need SGE to use this method.
    * See Also
      
      ((<SDL::BMFont#textout>))

--- SDL::BMFont#textout(surface, string, x, y)

    Renders the given ((|string|)) on surface with the given font. 
    (((|x|)), ((|y|))) is the position of the left top corner. 


    You need SGE to use this method.
    * See Also
      
      ((<SDL::BMFont#text_size>))

--- SDL::Kanji.open(filename, size)

    Load bdf font data from ((|filename|)) and 
    returns new ((<SDL::Kanji>)) obejct.
    ((|size|)) is the height of one character.

    * See Also
      
      ((<SDL::Kanji#add>))

--- SDL::Kanji#close

    Closes bdf font data and release
    the resouces and memories.

    * See Also
      
      ((<SDL::Kanji.open>)), ((<SDL::Kanji#closed?>))

--- SDL::Kanji#closed?

    Returns whether bdf font is closed by ((<SDL::Kanji#close>))

    * See Also
      
      ((<SDL::Kanji#close>))

--- SDL::Kanji#add(filename)

    Add font data fromt ((|filename|)) into already loaded font ((|self|)).
    This method combines two or more font files into one.

    * See Also
      
      ((<SDL::Kanji.open>))

--- SDL::Kanji#set_coding_system(sys)
--- SDL::Kanji#setCodingSystem(sys)

    Set encoding. ((|sys|)) is one of following:
    * SDL::Kanji::SJIS
    * SDL::Kanji::EUC
    * SDL::Kanji::JIS
    Default is SDL::Kanji::JIS.

    * See Also
      
      ((<SDL::Kanji#get_coding_system>))

--- SDL::Kanji#get_coding_system
--- SDL::Kanji#getCodingSystem

    Get encoding. A return value is one of following:
    * SDL::Kanji::SJIS
    * SDL::Kanji::EUC
    * SDL::Kanji::JIS
    Default is SDL::Kanji::JIS.

    * See Also
      
      ((<SDL::Kanji#set_coding_system>))

--- SDL::Kanji#height

    Returns the height of one character as piexel.

--- SDL::Kanji#textwidth(text)

    Get width of given ((|text|)) with ((|self|)) font.

    * See Also
      
      ((<SDL::Kanji#width>))

--- SDL::Kanji#width

    Returns the width of one character.

    * See Also
      
      ((<SDL::Kanji#textwidth>))

--- SDL::Kanji#put(surface, text, x, y, r, g, b)

    Renders ((|text|)) at (((|x|)), ((|y|))) in ((|surface|))
    with (((|r|)), ((|g|)), ((|b|))) color.

    * NOTES

      If Ruby/SDL m17n support is enabled, ((|text|)) 
      will be converted to suitable encoding.

    * See Also
      
      ((<SDL::Kanji#put_tate>)), ((<SDL::Kanji#set_coding_system>))

--- SDL::Kanji#put_tate(surface, x, y, r, g, b)
--- SDL::Kanji#putTate(surface, x, y, r, g, b)

    Renders ((|text|)) as tagetaki at (((|x|)), ((|y|))) in ((|surface|))
    with (((|r|)), ((|g|)), ((|b|))) color.
    
    `Half-width' character is not rendered.

    * NOTES

      If Ruby/SDL m17n support is enabled, ((|text|)) 
      will be converted to suitable encoding.

    * See Also
      
      ((<SDL::Kanji#put>)), ((<SDL::Kanji#set_coding_system>))

= Collision Detection
* ((<Collision Detection outline>))
* ((<SDL::CollisionMap>))

* ((<Collision Detection Methods>))
  * ((<SDL::Surface#make_collision_map>)) -- Creates a new collision map
  * ((<SDL::CollisionMap#collision_check>)) -- Does pixel collision detection.
  * ((<SDL::CollisionMap.bounding_box_check>)) -- Checks if two shapes overlap.
  * ((<SDL::CollisionMap#bounding_box_check>)) -- Checks if two shapes overlap.
  * ((<SDL::CollisionMap#clear>)) -- Clears an area in the collision map
  * ((<SDL::CollisionMap#set>)) -- Makes an area in the collision map solid
  * ((<SDL::CollisionMap#w>)) -- Gets width of collision map
  * ((<SDL::CollisionMap#h>)) -- Get height of collision map

== Collision Detection outline
Ruby/SDL has collision detection system
derived from 
((<SGE|URL:http://www.etek.chalmers.se/~e8cal1/sge/index.html>)).
This enables you to pixel-pixel checking after
creating binary image by  ((<SDL::Surface#make_collision_map>)).

Please see sample/collision.rb too.

== SDL::CollisionMap
This class represents binary image used by collision 
detections.
You can create this instance only by 
((<SDL::Surface#make_collision_map>)).

* ((<SDL::CollisionMap#collision_check>)) -- Does pixel collision detection.
* ((<SDL::CollisionMap.bounding_box_check>)) -- Checks if two shapes overlap.
* ((<SDL::CollisionMap#bounding_box_check>)) -- Checks if two shapes overlap.
* ((<SDL::CollisionMap#clear>)) -- Clears an area in the collision map
* ((<SDL::CollisionMap#set>)) -- Makes an area in the collision map solid
* ((<SDL::CollisionMap#w>)) -- Gets width of collision map
* ((<SDL::CollisionMap#h>)) -- Get height of collision map

== Collision Detection Methods

--- SDL::Surface#make_collision_map
--- SDL::Surface#makeCollisionMap

    Creates a new collision map from ((<SDL::Surface>)) object.
    Use ((<SDL::Surface#set_color_key>)) before calling this method.
    Every non-transparent pixel is set to
    solid in the collision map. 
    
    Returns a new ((<SDL::CollisionMap>)) object.

    Raises ((<SDL::Error>)) on failure

    You need SGE to use this method.
    * See Also
      
      ((<SDL::Surface#set_color_key>)), ((<SDL::CollisionMap#collision_check>)), ((<SDL::CollisionMap#clear>)), ((<SDL::CollisionMap#set>))

--- SDL::CollisionMap#collision_check(x1, y1, cmap, x2, y2)

    Does pixel perfect collision detection with 
    ((|self|)) and ((|cmap|)). 
    The (((|x1|)),((|y1|))) and (((|x2|)),((|y2|)))
    coords are the positions of the upper left corners of the
    images. Returns true if any solid
    pixels of the two images overlap or else false.
    
    This method calls ((<SDL::CollisionMap#bounding_box_check>)) 
    internally.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap#bounding_box_check>))

--- SDL::CollisionMap.bounding_box_check(x1,y1,w1,h1,x2,y2,w2,h2)
--- SDL::CollisionMap.boundingBoxCheck(x1,y1,w1,h1,x2,y2,w2,h2)

    
    Checks if two rectangles 
    (((|x1|)), ((|$y1|)), ((|w1|)), ((|h1|))) and
    (((|x2|)), ((|$y2|)), ((|w2|)), ((|h2|))) overlap.

    Returns true if two rectangles overlap, otherwise
    returns false.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap#bounding_box_check>))

--- SDL::CollisionMap#bounding_box_check(x1, y1, cmap, x2, y2)
--- SDL::CollisionMap#boundingBoxCheck(x1, y1, cmap, x2, y2)

    
    Checks if two rectangles 
    (the bounding boxes, ((|self|)) and ((|cmap|))) overlap. 
    The (((|x1|)),((|y1|))) and (((|x2|)),((|y2|)))
    coords are the positions of the upper left corners of the
    images.

    Returns true if two rectangles overlap, otherwise
    returns false.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap.bounding_box_check>)), ((<SDL::CollisionMap#collision_check>)), ((<SDL::CollisionMap#w>)), ((<SDL::CollisionMap#h>))

--- SDL::CollisionMap#clear(x, y, w, h)

    Clears an area in the collision map from anything solid.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap#set>))

--- SDL::CollisionMap#set(x, y, w, h)

    Makes an area in the collision map solid.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap#set>))

--- SDL::CollisionMap#w

    Returns width of collision map.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap#h>))

--- SDL::CollisionMap#h

    Returns height of collision map.


    You need SGE to use this method.
    * See Also
      
      ((<SDL::CollisionMap#w>))

= SDLSKK
* ((<Japanese input system by SDLSKK>))
* ((<SDL::SKK::Context>))
* ((<SDL::SKK::Dictionary>))
* ((<SDL::SKK::Keybind>))
* ((<SDL::SKK::RomKanaRuleTable>))
* SDLSKK methods
  * ((<SDL::SKK.encoding=>)) -- Set SDLSKK internal encoding
  * ((<SDL::SKK.encoding>)) -- Get SDLSKK internal encoding
  * ((<SDL::SKK::RomKanaRuleTable.new>)) -- Load a Romaji-Kana trasnlation table
  * ((<SDL::SKK::Dictionary.new>)) -- Create empty dictionary
  * ((<SDL::SKK::Dictionary#load>)) -- Read a dictionary file
  * ((<SDL::SKK::Dictionary#save>)) -- Save user dictionary data
  * ((<SDL::SKK::Keybind.new>)) -- Create empty keybind
  * ((<SDL::SKK::Keybind#set_key>)) -- Set keybind
  * ((<SDL::SKK::Keybind#set_default_key>)) -- Load default Emacs-like keybinds
  * ((<SDL::SKK::Keybind#unset_key>)) -- Unset keybind
  * ((<SDL::SKK::Context.new>)) -- Create new input context
  * ((<SDL::SKK::Context#input>)) -- Handle keyboard event
  * ((<SDL::SKK::Context#str>)) -- Get input string
  * ((<SDL::SKK::Context#render_str>)) -- Render input string
  * ((<SDL::SKK::Context#render_minibuffer_str>)) -- Render minibuffer string
  * ((<SDL::SKK::Context#clear>)) -- Clear context
  * ((<SDL::SKK::Context#clear_text>)) -- Creat input text
  * ((<SDL::SKK::Context#get_basic_mode>)) -- Get whether input mode is basic mode

== Japanese input system by SDLSKK
Ruby/SDL has 
((<SKK|URL:http://openlab.jp/skk/index-j.html>))-like
Japanese input system by 
((<SDLSKK|URL:http://www.kmc.gr.jp/~ohai/sdlskk.html>)).

This system enables you not only to input Japanse
but also to handle line input including 
cut and paste.

Please see sample/sdlskk.rb.

== SDL::SKK
This module has some SDLSKK-related module functions
and classes.

* ((<SDL::SKK.encoding=>)) -- Set SDLSKK internal encoding
* ((<SDL::SKK.encoding>)) -- Get SDLSKK internal encoding

== SDL::SKK::Context
This class represents input state.

* ((<SDL::SKK::Context.new>)) -- Create new input context
* ((<SDL::SKK::Context#input>)) -- Handle keyboard event
* ((<SDL::SKK::Context#str>)) -- Get input string
* ((<SDL::SKK::Context#render_str>)) -- Render input string
* ((<SDL::SKK::Context#render_minibuffer_str>)) -- Render minibuffer string
* ((<SDL::SKK::Context#clear>)) -- Clear context
* ((<SDL::SKK::Context#clear_text>)) -- Creat input text
* ((<SDL::SKK::Context#get_basic_mode>)) -- Get whether input mode is basic mode

== SDL::SKK::Dictionary
This class represents a Kana-Kanji dictionary.
Load SKK dictionary from files.

* ((<SDL::SKK::Dictionary.new>)) -- Create empty dictionary
* ((<SDL::SKK::Dictionary#load>)) -- Read a dictionary file
* ((<SDL::SKK::Dictionary#save>)) -- Save user dictionary data

== SDL::SKK::Keybind
This class represents keybind.

* ((<SDL::SKK::Keybind.new>)) -- Create empty keybind
* ((<SDL::SKK::Keybind#set_key>)) -- Set keybind
* ((<SDL::SKK::Keybind#set_default_key>)) -- Load default Emacs-like keybinds
* ((<SDL::SKK::Keybind#unset_key>)) -- Unset keybind

== SDL::SKK::RomKanaRuleTable
This class represents the translation table
from Romaji(Alphabet) to Kana.
Load text data from a file and create new table object.

* ((<SDL::SKK::RomKanaRuleTable.new>)) -- Load a Romaji-Kana trasnlation table

== SDLSKK methods

--- SDL::SKK.encoding=(encoding)

    Sets SDLSKKK internal encoding to ((|encoding|)).
    Following constants are allowed:
    * SDL::SKK::EUCJP
    * SDL::SKK::UTF8
    * SDL::SKK::SJIS
    Default is SDL::SKK::EUCJP.
    
    This encoding determines 
    the encoding of ((<dictionary files|SDL::SKK::Dictionary#load>)),
    ((<a romaji-kana translation table file|SDL::SKK::RomKanaRuleTable.new>))
    and ((<private dictionary|SDL::SKK::Dictionary#save>)).


    You need SDLSKK to use this method.
    * NOTES

      This function should call once before calling other
      SDLSKK methods.

    * See Also
      
      ((<SDL::SKK.encoding>)), ((<SDL::SKK::Dictionary#load>)), ((<SDL::SKK::Dictionary#save>)), ((<SDL::SKK::RomKanaRuleTable.new>))

--- SDL::SKK.encoding

    Returns the SDLSKK internal encoding. Please see
    ((<SDL::SKK.encoding=>)) for more detail.


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK.encoding=>))

--- SDL::SKK::RomKanaRuleTable.new(filename)

    Load a Romaji-Kana trasnlation table from ((|filename|)).
    File format is:
    * a line beginnig with ;; is comment
    * empty line is ignored
    * one entry per one line: <input alphabets><TAB><Katakana><TAB><Hiragana>
      


    You need SDLSKK to use this method.
    * NOTES

      Encoding of this file is set by ((<SDL::SKK.encoding=>))
      before loading it.

    * See Also
      
      ((<SDL::SKK::Context.new>))

--- SDL::SKK::Dictionary.new

    Creates empty dictionary object and returns it.


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Dictionary#load>))

--- SDL::SKK::Dictionary#load(filename, user)

    Read a dictionary data from ((|filename|)). 
    Format of dictionary is same as of SKK
    (Ruby/SDL cannot read data with annotations).
    If ((|user|)) is true, loaded data is treated as
    user dictionary data. If ((|user|)) is false,
    loaded data is treated as system dictionary data.

    Raises ((<SDL::Error>)) on failure

    You need SDLSKK to use this method.
    * NOTES

      Encoding of this file is set by ((<SDL::SKK.encoding=>))
      before loading it.

    * See Also
      
      ((<SDL::SKK::Dictionary.new>)), ((<SDL::SKK::Dictionary#save>)), ((<SDL::SKK::Context.new>))

--- SDL::SKK::Dictionary#save(filename)

    Save user dictionary data into ((|filename|)).


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Dictionary.new>)), ((<SDL::SKK::Dictionary#load>))

--- SDL::SKK::Keybind.new

    Creates empty keybind object and returns it.
    Add keybind to this object using
    ((<SDL::SKK::Keybind#set_key>)) and ((<SDL::SKK::Keybind#set_default_key>)).


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Keybind#set_key>)), ((<SDL::SKK::Keybind#set_default_key>)), ((<SDL::SKK::Context.new>))

--- SDL::SKK::Keybind#set_key(key_str, cmd_str)

    Sets keybind. ((|key_str|)) is a key-symbol string.
    ((|cmd_str|)) is command string.
    
    Following strings are allowed as ((|key_str|)):
    * Alphabet and ascii characters like "%"
    * "SPC" "TAB" "DEL" "RET" "UP" "DOWN" "RIGHT" "LEFT" "INSERT" "HOME" "END"
      "PAGEUP" "PAGEDOWN" "F1" "F2" "F3" "F4" "F5" "F6" "F7" "F8" "F9" "F10"
      "F11" "F12" "F13" "F14" "F15" "HELP"
    * key with modifiers like "C-a" and "M-C-a"
    
    Following strings is allowed as ((|cmd_str|)):
    * "backward-char",
    * "forward-char",
    * "backward-delete-char",
    * "delete-char",
    * "kakutei",
    * "kettei",
    * "space",
    * "keyboard-quit",
    * "set-mark-command",
    * "kill-region",
    * "yank",
    * "copy",
    * "graph-char",
    * "upper-char",
    * "lower-char",
    * "abbrev-input",
    * "latin-mode",
    * "previous-candidate",
    * "jisx0208-mode",
    * "toggle-kana",
    * "beginning-of-line"
    * "end-of-line"
    * "do-nothing"
    
    You shouldn't change the keybind of only one ascii character key
    like "a" and "/".
    
    ((<SDL::SKK::Keybind#set_default_key>)) is useful.


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Keybind#set_default_key>)), ((<SDL::SKK::Keybind#unset_key>))

--- SDL::SKK::Keybind#set_default_key

    Load default Emacs-like keybinds.


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Keybind#set_key>))

--- SDL::SKK::Keybind#unset_key(key_str)

    Unset keybind of ((|key_str|)).


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Keybind#set_key>))

--- SDL::SKK::Context.new(dict, romkama_table, bind, use_minibuffer)

    Creates input context and returns new ((<SDL::SKK::Context>)) object.
    ((|dict|)) is a ((<dictionary|SDL::SKK::Dictionary>)),
    ((|romkama_table|)) is a
    ((<Ronaji-Kana translation table|SDL::SKK::RomKanaRuleTable>))
    and ((|bind|)) is ((<keybind|SDL::SKK::Keybind>)).
    If ((|use_minibuffer|)) is true, 
    SKK-like minibuffer is enabled.


    You need SDLSKK to use this method.

    EXAMPLE
      # Create dictionary object and read data from 'jisyo'
      dict = SDL::SKK::Dictionary.new
      dict.load( 'jisyo', false )
      # Read Romaji-Kana translation table from 'rule_table'
      table = SDL::SKK::RomKanaRuleTable.new( 'rule_table' )
      # Set keybind
      bind = SDL::SKK::Keybind.new
      bind.set_default_key
      
      # Create context
      context = SDL::SKK::Context.new( dict, table, bind, use_minibuffer )

    * See Also
      
      ((<SDL::SKK::Context#input>)), ((<SDL::SKK::Context#str>))

--- SDL::SKK::Context#input(event)

    Handles keyboard event. ((|event|)) should be 
    ((<SDL::Event>)) object.
    This method handles only ((<keydown events|SDL::Event::KeyDown>))
    and ignore other events.


    You need SDLSKK to use this method.

    EXAMPLE
      while event = SDL::Event.poll do
        case event
        when SDL::Event::Quit
          exit
        when SDL::Event::KeyDown
          if event.sym == SDL::Key::ESCAPE then
            exit
          end
          if event.sym == SDL::Key::F1
            dict.save("test_user_dict")
          end
          context.input( event )      
        end
      end

--- SDL::SKK::Context#str

    Returns input string.


    You need SDLSKK to use this method.
    * NOTES

      If Ruby/SDL m17n support is enabled,
      the string with proper encoding will be returned.

    * See Also
      
      ((<SDL::SKK::Context#render_str>)), ((<SDL::SKK::Context#clear>)), ((<SDL::SKK::Context#clear_text>)), ((<SDL::SKK.encoding>))

--- SDL::SKK::Context#render_str(font, r, g, b)

    Renders input string and returns ((<SDL::Surface>)) object.


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Context#render_minibuffer_str>))

--- SDL::SKK::Context#render_minibuffer_str(font, r, g, b)

    Renders minibuffer string and returns ((<SDL::Surface>)) object.


    You need SDLSKK to use this method.
--- SDL::SKK::Context#clear

    Clears input context.


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Context#clear_text>))

--- SDL::SKK::Context#clear_text

    Clears input text, but input mode is held.
    
    If you want multi-line input, this method is better
    than ((<SDL::SKK::Context#clear>))


    You need SDLSKK to use this method.
    * See Also
      
      ((<SDL::SKK::Context#get_basic_mode>))

--- SDL::SKK::Context#get_basic_mode

    Returns true if ((|self|))'s input mode is kakutei-mode,
    latin-mode or jisx0208-latim-mode, otherwise returns
    false.


    You need SDLSKK to use this method.
    * NOTES

      Please see ((<SKK|URL:http://openlab.jp/skk/index.html>)).

    * See Also
      
      ((<SDL::SKK::Context#clear_text>))

= MPEG playback
* ((<MPEG playback Outline>))
* ((<SDL::MPEG>))
* ((<SDL::MPEG::Info>))
* ((<MPEG playback methods>))
  * ((<SDL::MPEG.new>)) -- Load MPEG file.
  * ((<SDL::MPEG#info>)) -- Get information about MPEG object
  * ((<SDL::MPEG#enable_audio>)) -- Enable/Dislable audio
  * ((<SDL::MPEG#enable_video>)) -- Enable/Disable video
  * ((<SDL::MPEG#status>)) -- Get current status
  * ((<SDL::MPEG#set_volume>)) -- Change volume of MPEG stream
  * ((<SDL::MPEG#set_display>)) -- Set display surface
  * ((<SDL::MPEG#set_loop>)) -- Set/Clear looping play
  * ((<SDL::MPEG#scale_xy>)) -- Scale pixel display
  * ((<SDL::MPEG#scale>)) -- Scale pixel display
  * ((<SDL::MPEG#move>)) -- Move the video display area
  * ((<SDL::MPEG#set_display_region>)) -- Set the video display region
  * ((<SDL::MPEG#play>)) -- Play an MPEG object
  * ((<SDL::MPEG#stop>)) -- Stop playback of an MPEG object
  * ((<SDL::MPEG#pause>)) -- Pause/Resume playback of an MPEG object
  * ((<SDL::MPEG#rewind>)) -- Rewind the play position 
  * ((<SDL::MPEG#seek>)) -- Seek in the MPEG stream.
  * ((<SDL::MPEG#skip>)) -- Skip seconds in the MPEG stream
  * ((<SDL::MPEG#render_frame>)) -- Render a particular frame in the MPEG video.
  * ((<SDL::MPEG#render_final>)) -- Render the last frame of an MPEG video
  * ((<SDL::MPEG#set_filer>)) -- Set video filter
  * ((<SDL::MPEG::Info#has_audio>)) -- Get whether an MPEG stream has audio data
  * ((<SDL::MPEG::Info#has_video>)) -- Get whether an MPEG stream has video data
  * ((<SDL::MPEG::Info#width>)) -- Get width of video
  * ((<SDL::MPEG::Info#height>)) -- Get height of video
  * ((<SDL::MPEG::Info#current_frame>)) -- 
  * ((<SDL::MPEG::Info#current_fps>)) -- 
  * ((<SDL::MPEG::Info#audio_string>)) -- 
  * ((<SDL::MPEG::Info#audio_current_frame>)) -- 
  * ((<SDL::MPEG::Info#current_offset>)) -- 
  * ((<SDL::MPEG::Info#total_size>)) -- 
  * ((<SDL::MPEG::Info#current_time>)) -- 
  * ((<SDL::MPEG#total_time>)) -- 
  * ((<SDL::MPEG#delete>)) -- 
  * ((<SDL::MPEG#deleted?>)) -- 

== MPEG playback Outline
Ruby/SDL enables you to play MPEG movie 
with ((<SMPEG|URL:http://www.icculus.org/smpeg>)).

Before calling MPEG methods, ((<SDL.init>)) should be called 
with SDL::INIT_AUDIO|SDL::INIT_VIDEO and 
((<SDL::Mixer.open>)) should be called.

MPEG playback system runs in sub thread(native thread).
Therefore you cannot read and write movie ((<SDL::Surface>)) 
while playing. In addition you cannot use ((<SDL::Mixer>)) 
routines while playing if ((<audio is enabled|SDL::MPEG#enable_audio>)).
Ruby/SDL doesn't control such an invalid access.

== SDL::MPEG
This class represents MPEG stream and playing state.

* ((<SDL::MPEG.new>)) -- Load MPEG file.
* ((<SDL::MPEG#info>)) -- Get information about MPEG object
* ((<SDL::MPEG#enable_audio>)) -- Enable/Dislable audio
* ((<SDL::MPEG#enable_video>)) -- Enable/Disable video
* ((<SDL::MPEG#status>)) -- Get current status
* ((<SDL::MPEG#set_volume>)) -- Change volume of MPEG stream
* ((<SDL::MPEG#set_display>)) -- Set display surface
* ((<SDL::MPEG#set_loop>)) -- Set/Clear looping play
* ((<SDL::MPEG#scale_xy>)) -- Scale pixel display
* ((<SDL::MPEG#scale>)) -- Scale pixel display
* ((<SDL::MPEG#move>)) -- Move the video display area
* ((<SDL::MPEG#set_display_region>)) -- Set the video display region
* ((<SDL::MPEG#play>)) -- Play an MPEG object
* ((<SDL::MPEG#stop>)) -- Stop playback of an MPEG object
* ((<SDL::MPEG#pause>)) -- Pause/Resume playback of an MPEG object
* ((<SDL::MPEG#rewind>)) -- Rewind the play position 
* ((<SDL::MPEG#seek>)) -- Seek in the MPEG stream.
* ((<SDL::MPEG#skip>)) -- Skip seconds in the MPEG stream
* ((<SDL::MPEG#render_frame>)) -- Render a particular frame in the MPEG video.
* ((<SDL::MPEG#render_final>)) -- Render the last frame of an MPEG video
* ((<SDL::MPEG#set_filer>)) -- Set video filter
* ((<SDL::MPEG#total_time>)) -- 
* ((<SDL::MPEG#delete>)) -- 
* ((<SDL::MPEG#deleted?>)) -- 

== SDL::MPEG::Info
This class represents ((<SDL::MPEG>)) information.
You can get instance by ((<SDL::MPEG#info>)).

* ((<SDL::MPEG::Info#has_audio>)) -- Get whether an MPEG stream has audio data
* ((<SDL::MPEG::Info#has_video>)) -- Get whether an MPEG stream has video data
* ((<SDL::MPEG::Info#width>)) -- Get width of video
* ((<SDL::MPEG::Info#height>)) -- Get height of video
* ((<SDL::MPEG::Info#current_frame>)) -- 
* ((<SDL::MPEG::Info#current_fps>)) -- 
* ((<SDL::MPEG::Info#audio_string>)) -- 
* ((<SDL::MPEG::Info#audio_current_frame>)) -- 
* ((<SDL::MPEG::Info#current_offset>)) -- 
* ((<SDL::MPEG::Info#total_size>)) -- 
* ((<SDL::MPEG::Info#current_time>)) -- 

== MPEG playback methods

--- SDL::MPEG.new(filename)
--- SDL::MPEG.load(filename)

    Loads a ((|filename|)) and returns 
    new ((<SDL::MPEG>)) object.

    Raises ((<SDL::Error>)) on failure

    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#info>)), ((<SDL::MPEG#play>))

--- SDL::MPEG#info

    Gets information about ((|self|)) as ((<SDL::MPEG::Info>)) object.


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG::Info>))

--- SDL::MPEG#enable_audio(enable)
--- SDL::MPEG#enableAudio(enable)

    Enables or disables audio.
    If ((|enable|)) is true, audio data is played, but if ((|enable|))
    is false, audio data is not played.


    You need SMPEG to use this method.
    * NOTES

      Audio enable/disable setting is reflected after
      playing starts.

    * See Also
      
      ((<SDL::MPEG#enable_video>)), ((<SDL::MPEG#info>))

--- SDL::MPEG#enable_video(enable)
--- SDL::MPEG#enableVideo(enable)

    Enables or disables audio.
    If ((|enable|)) is true, movie data is played, but if ((|enable|))
    is false, movie data is not played.


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#enable_audio>)), ((<SDL::MPEG#info>))

--- SDL::MPEG#status

    Returns current status of ((|self|)) as follows:
    * SDL::MEPG::ERROR - system has some errors
    * SDL::MPEG::STOPPED - movie is stopped
    * SDL::MPEG::PLAYING - movie is playing


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#info>))

--- SDL::MPEG#set_volume(volume)
--- SDL::MPEG#setVolume(volume)

    Set volume MPEG stream from 0 to 100.


    You need SMPEG to use this method.
    * NOTES

      You cannot get current volume.

    * See Also
      
      ((<SDL::MPEG#enable_audio>))

--- SDL::MPEG#set_display(surface)
--- SDL::MPEG#setDisplay(surface)

    Sets the ((<surface|SDL::Surface>)) that the playing movie displays on.
    Normally, the surface object returned by ((<SDL.set_video_mode>))
    is used as ((|surface|)).


    You need SMPEG to use this method.
    * NOTES

      MPEG playback system call ((<SDL::Screen#update_rect>)) from 
      a (native) sub thread.

    * See Also
      
      ((<SDL::Surface>)), ((<SDL::MPEG#play>))

--- SDL::MPEG#set_loop(repeat)
--- SDL::MPEG#setLoop(repeat)

    Set or clear looping play on ((|self|)).


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#play>))

--- SDL::MPEG#scale_xy(width, height)
--- SDL::MPEG#scaleXY(width, height)

    Set scale pixel display on ((|self|)).
    The Unit of ((|width|)) and ((|height|)) is pixel.


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#scale>)), ((<SDL::MPEG#set_display_region>))

--- SDL::MPEG#scale(scale)

    Set scale display on ((|self|)).


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#scale_xy>))

--- SDL::MPEG#move(x, y)

    Moves the video display to (((|x|)), ((|y|))) 
    within the destination surface set by ((<SDL::MPEG#set_display>)).


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#set_display>)), ((<SDL::MPEG#set_display_region>))

--- SDL::MPEG#set_display_region(x, y, w, h)

    Set the region of the video to be shown at 
    the rectangle of ((|x|)), ((|y|)), ((|w|)), ((|h|))


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#move>)), ((<SDL::MPEG#scale_xy>))

--- SDL::MPEG#play

    Plays an MPEG object.


    You need SMPEG to use this method.
    * NOTES

      You don't have to access surface set by ((<SDL::MPEG#set_display>)).
      x

    * See Also
      
      ((<SDL::MPEG#pause>)), ((<SDL::MPEG#stop>)), ((<SDL::MPEG#rewind>)), ((<SDL::MPEG#seek>)), ((<SDL::MPEG#skip>)), ((<SDL::MPEG#render_frame>))

--- SDL::MPEG#stop

    Stop play back of ((|self|)).


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#play>))

--- SDL::MPEG#pause

    Pauses/Resumes playback of ((|self|)).
    Pauses playback if ((|self|)) is playing, and
    Resume playback if paused.


    You need SMPEG to use this method.
--- SDL::MPEG#rewind

    Rewinds the play position of ((|self|))
    to the beginning of the MPEG.


    You need SMPEG to use this method.
--- SDL::MPEG#seek(bytes)

    Seeks ((|bytes|)) ((*bytes*)) the play position of ((|self|)).


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#play>)), ((<SDL::MPEG#skip>))

--- SDL::MPEG#skip(seconds)

    Skips ((|seconds|)) seconds in ((|self|)) MPEG stream.
    ((|seconds|)) can be Float or Integer.


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#play>)), ((<SDL::MPEG#seek>))

--- SDL::MPEG#render_frame(framenum)

    Render the ((|framenum|))-th frame in the surface set by
    ((<SDL::MEPG#set_display>)).


    You need SMPEG to use this method.
    * See Also
      
      ((<SDL::MPEG#render_final>)), ((<SDL::MPEG#play>))

--- SDL::MPEG#render_final(dst, x, y)

    Render the last frame of ((|self|)) video 
    at (((|x|)), ((|y|))) in the ((|dst|)) ((<surface|SDL::Surface>)).


    You need SMPEG to use this method.
--- SDL::MPEG#set_filer(filter)

    Selects video filter from one of following:
    * SDL::MPEG::NULL_FILTER no filter
    * SDL::MPEG::BILIEAR_FILTER bilinear filter
    * SDL::MPEG::DEBLOCKING_FILTER deblocking filter


    You need SMPEG to use this method.
--- SDL::MPEG::Info#has_audio

    Returns true if ((|self|)) MPEG stream has audio data,
    otherwise returns false.


    You need SMPEG to use this method.
--- SDL::MPEG::Info#has_video

    Returns true if ((|self|)) MPEG stream has video data,
    otherwise returns false.


    You need SMPEG to use this method.
--- SDL::MPEG::Info#width

    Returns the width of video as pixels.


    You need SMPEG to use this method.
--- SDL::MPEG::Info#height

    Returns the width of video as pixels.


    You need SMPEG to use this method.
--- SDL::MPEG::Info#current_frame

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG::Info#current_fps

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG::Info#audio_string

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG::Info#audio_current_frame

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG::Info#current_offset

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG::Info#total_size

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG::Info#current_time

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG#total_time

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG#delete

    not documented yet


    You need SMPEG to use this method.
--- SDL::MPEG#deleted?

    not documented yet


    You need SMPEG to use this method.
