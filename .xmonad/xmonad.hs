
import XMonad
import XMonad.Core
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import qualified XMonad.StackSet as W
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Layout
import XMonad.Layout.ResizableTile
import XMonad.Util.Loggers

main = do
	xmproc <- spawnPipe "xmobar"
	xmonad $ defaultConfig 
		{ borderWidth = 1 
		, terminal = "urxvt"
			--xmobar (I think)
		, manageHook = myManageHook <+> manageHook defaultConfig
		, startupHook = myStartup
		, logHook = dynamicLogWithPP xmobarPP
							{ ppOutput = hPutStrLn xmproc
						--	, ppTitle = (\str -> (case logTitle  of
							, ppTitle = xmobarColor "green" "" . shorten 50
							--, ppTitle = test
							}
			--smartBord
		, layoutHook = smartBorders (myLayout)
		, focusFollowsMouse = False
		} 

------------------------------------------------------------------------------
--Layouts
--
myLayout = avoidStruts
			  $ tiled ||| Full
	where
		tiled = ResizableTall 1 (3/100) (1/2) []

------------------------------------------------------------------------------
--Startup
--
myStartup = do
			 spawn "xterm -e 'wicd-curses'"
			 spawn "xterm -e 'alsamixer'"
			 spawn "firefox"

------------------------------------------------------------------------------
--Manage Hooks
--
myManageHook = composeAll . concat $
	[ [ className =? "Firefox" --> doShift "2"]
	, [(className =? "Firefox" <&&> resource =? "Dialog") --> doFloat]
	, [ isFullscreen --> doFullFloat]
	] 

------------------------
--tests
--
--test = ifh 
