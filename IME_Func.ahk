/*----------------------------------------------------------------------
  IME ����p Functuion�W (�g���p)
   ����m�F��  2005/05/20
     WinXP SP1a (98�n�ł�������Ǝv��)
     AutoHotkey   : ver.1.0.33.1�`

   �g������ #Include IME.ahk���Ċe�֐����Ăяo���Ďg�p���ĉ������B

    IME ON/OFF �擾 / �Z�b�g
        IME_CHECK(WinTitle)
        IME_ON(WinTitle)
        IME_OFF(WinTitle)
        IME_TOGGLE(WinTitle)

    IME ���̓��[�h�擾 / �Z�b�g
        IME_GetConvMode(WinTitle)
        IME_SetConvMode(WinTitle,ConvMode)

    IME �ϊ����[�h�擾 / �Z�b�g
        IME_GetSentenceMode(WinTitle)
        IME_SetSentenceMode(WinTitle,SentenceMode)

    SendMessage��WM_IME_CONTROL����
        Send_ImeControl(DefaultIMEWnd, wParam, lParam)

        ImmGetDefaultIMEWnd(hWnd)
            �w��Window��Def IME�n���h����Ԃ�

 �� ���̓��[�h��ON���Ƀ��Z�b�g�����IME������݂����H
    ���̏ꍇ�͐��ON���Ă���擾/�Z�b�g����Ȃǂő΍􂵂ĉ������B
---------------------------------------------------------------------
*/
;----------------------------
; IME�̏�Ԃ̎擾 / �Z�b�g
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
; IME ���̓��[�h �擾 / �Z�b�g
;
;    0000xxxx    ���ȓ���
;    0001xxxx    ���[�}������
;    xxxx0xxx    ���p
;    xxxx1xxx    �S�p
;    xxxxx000    �p��
;    xxxxx001    �Ђ炪��
;    xxxxx011    ��/�J�i
;
;     0 (0x00  0000 0000) ����    ���p��
;     3 (0x03  0000 0011)         ����
;     8 (0x08  0000 1000)         �S�p��
;     9 (0x09  0000 1001)         �Ђ炪��
;    11 (0x0B  0000 1011)         �S�J�^�J�i
;    16 (0x10  0001 0000) ���[�}�����p��
;    19 (0x13  0001 0011)         ����
;    24 (0x18  0001 1000)         �S�p��
;    25 (0x19  0001 1001)         �Ђ炪��
;    27 (0x1B  0001 1011)         �S�J�^�J�i

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
; IME �ϊ����[�h
;    0:���ϊ�
;    1:�l��/�n��
;    8:���
;   16:�b�����t�D��

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
{ ;IME�N���X�̃f�t�H���g�E�B���h�E�̃n���h���擾
    return DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hWnd, Uint)
}
