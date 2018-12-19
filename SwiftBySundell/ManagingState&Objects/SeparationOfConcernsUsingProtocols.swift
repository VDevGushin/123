//
//  SeparationOfConcernsUsingProtocols.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 19/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import CoreData

// MARK: - Help class
fileprivate class Model { }

fileprivate class Query { }

/*
 Допустим, мы создаем ContactSearchViewController, который позволяет нашим пользователям искать контакты, локально сохраненные в приложении.
 В настоящее время приложение использует Core Data для сохранения, поэтому наше первоначальное решение может заключаться в том,
 чтобы просто внедрить контекст Core Data приложения (NSManagedObjectContext) в наш новый контроллер представления в качестве зависимости:
 */

fileprivate class ContactSearchViewController: UIViewController {
    private let coreDataContext: NSManagedObjectContext

    init(coreDataContext: NSManagedObjectContext) {
        self.coreDataContext = coreDataContext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 Выполнение чего-либо, подобного описанному выше, является очень распространенным решением, и оно полностью допустимо, однако оно имеет две проблемы:

1 Наш контроллер представления знает, что наше приложение использует Core Data. Хотя это может быть очень удобно, это также делает наш код менее гибким (если мы, например, хотим изменить решение для нашей базы данных на что-то другое - например, Realm). Это также делает тестирование действительно трудным (даже если мы используем внедрение зависимостей), поскольку манипулирование системным классом, таким как NSManagedObjectContext, является сложным и часто приводит к нестабильным тестам.
2 Поскольку наш контроллер представления получает полный доступ к нашей базе данных, он может делать с ним все, что захочет. Он может как читать, так и писать, что в данном случае на самом деле не нужно - контроллер представления будет выполнять поиск только по контактам, для которых требуется только чтение. Было бы намного лучше, если бы мы могли отделить чтение и запись, чтобы обеспечить только заданный контроллер представления необходимой функциональностью.ё
 
 Вместо того, чтобы предоставлять нашим контроллерам представления прямой доступ к конкретной реализации нашей базы данных, мы можем создать протокол, который определяет все API, которые нужны нашему приложению для загрузки и сохранения объектов, например:
 */

fileprivate protocol DataBase {
    func loadObjects<T: Model>(matching query: Query) -> [T]
    func loadObject<T: Model>(withID id: String) -> T?
    func save<T: Model>(_ object: T)
}

fileprivate class ContactSearchViewController1: UIViewController {
    private let database: DataBase

    init(database: DataBase) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/*
 Выполнение вышеизложенного решает проблему номер один - наш код стал намного более гибким и более простым для тестирования. В наших тестах мы теперь можем просто создавать макеты путем реализации протокола базы данных, и если мы когда-либо захотим перейти на новое решение для базы данных (или даже использовать специальное решение для таких вещей, как тесты пользовательского интерфейса), мы можем легко сделать это, добавив новые реализации базы данных:
 */

fileprivate class NSManagedObjectContext: DataBase {
    func loadObjects<T>(matching query: Query) -> [T] where T: Model { return Model() as! [T] }
    func loadObject<T>(withID id: String) -> T? where T: Model { return Model() as? T }
    func save<T>(_ object: T) where T: Model { }
}

fileprivate class Realm: DataBase {
    func loadObjects<T>(matching query: Query) -> [T] where T: Model { return Model() as! [T] }
    func loadObject<T>(withID id: String) -> T? where T: Model { return Model() as? T }
    func save<T>(_ object: T) where T: Model { }
}

fileprivate class MockedDatabase: DataBase {
    func loadObjects<T>(matching query: Query) -> [T] where T: Model { return Model() as! [T] }
    func loadObject<T>(withID id: String) -> T? where T: Model { return Model() as? T }
    func save<T>(_ object: T) where T: Model { }
}

fileprivate class UITestingDatabase: DataBase {
    func loadObjects<T>(matching query: Query) -> [T] where T: Model { return Model() as! [T] }
    func loadObject<T>(withID id: String) -> T? where T: Model { return Model() as? T }
    func save<T>(_ object: T) where T: Model { }
}


/*
 Вместо того, чтобы использовать единый протокол для всех функций базы данных, давайте использовать состав протокола для разделения.
 В этом случае мы создадим один протокол для чтения и один для записи. Те же API, просто разделенные на два протокола вместо одного:
 */

fileprivate protocol ReadableDatabase {
    func loadObjects<T: Model>(matching query: Query) -> [T]
    func loadObject<T: Model>(withID id: String) -> T?
}

fileprivate protocol WritableDatabase {
    func save<T: Model>(_ object: T)
}

fileprivate class ContactSearchViewController2: UIViewController {
    private let database: ReadableDatabase
    
    init(database: ReadableDatabase) {
        self.database = database
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate typealias Database = ReadableDatabase & WritableDatabase
