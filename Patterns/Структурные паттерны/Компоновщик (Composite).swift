//
//  Компоновщик (Composite).swift
//  Patterns
//
//  Created by Vlad Gushchin on 22/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

/*Паттерн Компоновщик (Composite) объединяет группы объектов в древовидную структуру по принципу "часть-целое и позволяет клиенту одинаково работать как с отдельными объектами, так и с группой объектов.
 
 Образно реализацию паттерна можно представить в виде меню, которое имеет различные пункты. Эти пункты могут содержать подменю, в которых, в свою очередь, также имеются пункты. То есть пункт меню служит с одной стороны частью меню, а с другой стороны еще одним меню. В итоге мы однообразно можем работать как с пунктом меню, так и со всем меню в целом.
 
 Когда использовать компоновщик?
 
 Когда объекты должны быть реализованы в виде иерархической древовидной структуры
 
 Когда клиенты единообразно должны управлять как целыми объектами, так и их составными частями. То есть целое и его части должны реализовать один и тот же интерфейс*/

// определяет интерфейс для всех компонентов в древовидной структуре
fileprivate protocol Component {
    var name: String { get set }
    init(name: String)
    func display()
    func add(component: Component)
    func remove(component: Component)
}

//представляет компонент, который может содержать другие компоненты и реализует механизм для их добавления и удаления
fileprivate class Composite: Component {
    var name: String
    var children: [Component]

    required init(name: String) {
        self.name = name
        self.children = [Component]()
    }

    func add(component: Component) {
        self.children.append(component)
    }

    func remove(component: Component) {
        self.children = children.filter { component.name != $0.name }
    }

    func display() {
        for component in children {
            component.display()
        }
    }
}

//представляет отдельный компонент, который не может содержать другие компоненты
fileprivate class Leaf: Component {
    var name: String

    required init(name: String) {
        self.name = name
    }

    func display() {
        print("display")
    }

    func add(component: Component) {
        //
    }

    func remove(component: Component) {
        //
    }
}

fileprivate func main() {
    let root = Composite(name: "Root")
    let leaf = Leaf(name: "Leaf")
    let subTree = Composite(name: "SubTree")
    root.add(component: leaf)
    root.add(component: subTree)
    root.display()
}

/*Рассмотрим простейший пример.
Допустим, нам надо создать объект файловой системы.
Файловую систему составляют папки и файлы.
Каждая папка также может включать в себя папки и файлы.
То есть получается древовидная иерархическая структура, где с вложенными папками нам надо работать также, как и с папками, которые их содержат. Для реализации данной задачи и воспользуемся паттерном Компоновщик:*/

protocol FileOsComponent {
    var name: String { get }
    init(name: String)
    func add(component: FileOsComponent)
    func remove(component: FileOsComponent)
    func display()
}

extension FileOsComponent {
    func add(component: FileOsComponent) { }
    func remove(component: FileOsComponent) { }
    func display() {
        print(self.name)
    }
}


class Directory: FileOsComponent {
    var components: [FileOsComponent]
    let name: String

    required init(name: String) {
        self.name = name
        self.components = []
    }

    func add(component: FileOsComponent) {
        self.components.append(component)
    }

    func remove(component: FileOsComponent) {
        self.components = self.components.filter {
            $0.name != component.name
        }
    }

    func display() {
        print("узел \(name)")
        print("Подъузлы:")
        for subComponent in components {
            subComponent.display()
        }
    }
}

class File: FileOsComponent {
    var name: String

    required init(name: String) {
        self.name = name
    }
}

func testComposite() {
    let fileSystem = Directory(name: "File system")
    // определяем новый диск
    let diskC = Directory(name: "Disk C")
    // новые файлы
    let pngFile = File(name: "12345.png")
    let docxFile = File(name: "Document.docx")
    // добавляем файлы на диск С
    diskC.add(component: pngFile)
    diskC.add(component: docxFile)
    // добавляем диск С в файловую систему
    fileSystem.add(component: diskC)
    // выводим все данные
    fileSystem.display()
    // удаляем с диска С файл
    diskC.remove(component: pngFile);
    // создаем новую папку
    let docsFolder = Directory(name: "Мои Документы");
    // добавляем в нее файлы
    let txtFile = File(name: "readme.txt");
    let csFile = File(name: "Program.cs");
    docsFolder.add(component: txtFile);
    docsFolder.add(component: csFile);
    diskC.add(component: docsFolder);
}
