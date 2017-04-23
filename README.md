# class ToolTip
Представляю класс ToolTip, который можно использовать для создания ToolTip'ов и TrayTip'ов с возможностью выбора шрифта (и его размера и стиля), а также цвета фона и текста.  
  
### Пример использования:  
Код:  
```ahk
#Persistent
myToolTip := new ToolTip({ title: "Title"
                         , text: "I'm the colored TrayTip!"
                         , icon: 1  ; icon Info
                         , TrayTip: true
                         , FontName: "Comic Sans MS"
                         , FontSize: 20
                         , TextColor: "Navy"
                         , BackColor: 0xFFA500 })
```
Результат:  
![TrayTip](http://i.imgur.com/SMhcrkd.jpg)
