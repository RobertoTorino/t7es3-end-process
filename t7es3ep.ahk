; YouTube: @game_play267
; Twitch: RR_357000
; X:@relliK_2048
; T7ES3 End Process
#SingleInstance force
#Persistent
#NoEnv

SetWorkingDir %A_ScriptDir%

; ─── Set as admin. ────────────────────────────────────────────────────────────────────────────────────────────────────
if not A_IsAdmin
{
    try
    {
        Run *RunAs "%A_ScriptFullPath%"
    }
    catch
    {
        MsgBox, 0, Error, This script needs to be run as Administrator.
    }
    ExitApp
}


; ─── Unique window class name. ────────────────────────────────────────────────────────────────────────────────────────
#WinActivateForce
scriptTitle := "T7ES3 End Process"
if WinExist("ahk_class AutoHotkey ahk_exe " A_ScriptName) && !A_IsCompiled {
    ;Re-run if script is not compiled
    ExitApp
}

;Try to send a message to existing instance
if A_Args[1] = "activate" {
    PostMessage, 0x5555,,,, ahk_class AutoHotkey
    ExitApp
}


; ─── Start GUI. ───────────────────────────────────────────────────────────────────────────────────────────────────────
title := "T7ES3 End Process - " . Chr(169) . " " . A_YYYY . " - Philip"
Gui, Show, w400 h50, %title%
Gui, +LastFound
Gui, Font, s10 bold q5, Arial
Gui, Margin, 15, 15
GuiHwnd := WinExist()

    Gui, Add, Text, w375 h40 +Center, Press Escape to quit TEKKEN 7 (works for all T7 versions).

; ─── System tray. ────────────────────────────────────────────────────────────
Menu, Tray, NoStandard                                  ;Remove default items like "Pause Script"
Menu, Tray, Add, Show GUI, ShowGui                      ;Add a custom "Show GUI" option
Menu, Tray, Add                                         ;Add a separator line
Menu, Tray, Add, About T7ES3EP..., ShowAboutDialog
Menu, Tray, Default, Show GUI                           ;Make "Show GUI" the default double-click action
Menu, Tray, Tip, T7ES3 End Process                      ;Tooltip when hovering

; ─── This return ends all updates to the gui. ─────────────────────────────────────────────────────────────────────────
return
; ─── END GUI. ─────────────────────────────────────────────────────────────────────────────────────────────────────────


; ─── Kill t7es3 process with escape button function. ──────────────────────────────────────────────────────────────────
Esc::
    Process, Exist, TekkenGame-Win64-Shipping.exe
    if (ErrorLevel) {
        CustomTrayTip("ESC pressed. Killing T7ES3 processes.", 2)
        KillAllProcessesEsc()
    } else {
        CustomTrayTip("No T7ES3 processes found.", 1)
    }
return


KillAllProcessesEsc() {
    RunWait, taskkill /im TekkenGame-Win64-Shipping.exe /F,, Hide
    RunWait, taskkill /im powershell.exe /F,, Hide
    ;RunWait, taskkill /im autohotkey.exe /F,, Hide
}


; ─── Custom tray tip function ─────────────────────────────────────────────────────────────────────────────────────────
CustomTrayTip(Text, Icon := 1) {
    ; Parameters:
    ; Text  - Message to display
    ; Icon  - 0=None, 1=Info, 2=Warning, 3=Error (default=1)
    static Title := "T7ES3 End Process"
    ; Validate icon input (clamp to 0-3 range)
    Icon := (Icon >= 0 && Icon <= 3) ? Icon : 1
    ; 16 = No sound (bitwise OR with icon value)
    TrayTip, %Title%, %Text%, , % Icon|16
}


; ─── Show "about" dialog function. ────────────────────────────────────────────────────────────────────
ShowAboutDialog() {
    ; Extract embedded version.dat resource to temp file
    tempFile := A_Temp "\version.dat"
    hRes := DllCall("FindResource", "Ptr", 0, "VERSION_FILE", "Ptr", 10) ;RT_RCDATA = 10
    if (hRes) {
        hData := DllCall("LoadResource", "Ptr", 0, "Ptr", hRes)
        pData := DllCall("LockResource", "Ptr", hData)
        size := DllCall("SizeofResource", "Ptr", 0, "Ptr", hRes)
        if (pData && size) {
            File := FileOpen(tempFile, "w")
            if IsObject(File) {
                File.RawWrite(pData + 0, size)
                File.Close()
            }
        }
    }
    ; Read version string
    FileRead, verContent, %tempFile%
    version := "Unknown"
    if (verContent != "") {
        version := verContent
    }

aboutText := "T7ES3 End Process`n"
           . "Kills all T7ES3 Processes`n"
           . "Version: " . version . "`n"
           . Chr(169) . " " . A_YYYY . " Philip" . "`n"
           . "YouTube: @game_play267" . "`n"
           . "Twitch: RR_357000" . "`n"
           . "X: @relliK_2048" . "`n"
           . "Discord:"

MsgBox, 64, About T7ES3EP, %aboutText%
}

; ─── Show GUI. ────────────────────────────────────────────────────────────────────────────────────────────────────────
ShowGui:
    Gui, Show
    SB_SetText("T7ES3 End Process GUI Shown.", 2)
return

GuiClose:
    ExitApp
return
