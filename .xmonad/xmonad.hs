import XMonad
import System.IO
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
---
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
---
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Spiral
import XMonad.Layout.Grid
import XMonad.Layout.Named
import XMonad.Util.Paste
---
import XMonad.Actions.CopyWindow
import qualified XMonad.StackSet as W

myLayout = avoidStruts $ tiled ||| named "Mirror" (Mirror tiled) ||| Grid ||| noBorders Full ||| spiral (6/7)  
 where
  tiled = named "Tall" (ResizableTall 3 (3/100) (1/2) [])
  boarderless = noBorders Full

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
--myFocusedBorderColor = "#990000"
--myFocusedBorderColor = "#098cfe"
myFocusedBorderColor = "#ccff2a"

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Jitsi" --> doFloat
    , className =? "Tor Browser" --> doShift "F"
    , className =? "Firefox" --> doShift "F"
    , className =? "Firefox" --> doFloat
    , className =? "Evince" --> doShift "I"
    , className =? "Icedove" --> doShift "I"
    , className =? "Chromium" --> doShift "E"
    , className =? "Pidgin" --> doFloat
    , className =? "ricochet" --> doFloat
    ]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook -- make sure to include myManageHook definition from above
                        <+> manageHook defaultConfig
	, layoutHook = myLayout -- make sure to include myLayout definition from above
        , focusFollowsMouse = myFocusFollowsMouse
	, logHook = dynamicLogWithPP $ xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Super key
	, focusedBorderColor = myFocusedBorderColor
	, terminal = "urxvt"
	, workspaces = ["A","B","C","D","E","F","G","H","I"]
        } `additionalKeys`
        [   
	 ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures/Screenshots'")
	, ((mod4Mask, xK_p), spawn "dmenu_run -fn '-*-terminus-medium-*-*-22-*-*-*-*-*-*'")
	, ((mod4Mask, xK_v ), windows copyToAll) -- @@ Make focused window always visible
 	, ((mod4Mask .|. shiftMask, xK_v ),  killAllOtherCopies) -- @@ Toggle window state back
	]

