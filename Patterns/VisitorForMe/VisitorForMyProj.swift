//
//  VisitorForMyProj.swift
//  Patterns
//
//  Created by Vlad Gushchin on 24/06/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import Foundation

fileprivate class FirstCell: UITableViewCell { }

fileprivate class SecondCell: UITableViewCell { }

fileprivate class ThirdCell: UITableViewCell { }

fileprivate class TableVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(FirstCell.self,
            forCellReuseIdentifier: "FirstCell")
        tableView.register(SecondCell.self,
            forCellReuseIdentifier: "SecondCell")
        tableView.register(ThirdCell.self,
            forCellReuseIdentifier: "ThirdCell")
    }

    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**/ return FirstCell()
        /**/ return SecondCell()
        /**/ return ThirdCell()
    }

    override func tableView(_ tableView: UITableView,
        heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as! VisitableСell
        return cell.accept(HeightResultCellVisitor())
    }

    override func tableView(_ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = (cell as! VisitableСell).accept(ColorResultCellVisitor())
    }
}

fileprivate protocol VisitableСell where Self: UITableViewCell {
    func accept<V: CellVisitor>(_ visitor: V) -> V.T
}

extension FirstCell: VisitableСell {
    func accept<V: CellVisitor>(_ visitor: V) -> V.T {
        return visitor.visit(self)
    }
}
extension SecondCell: VisitableСell {
    func accept<V: CellVisitor>(_ visitor: V) -> V.T {
        return visitor.visit(self)
    }
}
extension ThirdCell: VisitableСell {
    func accept<V: CellVisitor>(_ visitor: V) -> V.T {
        return visitor.visit(self)
    }
}


fileprivate protocol CellVisitor {
    associatedtype T
    func visit(_ cell: FirstCell) -> T
    func visit(_ cell: SecondCell) -> T
    func visit(_ cell: ThirdCell) -> T
}

fileprivate struct HeightResultCellVisitor: CellVisitor {
    func visit(_ cell: FirstCell) -> CGFloat { return 10.0 }
    func visit(_ cell: SecondCell) -> CGFloat { return 20.0 }
    func visit(_ cell: ThirdCell) -> CGFloat { return 30.0 }
}

fileprivate struct ColorResultCellVisitor: CellVisitor {
    func visit(_ cell: FirstCell) -> UIColor { return .black }
    func visit(_ cell: SecondCell) -> UIColor { return .white }
    func visit(_ cell: ThirdCell) -> UIColor { return .red }
}

fileprivate struct BackgroundColorSetter: CellVisitor {
    func visit(_ cell: FirstCell) { cell.backgroundColor = .black }
    func visit(_ cell: SecondCell) { cell.backgroundColor = .white }
    func visit(_ cell: ThirdCell) { cell.backgroundColor = .red }
}

//HELPERS
fileprivate enum UIColor {
    case black
    case white
    case red
}

fileprivate class UITableViewCell {
    var backgroundColor: UIColor!
}
fileprivate class UITableViewController {
    var tableView: UITableView!
    func viewDidLoad() { }
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 0.0 }
    func tableView(_ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath) { }
}
fileprivate class UITableView {
    func register(_ with: AnyObject.Type, forCellReuseIdentifier: String) { }
    func cellForRow(at: IndexPath) -> UITableViewCell { return UITableViewCell() }
}
