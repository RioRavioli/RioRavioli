module Frusdl
  module SDL
    extend Frusdl::Low::SDL
    include Frusdl::Low::SDL
    
    class Error < Exception
    end
    
    
    INIT_TIMER        = SDL_INIT_TIMER
    INIT_AUDIO        = SDL_INIT_AUDIO
    INIT_VIDEO        = SDL_INIT_VIDEO
    INIT_CDROM        = SDL_INIT_CDROM
    INIT_JOYSTICK     = SDL_INIT_JOYSTICK
    INIT_NOPARACHUTE  = SDL_INIT_NOPARACHUTE
    INIT_EVENTTHREAD  = SDL_INIT_EVENTTHREAD
    INIT_EVERYTHING   = SDL_INIT_EVERYTHING
    
    # Helper function to raise an error message from SDL_GetError .  
    def raise_error()
        message = SDL_GetError();
        raise SDL::Error.new(message)
    end
  
    # Initializes SDL. This should be called before all other Frusdl methods. 
    # The flags parameter specifies what part(s) of SDL to initialize.
    # SDL::INIT_AUDIO      : Initialize audio subsystems. 
    # SDL::INIT_VIDEO      : Initialize SDL::Video subsystem. 
    # SDL::INIT_CDROM      : Initialize SDL::CDROM subsystem. 
    # SDL::INIT_JOYSTICK   : Initialize SDL::Joystick subsystem. 
    # SDL::INIT_EVERYTHING : Initialize all of the above. 
    # Raises SDL::Error on failure
    def self.init(what= INIT_EVERYTHING)
      res = SDL_Init(what)
      raise_error if res < 0
      at_exit { SDL_Quit() }    
    end 
    
    # This method shuts down all SDL subsystems and frees the resources 
    # allocated to them. This method is automatically called when ruby stops, 
    # so normally you don't have to call this function.
    def self.quit()
      SDL_Quit()
    end
    
    # This method allows you to see which SDL subsytems have
    # been initialized. flags is a bitwise OR'd combination of the subsystems 
    # you wish to check (see SDL.init for a list of subsystem flags).
    # Returns a bitwised OR'd combination of the initialized subsystems.
    def self.inited_system(flags)
      return SDL_WasInit(flags)
    end
    
    
    def self.getenv(s)
      return SDL_getenv(s)
    end
    
    def self.putenv(s)
      return SDL_putenv(s)
    end

     
    
      # And some for video functions
      SDL_SWSURFACE         = 0x00000000
      SDL_HWSURFACE         = 0x00000001
      SDL_ASYNCBLIT         = 0x00000004
      SDL_ANYFORMAT         = 0x10000000
      SDL_HWPALETTE         = 0x20000000
      SDL_DOUBLEBUF         = 0x40000000
      SDL_FULLSCREEN        = 0x80000000
      SDL_OPENGL            = 0x00000002
      SDL_OPENGLBLIT        = 0x0000000A
      SDL_RESIZABLE         = 0x00000010
      SDL_NOFRAME           = 0x00000020
      # And some more for mouse grabbing
      SDL_GRAB_QUERY        = -1
      SDL_GRAB_OFF          = 0
      SDL_GRAB_ON           = 1
      SDL_GRAB_FULLSCREEN   = 2
    
      SDL_LIL_ENDIAN = :little_endian
    
      if [-1].pack('V') ==  [-1].pack('N') 
        SDL_BYTEORDER = SDL_LIL_ENDIAN
      else
        SDL_BYTEORDER = SDL_BIG_ENDIAN
      end   
    
      AUDIO_U8      = 0x0008  # Unsigned 8-bit samples
      AUDIO_S8      = 0x8008  # Signed 8-bit samples 
      AUDIO_U16LSB  = 0x0010  # Unsigned 16-bit samples
      AUDIO_S16LSB  = 0x8010  # Signed 16-bit samples 
      AUDIO_U16MSB  = 0x1010  # As above, but big-endian byte order 
      AUDIO_S16MSB  = 0x9010  # As above, but big-endian byte order 
      AUDIO_U16     = AUDIO_U16LSB
      AUDIO_S16     = AUDIO_S16LSB
    
      # Native audio byte ordering
      if SDL_BYTEORDER == SDL_LIL_ENDIAN
        AUDIO_U16SYS = AUDIO_U16LSB
        AUDIO_S16SYS = AUDIO_S16LSB
      else
        AUDIO_U16SYS = AUDIO_U16MSB
        AUDIO_S16SYS =  AUDIO_S16MSB
      end
    
      SDL_AUDIO_STOPPED = 0
      SDL_AUDIO_PLAYING = 1
      SDL_AUDIO_PAUSED  = 2
      SDL_MIX_MAXVOLUME = 128
        
      SDL_DEFAULT_REPEAT_DELAY    = 500
      SDL_DEFAULT_REPEAT_INTERVAL = 30
      
      # SDL_keysym (lots of boring constants ahead :p )
      SDLK_UNKNOWN    = 0
      SDLK_FIRST      = 0
      SDLK_BACKSPACE  = 8
      SDLK_TAB        = 9
      SDLK_CLEAR      = 12
      SDLK_RETURN     = 13
      SDLK_PAUSE      = 19
      SDLK_ESCAPE     = 27
      SDLK_SPACE      = 32
      SDLK_EXCLAIM    = 33
      SDLK_QUOTEDBL   = 34
      SDLK_HASH       = 35
      SDLK_DOLLAR     = 36
      SDLK_AMPERSAND  = 38
      SDLK_QUOTE      = 39
      SDLK_LEFTPAREN  = 40
      SDLK_RIGHTPAREN = 41
      SDLK_ASTERISK   = 42
      SDLK_PLUS       = 43
      SDLK_COMMA      = 44
      SDLK_MINUS      = 45
      SDLK_PERIOD     = 46
      SDLK_SLASH      = 47
      SDLK_0          = 48
      SDLK_1          = 49
      SDLK_2          = 50
      SDLK_3          = 51
      SDLK_4          = 52
      SDLK_5          = 53
      SDLK_6          = 54
      SDLK_7          = 55
      SDLK_8          = 56
      SDLK_9          = 57
      SDLK_COLON      = 58
      SDLK_SEMICOLON  = 59
      SDLK_LESS       = 60
      SDLK_EQUALS     = 61
      SDLK_GREATER    = 62
      SDLK_QUESTION   = 63
      SDLK_AT         = 64
      SDLK_LEFTBRACKET  = 91
      SDLK_BACKSLASH    = 92
      SDLK_RIGHTBRACKET = 93
      SDLK_CARET        = 94
      SDLK_UNDERSCORE   = 95
      SDLK_BACKQUOTE    = 96
      SDLK_a      = 97
      SDLK_b      = 98
      SDLK_c      = 99
      SDLK_d      = 100
      SDLK_e      = 101
      SDLK_f      = 102
      SDLK_g      = 103
      SDLK_h      = 104
      SDLK_i      = 105
      SDLK_j      = 106
      SDLK_k      = 107
      SDLK_l      = 108
      SDLK_m      = 109
      SDLK_n      = 110
      SDLK_o      = 111
      SDLK_p      = 112
      SDLK_q      = 113
      SDLK_r      = 114
      SDLK_s      = 115
      SDLK_t      = 116
      SDLK_u      = 117
      SDLK_v      = 118
      SDLK_w      = 119
      SDLK_x      = 120
      SDLK_y      = 121
      SDLK_z      = 122
      SDLK_DELETE = 127  
      SDLK_WORLD_0    = 160    
      SDLK_WORLD_1    = 161
      SDLK_WORLD_2    = 162
      SDLK_WORLD_3    = 163
      SDLK_WORLD_4    = 164
      SDLK_WORLD_5    = 165
      SDLK_WORLD_6    = 166
      SDLK_WORLD_7    = 167
      SDLK_WORLD_8    = 168
      SDLK_WORLD_9    = 169
      SDLK_WORLD_10   = 170
      SDLK_WORLD_11   = 171
      SDLK_WORLD_12   = 172
      SDLK_WORLD_13   = 173
      SDLK_WORLD_14   = 174
      SDLK_WORLD_15   = 175
      SDLK_WORLD_16   = 176
      SDLK_WORLD_17   = 177
      SDLK_WORLD_18   = 178
      SDLK_WORLD_19   = 179
      SDLK_WORLD_20   = 180
      SDLK_WORLD_21   = 181
      SDLK_WORLD_22   = 182
      SDLK_WORLD_23   = 183
      SDLK_WORLD_24   = 184
      SDLK_WORLD_25   = 185
      SDLK_WORLD_26   = 186
      SDLK_WORLD_27   = 187
      SDLK_WORLD_28   = 188
      SDLK_WORLD_29   = 189
      SDLK_WORLD_30   = 190
      SDLK_WORLD_31   = 191
      SDLK_WORLD_32   = 192
      SDLK_WORLD_33   = 193
      SDLK_WORLD_34   = 194
      SDLK_WORLD_35   = 195
      SDLK_WORLD_36   = 196
      SDLK_WORLD_37   = 197
      SDLK_WORLD_38   = 198
      SDLK_WORLD_39   = 199
      SDLK_WORLD_40   = 200
      SDLK_WORLD_41   = 201
      SDLK_WORLD_42   = 202
      SDLK_WORLD_43   = 203
      SDLK_WORLD_44   = 204
      SDLK_WORLD_45   = 205
      SDLK_WORLD_46   = 206
      SDLK_WORLD_47   = 207
      SDLK_WORLD_48   = 208
      SDLK_WORLD_49   = 209
      SDLK_WORLD_50   = 210
      SDLK_WORLD_51   = 211
      SDLK_WORLD_52   = 212
      SDLK_WORLD_53   = 213
      SDLK_WORLD_54   = 214
      SDLK_WORLD_55   = 215
      SDLK_WORLD_56   = 216
      SDLK_WORLD_57   = 217
      SDLK_WORLD_58   = 218
      SDLK_WORLD_59   = 219
      SDLK_WORLD_60   = 220
      SDLK_WORLD_61   = 221
      SDLK_WORLD_62   = 222
      SDLK_WORLD_63   = 223
      SDLK_WORLD_64   = 224
      SDLK_WORLD_65   = 225
      SDLK_WORLD_66   = 226
      SDLK_WORLD_67   = 227
      SDLK_WORLD_68   = 228
      SDLK_WORLD_69   = 229
      SDLK_WORLD_70   = 230
      SDLK_WORLD_71   = 231
      SDLK_WORLD_72   = 232
      SDLK_WORLD_73   = 233
      SDLK_WORLD_74   = 234
      SDLK_WORLD_75   = 235
      SDLK_WORLD_76   = 236
      SDLK_WORLD_77   = 237
      SDLK_WORLD_78   = 238
      SDLK_WORLD_79   = 239
      SDLK_WORLD_80   = 240
      SDLK_WORLD_81   = 241
      SDLK_WORLD_82   = 242
      SDLK_WORLD_83   = 243
      SDLK_WORLD_84   = 244
      SDLK_WORLD_85   = 245
      SDLK_WORLD_86   = 246
      SDLK_WORLD_87   = 247
      SDLK_WORLD_88   = 248
      SDLK_WORLD_89   = 249
      SDLK_WORLD_90   = 250
      SDLK_WORLD_91   = 251
      SDLK_WORLD_92   = 252
      SDLK_WORLD_93   = 253
      SDLK_WORLD_94   = 254
      SDLK_WORLD_95   = 255    
      SDLK_KP0    = 256
      SDLK_KP1    = 257
      SDLK_KP2    = 258
      SDLK_KP3    = 259
      SDLK_KP4    = 260
      SDLK_KP5    = 261
      SDLK_KP6    = 262
      SDLK_KP7    = 263
      SDLK_KP8    = 264
      SDLK_KP9    = 265
      SDLK_KP_PERIOD    = 266
      SDLK_KP_DIVIDE    = 267
      SDLK_KP_MULTIPLY  = 268
      SDLK_KP_MINUS     = 269
      SDLK_KP_PLUS      = 270
      SDLK_KP_ENTER     = 271
      SDLK_KP_EQUALS    = 272
      SDLK_UP       = 273
      SDLK_DOWN     = 274
      SDLK_RIGHT    = 275
      SDLK_LEFT     = 276
      SDLK_INSERT   = 277
      SDLK_HOME     = 278
      SDLK_END      = 279
      SDLK_PAGEUP   = 280
      SDLK_PAGEDOWN = 281
      SDLK_F1     = 282
      SDLK_F2     = 283
      SDLK_F3     = 284
      SDLK_F4     = 285
      SDLK_F5     = 286
      SDLK_F6     = 287
      SDLK_F7     = 288
      SDLK_F8     = 289
      SDLK_F9     = 290
      SDLK_F10    = 291
      SDLK_F11    = 292
      SDLK_F12    = 293
      SDLK_F13    = 294
      SDLK_F14    = 295
      SDLK_F15    = 296
      SDLK_NUMLOCK    = 300
      SDLK_CAPSLOCK   = 301
      SDLK_SCROLLOCK  = 302
      SDLK_RSHIFT   = 303
      SDLK_LSHIFT   = 304
      SDLK_RCTRL    = 305
      SDLK_LCTRL    = 306
      SDLK_RALT     = 307
      SDLK_LALT     = 308
      SDLK_RMETA    = 309
      SDLK_LMETA    = 310
      SDLK_LSUPER   = 311   
      SDLK_RSUPER   = 312   
      SDLK_MODE     = 313    
      SDLK_COMPOSE  = 314   
      SDLK_HELP     = 315
      SDLK_PRINT    = 316
      SDLK_SYSREQ   = 317
      SDLK_BREAK    = 318
      SDLK_MENU     = 319
      SDLK_POWER    = 320  
      SDLK_EURO     = 321    
      SDLK_UNDO     = 322    
      SDLK_LAST     = 323
    
      KMOD_NONE     = 0x0000
      KMOD_LSHIFT   = 0x0001
      KMOD_RSHIFT   = 0x0002
      KMOD_LCTRL    = 0x0040
      KMOD_RCTRL    = 0x0080
      KMOD_LALT     = 0x0100
      KMOD_RALT     = 0x0200
      KMOD_LMETA    = 0x0400
      KMOD_RMETA    = 0x0800
      KMOD_NUM      = 0x1000
      KMOD_CAPS     = 0x2000
      KMOD_MODE     = 0x4000
      KMOD_RESERVED = 0x8000
      KMOD_CTRL     = (KMOD_LCTRL|KMOD_RCTRL)
      KMOD_SHIFT    = (KMOD_LSHIFT|KMOD_RSHIFT)
      KMOD_ALT      = (KMOD_LALT|KMOD_RALT)
      KMOD_META     = (KMOD_LMETA|KMOD_RMETA)
      # Phew, all done! ^_^
    
      RW_SEEK_SET = 0 
      RW_SEEK_CUR = 1 
      RW_SEEK_END = 2
    
      # SDL_event
      SDL_RELEASED        = 0
      SDL_PRESSED         = 1
      SDL_NOEVENT         = 0
      SDL_ACTIVEEVENT     = 1
      SDL_KEYDOWN         = 2
      SDL_KEYUP           = 3
      SDL_MOUSEMOTION     = 4
      SDL_MOUSEBUTTONDOWN = 5
      SDL_MOUSEBUTTONUP   = 6
      SDL_JOYAXISMOTION   = 7
      SDL_JOYBALLMOTION   = 8
      SDL_JOYHATMOTION    = 9
      SDL_JOYBUTTONDOWN   = 10
      SDL_JOYBUTTONUP     = 11
      SDL_QUIT            = 12
      SDL_SYSWMEVENT      = 13
      SDL_EVENT_RESERVEDA = 14
      SDL_EVENT_RESERVEDB = 15
      SDL_VIDEORESIZE     = 16
      SDL_VIDEOEXPOSE     = 17
      SDL_EVENT_RESERVED2 = 18
      SDL_EVENT_RESERVED3 = 19
      SDL_EVENT_RESERVED4 = 20
      SDL_EVENT_RESERVED5 = 21
      SDL_EVENT_RESERVED6 = 22
      SDL_EVENT_RESERVED7 = 23
      SDL_USEREVENT       = 24
      SDL_NUMEVENTS       = 32
      
      SDL_HAT_CENTERED  = 0x00
      SDL_HAT_UP        = 0x01
      SDL_HAT_RIGHT     = 0x02
      SDL_HAT_DOWN      = 0x04
      SDL_HAT_LEFT      = 0x08
      SDL_HAT_RIGHTUP   = (SDL_HAT_RIGHT|SDL_HAT_UP)
      SDL_HAT_RIGHTDOWN = (SDL_HAT_RIGHT|SDL_HAT_DOWN)
      SDL_HAT_LEFTUP    = (SDL_HAT_LEFT|SDL_HAT_UP)
      SDL_HAT_LEFTDOWN  = (SDL_HAT_LEFT|SDL_HAT_DOWN)

    
    
    
    autoload :Surface     , 'frusdl/sdl/surface' 
    autoload :Screen      , 'frusdl/sdl/screen'
    autoload :PixelFormat , 'frusdl/sdl/pixelformat'
    autoload :VideoInfo   , 'frusdl/sdl/videoinfo'
    
  end # module SDL  
end # module Frusdl