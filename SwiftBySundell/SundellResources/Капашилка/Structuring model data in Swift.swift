//
//  Structuring model data in Swift.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 13/05/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

/*
 Создание надежной структуры в базе кода часто необходимо для облегчения работы. Однако создать структуру, которая будет достаточно жесткой, чтобы предотвращать ошибки и проблемы, и достаточно гибкой для существующих функций и любых будущих изменений, которые мы хотим внести в будущее, может быть действительно сложной задачей.
 
 Это, как правило, особенно верно для кода модели, который часто используется многими различными функциями, каждый из которых имеет свой набор требований. На этой неделе давайте рассмотрим несколько различных методов структурирования данных, составляющих наши основные модели, и то, как улучшение этой структуры может оказать большое положительное влияние на остальную часть нашей кодовой базы.
 */

// MARK: - Работа с классом и струтктурой - мы должны видеть отдельные модели

fileprivate struct Tag { }
fileprivate struct Folder { }
fileprivate struct Video { }

fileprivate struct Message {
    var subject: String
    var body: String
    let date: Date
    var tags: [Tag]
    var replySent: Bool

    //==============================
    let senderName: String
    let senderImage: UIImage?
    let senderAddress: String
    //============================== TO
    let person: Person
    //==============================
}

fileprivate struct Person {
    let name: String
    let address: String
    let image: UIImage?
}

// MARK: - Избавление от бубликатов

//начальная модель
fileprivate enum Event {
    case add(Message)
    case update(Message)
    case delete(Message)
    case move(Message, to: Folder)
}

//конечная модель
fileprivate enum Action {
    case add
    case update
    case delete
    case move(to: Folder)
}

fileprivate struct EventOptimal {
    let message: Message
    let action: Action
}


// MARK: - Рекурсивные структуры

//Допустим, мы работаем над приложением, которое отображает различные виды контента, такие как текст и изображения, и что мы снова используем enum для определения каждой части контента - например, так:
fileprivate enum Content {
    case text(String)
    case image(UIImage)
    case video(Video)
}

//Теперь допустим, что мы хотим, чтобы наши пользователи могли формировать группы контента - например, путем создания списка избранных или упорядочивания вещей с использованием папок. Начальная идея может заключаться в том, чтобы перейти к выделенному типу группы, который содержит имя группы и содержимое, которое принадлежит ей:
fileprivate struct Group {
    var name: String
    var content: [Content]
}

/*Однако, хотя вышеприведенное выглядит элегантно и хорошо структурировано, в этом случае у него есть некоторые недостатки. Внедряя новый выделенный тип, мы должны будем обрабатывать группы отдельно от отдельных частей контента, что усложнит создание таких вещей, как списки, и мы также не сможем легко поддерживать вложенные группы.
 
 Поскольку в этом случае группа является не чем иным, как другим способом структурирования контента, давайте вместо этого сделаем ее первоклассным членом самого перечисления Content, просто добавив для нее новый регистр - например, так:*/

fileprivate enum ContentOptimal {
    case text(String)
    case image(UIImage)
    case video(Video)
    case group(name: String, content: [ContentOptimal])
}

fileprivate func test(content: ContentOptimal) {
    switch content {
    case .text(let string): print(string)
    case .image(let image): dump(image)
    case .video(let video): dump(video)
    case .group(let name, let content):
        dump(name)
        dump(content)
    }
}

// MARK: - специальные модели
/*Хотя возможность повторного использования кода часто является хорошей вещью, иногда лучше создать более специализированную новую версию модели, чем пытаться использовать ее в совершенно ином контексте.
 
 Возвращаясь к нашему примеру приложения для работы с электронной почтой, скажем, мы хотим, чтобы пользователи могли сохранять черновики частично составленных сообщений. Вместо того, чтобы эта функция работала с полными экземплярами сообщений, для которых требуются данные, которые не будут доступны для черновиков, такие как имя отправителя или дата получения сообщения, давайте вместо этого создадим гораздо более простой тип черновика, который мы вложим в Сообщение для дополнительного контекста:*/
fileprivate extension Message {
    struct Draft {
        var subject: String?
        var body: String?
        var recipients: [Person]
    }
}
