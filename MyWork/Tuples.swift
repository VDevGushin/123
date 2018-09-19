//
//  Tuples.swift
//  MyWork
//
//  Created by Vladislav Gushin on 31/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

class TextView: UIView {
    typealias Texts = (title: String, subtitle: String)

    let titleLabel: UILabel? = nil
    let subtitleLabel: UILabel? = nil

    func render(_ texts: Texts) {
        self.titleLabel?.text = texts.title
        self.subtitleLabel?.text = texts.subtitle
    }
}
//======================================================================================================
struct Tile { }
struct MapTest {
    typealias Coordinate = (x: Int, y: Int)
    let width: Int
    let tites: [Tile]
    subscript(_ coordinate: Coordinate) -> Tile {
        return tites[coordinate.x + coordinate.y * width]
    }
}

class TestMap {
    func testMap() {
        let map = MapTest(width: 23, tites: [Tile()])
        _ = map[(2, 1)]
    }
}

//======================================================================================================

private class UserSearchViewControllea: UIViewController {
    enum Scope {
        case friends
        case favorites
        case all
    }

    private var currentCriteria: (query: String, scope: Scope)?

    func searchForUsers(matching query: String, in scope: Scope) {
        if let criteria = currentCriteria {
            guard (query, scope) != criteria else {
                return
            }
        }

        currentCriteria = (query, scope)
    }
}

//////=======Combined with first class functions=======================
func call<Input, Output>(_ function: (Input) -> Output, with input: Input) -> Output {
    return function(input)
}

class HeaderView: UIView {
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PromotionView: UIView {
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfileView: UIView {
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class TestAllViewsWithTuples {
    func test() {
        let styles = (CGRect.zero, UIFont.systemFont(ofSize: 20), UIColor.red)
        let headerView = call(HeaderView.init, with: styles)
        let promotionView = call(PromotionView.init, with: styles)
        let profileView = call(ProfileView.init, with: styles)
        dump(headerView)
        dump(promotionView)
        dump(profileView)
    }
}
