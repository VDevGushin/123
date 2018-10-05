//
//  Animation.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 03/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//MARK: - Simple animation array
public struct Animation {
    public let duration: TimeInterval
    public let closure: (UIView) -> Void
}

public extension Animation {
    public static func fadeIn(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.alpha = 1 })
    }

    public static func fadeOut(duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.alpha = 0 })
    }

    public static func resize(to size: CGSize, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration, closure: { $0.bounds.size = size })
    }

    static func move(byX x: CGFloat, y: CGFloat, duration: TimeInterval = 0.3) -> Animation {
        return Animation(duration: duration) {
            $0.center.x += x
            $0.center.y += y
        }
    }
}

//MARK: - Framework
public extension UIView {
    public static func animate(_ tokens: AnimationToken...) {
        animate(tokens)
    }

    public static func animate(_ tokens: [AnimationToken]) {
        guard !tokens.isEmpty else {
            return
        }

        var tokens = tokens
        let token = tokens.removeFirst()

        token.perform {
            self.animate(tokens)
        }
    }


    @discardableResult func animate(_ animations: Animation...) -> AnimationToken {
        return animate(animations)
    }

    @discardableResult func animate(inParallel animations: Animation...) -> AnimationToken {
        return animate(inParallel: animations)
    }

    @discardableResult func animate(_ animations: [Animation]) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .inSequence
        )
    }

    @discardableResult func animate(inParallel animations: [Animation]) -> AnimationToken {
        return AnimationToken(
            view: self,
            animations: animations,
            mode: .inParallel
        )
    }


    func performAnimations(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        guard !animations.isEmpty else {
            return completionHandler()
        }

        var animations = animations
        let animation = animations.removeFirst()

        UIView.animate(withDuration: animation.duration, animations: {
            animation.closure(self)
        }, completion: { _ in
            self.performAnimations(animations, completionHandler: completionHandler)
        })
    }

    func performAnimationsInParallel(_ animations: [Animation], completionHandler: @escaping () -> Void) {
        guard !animations.isEmpty else {
            return completionHandler()
        }

        let animationCount = animations.count
        var completionCount = 0
        let animationCompletionHandler = {
            completionCount += 1
            if completionCount == animationCount {
                completionHandler()
            }
        }

        for animation in animations {
            UIView.animate(withDuration: animation.duration, animations: {
                animation.closure(self)
            }, completion: { _ in
                animationCompletionHandler()
            })
        }
    }
}

public enum AnimationMode {
    case inSequence
    case inParallel
}

public final class AnimationToken {
    private weak var view: UIView?
    private let animations: [Animation]
    private let mode: AnimationMode
    private var isValid = true

    public init(view: UIView, animations: [Animation], mode: AnimationMode) {
        self.view = view
        self.animations = animations
        self.mode = mode
    }

    deinit { perform { } }

    internal func perform(completionHandler: @escaping () -> Void) {
        guard self.isValid else { return }
        self.isValid.toggle()
        switch mode {
        case .inSequence:
            view?.performAnimations(animations,
                                    completionHandler: completionHandler)
        case .inParallel:
            view?.performAnimationsInParallel(animations,
                                              completionHandler: completionHandler)
        }
    }
}
