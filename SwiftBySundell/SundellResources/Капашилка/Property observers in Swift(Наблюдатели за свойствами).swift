//
//  Property observers in Swift.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 22/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

// Оповещаем всех об изменениях значений
// MARK: - Automatic updates
// Пример оповещения через делегат и willset didset
fileprivate struct Tool: Equatable {
    let name: String

    static var boxedSelection: Tool {
        return Tool(name: "boxedSelecton")
    }

    static func == (lhs: Tool, rhs: Tool) -> Bool {
        return lhs.name == rhs.name
    }
}

fileprivate protocol ToolboxViewControllerDelegate: class {
    func toolboxViewController(_ viewController: ToolboxViewController, willChangeToolTo newTool: Tool)
    func toolboxViewController(_ viewController: ToolboxViewController, didChangeToolFrom oldTool: Tool)
}

fileprivate class ToolboxViewController {
    weak var delegate: ToolboxViewControllerDelegate?
    var tool = Tool.boxedSelection {
        willSet {
            guard tool != newValue else { return }
            delegate?.toolboxViewController(self, willChangeToolTo: newValue)
        }
        didSet {
            guard tool != oldValue else { return }
            delegate?.toolboxViewController(self, didChangeToolFrom: oldValue)
        }
    }
}

// Через key path
fileprivate protocol SelfPropertyChecker {
    func property<T: Equatable>(_ keyPath: KeyPath<Self, T>, didChangeFrom oldValue: T)
    func notify()
}

extension SelfPropertyChecker {
    func property<T: Equatable>(_ keyPath: KeyPath<Self, T>, didChangeFrom oldValue: T) {
        guard self[keyPath: keyPath] != oldValue else { return }
        self.notify()
    }
}

fileprivate final class GraphView: UIView, SelfPropertyChecker {

    var points = [CGPoint]() {
        didSet { property(\.points, didChangeFrom: oldValue) }
    }

    var lineColor = UIColor.black {
        didSet { property(\.lineColor, didChangeFrom: oldValue) }
    }

    var drawMarkers = false {
        didSet { property(\.drawMarkers, didChangeFrom: oldValue) }
    }

    override func draw(_ rect: CGRect) {
        // Draw the graph
    }

    func notify() {
        self.setNeedsDisplay()
    }
}
