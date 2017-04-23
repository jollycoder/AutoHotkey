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
  
Также примеры использования приводятся в файлах example1.ahk и example2.ahk. Для их запуска необходимо файл ToolTip.ahk положить в папку скрипта, либо удалить из примеров строку
```ahk
#Include %A_ScriptDir%\ToolTip.ahk
```
и дописать класс непосредственно в код примера.
### Описание
При создании экземпляра объекта в конструктор передаётся ассоциативный массив с опциями.
Возможные ключи и их псевдонимы:

title  
text  
icon (1 — Info, 2 — Warning; 3 — Error; n > 3 — предполагается hIcon)
CloseButton (или close) — true или false
