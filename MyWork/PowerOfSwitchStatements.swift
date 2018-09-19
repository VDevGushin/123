//
//  PowerOfSwitchStatements.swift
//  MyWork
//
//  Created by Vladislav Gushin on 14/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

private enum HTTPError: Error {
    case unauthorized
}

private enum CheckResult<T: Equatable> {
    case result(T)
    case error(Error)
}

extension CheckResult: Equatable {
    static func == (lhs: CheckResult<T>, rhs: CheckResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.result(let valueA), .result(let valueB)):
            return valueA == valueB
        case (.error(let errorA), .error(let errorB)):
            return errorA.localizedDescription == errorB.localizedDescription
        case (.result, .error):
            return false
        case (.error, .result):
            return false
        }
    }

    private func handle(_ any: Any) {

    }

    //Using pattern matching
    func handleResult(result: CheckResult<T>) {
        switch result {
        case .result(let data):
            handle(data)
        case .error(let error as HTTPError) where error == .unauthorized:
            handle(error)
        case .error(let error):
            handle(error)
        }
    }
}

//Switching on a set
private class RoadTile {
    enum ConnectedDirections {
        case up
        case down
        case left
        case right
    }
    var connectedDirections = Set<ConnectedDirections>()

    func render() {
        switch connectedDirections {
        case [.up, .down]: break
            //image = UIImage(named: "road-vertical")
        case [.left, .right]: break
            //image = UIImage(named: "road-horizontal")
        default: break
            // image = UIImage(named: "road")
        }
    }

    func render2() {
        if connectedDirections.contains(.up) && connectedDirections.contains(.down) {
            // image = UIImage(named: "road-vertical")
        } else if connectedDirections.contains(.left) && connectedDirections.contains(.right) {
            //  image = UIImage(named: "road-horizontal")
        } else {
            //  image = UIImage(named: "road")
        }
    }
}

//Switching on a comparison
private class SwitchingComparison {
    let score1 = 1
    let score2 = 2
    var text = ""

    func testScores() {
        if score1 < score2 {
            text = "You're losing 😢"
        } else if score1 > score2 {
            text = "You're winning 🎉"
        } else {
            text = "You're tied 😬"
        }
    }

    func testScores2() {
        switch score1.compare(to: score2) {
        case .equal:
            text = "You're tied 😬"
        case .greater:
            text = "You're winning 🎉"
        case .less:
            text = "You're losing 😢"
        }
    }
}

extension Int {
    enum ComparisonOutcome {
        case equal
        case greater
        case less
    }

    func compare(to otherInt: Int) -> ComparisonOutcome {
        if self < otherInt {
            return .less
        }

        if self > otherInt {
            return .greater
        }

        return .equal
    }
}
