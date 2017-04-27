myTrayTip := new ToolTip({ title: " Look!"
                         , text: " It's a blue TrayTip! "
                         , FontSize: 18
                         , icon: 2            ; icon Warning
                         , TrayTip: true      ; будет отображаться возле иконки скрипта в трее
                         , Timeout: -4000     ; TrayTip будет удалён через 4 секунды
                         , BackColor: 0x0055aa
                         , TextColor: "white" })
Sleep, 2500
myTrayTip.SetTitle()  ; удаляем иконку и текст заголовка
myTrayTip.SetText("Goodbye!")
Sleep, 2000
ExitApp

#Include %A_ScriptDir%\ToolTip.ahk
