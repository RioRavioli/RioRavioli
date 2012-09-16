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

    module SDL 
      extend FFI::Library
      ffi_lib('SDL')   # load SDL library through ffi  
    
      # Define some constants for the init function
      SDL_INIT_TIMER        = 0x00000001
      SDL_INIT_AUDIO        = 0x00000010
      SDL_INIT_VIDEO        = 0x00000020
      SDL_INIT_CDROM        = 0x00000100
      SDL_INIT_JOYSTICK     = 0x00000200
      SDL_INIT_NOPARACHUTE  = 0x00100000
      SDL_INIT_EVENTTHREAD  = 0x01000000
      SDL_INIT_EVERYTHING   = 0x0000FFFF
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
    
    
    
      class SDL_Rect < FFI::Struct
        layout :x => :short,
          :y => :short,
          :w => :ushort,
          :h => :ushort
      end
    
      class SDL_Color < FFI::Struct
        layout :r      => :uchar,
        :g      => :uchar,
        :b      => :uchar,
        :unused => :uchar    
      end
    
    
      class SDL_Palette < FFI::Struct
        layout  :ncolors => :int, 
                :colors  => :pointer 
      end
    
      class SDL_VideoInfo < FFI::Struct
        layout :bitfields => :ulong,
               :video_mem => :ulong, 
               :vfmt      => :pointer,
               :current_w => :int,
               :current_h => :int
      end
      
=begin 
    # XXX: How to do these bitfields???     
    Uint32 hw_available:1;
    Uint32 wm_available:1;
    Uint32 blit_hw:1;
    Uint32 blit_hw_CC:1;
    Uint32 blit_hw_A:1;
    Uint32 blit_sw:1;
    Uint32 blit_sw_CC:1;
    Uint32 blit_sw_A:1;
    Uint32 blit_fill:1;
    Uint32 video_mem;
    SDL_PixelFormat *vfmt;
    int current_w;
    int current_h;
=end


    
      class SDL_PixelFormat < FFI::Struct
        layout  :palette        => :pointer, 
                :bitsperpixel   => :uchar,
                :bytesperpixel  => :uchar,
                :rloss          => :uchar,
                :gloss          => :uchar,
                :bloss          => :uchar,
                :aloss          => :uchar,
                :rshift         => :uchar,
                :gshift         => :uchar,
                :bshift         => :uchar,
                :ashift         => :uchar,
                :rmask          => :uint,
                :gmask          => :uint,
                :bmask          => :uint,
                :amask          => :uint,
                :colorkey       => :uint,
                :alpha          => :uchar
      end
    
      class SDL_Surface < FFI::ManagedStruct
        layout :flags   => :ulong   ,
              :format  => :pointer ,
              :w       => :int     ,
              :h       => :int     ,
              :pitch   => :short   ,
              :pixels  => :pointer
        # the rest of the C struct is mostly private
        def self.release(ptr)
            if ptr && (!ptr.null?) 
                SDL.SDL_FreeSurface(ptr) 
            end 
        end
        
      end
    
      # SDL_audio
      class SDL_AudioSpec < FFI::Struct
      layout  :freq     => :int,      # DSP frequency -- samples per second
              :format   => :ushort,   #  Audio data format
              :channels => :uchar,    # Number of channels: 1 mono, 2 stereo
              :silence  => :uchar,    # Audio buffer silence value (calculated)
              :samples  => :ushort,   # Audio buffer size in samples (power of 2)
              :padding  => :ushort,   # Necessary for some compile environments
              :size     => :ulong,    # Audio buffer size in bytes (calculated)
              :callback => :pointer,            
              # This function is called when the audio device needs more data.
              #   'stream' is a pointer to the audio data buffer
              #   'len' is the length of that buffer in bytes.
              #   Once the callback returns, the buffer will no longer be valid.
              #   Stereo samples are stored in a LRLRLR ordering.
            :userdata =>  :pointer  
      end
    
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
        
      # SDL_AudioCVT  skipped for now 
      attach_function :SDL_AudioDriverName, [:pointer, :int], :pointer  
      attach_function :SDL_OpenAudio, [:pointer, :pointer ], :int   
      attach_function :SDL_GetAudioStatus, [], :int
      attach_function :SDL_PauseAudio, [:int], :void
      attach_function :SDL_LoadWAV_RW, [:pointer, :int, :pointer, :pointer, :pointer], :pointer 
      
      # Compatibility convenience function -- loads a WAV from a file
      def self.SDL_LoadWAV(filename, spec, audio_buf, audio_len) 
        SDL_LoadWAV_RW(SDL_RWFromFile(filename, "rb"),1, spec, audio_buf, audio_len)
      end
    
      attach_function :SDL_FreeWAV, [:pointer], :void
      # SDL_BuildAudioCVT skipped
      # SDL_ConvertAudio(SDL_AudioCVT *cvt) skipped 
      attach_function :SDL_MixAudio, [:pointer, :pointer, :ulong, :int], :void
      attach_function :SDL_LockAudio, [], :void
      attach_function :SDL_UnlockAudio, [], :void
      attach_function :SDL_CloseAudio, [], :void
    
      # SDL_error
      attach_function :SDL_SetError   , [:string], :void
      attach_function :SDL_GetError   , [], :string
      attach_function :SDL_ClearError , [], :void
    
      # SDL_keyboard
      class SDL_keysym < FFI::Struct
        layout :scancode => :uchar,    # hardware specific scancode 
              :sym      => :int,      # SDL virtual keysym 
              :mod      => :int,      # current key modifiers 
              :unicode  => :ushort    # translated character 
      end
    
      attach_function :SDL_EnableUNICODE, [:int], :int
      SDL_DEFAULT_REPEAT_DELAY    = 500
      SDL_DEFAULT_REPEAT_INTERVAL = 30
      attach_function :SDL_EnableKeyRepeat, [:int, :int], :int
      attach_function :SDL_GetKeyRepeat   , [:pointer, :pointer], :void
      attach_function :SDL_GetKeyState, [:int], :pointer
      attach_function :SDL_GetModState, [], :int 
      attach_function :SDL_SetModState, [:int], :void
      attach_function :SDL_GetKeyName, [:int], :string
      
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
    
      # SDL_mouse
      class SDL_Cursor < FFI::Struct 
      #  SDL_Rect area;     # need typedef for this. How to do it?
      #  Sint16 hot_x, hot_y;    /* The "tip" of the cursor */
      #  Uint8 *data;      /* B/W cursor data */
      #  Uint8 *mask;      /* B/W cursor mask */
      #  Uint8 *save[2];     /* Place to save cursor area */
      #  WMcursor *wm_cursor;    /* Window-manager cursor */
      end
    
      attach_function :SDL_GetMouseState        , [:pointer, :pointer], :uchar
      attach_function :SDL_GetRelativeMouseState, [:pointer, :pointer], :uchar
      attach_function :SDL_WarpMouse            , [:ushort, :ushort], :void
      attach_function :SDL_CreateCursor         , [:pointer, :pointer, :int, :int, :int, :int, ], :pointer  
      attach_function :SDL_SetCursor            , [:pointer], :void
      attach_function :SDL_FreeCursor           , [:pointer], :void
      attach_function :SDL_ShowCursor           , [:int], :int
      
      SDL_BUTTON_LEFT       = 1
      SDL_BUTTON_MIDDLE     = 2
      SDL_BUTTON_RIGHT      = 3
      SDL_BUTTON_WHEELUP    = 4
      SDL_BUTTON_WHEELDOWN  = 5
    
      # SDL_rwops. We need this because a lot of SDL uses this inside macros
      # which we obviously have to reimplement as Ruby methods.
      class SDL_RWops < FFI::Struct
        layout :seek  => :pointer, # is a callback in reality
              :read  => :pointer, # is a callback in reality
              :write => :pointer, # is a callback in reality
              :close => :pointer, # is a callback in reality
              :type  => :ulong
        # rest is private 
      end  
      
      attach_function :SDL_RWFromFile     , [:string, :string], :pointer
      attach_function :SDL_RWFromFP       , [:pointer, :int]  , :pointer
      attach_function :SDL_RWFromMem      , [:pointer, :int]  , :pointer
      attach_function :SDL_RWFromConstMem , [:pointer, :int]  , :pointer
      attach_function :SDL_AllocRW        , []                , :pointer
      attach_function :SDL_FreeRW         , [:pointer]        , :void
    
      RW_SEEK_SET = 0 
      RW_SEEK_CUR = 1 
      RW_SEEK_END = 2 
      # SDL uses macros to "easily" read and write from an SDL_RWops structure
      # unfortunately, we need to use callbacks for this 
      def SDL_RWseek(ctx, offset, whence) 
        ctx[:seek].call(ctx, offset, whence)
      end
    
      def SDL_RWtell(ctx) 
        ctx[:seek].call(ctx, 0, RW_SEEK_CUR)
      end
    
      def SDL_RWread(ctx, ptr, size, n) 
        ctx[:read].call(ctx, ptr, size, n)
      end 
    
      def SDL_RWwrite(ctx, offset, whence) 
        ctx[:write].call(ctx, ptr, size, n)
      end
    
      def SDL_RWclose(ctx) 
        ctx[:close].call(ctx)
      end
      
      # We don't need more of SDL_rwops, because we have ruby's much 
      # easier to use File. 
    
      # SDL_timer
      SDL_TIMESLICE     = 10
      TIMER_RESOLUTION  = 10 
      attach_function :SDL_GetTicks, [:void], :ulong
      # Wait a specified number of milliseconds before returning 
      attach_function :SDL_Delay, [:ulong], :void
      attach_function :SDL_SetTimer, [ :ulong, :pointer], :int
      attach_function :SDL_AddTimer, [:ulong, :pointer, :pointer], :pointer
      attach_function :SDL_RemoveTimer, [:pointer], :int
    
      # SDL_version
      class SDL_version < FFI::Struct
        layout :major => :uchar, 
              :minor => :uchar,
              :patch => :uchar
      end
    
      attach_function :SDL_Linked_Version, [], :pointer
    
    
    
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
    
      # Application visibility event structure 
      class SDL_ActiveEvent < FFI::Struct
        layout :type  => :uchar, 
              :gain  => :uchar,
              :state => :uchar
      end
    
    
      # Keyboard event structure
      class SDL_KeyboardEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :state  => :uchar,
              :keysym => :pointer 
      end
    
      # Keyboard event structure
      class SDL_MouseMotionEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :state  => :uchar,
              :x      => :ushort,
              :y      => :ushort,
              :xrel   => :short,
              :yrel   => :short
      end
    
      # Mouse button event structure 
      class SDL_MouseButtonEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :button => :uchar,
              :state  => :uchar,
              :x      => :ushort,
              :y      => :ushort
      end
    
      #  Joystick axis motion event structure
      class SDL_JoyAxisEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :axis   => :uchar,
              :value  => :short 
      end
    
      # Joystick trackball motion event structure 
      class SDL_JoyBallEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :ball   => :uchar,
              :xrel   => :short,
              :yrel   => :short
      end
    
      # Joystick hat position change event structure 
      class SDL_JoyHatEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :hat    => :uchar,
              :value  => :uchar 
      end
    
      # Joystick button event structure  
      class SDL_JoyButtonEvent < FFI::Struct
        layout :type   => :uchar, 
              :which  => :uchar,
              :button => :uchar,
              :state  => :uchar 
      end
    
      # The "window resized" event
      class SDL_ResizeEvent < FFI::Struct
        layout :type   => :uchar, 
              :x      => :int,
              :y      => :int
      end
    
      class SDL_ExposeEvent < FFI::Struct
        layout :type   => :uchar
      end
    
      class SDL_QuitEvent < FFI::Struct
        layout :type   => :uchar
      end
    
      # A user-defined event type 
      class SDL_UserEvent < FFI::Struct
        layout :type   => :uchar, 
              :code   => :int,
              :data1  => :pointer,
              :data2  => :pointer
      end 
    
      # General event structure. Cheat a bit because it's a union
      class SDL_Event < FFI::Struct
        layout :type   => :uchar,
              :fake1  => :ulong,
              :fake2  => :ulong,
              :fake3  => :ulong,
              :fake4  => :ulong
      end
    
      attach_function :SDL_PumpEvents, [], :void
    
      SDL_ADDEVENT  = 0
      SDL_PEEKEVENT = 1
      SDL_GETEVENT  = 2
    
      attach_function :SDL_PeepEvents, [:pointer, :int, :int, :ulong], :int 
      attach_function :SDL_PollEvent,  [:pointer], :int
      attach_function :SDL_WaitEvent,  [:pointer], :int
      attach_function :SDL_PushEvent,  [:pointer], :int 
      attach_function :SDL_SetEventFilter, [:pointer], :void
      attach_function :SDL_GetEventFilter, [], :pointer
      SDL_QUERY     = -1
      SDL_IGNORE    =  0
      SDL_DISABLE   =  0
      SDL_ENABLE    =  1
      attach_function :SDL_EventState, [:uchar, :int], :int
    
    
      class SDL_Joystick < FFI::Struct
        layout :fake => :pointer
        # The struct is private
        def self.release(ptr) 
            if ptr && (!ptr.null?) 
                SDL.SDL_JoystickClose(ptr)
            end 
        end
        
      end
    
    
      # SDL_joystick
      # Count the number of joysticks attached to the system
      attach_function :SDL_NumJoysticks, [], :int
    
      # Get the implementation dependent name of a joystick.
      attach_function :SDL_JoystickName, [:int], :string
    
      # Open a joystick for use - the index passed as an argument refers to
      # the N'th joystick on the system.  This index is the value which will
      # identify this joystick in future joystick events.
      attach_function :SDL_JoystickOpen, [:int], :pointer
    
      # Returns 1 if the joystick has been opened, or 0 if it has not.
      attach_function :SDL_JoystickOpened, [:int], :int
    
      # Get the device index of an opened joystick.
      attach_function :SDL_JoystickIndex, [:pointer], :int
    
      # Get the number of general axis controls on a joystick
      attach_function :SDL_JoystickNumAxes, [:pointer], :int
    
      # Get the number of trackballs on a joystick
      attach_function :SDL_JoystickNumBalls, [:pointer], :int
    
      # Get the number of POV hats on a joystick
      attach_function :SDL_JoystickNumHats, [:pointer], :int
    
      # Get the number of buttons on a joystick
      attach_function :SDL_JoystickNumButtons, [:pointer], :int
      
      # Update joystick state 
      attach_function :SDL_JoystickUpdate, [], :void    
      attach_function :SDL_JoystickEventState, [:int], :int
      attach_function :SDL_JoystickGetAxis, [:pointer, :int], :short
      SDL_HAT_CENTERED  = 0x00
      SDL_HAT_UP        = 0x01
      SDL_HAT_RIGHT     = 0x02
      SDL_HAT_DOWN      = 0x04
      SDL_HAT_LEFT      = 0x08
      SDL_HAT_RIGHTUP   = (SDL_HAT_RIGHT|SDL_HAT_UP)
      SDL_HAT_RIGHTDOWN = (SDL_HAT_RIGHT|SDL_HAT_DOWN)
      SDL_HAT_LEFTUP    = (SDL_HAT_LEFT|SDL_HAT_UP)
      SDL_HAT_LEFTDOWN  = (SDL_HAT_LEFT|SDL_HAT_DOWN)
      attach_function :SDL_JoystickGetHat, [:pointer, :int], :uchar
      # Get the ball axis change since the last poll
      attach_function :SDL_JoystickGetBall, [:pointer, :int, :pointer, :pointer], :int
      # Get the current state of a button on a joystick The button indices start at 0.
      attach_function :SDL_JoystickGetButton, [:pointer, :int], :uchar
      attach_function :SDL_JoystickClose, [:pointer], :void
    
    
      # SDL 
      attach_function :SDL_Init, [:ulong], :int
      attach_function :SDL_Quit, [], :int
      attach_function :SDL_WasInit, [:ulong], :ulong
      
      # getenv/putenv, macro madness
      begin 
        attach_function :SDL_getenv, [:string], :string
        attach_function :SDL_putenv, [:string], :int
      rescue FFI::NotFoundError 
      # possibly not in the dynamic library on some platforms 
      # So use normal getenv/setenv in stead
        def self.SDL_getenv(s)
          return ENV[s] 
        end   
         
        def self.SDL_putenv(s)
          a = s.split('=') 
          ENV[a[0]] = a[1]
          return 0
        end   
      end  
    
      # SDL_video
      
      attach_function :SDL_SetVideoMode   , [:int, :int, :int, :ulong ], :pointer
      attach_function :SDL_GetVideoSurface, [], :pointer
      attach_function :SDL_GetVideoInfo, [], :pointer

      attach_function :SDL_VideoDriverName, [:pointer, :int], :string
      attach_function :SDL_ListModes      , [:pointer, :ulong], :pointer
      attach_function :SDL_VideoModeOK    , [:int, :int, :int, :ulong ], :int

      
      attach_function :SDL_Flip   , [:pointer], :int
      attach_function :SDL_MapRGB , [:pointer, :uchar, :uchar, :uchar], :ulong
      attach_function :SDL_MapRGBA, [:pointer, :uchar, :uchar, :uchar, :uchar], :ulong
      attach_function :SDL_CreateRGBSurface, [:ulong, :int, :int, :int, :ulong, :ulong, :ulong, :ulong], :pointer
      attach_function :SDL_CreateRGBSurfaceFrom, 
      [:pointer, :int, :int, :int, :int, :ulong, :ulong, :ulong, :ulong], :pointer
      attach_function :SDL_FreeSurface, [:pointer], :void
      attach_function :SDL_LockSurface, [:pointer], :int
      attach_function :SDL_UnlockSurface, [:pointer], :void
      attach_function :SDL_LoadBMP_RW, [:pointer, :int], :pointer
      attach_function :SDL_SaveBMP_RW, [:pointer, :pointer, :int], :int
      
      attach_function :SDL_UpdateRect, [:pointer, :short, :short, :short, :short], :void
      attach_function :SDL_UpdateRects, [:pointer, :int, :pointer], :void
      
      attach_function :SDL_SetGamma     , [:float, :float, :float], :int
      attach_function :SDL_SetGammaRamp , [:pointer, :pointer, :pointer], :int
      attach_function :SDL_GetGammaRamp , [:pointer, :pointer, :pointer], :int
    
      def self.SDL_LoadBMP(filename) 
        SDL_LoadBMP_RW(SDL_RWFromFile(filename, "rb"), 1)
      end
    
      def self.SDL_SaveBMP(surface, filename) 
        SDL_SaveBMP_RW(surface, SDL_RWFromFile(filename, "wb"), 1)
      end 
    
      attach_function :SDL_SetColorKey, [:pointer, :ulong, :ulong], :int
      attach_function :SDL_SetAlpha   , [:pointer, :ulong, :uchar], :int
      attach_function :SDL_SetClipRect, [:pointer, :pointer], :int
      attach_function :SDL_GetClipRect, [:pointer, :pointer], :void
      attach_function :SDL_ConvertSurface, [:pointer, :pointer, :ulong], :pointer
      attach_function :SDL_UpperBlit, [:pointer, :pointer, :pointer, :pointer], :int
      
      def self.SDL_BlitSurface(src, srcrect, dst, dstrect)
        SDL_UpperBlit(src, srcrect, dst, dstrect)
      end
    
      attach_function :SDL_FillRect           , [:pointer, :pointer, :ulong], :int 
      attach_function :SDL_DisplayFormat      , [:pointer, :pointer], :pointer
      attach_function :SDL_DisplayFormatAlpha , [:pointer, :pointer], :pointer
      attach_function :SDL_WM_SetCaption      , [:string, :string]  , :void 
      attach_function :SDL_WM_GetCaption      , [:pointer, :pointer], :void
      attach_function :SDL_WM_SetIcon         , [:pointer, :pointer], :void
      attach_function :SDL_WM_IconifyWindow   , [], :int
      attach_function :SDL_WM_ToggleFullScreen, [:pointer], :int  
      attach_function :SDL_WM_GrabInput       , [:int], :int
    
    
    end




  end
end    
