# class ToolTip
Класс ToolTip используется для создания ToolTip'ов и TrayTip'ов с возможностью выбора шрифта (и его размера и стиля), а также цвета фона и текста.  
  
### Пример использования:  
Код:  
```ahk
myToolTip := new ToolTip({ title: "Title"
                         , text: "I'm the colored TrayTip!"
                         , icon: 1  ; icon Info
                         , TrayTip: true
                         , FontName: "Comic Sans MS"
                         , FontSize: 20
                         , TextColor: "Navy"
                         , BackColor: 0xFFA500 })
                         
#Include %A_ScriptDir%\ToolTip.ahk
```
Результат:  
![TrayTip](http://i.imgur.com/6JWVAUm.jpg)
  
Также примеры использования приводятся в файлах [example1.ahk](https://github.com/jollycoder/AutoHotkey/blob/ToolTip-%D1%81%D0%BE-%D1%81%D0%B2%D0%BE%D0%B8%D0%BC-%D1%88%D1%80%D0%B8%D1%84%D1%82%D0%BE%D0%BC-%D0%B8-%D1%86%D0%B2%D0%B5%D1%82%D0%BE%D0%BC/example1.ahk) и [example2.ahk](https://github.com/jollycoder/AutoHotkey/blob/ToolTip-%D1%81%D0%BE-%D1%81%D0%B2%D0%BE%D0%B8%D0%BC-%D1%88%D1%80%D0%B8%D1%84%D1%82%D0%BE%D0%BC-%D0%B8-%D1%86%D0%B2%D0%B5%D1%82%D0%BE%D0%BC/example2.ahk). Для их запуска необходимо файл [ToolTip.ahk](https://github.com/jollycoder/AutoHotkey/blob/ToolTip-%D1%81%D0%BE-%D1%81%D0%B2%D0%BE%D0%B8%D0%BC-%D1%88%D1%80%D0%B8%D1%84%D1%82%D0%BE%D0%BC-%D0%B8-%D1%86%D0%B2%D0%B5%D1%82%D0%BE%D0%BC/ToolTip.ahk) положить в папку скрипта, либо удалить из примеров строку
```ahk
#Include %A_ScriptDir%\ToolTip.ahk
```
и дописать [класс](https://raw.githubusercontent.com/jollycoder/AutoHotkey/ToolTip-%D1%81%D0%BE-%D1%81%D0%B2%D0%BE%D0%B8%D0%BC-%D1%88%D1%80%D0%B8%D1%84%D1%82%D0%BE%D0%BC-%D0%B8-%D1%86%D0%B2%D0%B5%D1%82%D0%BE%D0%BC/ToolTip.ahk) непосредственно в код примера.
### Описание
При создании экземпляра объекта в конструктор передаётся ассоциативный массив с опциями.
Возможные ключи и их псевдонимы:

* *title*  
* *text*  
* *icon* (возможные значения: 1 — Info, 2 — Warning; 3 — Error; n > 3 — предполагается hIcon)  
* *CloseButton* (или *close*) — true или false  
* *transparent* (или *trans*) — true или false, указывает, будет ли ToolTip прозрачен для кликов мыши  
* *ShowNow* (или *now*) — true или false, показывать или не показывать ToolTip при создании экземпляра объекта. Если параметр не указан, ToolTip будет показан сразу же.  
* *x, y* — координаты, если не указаны, ToolTip появится вблизи курсора  
* *BalloonTip* (или *balloon*, или *ball*) — true или false, BalloonTip — это ToolTip с хвостиком  
* *TrayTip* (или *tray*) — будет показан BalloonTip у иконки скрипта в трее, параметры *x, y*, и *BalloonTip* игнорируются. Если указан ключ *TrayTip*, удалить экземпляр объекта можно либо методом *Destroy()*, либо указав *TimeOut* с отрицателным значением. Если нет, тогда можно просто прировнять ссылку на объект пустому значению.  
* *FontName* (или *font*)  
* *FontSize* (или *size*)  
* *FontStyle* (или *style*) — bold, italic, underline, strikeout в любом сочетании через пробел  
* *TimeOut* (или *time*) — время в милисекундах, через которое ToolTip будет скрыт, если число положительное, либо уничтожен, если отрицательное.  
* *BackColor* (или *back*) — цвет фона  
* *TextColor* (или *color*) — цвет текста  
  
Для указания цвета можно использовать литеральные названия, перечисленные [здесь](https://autohotkey.com/docs/commands/Progress.htm#colors).
В этом случае название должно быть в кавычках.
  
Ключи можно задавать в любом порядке и в любой комбинации, как показано в примерах использования.
Если указан ключ TrayTip, удалить экземпляр объекта можно только методом Destroy(),
если нет, тогда можно просто прировнять ссылку на объект пустому значению.  
  
#### Публичные методы объекта:

*  *Show(x, y, timeout)* — показ ранее скрытого ToolTip'а, указание координат и время показа  
x и y — координаты, если пустые значения — ToolTip будет показан возле курсора  
timeout — время в милисекундах, через которое ToolTip будет скрыт, если число положительное, либо уничтожен, если отрицательное
* *Hide()* — скрытие ToolTip
* *SetText(text)* — изменение текста
* *SetTitle(icon, title)* — изменение иконки и заголовка
* *Destroy()* — уничтожение экземпляра объекта
