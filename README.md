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
  
Также примеры использования приводятся в файлах example1.ahk и example2.ahk. Для их запуска необходимо файл ToolTip.ahk положить в папку скрипта, либо удалить из примеров строку <span style="color:blue">#Include %A_ScriptDir%\ToolTip.ahk</span> и дописать класс непосредственно в код примера.
- ![#f03c15](https://placehold.it/15/f03c15/000000?text=+) `#f03c15`
- ![#c5f015](https://placehold.it/15/c5f015/000000?text=+) `#c5f015`
- ![#1589F0](https://placehold.it/15/1589F0/000000?text=+) `#1589F0`
