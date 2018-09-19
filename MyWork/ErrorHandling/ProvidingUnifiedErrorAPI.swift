//
//  ProvidingUnifiedErrorAPI.swift
//  MyWork
//
//  Created by Vladislav Gushin on 23/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation
private enum SearchError: Error {
    case invalidQuery(String)
    case dataLoadingFailed(URL)
}

///First
private func loadSearchData1(matching query: String) throws -> Data {
    let urlString = "https://my.api.com/search?q=\(query)"

    guard let url = URL(string: urlString) else {
        throw SearchError.invalidQuery(query)
    }

    return try Data(contentsOf: url)
}

//Second
func loadSearchData2(matching query: String) throws -> Data {
    let urlString = "https://my.api.com/search?q=\(query)"

    guard let url = URL(string: urlString) else {
        throw SearchError.invalidQuery(query)
    }

    do {
        return try Data(contentsOf: url)
    } catch {
        throw SearchError.dataLoadingFailed(url)
    }
}

//Make perform
func perform<T>(_ expression: @autoclosure () throws -> T,
                orThrow err: Error?) throws -> T {
    do {
        return try expression()
    } catch {
        throw err ?? error
    }
}

func loadSearchData(matching query: String) throws -> Data {
    let urlString = "https://my.api.com/search?q=\(query)"

    guard let url = URL(string: urlString) else {
        throw SearchError.invalidQuery(query)
    }

    try perform(testTTT(1), orThrow: nil)
    
    return try perform(Data(contentsOf: url),
                       orThrow: SearchError.dataLoadingFailed(url))
    
}

enum T: Error {
    case t
}
func testTTT(_ a: Int) throws {
    throw T.t
}
