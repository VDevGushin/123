//
//  KeyPaths.swift
//  MyWork
//
//  Created by Vladislav Gushin on 29/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
//MARK: - Simple code
fileprivate struct SArticle {
    let id: Identifier
    let source: URL
    let title: String
    let body: String
}

fileprivate func ftest() {
    let a = SArticle(id: Identifier(), source: URL(string: "13")!, title: "t", body: "t")
    let articles = [a]

    let ids = articles.map { $0.id }
    let aSourses = articles.map { $0.source }

    let keyPAthArt = articles.map(\.id)
    let keyPAthSou = articles.map(\.source)
    articles.sorted(by: \.title)
}

extension Sequence {
    func map<T>(_ keyPath: KeyPath<Element, T>) -> [T] {
        return map { $0[keyPath: keyPath] }
    }

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}

//MARK: - No instance required
fileprivate struct Song {
    let name: String
    let artistName: String
    let image: UIImage?
}

fileprivate struct Playlist {
    let name: String
    let artistName: String
    let artwork: UIImage?
}

//Слишком узкоспециальизрованный код
fileprivate struct SongCellConfigurator {
    func configure(_ cell: UITableViewCell, for song: Song) {
        cell.textLabel?.text = song.name
        cell.detailTextLabel?.text = song.artistName
        cell.imageView?.image = song.image
    }
}
//Создадим глобальный конфигуратор
fileprivate struct CellConfigurator<Model> {
    let titleKeyPath: KeyPath<Model, String>
    let subtitleKeyPath: KeyPath<Model, String>
    let imageKeyPath: KeyPath<Model, UIImage?>

    func configure(_ cell: UITableViewCell, for model: Model) {
        cell.textLabel?.text = model[keyPath: titleKeyPath]
        cell.detailTextLabel?.text = model[keyPath: subtitleKeyPath]
        cell.imageView?.image = model[keyPath: imageKeyPath]
    }
}

fileprivate struct TestCellConfigurator {
    func test() {
        let one = CellConfigurator<Song>.init(titleKeyPath: \.name, subtitleKeyPath: \.artistName, imageKeyPath: \.image)

        let two = CellConfigurator<Playlist>.init(titleKeyPath: \.name, subtitleKeyPath: \.artistName, imageKeyPath: \.artwork)
    }
}

//MARK: - Converting to functions
fileprivate struct Item {

}

fileprivate struct ItemsLoader {
    func load(_ then: ([Item]) -> Void) {
        then([Item()])
    }
}

fileprivate class AListViewController {
    let loader = ItemsLoader()
    private var items = [Item]() {
        didSet {
            render()
        }
    }

    func loadItems() {
        loader.load { [weak self] items in
            self?.items = items
        }
        
        //Использование keypath для записи в свойство
        loader.load(setter(for: self, keyPath: \.items))
    }
    
    func render() { }
    
    func setter<Object: AnyObject, Value>(
        for object: Object,
        keyPath: ReferenceWritableKeyPath<Object, Value>)
        -> (Value) -> Void {
            return { [weak object] value in
                object?[keyPath: keyPath] = value
            }
    }
}
