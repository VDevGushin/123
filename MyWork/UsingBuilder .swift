//
//  UsingBuilder .swift
//  MyWork
//
//  Created by Vladislav Gushin on 31/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate class ArticleView: UIView {
    let titleLabel: String?
    let subtitleLabel: String?
    let image: UIImage?
    init(title: String?, subtitle: String?, image: UIImage?) {
        self.titleLabel = title
        self.subtitleLabel = subtitle
        self.image = image
        super.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate class ArticleViewBuilder {
    var titleLabel: String?
    var subtitleLabel: String?
    var image: UIImage?

    @discardableResult
    func withTitle(_ string: String) -> ArticleViewBuilder {
        self.titleLabel = string
        return self
    }

    @discardableResult
    func withSubtitle(_ string: String) -> ArticleViewBuilder {
        self.titleLabel = string
        return self
    }

    @discardableResult
    func withImage(_ image: UIImage) -> ArticleViewBuilder {
        self.image = image
        return self
    }

    func build() -> ArticleView {
        return ArticleView(title: self.titleLabel, subtitle: self.subtitleLabel, image: self.image)
    }
}

fileprivate struct TestBuilder {
    func test() {
        _ = ArticleView(title: "test", subtitle: "test", image: UIImage())
        //We wont to use
        _ = ArticleViewBuilder()
            .withTitle("test")
            .withSubtitle("subtitle")
            .withImage(UIImage())
            .build()
    }
}

//MARK: - Simple
class AttributedStringBuilder {
    typealias Attributes = [NSAttributedString.Key: Any]

    private let string = NSMutableAttributedString(string: "")

    // We follow the convention of returning the builder object
    // itself from any configuration methods, and by adding the
    // @discardableResult attribute we won't get warnings if we
    // don't end up doing any chaining.
    @discardableResult
    func append(_ character: Character,
                attributes: Attributes) -> AttributedStringBuilder {
        let addedString = NSAttributedString(
            string: String(character),
            attributes: attributes
        )

        string.append(addedString)

        return self
    }

    func build() -> NSAttributedString {
        return NSAttributedString(attributedString: string)
    }
}

//MARK: - Hiding complexity
fileprivate class Record { }

fileprivate class Query<T> {
    private var operations: [QueryOperation<T>]
    init(operations: [QueryOperation<T>]) {
        self.operations = operations
    }
}
fileprivate class QueryOperation<Record> {
    init(_ c: @autoclosure () -> QueryOperationType) {}
}

fileprivate enum QueryOperationType {
    case match(String)
    case addLimit(Int)
}

fileprivate class QueryBuilder<Record> {
    private var operations = [QueryOperation<Record>]()

    @discardableResult
    func matchRecords(with string: String) -> QueryBuilder<Record> {
        //operations.append(["asdf": 1])
        //operations.append([.match(string)])
        return self
    }

    @discardableResult
    func limitNumberOfResults(to count: Int) -> QueryBuilder<Record> {
        //operations.append(["asdf": 1])
        //operations.append(.addLimit(count))
        return self
    }
//
//    @discardableResult
//    func filterByKey<T: Equatable>(_ keyPath: KeyPath<Record, T>, value: T) -> QueryBuilder<Record> {
//        operations.append(.filter { record in
//            return record[keyPath: keyPath] == value
//        })
//        return self
//    }

    func build() -> Query<Record> {
        return Query(operations: self.operations)
    }
}
