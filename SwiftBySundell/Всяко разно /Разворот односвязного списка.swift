//
//  Разворот односвязного списка.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 03/07/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

// Узел
final class Node<T> {
    let data: T
    var nextNode: Node?

    init(data: T, nextNode: Node? = nil) {
        self.data = data
        self.nextNode = nextNode
    }
}

//Писок исчерпывающе идентифицируется своим первым узлом:
final class SinglyLinkedList<T> {
    var firstNode: Node<T>?

    init(firstNode: Node<T>? = nil) {
        self.firstNode = firstNode
    }
}

// MARK: - Разворот односвязного списка
//Первый способ. Цикл


extension SinglyLinkedList {
    func reverse() {
        var previousNode: Node<T>? = nil
        var currentNode = firstNode
        var nextNode = firstNode?.nextNode

        while nextNode != nil {
            currentNode?.nextNode = previousNode
            previousNode = currentNode
            currentNode = nextNode
            nextNode = currentNode?.nextNode
        }
        
        currentNode?.nextNode = previousNode
        firstNode = currentNode
    }

}
