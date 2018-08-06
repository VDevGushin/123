//
//  PowerOfSet.swift
//  MyWork
//
//  Created by Vladislav Gushin on 06/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

fileprivate struct UserWithSet {
    var friendIDs = Set<UUID>()

    //variant 1
    func hasFriendsInCommon1(with otherUser: UserWithSet) -> Bool {
        for id in friendIDs {
            if otherUser.friendIDs.contains(id) {
                return true
            }
        }
        return false
    }

    //variant 2
    func hasFriendsInCommon2(with otherUser: UserWithSet) -> Bool {
        return !friendIDs.isDisjoint(with: otherUser.friendIDs)
    }

    //variant 3
    func hasFriendsInCommon3(with otherUser: UserWithSet) -> Bool {
        return friendIDs.isSubset(of: otherUser.friendIDs)
    }

    //variant 4
    func hasFriendsInCommon4(with otherUser: UserWithSet) -> Set<UUID> {
        return friendIDs.intersection(otherUser.friendIDs)
    }
}

fileprivate class Movie {
    let id: UUID
    init(with id: UUID) {
        self.id = id
    }
}

fileprivate class RatingsManager {
    private typealias Rating = (score: Int, movieID: UUID)
    private var ratings = [Rating]()
    private var movieIDs = Set<UUID>()

    func containsRating(for movie: Movie) -> Bool {
        return movieIDs.contains(movie.id)
    }

    //OLD Когда мы ввели сет id, мы просто работаем с сетом и все
//    func containsRating(for movie: Movie) -> Bool {
//        for rating in self.ratings {
//            if rating.movieID == movie.id {
//                return true
//            }
//        }
//        return false
//    }

    func insertRating(_ score: Int, for movie: Movie) {
        ratings.append((score: score, movieID: movie.id))
        movieIDs.insert(movie.id)
    }
}

//////////////////////////////////////////////////////////////////////Guarding using set
fileprivate protocol ContentLoader { }
fileprivate protocol ContentOperation: AnyObject {
    func prepare()
    func perform(using loader: ContentLoader, then handler: @escaping () -> Void)
}

fileprivate class ContentManager {
    private var prepareOperationIDs = Set<ObjectIdentifier>()

    func perform(_ operation: ContentOperation, with lodader: ContentLoader, then handler: @escaping () -> Void) {
        operation.perform(using: lodader, then: handler)
    }

    private func prepareIfNeeded(_ operation: ContentOperation) {
        let id = ObjectIdentifier(operation)
        guard prepareOperationIDs.insert(id).inserted else { ////!!!
            return
        }
        operation.prepare()
    }
}



