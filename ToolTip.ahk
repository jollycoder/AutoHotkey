class ToolTip  {
/*
Версия: 1.05
Описание и примеры использования (GitHub): https://goo.gl/51pZeA
Автор teadrinker (на GitHub jollycoder), email dfiveg@mail.ru, skype dmitry_fiveg
*/
   __New( options )  {
      this.ShowNow := true
      for k, v in options
         this[k] := v
      this._CreateToolTip()
      ( this.ShowNow && this.Show(this.x, this.y, this.TimeOut) )
   }
   
   __Set(key, value)  {
      static PsevdoKeys := { close: "CloseButton", trans: "transparent", size: "FontSize"
                           , balloon: "BalloonTip", ball: "BalloonTip", tray: "TrayTip"
                           , style: "FontStyle", time: "TimeOut", font: "FontName"
                           , back: "BackColor", color: "TextColor", now: "ShowNow" }
                           
      for k, v in PsevdoKeys
         if (key = k)
            this[v] := value
   }
   
   _CreateToolTip()  {
      static WS_POPUP := 0x80000000, WS_EX_TOPMOST := 8, WS_EX_TRANSPARENT := 0x20
           , TTS_NOPREFIX := 2, TTS_ALWAYSTIP := 1, TTS_BALLOON := 0x40, TTS_CLOSE := 0x80
           , TTF_TRACK := 0x20, TTF_ABSOLUTE := 0x80, szTI := A_PtrSize = 4 ? 48 : 72
     
      VarSetCapacity(TOOLINFO, szTI, 0)
      this.pTI := &TOOLINFO
      NumPut(szTI, TOOLINFO)
      (this.TrayTip && this.BalloonTip := true)
      NumPut(TTF_TRACK|(this.BalloonTip ? 0 : TTF_ABSOLUTE), &TOOLINFO + 4)
      
      this.hwnd := DllCall("CreateWindowEx", UInt, WS_EX_TOPMOST|(this.transparent ? WS_EX_TRANSPARENT : 0)
        , Str, "tooltips_class32", Str, ""
        , UInt, WS_POPUP | TTS_NOPREFIX | TTS_ALWAYSTIP | (this.CloseButton ? TTS_CLOSE : 0) | (this.BalloonTip ? TTS_BALLOON : 0)
        , Int, 0, Int, 0, Int, 0, Int, 0, Ptr, 0, Ptr, 0, Ptr, 0, Ptr, 0)
        
      if (this.FontName || this.FontSize || this.FontStyle)
         this._SetFont()
      
      if (this.TextColor != "" || this.BackColor != "")
         this._SetColor()
      
      this._SetInfo()
   }
   
   _SetFont()  {
      static WM_GETFONT := 0x31, mult := A_IsUnicode ? 2 : 1, szLF := 28 + 32 * mult
           , LOGPIXELSY := 90, ANTIALIASED_QUALITY := 4
           , styles := { bold: {value: 700, offset: 16, size: "Int"}
                       , italic: {value: 1, offset: 20, size: "Char"}
                       , underline: {value: 1, offset: 21, size: "Char"}
                       , strikeout: {value: 1, offset: 22, size: "Char"} }
                       
      hPrevFont := this._SendMessage(WM_GETFONT)
      VarSetCapacity(LOGFONT, szLF, 0)
      DllCall("GetObject", Ptr, hPrevFont, Int, szLF, Ptr, &LOGFONT)
      DllCall("DeleteObject", Ptr, hPrevFont)
      
      if this.FontSize  {
         hDC := DllCall("GetDC", Ptr, this.hwnd, Ptr)
         height := -DllCall("MulDiv", Int, this.FontSize, Int, DllCall("GetDeviceCaps", Ptr, hDC, Int, LOGPIXELSY), Int, 72)
         DllCall("ReleaseDC", Ptr, this.hwnd, Ptr, hDC)
         NumPut(height, LOGFONT, "Int")
      }
      FontStyle := this.FontStyle
      Loop, parse, FontStyle, %A_Space%
         if obj := styles[A_LoopField]
            NumPut(obj.value, &LOGFONT + obj.offset, obj.size)

      (this.FontSize > 24 && NumPut(ANTIALIASED_QUALITY, &LOGFONT + 26, "Char"))
      this.FontName && StrPut(this.FontName, &LOGFONT + 28, StrLen(this.FontName) * mult, A_IsUnicode ? "UTF-16" : "CP0")
      this.hFont := DllCall("CreateFontIndirect", Ptr, &LOGFONT, Ptr)
   }
   
   _SetColor()  {
      static WM_USER := 0x400, TTM_SETTIPBKCOLOR := WM_USER + 19, TTM_SETTIPTEXTCOLOR := WM_USER + 20
      
      VarSetCapacity(empty, 2, 0)
      DllCall("UxTheme\SetWindowTheme", Ptr, this.hwnd, Ptr, 0, Ptr, &empty)   
      ( this.TextColor != "" && this._SendMessage(TTM_SETTIPTEXTCOLOR, this._GetColor(this.TextColor)) )
      ( this.BackColor != "" && this._SendMessage(TTM_SETTIPBKCOLOR, this._GetColor(this.BackColor)) )
   }
   
   _GetColor(color)  {
      static WS_CHILD := 0x40000000, WM_CTLCOLORSTATIC := 0x138
      
      Gui, New, +hwndhGui +%WS_CHILD%
      Gui, Color, % color + 0 = "" ? color : Format("{:x}", color)
      Gui, Add, Text, hwndhText
      hdc := DllCall("GetDC", Ptr, hText, Ptr)
      SendMessage, WM_CTLCOLORSTATIC, hdc, hText,, ahk_id %hGui%
      clr := DllCall("GetBkColor", Ptr, hdc)
      DllCall("ReleaseDC", Ptr, hText, Ptr, hdc)
      Gui, Destroy
      Return clr
   }
   
   _SetInfo()  {
      static WM_USER := 0x400, TTM_SETMAXTIPWIDTH := WM_USER + 24
           , TTM_ADDTOOL := WM_USER + (A_IsUnicode ? 50 : 4), WM_SETFONT := 0x30
      
      this._SendMessage(WM_SETFONT, this.hFont, 1)
      this._SendMessage(TTM_ADDTOOL, 0, this.pTI)
      this.SetTitle(this.icon, this.title)
      this._SendMessage(TTM_SETMAXTIPWIDTH, 0, A_ScreenWidth)
      this.SetText(this.text)
   }
   
   SetText(text)  {
      static WM_USER := 0x400, TTM_UPDATETIPTEXT := WM_USER + (A_IsUnicode ? 57 : 12)
      NumPut(&text, this.pTI + (A_PtrSize = 4 ? 36 : 48))
      this._SendMessage(TTM_UPDATETIPTEXT, 0, this.pTI)
   }
   
   SetTitle(icon := "", title := "")  {
      static WM_USER := 0x400, TTM_SETTITLE := WM_USER + (A_IsUnicode ? 33 : 32), TTM_UPDATE := WM_USER + 29
      
      ((icon || this.CloseButton) && title = "") && title := " "
      this._SendMessage(TTM_SETTITLE, icon, &title)
      (icon > 3 && DllCall("DestroyIcon", Ptr, icon))
      this._SendMessage(TTM_UPDATE)
   }
   
   Show(x := "", y := "", timeout := "")  {
      static WM_USER := 0x400, TTM_TRACKACTIVATE := WM_USER + 17, TTM_TRACKPOSITION := WM_USER + 18
      
      if (x = "TrayTimer")
         Critical
      
      if this.TrayTip  {
         this._GetTrayIconCoords(xTT, yTT)
         if !this.SetTrayTimer  {
            this.TrayTimer := timer := ObjBindMethod(this, "Show", "TrayTimer")
            SetTimer, % timer, 1000
            this.SetTrayTimer := true
         }
         else  {
            this._CheckPosAboveTaskBar()
            if (this.xTT = xTT && this.yTT = yTT)
               Return
            else
               this.xTT := xTT, this.yTT := yTT
         }
      }
      else  {
         xTT := x, yTT := y
      
         if (xTT = "" || yTT = "") {
            CoordMode, Mouse
            MouseGetPos, xm, ym
            (xTT = "" && xTT := xm + 10)
            (yTT = "" && yTT := ym + 10)
         }
      }
      this._SendMessage(TTM_TRACKPOSITION, 0, xTT|(yTT<<16))
      this._SendMessage(TTM_TRACKACTIVATE, 1, this.pTI)
      
      if this.BalloonTip
         xMax := A_ScreenWidth, yMax := A_ScreenHeight
      else  {
         WinGetPos,,, W, H, % "ahk_id" this.hwnd
         xMax := A_ScreenWidth - W - 10
         yMax := A_ScreenHeight - H - 10
      }
      
      if (xTT > xMax || yTT > yMax)  {
         (xTT > xMax && xTT := xMax)
         (yTT > yMax && yTT := yMax)
         this._SendMessage(TTM_TRACKPOSITION, 0, xTT|(yTT<<16))
      }

      if timeout  {
         timer := this.timer
         try SetTimer, % timer, Delete
         this.timer := timer := ObjBindMethod(this, timeout > 0 ? "Hide" : "Destroy")
         SetTimer % timer, % "-" . Abs(timeout)
      }
   }
   
   Hide()  {
      static WM_USER := 0x400, TTM_TRACKACTIVATE := WM_USER + 17
      this._SendMessage(TTM_TRACKACTIVATE, 0, this.pTI)
      if this.SetTrayTimer  {
         this.SetTrayTimer := false
         timer := this.TrayTimer
         SetTimer, % timer, Delete
      }
   }
   
   Destroy()  {
      this.__Delete()
      this.SetCapacity(0)
      this.base := ""
   }
   
   _CheckPosAboveTaskBar()  {
      static GW_HWNDNEXT := 2, SWP_NOSIZE := 1, SWP_NOMOVE := 2
      
      hTaskBar := WinExist("ahk_class Shell_TrayWnd")
      Loop
         hWnd := A_Index = 1 ? DllCall("GetTopWindow", Ptr, 0, Ptr) : DllCall("GetWindow", Ptr, hWnd, UInt, GW_HWNDNEXT, Ptr)
      until (hWnd = hTaskBar && TaskBarAbove := true) || hWnd = this.hwnd
      
      if TaskBarAbove
         DllCall("SetWindowPos", Ptr, this.hwnd, Ptr, 0
                               , Int, 0, Int, 0, Int, 0, Int, 0
                               , UInt, SWP_NOSIZE | SWP_NOMOVE )
   }
   
   _SendMessage(msg, wp := 0, lp := 0)  {
      Return DllCall("SendMessage", Ptr, this.hwnd, UInt, msg, Ptr, wp, Ptr, lp, Ptr)
   }
   
   _GetTrayIconCoords(ByRef x, ByRef y)  {
      static WM_USER := 0x400, TB_BUTTONCOUNT := WM_USER + 24, TB_GETBUTTON := WM_USER + 23, TB_GETITEMRECT := WM_USER + 29
           , PtrSize := A_Is64bitOS ? 8 : 4, szTBBUTTON := 8 + PtrSize*3, szHWND := PtrSize
         
      for k, v in ["TrayNotifyWnd", "SysPager", "ToolbarWindow32"]
         hTray := DllCall("FindWindowEx", Ptr, k = 1 ? WinExist("ahk_class Shell_TrayWnd") : hTray, Ptr, 0, Str, v, UInt, 0, Ptr)
      WinWait, ahk_id %hTray%
      WinGet, PID, PID
      WinGetPos, xTB, yTB
      
      if !IsObject(RemoteBuff := new this.RemoteBuffer(PID, szTBBUTTON))  {
         x := xTB, y := yTB
         MsgBox, % "Не удалось создать удалённый буфер`nОшибка " A_LastError
         Return
      }
      SendMessage, TB_BUTTONCOUNT
      Loop % ErrorLevel  {
         SendMessage, TB_GETBUTTON, A_Index - 1, RemoteBuff.ptr
         pTBBUTTON := RemoteBuff.Read(szTBBUTTON)
         pHWND := RemoteBuff.Read(szHWND, NumGet(pTBBUTTON + 8 + PtrSize) - RemoteBuff.ptr)
         hWnd := NumGet(pHWND + 0, PtrSize = 4 ? "UInt" : "UInt64")
         if (hWnd = A_ScriptHwnd)  {
            SendMessage, TB_GETITEMRECT, A_Index - 1, RemoteBuff.ptr
            pRECT := RemoteBuff.Read(16)
            x := xTB + ( NumGet(pRECT + 0, "Int") + NumGet(pRECT + 8, "Int") )//2
            y := yTB + ( NumGet(pRECT + 4, "Int") + NumGet(pRECT + 12, "Int") )//2 - 5
            break
         }
      }
      RemoteBuff := "", ((x = "" || y = "") && (x := xTB, y := yTB))
   }
   
   __Delete()  {
      (this.hFont && DllCall("DeleteObject", Ptr, this.hFont))
      (this.Icon > 3 && DllCall("DestroyIcon", Ptr, this.Icon))
      DllCall("DestroyWindow", Ptr, this.hwnd)
   }

   class RemoteBuffer
   {
      __New(PID, size)  {
         static PROCESS_VM_OPERATION := 0x8, PROCESS_VM_WRITE := 0x20
              , PROCESS_VM_READ := 0x10, MEM_COMMIT := 0x1000, PAGE_READWRITE := 0x4
            
         if !(this.hProc := DllCall("OpenProcess", UInt, PROCESS_VM_OPERATION|PROCESS_VM_READ|PROCESS_VM_WRITE, Int, 0, UInt, PID, Ptr))
            Return
         
         if !(this.ptr := DllCall("VirtualAllocEx", Ptr, this.hProc, Ptr, 0, Ptr, size, UInt, MEM_COMMIT, UInt, PAGE_READWRITE, Ptr))
            Return, "", DllCall("CloseHandle", Ptr, this.hProc)
         
         this.hHeap := DllCall("GetProcessHeap", Ptr)
      }
      
      __Delete()  {
         DllCall("VirtualFreeEx", Ptr, this.hProc, Ptr, this.ptr, UInt, 0, UInt, MEM_RELEASE := 0x8000)
         DllCall("CloseHandle", Ptr, this.hProc)
         DllCall("HeapFree", Ptr, this.hHeap, UInt, 0, Ptr, this.pHeap)
      }
      
      Read(size, offset = 0)  {
         (this.pHeap && DllCall("HeapFree", Ptr, this.hHeap, UInt, 0, Ptr, this.pHeap))
         this.pHeap := DllCall("HeapAlloc", Ptr, this.hHeap, UInt, HEAP_ZERO_MEMORY := 0x8, Ptr, size, Ptr)
         if !DllCall("ReadProcessMemory", Ptr, this.hProc, Ptr, this.ptr + offset, Ptr, this.pHeap, Ptr, size, Int, 0)
            Return, 0, DllCall("MessageBox", Ptr, 0, Str, "Не удалось прочитать данные`nОшибка " A_LastError, Str, "", UInt, 0)
         Return this.pHeap
      }
      
      Write(pLocalBuff, size, offset = 0)  {
         if !res := DllCall("WriteProcessMemory", Ptr, this.hProc, Ptr, this.ptr + offset, Ptr, pLocalBuff, Ptr, size, PtrP, writtenBytes)
            DllCall("MessageBox", Ptr, 0, Str, "Не удалось записать данные`nОшибка " A_LastError, Str, "", UInt, 0)
         Return writtenBytes
      }
   }
}
