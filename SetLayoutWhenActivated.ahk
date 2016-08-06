WinLangArray := [ {title: "Безымянный — Блокнот", lang: "ru"}
                , {title: "ahk_class WordPadClass", lang: "en"}  ]
                
handler := Func("ChangeLayoutWhenActive").Bind(WinLangArray)

DllCall("RegisterShellHookWindow", Ptr, A_ScriptHwnd)
OnMessage(DllCall("RegisterWindowMessage", Str, "SHELLHOOK"), Func("ShellProc").Bind(handler))
OnExit("Exit")
Return

ChangeLayoutWhenActive(winData)  {
   static WM_INPUTLANGCHANGEREQUEST := 0x50, langCodes := {en: 0x409, ru: 0x419}
   
   for k, v in winData  {
      if WinActive(v.title)  {
         ControlGetFocus, CtrlFocus, A
         PostMessage, WM_INPUTLANGCHANGEREQUEST,, langCodes[v.lang], %CtrlFocus%, A
         break
      }
   }
}

ShellProc(handler, nCode)  {
   if ( nCode = (HSHELL_WINDOWACTIVATED := 4) )
      SetTimer, % handler, -10
}

Exit() {
   DllCall("DeregisterShellHookWindow", Ptr, A_ScriptHwnd)
}
