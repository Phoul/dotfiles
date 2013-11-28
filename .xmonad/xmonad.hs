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
import XMonad.Layout.Grid
import XMonad.Layout.Named
---

myLayout = avoidStruts $ tiled ||| named "Mirror" (Mirror tiled) ||| Grid ||| noBorders Full 
 where
  tiled = named "Tall" (ResizableTall 3 (3/100) (1/2) [])
  boarderless = noBorders Full

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Iceweasel" --> doShift "F"
    , className =? "Firefox" --> doShift "F"
    , className =? "Evince" --> doShift "H"
    , className =? "Icedove" --> doShift "I"
--    , className =? "Emacs" --> doShift "C" 
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
	, terminal = "urxvt"
	, workspaces = ["A","B","C","D","E","F","G","H","I"]
        } `additionalKeys`
        [ ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/Pictures/Screenshots'")
	]

