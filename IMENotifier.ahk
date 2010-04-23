;
; ‰æ–Ê’†‰›‚ÅIME‚Ì’Ê’m‚ğ‚¨‚±‚È‚¤
;
; 2010/04/19 opa
;

#Persistent
#NoEnv
#SingleInstance Force
#HotkeyInterval 1000
#MaxHotkeysPerInterval 64
#InstallKeybdHook

#Include %A_ScriptDir%
#Include IME_Func.ahk

Auto-Execute:
	SetWorkingDir, %A_ScriptDir%
	Menu, Tray, Icon, , , 1
	OnExit, Exit-Execute
	SetTimer, IMENotifyTimerHandler, 110
	exit

Exit-Execute:
	SetTimer, IMENotifyTimerHandler, Off
	ExitApp

CriticalSection(op) ; 1:Start -1:End
{
	static cnt = 0

	Critical
	if(op == 1){
		++cnt
	}else if(op == -1){
		if(cnt > 0){
			--cnt
		}
		if(cnt <= 0){
			Critical, Off
		}
	}
}

; ’Ê’m‚ğ‚¨‚±‚È‚¤
Notify(title = "", msg = "Notify", fgcolor = "000000", bgcolor = "aaaaaa")
{
	CriticalSection(1)
	SetTimer, RemoveNotify, 1000
	GUI, Destroy
	GUI, +AlwaysOnTop +Disabled -Theme +ToolWindow -Caption +0x00040000 +LastFound
	GUI, Color, %bgcolor%
	GUI, Font, S18 C%fgcolor%
	GUI, Font, , ‚l‚r ‚oƒSƒVƒbƒN
	GUI, Font, , ‚l‚r ‚oƒSƒVƒbƒN ct
	GUI, Font, , MeiryoKe_PGothic
	GUI, Add, Text, X22 Y13, %msg%
	GuiControlGet, Text, Pos, %msg%
	WinGetPos, , , WinW, WinH
	WinSet, Transparent, 160
	WinSet, Region, % "R20-20 W" . TextW+45 . " H" . TextH+27 . " " . WinW/2 . "-" . WinH/2
	GUI, Show, Center AutoSize NA
	CriticalSection(-1)
}

; ’Ê’m‚ğÁ‚·
RemoveNotify:
	SetTimer, RemoveNotify, Off
	GUI, Destroy
	return

NotifyIME()
{
	static IMEstate := 0

	CriticalSection(1)

	IMEstateA := IME_CHECK("A")
	if(IMEstateA != "FAIL"){
		IMEstateA := (IMEstateA == 0) ? 0 : 1
		if(IMEstate != IMEstateA){
			IMEstate := IMEstateA
			if(IMEstate == 1){
				IMEmode := IME_GetConvMode("A") & 0xf
				if(IMEmode == 0x0){
					NotifyStr := "ABC"
				}else if(IMEmode == 0x3){
					NotifyStr := "¶À¶Å"
				}else if(IMEmode == 0x8){
					NotifyStr := "‰p”"
				}else if(IMEmode == 0x9){
					NotifyStr := "‚Ğ‚ç‚ª‚È"
				}else if(IMEmode == 0xb){
					NotifyStr := "ƒJƒ^ƒJƒi"
				}else{
					NotifyStr := "IME ON"
				}
				Notify("IME", NotifyStr, "8fefbf", "298959")
			}else{
				Notify("IME", "IME OFF", "ffffff", "999999")
			}
		}
	}

	CriticalSection(-1)
}

; IME‚Ìó‘Ô•ÏX‚ğƒ^ƒCƒ}‚ÅŠÄ‹
IMENotifyTimerHandler:
	NotifyIME()
	return

; [”¼Šp/‘SŠp]
~$*SC029::
	Sleep, 15
	NotifyIME()
	return
; [•ÏŠ·]
~$*SC079::
	Sleep, 15
	NotifyIME()
	return
; [–³•ÏŠ·]
~$*SC07B::
	Sleep, 15
	NotifyIME()
	return
; [‚Ğ‚ç‚ª‚È]
~$*SC070::
	Sleep, 15
	NotifyIME()
	return
;; [Alt] ¦ ƒŠƒ‚[ƒg‘€ì‚Éxá‚ªo‚é‚½‚ßƒRƒƒ“ƒgƒAƒEƒg
;~$*Alt Up::
;	Sleep, 15
;	NotifyIME()
;	return

