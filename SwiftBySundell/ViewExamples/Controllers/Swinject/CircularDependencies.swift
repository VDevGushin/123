//
//  CircularDependencies.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/02/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation
import Swinject
// MARK: - Initializer/Property Dependencies

/*Предположим, что у вас есть классы Parent и Child в зависимости друг от друга. Parent зависит от ChildProtocol через его инициализатор, а Child от ParentProtocol через свойство. Обратная ссылка от Child к ParentProtocol является слабым свойством, чтобы избежать утечки памяти*/
fileprivate protocol ParentProtocol: AnyObject { }
fileprivate protocol ChildProtocol: AnyObject { }

fileprivate class Parent: ParentProtocol {
    let child: ChildProtocol?

    init(child: ChildProtocol?) {
        self.child = child
    }
}

fileprivate class Child: ChildProtocol {
    weak var parent: ParentProtocol?
}

fileprivate func registerContainer() {
    let container = Container()
    container.register(ParentProtocol.self) { r in
        Parent(child: r.resolve(ChildProtocol.self)!)
    }

    container.register(ChildProtocol.self) { r in
        let child = Child()
        child.parent = r.resolve(ParentProtocol.self)
        return child
    }
}

// MARK: - Property/Property Dependencies

fileprivate protocol ParentProtocol1: AnyObject { }
fileprivate protocol ChildProtocol1: AnyObject { }

fileprivate class Parent1: ParentProtocol1 {
    var child: ChildProtocol1?
}

fileprivate class Child1: ChildProtocol1 {
    weak var parent: ParentProtocol1?
}

fileprivate func registerContainer1() {
    let container = Container()
    container.register(ParentProtocol1.self) { r in
        let parent = Parent1()
        parent.child = r.resolve(ChildProtocol1.self)!
        return parent
    }
    //===
    container.register(ParentProtocol1.self) { _ in Parent1() }
        .initCompleted { r, p in
            let parent = p as! Parent1
            parent.child = r.resolve(ChildProtocol1.self)!
    }

    container.register(ChildProtocol1.self) { r in
        let child = Child1()
        child.parent = r.resolve(ParentProtocol1.self)!
        return child
    }
}

// MARK: - Initializer/Initializer Dependencies
//Not supported. This type of dependency causes infinite recursion.


