//
//  BuilderPattern.swift
//  SwiftBySundell
//
//  Created by Vladislav Gushin on 14/12/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate final class ArcticleView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

fileprivate class Article {
    let title: String = ""
    let subtitle: String = ""
    let image: UIImage = UIImage(contentsOfFile: "123")!
}

fileprivate func test() {
    let article = Article()
    let view = ArcticleView()
    view.titleLabel.text = article.title
    view.subtitleLabel.text = article.subtitle
    view.imageView.image = article.image
}

/*Давайте теперь попробуем использовать шаблон построителя вместо этого. Вместо того, чтобы обращаться к подпредставлениям ArticleView,
 мы будем использовать ArticleViewBuilder, чтобы установить все необходимые нам свойства с помощью последовательности вызовов метода,
 и затем мы закончим, вызывая build () для создания экземпляра - вот так: Давайте теперь попытайтесь использовать шаблон строителя вместо этого.
 Вместо того, чтобы обращаться к подпредставлениям ArticleView,
 мы будем использовать ArticleViewBuilder, чтобы установить все необходимые нам свойства через серию связанных вызовов методов,
 а затем мы закончим, вызывая build () для создания экземпляра - например, так:
 */

fileprivate class TextDrawingViewController {
    private var text: NSMutableAttributedString!

    private func appendCharacter(_ character: Character) {
        let string = NSAttributedString(string: String(character), attributes: [:])
        text.append(string)
    }

    private func handleSaveButtonTap() {
        //save(text)
    }
}

//Реализуем билдер
final class AttributedStringBuilder {
    typealias Attributes = [NSAttributedString.Key: Any]

    private let string = NSMutableAttributedString(string: "")

    @discardableResult
    func append(_ character: Character, attributes: Attributes) -> AttributedStringBuilder {
        let appendingString = NSAttributedString(string: String(character), attributes: attributes)
        self.string.append(appendingString)
        return self
    }

    func build() -> NSAttributedString {
        return NSAttributedString(attributedString: self.string)
    }
}
//Используем билдер
fileprivate class TextDrawingViewControllerAttributed {
    private let textBuilder = AttributedStringBuilder()

    private func appendCharacter(_ character: Character) {
        textBuilder.append(character, attributes: [:])
    }

    private func handleSaveButtonTap() {
        let text = textBuilder.build()
        print(text)
    }
}
