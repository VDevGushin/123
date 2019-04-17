//
//  The power of key paths in Swift.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 25/03/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// MARK: - Functional shorthands

fileprivate struct Article {
    let id: Int
    let source: URL
    let title: String
    let body: String
}

// No keypath
fileprivate func test1(articles: [Article]) {
    let articleIDs = articles.map { $0.id }
    let articleSources = articles.map { $0.source }
    print(articleIDs, articleSources)
}

/*Хотя вышеприведенное полностью работает, так как мы просто заинтересованы в извлечении отдельного значения из каждого элемента, нам на самом деле не нужна полная мощность замыканий - поэтому вместо этого может быть полезно использовать ключевые пути. Давайте посмотрим, как это может работать.
 
 Мы начнем с расширения Sequence, чтобы добавить переопределение карты, в котором вместо пути используется ключевой путь. Поскольку мы заинтересованы только в доступе только для чтения для этого варианта использования, мы будем использовать стандартный тип KeyPath, а для фактического выполнения извлечения данных мы будем использовать подписку с указанным путем ключа в качестве аргумента - вот так:
*/
fileprivate extension Array {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }
}

extension Array {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

// With key path
fileprivate func test2(articles: [Article]) {
    let articleIDs = articles.map(\.id)
    let articleSources = articles.map(\.source)

    print(articles.sorted(by: \.id))
    print(articleIDs, articleSources)
}

// MARK: - No instance required
fileprivate struct Song {
    let name: String
    let artistName: String
    let albumArtwork: UIImage?
}

fileprivate struct Playlist {
    let title: String
    let authorName: String
    let artwork: UIImage?
}

// NO key path
fileprivate struct SongCellConfigurator1 {
    func configure(_ cell: UITableViewCell, for song: Song) {
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        cell.imageView?.image = song.albumArtwork
    }
}

// With keypath
fileprivate struct CellConfigurator2<Model> {
    let titleKeyPath: KeyPath<Model, String>
    let subtitleKeyPath: KeyPath<Model, String>
    let imageKeyPath: KeyPath<Model, UIImage?>

    func configure(_ cell: UITableViewCell, for model: Model) {
        cell.textLabel?.text = model[keyPath: titleKeyPath]
        cell.detailTextLabel?.text = model[keyPath: subtitleKeyPath]
        cell.imageView?.image = model[keyPath: imageKeyPath]
    }
}

func testKeyPath() {
    //no key path
    //Может использоваться только для модели песни - жесткая привязка к типу
    let songCellConfig = SongCellConfigurator1()
    songCellConfig.configure(.init(frame: .zero), for: . init(name: "123", artistName: "33", albumArtwork: nil))

    //with key path
    let songCellConfigurator = CellConfigurator2<Song>(
        titleKeyPath: \.name,
        subtitleKeyPath: \.artistName,
        imageKeyPath: \.albumArtwork
    )
    songCellConfigurator.configure(.init(frame: .zero), for: . init(name: "123", artistName: "33", albumArtwork: nil))
    //так же может обработать аналогичный тип - так как generic

    let playlistCellConfigurator2 = CellConfigurator2<Playlist>(
        titleKeyPath: \.title,
        subtitleKeyPath: \.authorName,
        imageKeyPath: \.artwork
    )
    playlistCellConfigurator2.configure(.init(frame: .zero), for: . init(title: "123", authorName: "33", artwork: nil))
}


// MARK: - Converting to functions
fileprivate struct Item { }
fileprivate struct Render {
    func load (then: ([Item]) -> Void) { }
}

fileprivate class ListViewController {
    private let render = Render()
    private var items = [Item]() { didSet { onRender() } }

    func loadItems() {
        render.load { [weak self] items in
            self?.items = items
        }

        //WITH Key path
        render.load(then: setter(for: self, keyPath: \.items))
    }

    private func onRender() {

    }


    func setter<Object: AnyObject, Value>(for object: Object, keyPath: ReferenceWritableKeyPath<Object, Value>
    ) -> (Value) -> Void {
        return { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}
