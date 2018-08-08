//
//  CustomOperators.swift
//  MyWork
//
//  Created by Vladislav Gushin on 08/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit



// MARK: - Numeric containers
fileprivate struct Resources {
    private(set) var gold: Int
    private(set) var wood: Int
}

// MARK: Operation overloading
extension Resources {
    static func -= (lhs: inout Resources, rhs: Resources) {
        lhs.gold = rhs.gold
        lhs.wood = rhs.wood
    }
//Mutating functions as an alternative
    mutating func reduce(by resource: Resources) {
        self.gold -= resource.gold
        self.wood -= resource.wood
    }
}

fileprivate struct Player {
    var resources: Resources
}

fileprivate struct Unit {
    enum Kind {
        var cost: Resources {
            return Resources(gold: 1, wood: 1)
        }
    }

    init(kind: Kind) {

    }
}


fileprivate class TrainignCamp {
    var currentPlayer: Player
    var board: [Unit]

    init(board: [Unit], current: Player) {
        self.board = board
        self.currentPlayer = current
    }

    func trinUnit(ofKind kind: Unit.Kind) {
        let unit = Unit(kind: kind)
        board.append(unit)
        //OLD
//        currentPlayer.resources.gold -= kind.cost.gold
//        currentPlayer.resources.wood -= kind.cost.wood

        currentPlayer.resources -= kind.cost
        currentPlayer.resources.reduce(by: kind.cost)
    }
}

// MARK: - Layout calculations
class TestLayoutCalculations {
    weak var label: UILabel!
    weak var imageView: UIScrollView!

    func test() {
        //OLD
        self.label.frame.origin = CGPoint(
            x: imageView.bounds.width + 10,
            y: imageView.bounds.height + 20
        )

        //NEW
        label.frame.origin = imageView.bounds.size + CGSize(width: 10, height: 20)
        // Using a tuple with labels:
        label.frame.origin = imageView.bounds.size + (x: 10, y: 20)
        // Or without:
        label.frame.origin = imageView.bounds.size + (10, 20)
    }
}

fileprivate extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.width + rhs.width, y: lhs.height + rhs.height)
    }

    static func + (lhs: CGSize, rhs: (x: CGFloat, y: CGFloat)) -> CGPoint {
        return CGPoint(
            x: lhs.width + rhs.x,
            y: lhs.height + rhs.y
        )
    }
}

// MARK: - A custom operator for error handling
fileprivate class Note {
    init(data: Data)throws {

    }
}
fileprivate class Fileloader {
    func loadFile(named: String)throws -> File {
        return File.init()
    }
}

fileprivate class NoteManager {
    let fileloader = Fileloader()

    //Код не несет на себе отвественность
    func loadNote(fromFileNamed fileName: String) throws -> Note {
        let file = try fileloader.loadFile(named: fileName)
        let data = try file.read()
        let note = try Note(data: data)
        return note
    }


    //Сложный код с обработками (трудно читать)
    func loadNoteWithError(fromFileNamed fileName: String) throws -> Note {
        do {
            let file = try fileloader.loadFile(named: fileName)

            do {
                let data = try file.read()

                do {
                    return try Note(data: data)
                } catch {
                    throw LoadingError.decodingFailed(error)
                }
            } catch {
                throw LoadingError.invalidData(error)
            }
        } catch {
            throw LoadingError.invalidFile(error)
        }
    }

    //Еще один варинат , где обработка и тип ошибки выбирается программистом
    func loadNotePerform(fromFileNamed fileName: String) throws -> Note {
        let file: File = try self.perform(fileloader.loadFile(named: fileName),
                                          orThrow: LoadingError.invalidFile)

        let data: Data = try self.perform(file.read(),
                                          orThrow: LoadingError.invalidData)

        let note: Note = try self.perform(Note(data: data),
                                          orThrow: LoadingError.decodingFailed)

        return note
    }
    
    //Работа с новым оператором
    func loadNoteOperator(fromFileNamed fileName: String) throws -> Note {
        let file = try fileloader.loadFile(named: fileName) ~> LoadingError.invalidFile
        let data = try file.read() ~> LoadingError.invalidData
        let note = try Note(data: data) ~> LoadingError.decodingFailed
        return note
    }
}

fileprivate extension NoteManager {
    enum LoadingError: Error {
        case invalidFile(Error)
        case invalidData(Error)
        case decodingFailed(Error)
    }

    func perform<Output>(_ f: @autoclosure () throws -> Output, orThrow: (Error) -> NoteManager.LoadingError)throws -> Output {
        do {
            return try f()
        } catch {
            throw orThrow(error)
        }
    }
}

// MARK: - Adding a new operator
infix operator ~>
func ~><T>(expression: @autoclosure () throws -> T,
           errorTransform: (Error) -> Error) throws -> T {
    do {
        return try expression()
    } catch {
        throw errorTransform(error)
    }
}

