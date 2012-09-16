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
    module MIX
      extend FFI::Library
      ffi_lib('SDL_mixer')
      class Mix_Chunk < FFI::Struct
        layout :allocated => :int,
              :abuf      => :pointer,
              :alen      => :ulong, 
              :volume    => :uchar
      end
    
      MIX_NO_FADING   = 0
      MIX_FADING_OUT  = 1
      MIX_FADING_IN   = 2
    
      MUS_NONE        = 0
      MUS_CMD         = 1
      MUS_WAV         = 2
      MUS_MOD         = 3
      MUS_MID         = 4
      MUS_OGG         = 5
      MUS_MP3         = 6
    
      class Mix_Music < FFI::Struct
        layout :fake => :pointer
      end
    
      attach_function :Mix_OpenAudio, [:int, :ushort, :int, :int], :int
      attach_function :Mix_AllocateChannels, [:int], :int
      attach_function :Mix_QuerySpec, [:pointer, :pointer, :pointer], :int
      # Load a wave file or a music (.mod .s3m .it .xm) file 
      attach_function :Mix_LoadWAV_RW, [:pointer, :int], :pointer
      def self.Mix_LoadWAV(filename) 
        Mix_LoadWAV_RW(SDL_RWFromFile(filename, "rb"), 1)
      end
      
      attach_function :Mix_LoadMUS, [:string], :pointer
      attach_function :Mix_LoadMUS_RW, [:pointer], :pointer
      # Free an audio chunk previously loaded 
      attach_function :Mix_FreeChunk, [:pointer], :void
      attach_function :Mix_FreeMusic, [:pointer], :void
      attach_function :Mix_GetMusicType, [:pointer], :int
      # skipped Mix_SetPostMix
      # skipped extern Mix_HookMusic
      # skiped  Mix_HookMusicFinished
      # skipped Mix_GetMusicHookData(void);
      # skipped Mix_ChannelFinished
      MIX_CHANNEL_POST = -2
      # skipped Mix_RegisterEffect
      # skipped Mix_UnregisterEffect
      # skipped Mix_UnregisterAllEffects 
      # define MIX_EFFECTSMAXSPEED  "MIX_EFFECTSMAXSPEED"
      attach_function :Mix_SetPanning, [:int, :uchar, :uchar], :int
      attach_function :Mix_SetPosition, [:int, :short, :uchar], :int
      attach_function :Mix_SetDistance, [:int, :uchar], :int
      attach_function :Mix_SetReverseStereo, [:int, :int], :int  
      attach_function :Mix_ReserveChannels, [:int], :int
      attach_function :Mix_GroupChannel  , [:int, :int], :int
      attach_function :Mix_GroupChannels , [:int, :int, :int], :int
      attach_function :Mix_GroupAvailable, [:int], :int
      attach_function :Mix_GroupCount    , [:int], :int
      attach_function :Mix_GroupOldest   , [:int], :int
      attach_function :Mix_GroupNewer    , [:int], :int
    
      def self.Mix_PlayChannel(channel,chunk,loops) 
        Mix_PlayChannelTimed(channel,chunk,loops,-1)
      end
    
      attach_function :Mix_PlayChannelTimed   , [:int, :pointer, :int, :int], :int 
      attach_function :Mix_PlayMusic          , [:pointer, :int], :int
      # Fade in music or a channel over "ms" milliseconds
      attach_function :Mix_FadeInMusic        , [:pointer, :int, :int], :int
      attach_function :Mix_FadeInMusicPos     , [:pointer, :int, :int, :double]   , :int
      attach_function :Mix_FadeInChannelTimed , [:int, :pointer, :int, :int, :int], :int
      
      def self.Mix_FadeInChannel(channel, chunk, loops, ms)
        Mix_FadeInChannelTimed(channel,chunk,loops,ms,-1)
      end
      # Set volume
      attach_function :Mix_Volume         , [:int    , :int], :int 
      attach_function :Mix_VolumeChunk    , [:pointer, :int , :int], :int
      attach_function :Mix_VolumeMusic    , [:int], :int
      # Halt playing of a particular channel 
      attach_function :Mix_HaltChannel    , [:int], :int
      attach_function :Mix_HaltGroup      , [:int], :int
      attach_function :Mix_HaltMusic      , [], :int
      # Change the expiration delay for a particular channel.
      attach_function :Mix_ExpireChannel  , [:int, :int], :int
      # Halt a channel, fading it out progressively till it's silent
      attach_function :Mix_FadeOutChannel , [:int, :int], :int
      attach_function :Mix_FadeOutGroup   , [:int, :int], :int  
      attach_function :Mix_FadeOutMusic   , [:int], :int
      # Query the fading status of a channel
      attach_function :Mix_FadingMusic    , []    , :int
      attach_function :Mix_FadingChannel  , [:int], :int
      # Pause/Resume a particular channel or music. 
      attach_function :Mix_Pause          , [:int], :void
      attach_function :Mix_Resume         , [:int], :void
      attach_function :Mix_Paused         , [:int], :void
      attach_function :Mix_PauseMusic     , [], :void
      attach_function :Mix_ResumeMusic    , [], :void
      attach_function :Mix_RewindMusic    , [], :void
      attach_function :Mix_PausedMusic    , [], :int
      attach_function :Mix_SetMusicPosition , [:double], :int
      # Check the status of a specific channel.
      attach_function :Mix_Playing          , [:int], :int 
      attach_function :Mix_PlayingMusic     , [], :int
      # Stop music and set external music playback command
      attach_function :Mix_SetMusicCMD      , [:string], :int
      # Skipping MIKMOD synchro values.
      # Get the Mix_Chunk currently associated with a mixer channel
      attach_function :Mix_GetChunk         , [:int], :pointer
      # Close the mixer, halting all playing audio 
      attach_function :Mix_CloseAudio       , [:void], :void 
    end
  end
end    
