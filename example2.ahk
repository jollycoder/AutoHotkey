myTrayTip := new ToolTip({ text: "Модифицированный TrayTip"
                         , title: "Стандартная иконка «Info»"
                         , CloseButton: true
                         , Icon: 1              ; 1 — Info, 2 — Warning, 3 — Error, n > 3 — предполагается hIcon
                         , TrayTip: true
                         , ShowNow: false       ; изначально показан не будет
                         , FontSize: 16
                         , FontName: "Verdana" })

myToolTip := new ToolTip({ text: "Это модифицированный ToolTip.`nОн прозрачен для кликов мыши."
                         , title: "Кастомная иконка"
                         , Timeout: 2500
                         , Icon: hIcon := CreateIconFromBase64(GetIcon(), 32)
                         , transparent: true    ; если true — окно прозрачно для мыши
                         , BalloonTip: true
                         , FontSize: 22
                         , FontName: "Times New Roman"
                         , FontStyle: "italic" })
                         
ColoredTip:= new ToolTip({ text: "Я цветной ToolTip!`nЯ исчезну через 7 сек"
                         , x: A_ScreenWidth
                         , y: 0
                         , BalloonTip: true
                         , TextColor: "Navy"
                         , BackColor: 0xFFA500
                         , FontName: "Comic Sans MS"
                         , FontSize: 20
                         , Timeout: -7000 })  ; будет автоматически удалён через 7000 мс
                         
oTimer := Func("Timer").Bind(ColoredTip)
SetTimer, % oTimer, 1000  ; этот таймер только для изменения текста
Sleep, 1000
myTrayTip.Show()  ; показываем изначально скрытый TrayTip, созданный с параметром ShowNow: false
Sleep, 1500
myToolTip.SetText("Можно менять`nтекст и расположение")  ; меняем текст
Sleep, 500

myToolTip.Show(50, 50, 2000)  ; показываем в координатах x = 50, y = 50 на две секунды
Sleep, 2000

myToolTip.SetText("I'm near the mouse cursor!")
Sleep, 500

myToolTip.Show("", "", -2500)  ; без координат — в районе курсора, таймаут отрицательный, значит объект через 
                               ; две с половиной секунды удалится без возможности дальнейшего использования
Sleep, 2500

myTrayTip.SetTItle(2, "Изменённый заголовок")  ; меняем иконку и заголовок
myTrayTip.SetText("Goodbye!")
Sleep, 1000
myTrayTip.Destroy()
Sleep, 1000
ExitApp

Timer(oTip)  {
   static i := 0
   oTip.SetText("Я цветной ToolTip!`r`nЯ исчезну через " (7 - ++i) " сек")
   if (i = 7)
      SetTimer,, Delete
}

CreateIconFromBase64(StringBASE64, Size)
{
   StringBase64ToData(StringBASE64, IconData)
   Return DllCall("CreateIconFromResourceEx", Ptr, &IconData + 4
      , UInt, NumGet(&IconData, "UInt"), UInt, true, UInt, 0x30000, Int, Size, Int, Size, UInt, 0)
}
   
StringBase64ToData(StringBase64, ByRef OutData)
{
   DllCall("Crypt32.dll\CryptStringToBinary", Ptr, &StringBase64 
      , UInt, StrLen(StringBase64), UInt, CRYPT_STRING_BASE64 := 1, UInt, 0, UIntP, Bytes, UIntP, 0, UIntP, 0)

   VarSetCapacity(OutData, Bytes) 
   DllCall("Crypt32.dll\CryptStringToBinary", Ptr, &StringBase64 
      , UInt, StrLen(StringBase64), UInt, CRYPT_STRING_BASE64, Str, OutData, UIntP, Bytes, UIntP, 0, UIntP, 0)
   Return Bytes
}

GetIcon()  {
   Icon32 = 
   (RTrim Join
      qBAAACgAAAAgAAAAQAAAAAEAIAAAAAAAgBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      FRgjABMXIQATFyEAFBchABMXIQAVGCMAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAABUYIwAAAAAAAAAAAAAAAAIAAAAAAAAAABUYIwAVGCMAExchABMXIRQUFyETExchABUYIwAVGCMAAAAAAAAAAAAAAAACAAAAAAAAAAAVGCMAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFRgjABQXIgAUFyIAFBciABMXIQATFyEAFRgjABUYIwIUFyIAFBciqxQXIqoUFyIAFRgjAhUYIwAUFyIA
      FBgiABQXIgATFyIAExciABUYIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVGCMAFBciABQXIhAUFiFCExgiABMWIQAAAAAA
      FRgjAxUYIwAVFiO4ExghuBUYIwAVGCMDAAAAABQXIgATGiIAExchQhMYIhATGCIAFRgjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAABUYIwEUFyIAFBchMhQXIv8TFyFDFBciABUXIwIVGCMCFRgjABUXI7sUGCK7FRgjABUYIwIUFyMCFBciABQXIkMUFyL/FBchMhQXIgAVGCMBAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFRgjABUXIgEVFyIAFBciuRQXItoVGSICFRgiARUYIwMUFyIBFBcinRMXIp0UFyIBFRgjAxUYIgEVGCIC
      FBci2hQXIroVFyIAFRciARUYIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFRgjAAAAAAAAAAAAAAAAAgAAAAEVGCMAFBgjARQXIgAUFyIkFBci/xQXImEUFyIC
      FRgjAAwOHwD/AAAA/wAAAAoRHQAVGCMAFBciAhQXImAUFyL/FBYiJRQXIgAUGCMBFBgiAAAAAAEAAAACAAAAAAAAAAAVGCMAAAAAAAAAAAAVGCMAFBUiABMVIgAUFyIA
      ExciABQXIgIUFyMAFRciABQXIgAUFiFRFBciKRUYJAAVHSoAFR8sIxMSGj0TEhs+FRsoJxUcKQEUGCQAFBcjKBMWIlEUFyIAFBciABQYIgAUFyICFBYiABQXIgASFyAA
      EhggABUYIwAAAAAAAAAAABUYIwATFSIAFBUiBRQXIl0TFyEWFBciABUXIwAUFyIAFRgjAxQXIgAVGiYAExUfcBILEtETERr8FRsn/xUbJ/8TEhv/EgsS1hMVH3QWHCYA
      FRgiABUYIwIUFyIAFBgiABQXIgAUFiEVFBchXBMWIAUSGCAAFRgjAAAAAAAAAAAAFRgjABQXIgAUFyMRExci7xQXIvcUFyJkFBciAxQYIgEUFyEAFBolKBMOFcwUGSX/
      Hlh5/yWLvf8pntn9KZ/Z/SaMv/8eW33/FBsn/xMOFc0UGiYlFBchABQXIwEUFyICFBciYxQXIvYUFyLvFBkiEBQYIgAVGCMAAAAAAAAAAAAVGCMAFRgiABQYIgAUFyES
      FBcilRQXIv8UFyGKFBYgABQdKyQTDxflGTdO/ymh2fouxP/8LsD//i28//4tvP/+LsD//i7E//0potz6GThP/xMPGOIVHiwfFBYhABQXIosUFyL/FBcilhQXIhMVGCMA
      FRgjABUYIwAAAAAAAAAAABUYIwAVGCMAFRgiABUXIwAUFyIAFBciMxQZJDATGSQDExAZxRg0Sf8stvX6Lb3//yuy8/4stPX+LLX2/yy19v8stPb+LLLz/i29//8stvT5
      GDJG/xMRGr4UFyIBFBgjMhQXIjQUFyIAFRgjABUWIwAVGCMAFRgjAAAAAAAAAAAAAAAAABUYIwAVGCMAFRciABQXIgEVGCMAFBEaABQYJFMUFyL/KJvV+y6///4rsvT+
      Lbb4/yy19/8stff/LLX3/yy19/8ttvj/K7L0/i6///4ol8/7FBUf/xQaJkwUEhwAFRgjABQXIgEUGCMAFRgjABUYIwAAAAAAAAAAABUYIwAUGyMAAAAAAhUYIwMVGCMD
      FhgjAxQYIwQMAAAAEggOsxtIZP0uwv/7LLL0/yy2+P8stff/Lbb4/y22+P8ttvj/Lbb4/yy19/8stvj/LLP1/y7C//sbRF/9EggOrgwAAAAUFyIEFRgkAxUYIwMVGCMD
      AAAAAhYYJQAVGCMAFRgjABUcIwAVFyIAFRgjABUYIwAUFyIAFBciABMwQwsSCxLkI3ek/i7B/vwrs/T+Lbb4/y22+P8ttvj/Lbb4/y22+P8ttvj/Lbb4/y22+P8rs/T+
      LsH+/CN1ov4SCxLjDyk4ChMYIQAUFyIAFRgjABUYIwAUGCIAFxgmABUYIwAVGCMBFBoiABQXIoYUGCK/FBgiuxQXIrcTFyEYFyY3FRMRGvcmjcH/Lb7+/Sy09f8stff/
      Lbb4/y22+P8ttvj/Lbb4/y22+P8ttvj/LLX3/yy09f8tvv79Joq+/xMQGfkYKTkYFBchGBQXIrcUGCK7FBcivxQXIoUVFyQAFRgjAhUYIwEUGSMAFBYihxQXIr8VFyO8
      FBYitxQVIRgXKDkUExEa9yaNwf8tvv79LLT1/yy19/8ttvj/Lbb4/y22+P8ttvj/Lbb4/y22+P8stff/LLT1/y2+/v0lir3/ExAZ+RgpORgTFiIYFBYiuBUXI7wUFyPA
      FBcihhUXJAAVGCMCFRgjABUdIwAVFyIAFRgjABUYIwAUFyIAFBchAA8sPAkSCxLiI3ej/i7B/vwrs/T+Lbb4/y22+P8ttvj/Lbb4/y22+P8ttvj/Lbb4/y22+P8rs/T+
      LsH+/CN2ov4SCxLjDic1ChMWIgAUFyIAFRgjABUYIwAUGCIAFxgmABUYIwAVGCMAFRsjAAAAAAIVGCMDFRgjAxUYIwMVGCIEDAAAABEIDa8bR2P9LsP/+yyy9P8stvj/
      LLX3/y22+P8ttvj/Lbb4/y22+P8stff/LLb4/yyz9P8uwv/7G0Rf/RIIDq8LAAAAFBcjBBQZIwMVGCMDFRgjAwAAAAIWGCUAFRgjAAAAAAAAAAAAFRgjABUYIwAUGCIA
      FBciARUYIwAUEhsAFBgkTxQWIf8omtT7Lr///iuy9P4ttvj/LLX3/yy19/8stff/LLX3/y22+P8rsvT+LsD//iiWzvsUFR//FBomTRQTHAAVGCMAExgiARQXIgAVGCMA
      FRgjAAAAAAAAAAAAAAAAABUYIwAVGCMAERghABQYIgAUFyEAFBciMxQZIzATFyECExEZwxgzSP8stvX6Lb3//yuy8/4stPb+LLX2/yy19v8stPb+K7Lz/i29//8stPL5
      GDFE/xMRGr8TFyIBExgjMBQXIjITGCMAFRcjABUXIQAVGCMAFRgjAAAAAAAAAAAAFRgjABUYIwAVFyMAFBciExQXIpYUFyL/FBciihQWIAAVHSskEw8X5Rk3Tv8podr6
      LsT//C7A//4tu//+Lbv//i7A//4uxP/9KaDZ+hk1S/8TDxjiFR4rIBQWIQAUFyKLFBci/xQXIpQUFyISFRciABUZIwAVGCMAAAAAAAAAAAAVGCMAFBciABYXIxAUFyLv
      FBci9hQXImQUFyICFRgjARQXIgAUGSUpEw4VzxUaJv8eWXr/Jo2//ymg2/0podv9Jo3A/x5ae/8UGSb/Ew4WzBQaJiUUFyEAFBgiARQXIgMUFyJmFBci9xQXIu4UFyIQ
      FBgiABUYIwAAAAAAAAAAABUYIwAUFSAAExUgBRQXIl0TFyIVFBciABQYIgAUFyIAFRgjAxQYIwAVHCgAFBUfcxILEtMTEhv+FRwo/xUcKf8UEhv/EgsS1hQVH3QVGSgA
      FRciABUYIwIUFyMAFBcjABQXIgATFyEXFBciXhQVIwUUFSEAFRgjAAAAAAAAAAAAFRgjABQVIAAUFR8AFBciABQXIgAUFyICFBciABQYIgAUFyIAExchTxQXIScUGCQA
      FR0pABQcKCUTERo/FBAaQBQbJygVHCkBFRgjABQXISkTFyFPFRciABQXJAAUFyIAFBciAhMXIQAUFyIAFBYjABQVIQAVGCMAAAAAAAAAAAAVGCMAAAAAAAAAAAAAAAAC
      AAAAARUYIwAUFyIBFBciABQXISUUFyL/FBciXxQXIgIVGCMACw4VACEAAAAoAAAABwseABQYIwAUFyICFBciYhQXIv8UFyIjFBciABUXIgEUGCMAAAAAAQAAAAIAAAAA
      AAAAABUYIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFRgjABUYIwEVGCMAFBciuhQXItkWGCICFRgiARUYIwMUFyIBFBcinBQXIpwUFyIBFRgjAxQXIwEVFyQC
      FBci2xQXIrcUGCMAFBgjARUYIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVGCMBFRciABUXIjIUFyL/FBciQxQXIgAUFyMC
      FRgjAxUYIwAVFyO7FBgiuxUYIwAVGCMDFRgiAhQXIgAUFiFFFBci/xQXIjEUFyIAFRgjAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAABUYIwAUFyIAFBciEBQXIkITGCYAFRQiAAAAAAAVGCMDFRgjABUWI7gTGCG4FRgjABUYIwMAAAAAExYgABQVHgATFiFDFBYiEBQWIgAVGCMAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFRgjABQXIgAUFyEAFBciABQXJAAVFSIAFRgjABUYIwIVFyIAFBciqxQXIqoVFyIAFRgjAhUYIwATFiEA
      FBYgABMXIgAUFyIAFBciABUYIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVGCMAAAAAAAAAAAAAAAACAAAAAAAAAAAVGCMA
      FRgjABUWIQAUFyEVFRYiFBUWIQAVGCMAFRgjAAAAAAAAAAAAAAAAAgAAAAAAAAAAFRgjAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVGCMAFRciABQXIgAVFiIAFRYiABUYIwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
      AAAAAAAAAAAAAAAA/////////////n////5///++ff//nnn//8/z///f+//38A/v8eAHj/jAAx//gAH//wAB//8AAP//AAD/wwAAw8MAAMP/AAD//wAA//+AAf//gAH/
      +MADH/HgB4/38A/v///////P8///nnn//759///+f////n////////////8=
   )
   Return Icon32
}

#Include %A_ScriptDir%\ToolTip.ahk
