/*----------------------------------------------------------------------
  IME 制御用 Functuion集 (組込用)
   動作確認環境  2005/05/20
     WinXP SP1a (98系でもいけると思う)
     AutoHotkey   : ver.1.0.33.1～

   組込元で #Include IME.ahkして各関数を呼び出して使用して下さい。

    IME ON/OFF 取得 / セット
        IME_CHECK(WinTitle)
        IME_ON(WinTitle)
        IME_OFF(WinTitle)
        IME_TOGGLE(WinTitle)

    IME 入力モード取得 / セット
        IME_GetConvMode(WinTitle)
        IME_SetConvMode(WinTitle,ConvMode)

    IME 変換モード取得 / セット
        IME_GetSentenceMode(WinTitle)
        IME_SetSentenceMode(WinTitle,SentenceMode)

    SendMessageでWM_IME_CONTROL制御
        Send_ImeControl(DefaultIMEWnd, wParam, lParam)

        ImmGetDefaultIMEWnd(hWnd)
            指定WindowのDef IMEハンドルを返す

 ※ 入力モードはON時にリセットされるIMEもあるみたい？
    その場合は先にONしてから取得/セットするなどで対策して下さい。
---------------------------------------------------------------------
*/
;----------------------------
; IMEの状態の取得 / セット
;  0:IME OFF 1:ON
IME_CHECK(WinTitle)
{   ; IMC_GETOPENSTATUS
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x005,"")
}
IME_ON(WinTitle)
{   ; IMC_SETOPENSTATUS
    WinGet,hWnd,ID,%WinTitle%
    Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x006,1)
}
IME_OFF(WinTitle)
{   ; IMC_SETOPENSTATUS
    WinGet,hWnd,ID,%WinTitle%
    Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x006,0)
}
IME_TOGGLE(WinTitle)
{
    if (IME_CHECK(WinTitle) )
            IME_OFF(WinTitle)
    else    IME_ON(WinTitle)
}

;---------------------------------------------
; IME 入力モード 取得 / セット
;
;    0000xxxx    かな入力
;    0001xxxx    ローマ字入力
;    xxxx0xxx    半角
;    xxxx1xxx    全角
;    xxxxx000    英数
;    xxxxx001    ひらがな
;    xxxxx011    ｶﾅ/カナ
;
;     0 (0x00  0000 0000) かな    半英数
;     3 (0x03  0000 0011)         半ｶﾅ
;     8 (0x08  0000 1000)         全英数
;     9 (0x09  0000 1001)         ひらがな
;    11 (0x0B  0000 1011)         全カタカナ
;    16 (0x10  0001 0000) ローマ字半英数
;    19 (0x13  0001 0011)         半ｶﾅ
;    24 (0x18  0001 1000)         全英数
;    25 (0x19  0001 1001)         ひらがな
;    27 (0x1B  0001 1011)         全カタカナ

IME_GetConvMode(WinTitle)
{   ; IMC_GETCONVERSIONMODE
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x001,"")
}

IME_SetConvMode(WinTitle,ConvMode)
{   ; IMC_SETCONVERSIONMODE
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x002,ConvMode)
}

;---------------------------------------------
; IME 変換モード
;    0:無変換
;    1:人名/地名
;    8:一般
;   16:話し言葉優先

IME_GetSentenceMode(WinTitle)
{   ; IMC_GETSENTENCEMODE
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x003,"")
}

IME_SetSentenceMode(WinTitle,SentenceMode)
{   ; IMC_SETSENTENCEMODE
    WinGet,hWnd,ID,%WinTitle%
    Return Send_ImeControl(ImmGetDefaultIMEWnd(hWnd),0x004,SentenceMode)
}

;---------------------------------------------------------------
;
Send_ImeControl(DefaultIMEWnd, wParam, lParam)
{ ;SendMessage WM_IME_CONTROL
    DetectSave := A_DetectHiddenWindows
    DetectHiddenWindows,ON
    SendMessage 0x283, wParam,lParam,,ahk_id %DefaultIMEWnd%
    if (DetectSave <> A_DetectHiddenWindows)
        DetectHiddenWindows,%DetectSave%
    return ErrorLevel
}
ImmGetDefaultIMEWnd(hWnd)
{ ;IMEクラスのデフォルトウィンドウのハンドル取得
    return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}
