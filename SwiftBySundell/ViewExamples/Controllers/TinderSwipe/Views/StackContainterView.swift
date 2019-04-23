//
//  StackContainterView.swift
//  SwiftBySundell
//
//  Created by Vlad Gushchin on 23/04/2019.
//  Copyright © 2019 Vladislav Gushin. All rights reserved.
//

import UIKit

protocol SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int
    func card(at index: Int) -> SwipeCardView
    func emptyView() -> UIView?
}

class StackContainterView: UIView {
}
