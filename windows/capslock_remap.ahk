; Capslock Remapping Script for Windows AutoHotkey
;
; (downloaded from svenlr/swift-map, modified by arensonzz to suit Turkish-Q layout)
; 
; NOTE: Save this file with ISO-8859-9 Turkish encoding, otherwise Turkish characters will
; cause AHK to throw error.
;
; Functionality:
; - Deactivates capslock for normal (accidental) use.
; - Hold Capslock and drag anywhere in a window to move it (not just the title bar).
; - Access the following functions when pressing Capslock: 
;     Cursor keys           - h j k l
;     PgDn, Home, End, PgUp - u ý o p (upper row of h j k l)
;     { [ ] } \ - can be accessed by CapsLock instead of AltGr
;  
; To use capslock as you normally would, you can press AltGr + Capslock

; This script is mostly assembled from modified versions of the following awesome scripts:
;
; # Home Row Computing by Gustavo Duarte: http://duartes.org/gustavo/blog/post/home-row-computing for 
; # Get the Linux Alt+Window Drag Functionality in Windows: http://www.howtogeek.com/howto/windows-vista/get-the-linux-altwindow-drag-functionality-in-windows/

#Persistent
SetCapsLockState, AlwaysOff

; Capslock + hjkl (left, down, up, right)

Capslock & h::Send {Blind}{Left DownTemp}
Capslock & h up::Send {Blind}{Left Up}

Capslock & j::Send {Blind}{Down DownTemp}
Capslock & j up::Send {Blind}{Down Up}

Capslock & k::Send {Blind}{Up DownTemp}
Capslock & k up::Send {Blind}{Up Up}

Capslock & l::Send {Blind}{Right DownTemp}
Capslock & l up::Send {Blind}{Right Up}


; Capslock + uýop (pgdn, home, end, pgup)

Capslock & u::SendInput {Blind}{PgDn Down}
Capslock & u up::SendInput {Blind}{PgDn Up}

Capslock & ý::SendInput {Blind}{Home Down}
Capslock & ý up::SendInput {Blind}{Home Up}

Capslock & o::SendInput {Blind}{End Down}
Capslock & o up::SendInput {Blind}{End Up}

Capslock & p::SendInput {Blind}{PgUp Down}
Capslock & p up::SendInput {Blind}{PgUp Up}


; CapsLock + {[]}\

CapsLock & 7::SendInput {Blind}{{ Down}
CapsLock & 7 up::SendInput {Blind}{{ Up} 

CapsLock & 8::SendInput {Blind}{[ Down}
CapsLock & 8 up::SendInput {Blind}{[ Up}

CapsLock & 9::SendInput {Blind}{] Down}
CapsLock & 9 up::SendInput {Blind}{] Up} 

CapsLock & 0::SendInput {Blind}{} Down}
CapsLock & 0 up::SendInput {Blind}{} Up} 

CapsLock & *::SendInput {Blind}{\ Down}
CapsLock & * up::SendInput {Blind}{\ Up} 


; CapsLock + öçe (<, >, ~)
CapsLock & ö::SendInput {Blind}{< Down}
CapsLock & ö up::SendInput {Blind}{< Up} 

CapsLock & ç::SendInput {Blind}{> Down}
CapsLock & ç up::SendInput {Blind}{> Up} 

CapsLock & e::SendInput {Blind}{Ctrl Down}{Alt Down}{ü}
CapsLock & e up::SendInput {Blind}{Ctrl Up}{Alt Up}{Space}


; Capslock + r (press esc)
Capslock & r::SendInput {Blind}{Esc Down}

; Make Alt Gr + Capslock work like Capslock
<^>!Capslock::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else 
    SetCapsLockState, AlwaysOn
Return


; Drag windows anywhere
;
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm
; by The How-To Geek
; http://www.howtogeek.com 

Capslock & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin% 
if EWD_WinState = 0  ; Only if the window isn't maximized 
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return