//
//  NamespacingAndNestedTypes.swift
//  MyWork
//
//  Created by Vladislav Gushin on 16/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
import Unbox
extension String {
    func formatted(withOptions options: Set<String>) -> String {
        return self
    }
    func formatted(withOptions options: Set<PostWithNested.TextFormatter.Option>) -> String {
        return self
    }
}

//Вот обычная несвязанная структура
fileprivate enum PostTextFormatterOption {
    case highlightNames
    case highlightLinks
}

struct Group: Hashable { }
enum Permission: Hashable {
    enum Status { }
    case comments
}

class User: Unboxable, Savable {
    var isFriend = false
    var firstName: String?
    var profileImage: UIImage?
    var lastName: String?
    var groups: Set<Group>?
    var permissions: Set<Permission>?
    required init(unboxer: Unboxer) throws {
    }

    init() { }
}

fileprivate struct Post {
    var id: Int
    var author: User
    var title: String
    var text: String
}

fileprivate class PostTextFormatter {
    private let options: Set<String>
    var post = Post(id: 2, author: User(), title: "", text: "I")
    init(options: Set<String>) {
        self.options = options
    }

    func formatTitle(for post: Post) -> String {
        return post.title.formatted(withOptions: options)
    }

    func formatText(for post: Post) -> String {
        return post.text.formatted(withOptions: options)
    }
}


//Свяжем эти данные
struct PostWithNested {
    let id: Int
    let author: User
    let title: String
    let text: String
}

extension PostWithNested {
    class TextFormatter {
        private let options: Set<Option>

        init(options: Set<Option>) {
            self.options = options
        }

        func formatTitle(for post: PostWithNested) -> String {
            return post.title.formatted(withOptions: options)
        }

        func formatText(for post: PostWithNested) -> String {
            return post.text.formatted(withOptions: options)
        }
    }
}

extension PostWithNested.TextFormatter {
    enum Option {
        case highlightNames
        case highlightLinks
    }
}

fileprivate class TestPostWithNested {
    func test() {
        let post = PostWithNested(id: 1, author: User(), title: "g", text: "g")
        let formatter = PostWithNested.TextFormatter(options: [.highlightLinks])
        let _ = formatter.formatText(for: post)
    }
}
