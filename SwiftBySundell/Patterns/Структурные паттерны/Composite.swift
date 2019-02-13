//
//  Composite.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 13/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
/*Паттерн Компоновщик (Composite) объединяет группы объектов в древовидную структуру по принципу "часть-целое и позволяет клиенту одинаково работать как с отдельными объектами, так и с группой объектов.
 
 Образно реализацию паттерна можно представить в виде меню, которое имеет различные пункты. Эти пункты могут содержать подменю, в которых, в свою очередь, также имеются пункты. То есть пункт меню служит с одной стороны частью меню, а с другой стороны еще одним меню. В итоге мы однообразно можем работать как с пунктом меню, так и со всем меню в целом.
 
 Когда использовать компоновщик?
 
 Когда объекты должны быть реализованы в виде иерархической древовидной структуры
 
 Когда клиенты единообразно должны управлять как целыми объектами, так и их составными частями. То есть целое и его части должны реализовать один и тот же интерфейс*/


// определяет интерфейс для всех компонентов в древовидной структуре
fileprivate protocol Component: class {
    var name: String { get set }
    func display()
    func add(c: Component)
    func remove(c: Component)
}

//представляет компонент, который может содержать другие компоненты и реализует механизм для их добавления и удаления
fileprivate class Composite: Component {
    var children = [Component]()

    var name: String

    init(name: String) { self.name = name }

    func display() {
        print(name)
        self.children.forEach {
            $0.display()
        }
    }

    func add(c: Component) {
        self.children.append(c)
    }

    func remove(c: Component) {
        self.children.removeAll {
            $0.name == c.name
        }
    }
}

//представляет отдельный компонент, который не может содержать другие компоненты
fileprivate class Leaf: Component {
    var name: String

    init(name: String) { self.name = name }

    func display() {
        print(name)
    }

    func add(c: Component) {
        //NotImplemented
    }

    func remove(c: Component) {
        //NotImplemented
    }
}

fileprivate class Cleint {
    func main() {
        let root = Composite(name: "Root")
        let leaf = Leaf(name: "Leaf")
        let subTree = Composite(name: "Subtree")
        root.add(c: leaf)
        root.add(c: subTree)
        root.display()
    }
}

/*Рассмотрим простейший пример. Допустим, нам надо создать объект файловой системы. Файловую систему составляют папки и файлы. Каждая папка также может включать в себя папки и файлы. То есть получается древовидная иерархическая структура, где с вложенными папками нам надо работать также, как и с папками, которые их содержат. Для реализации данной задачи и воспользуемся паттерном Компоновщик:*/

@objc fileprivate protocol FileSystemComponent {
    var name: String { get set }
    init(name: String)
    @objc optional func add(c: FileSystemComponent)
    @objc optional func remove(c: FileSystemComponent)
    func log()
}

fileprivate class Directory: FileSystemComponent {
    var components = [FileSystemComponent]()
    var name: String

    required init(name: String) {
        self.name = name
    }

    func add(c: FileSystemComponent) {
        self.components.append(c)
    }

    func remove(c: FileSystemComponent) {
        self.components.removeAll {
            $0.name == c.name
        }
    }

    func log() {
        print("Узел \(name)")
        print("Подузлы:")
        self.components.forEach {
            $0.log()
        }
    }
}

fileprivate class File: FileSystemComponent {
    var name: String

    required init(name: String) {
        self.name = name
    }

    func log() {
        print(self.name)
    }
}

fileprivate class Program {
    func main() {
        let fileSystem = Directory(name: "Файловая система")
        // определяем новый диск
        let diskC = Directory(name: "Диск С")
         // новые файлы
        let pngFile = File(name: "1231.png")
        let docxFile = File(name: "Document.docx")
        // добавляем файлы на диск С
        diskC.add(c: pngFile)
        diskC.add(c: docxFile)
         // добавляем диск С в файловую систему
        fileSystem.add(c: diskC)
        // выводим все данные
        fileSystem.log()
         // удаляем с диска С файл
        diskC.remove(c: pngFile)
        // создаем новую папку
        let docsFolder = Directory(name: "Мои документы")
        // добавляем в нее файлы
        let txtFile = File(name: "readme.txt")
        let csFile = File(name: "programm.cs")
        docsFolder.add(c: txtFile)
        docsFolder.add(c: csFile)
        diskC.add(c: docsFolder)
        
        fileSystem.log()
    }
}
