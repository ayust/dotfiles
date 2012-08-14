import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86

myManageHook = composeAll
    [ className =? "Gimp"      --> doFloat
    , className =? "Vncviewer" --> doFloat
    , title =? "pterm Reconfiguration" --> doFloat
    ]

main = do
    xmproc <- spawnPipe "/usr/bin/xmobar /home/aiiane/.xmonad/.xmobarrc"
    xmonad $ defaultConfig
        { manageHook = manageDocks <+> myManageHook
                        <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , modMask = mod4Mask     -- Rebind Mod to the Windows key
        , terminal = "pterm"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "/usr/bin/gnome-screensaver-command -l")
        , ((mod4Mask .|. shiftMask, xK_i), spawn "/usr/bin/fetchotp -x")
        , ((0, xF86XK_AudioLowerVolume), spawn "/usr/bin/amixer set Master 2dB-")
        , ((0, xF86XK_AudioRaiseVolume), spawn "/usr/bin/amixer set Master 2dB+")
        , ((0, xF86XK_AudioMute), spawn "/usr/bin/amixer set Master toggle")
        , ((controlMask, xK_Print), spawn "sleep 0.2; /usr/bin/scrot -s")
        , ((0, xK_Print), spawn "/usr/bin/scrot")
        ]
