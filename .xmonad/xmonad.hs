import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.NoBorders
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.UrgencyHook

import System.Exit
import System.IO

import Control.Monad
import Graphics.X11.ExtraTypes.XF86

quitWithWarning :: X()
quitWithWarning = do
  let m = "confirm quit"
  s <- dmenu [m]
  when (m == s) (io exitSuccess)

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , title =? "pterm Reconfiguration" --> doFloat
    , isFullscreen --> doFullFloat
    ]

myUrgencyHook = SpawnUrgencyHook "~/bin/urgency_hook "
myUrgencyConfig = urgencyConfig { suppressWhen = Visible }

myConfig = withUrgencyHookC myUrgencyHook myUrgencyConfig $ ewmh defaultConfig
    { manageHook = manageDocks <+> myManageHook
                    <+> manageHook defaultConfig
    , layoutHook = avoidStruts  $  smartBorders  $  layoutHook defaultConfig
    , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
    , startupHook = do
        startupHook myConfig
        spawn "/usr/bin/xcompmgr"
    , modMask = mod4Mask     -- Rebind Mod to the Windows key
    , terminal = "terminator"
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "/usr/bin/gnome-screensaver-command -l")
    , ((mod4Mask .|. shiftMask, xK_x), spawn "/usr/bin/gksudo /usr/sbin/pm-suspend-hybrid")
    , ((mod4Mask .|. shiftMask, xK_i), spawn "/usr/bin/xcalib -a -i")
    , ((mod4Mask .|. shiftMask, xK_g), focusUrgent)
    , ((mod4Mask .|. shiftMask, xK_q), quitWithWarning)
    , ((mod4Mask, xK_b), sendMessage ToggleStruts)
    , ((mod4Mask, xK_quoteleft), spawn "~/bin/touchpad-toggle")
    , ((0, xF86XK_AudioLowerVolume), spawn "/usr/bin/amixer set Master 2dB-")
    , ((0, xF86XK_AudioRaiseVolume), spawn "/usr/bin/amixer set Master 2dB+")
    , ((0, xF86XK_AudioMute), spawn "/usr/bin/amixer set Master toggle")
    , ((controlMask, xK_Print), spawn "sleep 0.2; /usr/bin/scrot -s")
    , ((0, xK_Print), spawn "/usr/bin/scrot")
    ]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar $HOME/.xmonad/.xmobarrc"
    xmonad $ myConfig
        { logHook = dynamicLogWithPP xmobarPP
                    { ppOutput = hPutStrLn xmproc
                    , ppTitle = xmobarColor "green" "" . shorten 50
                    , ppUrgent = xmobarColor "red" "" . xmobarStrip
                    }
        }
