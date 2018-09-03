//
//  FeatureFlags.swift
//  MyWork
//
//  Created by Vladislav Gushin on 03/09/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

//MARK: - using compiler flags
fileprivate class AppDataBase { }
fileprivate final class RealmDatabase: AppDataBase { }
fileprivate final class CoreDataDatabase: AppDataBase { }

fileprivate final class DataBaseFactory {
    func makeDatabase() -> AppDataBase {
        #if DATABASE_REALM //Xcode and add or remove DATABASE_REALM under Swift Compiler - Custom Flags > Active Compilation Conditions
            return RealmDatabase()
        #else
            return CoreDataDatabase()
        #endif
    }
}

//MARK: - Static flags
fileprivate struct FeatureFlags {
    static let searchEnabled = false
    static let maximumNumberOfFavorites = 10
    static let allowLandscapeMode = true
}

//using
fileprivate class SearchResultsViewContoller: UIViewController { }
extension ListViewController {
    func addSearchIfNeeded() {
        guard FeatureFlags.searchEnabled else {
            return
        }
        let resultVC = SearchResultsViewContoller()
        let searchVC = UISearchController(searchResultsController: resultVC)
        searchVC.searchResultsUpdater = resultVC as? UISearchResultsUpdating
        navigationItem.searchController = searchVC
    }
}

//MARK: - Runtime flags
fileprivate struct RuntimeFeatureFlags {
    let searchEnabled: Bool
    let maximumNumberOfFavorites: Int
    let allowLandscapeMode: Bool
}

extension RuntimeFeatureFlags {
    init(dictionary: [String: Any]) {
        searchEnabled = dictionary.value(forKey: "search", defaultValue: false)
        maximumNumberOfFavorites = dictionary.value(forKey: "favorites", defaultValue: 10)
        allowLandscapeMode = dictionary.value(forKey: "landscape", defaultValue: true)
    }
}

//using
fileprivate class FavoriteManager {
    private let featuresFlags: RuntimeFeatureFlags
    init(featuresFlags: RuntimeFeatureFlags) {
        self.featuresFlags = featuresFlags
    }

    func canUserAddMoreFavorites(_ user: User) -> Bool {
        let maxCount = featuresFlags.maximumNumberOfFavorites
        return maxCount < 10
    }
}
