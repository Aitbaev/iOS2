# iOS2
Приложение для iOS на objective-c
На первом ViewController TableView на котором 3 группы студентов при нажатии на ячейку группы открывается 
список студентов (второй ViewController) при нажатии же на имя студента отрывается третий ViewController с фотографией студента 
(для простоты там находится одна стандартная картинка для всех студентов) и  прочие данные (для простоты просто имя и фамилия студента).
На первом и втором ViewController так же находится строка для поиска студента. На первом ViewController поиск ведется среди всех 
студентов из всех трех групп, на каждом из ViewController группы поиск ведется по студентам данной группы. Данные добавляются в 
CoreData при первом запуске программы, при последующих запусках данные в приложение поддружаются из CoreData. Приложение выполненно без
использования Storyboard.
