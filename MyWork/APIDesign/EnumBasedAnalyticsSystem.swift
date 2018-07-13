//
//  EnumBasedAnalyticsSystem.swift
//  MyWork
//
//  Created by Vladislav Gushin on 13/07/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

enum LoginFailureReason { }
enum AnaliticsEvent {
    case loginScreenViewed
    case loginAttemped
    case loginFailed(reason: LoginFailureReason)
    case loginSuccess
    case messageSelected(index: Int)
    case messageDeleted(index: Int, read: Bool)
}

protocol AnalyticsEngine: class {
    func sendAnalyticsEvent(named name: String, metadata: [String: String])
}

class CKDatabase {
    static let sharedInstance = CKDatabase()
    func save() { }
}
class CKRecord {
    var t = "test"
    init(recordType: String) { }
    subscript(value: String) -> String {
        get {
            return t
        }
        set {
            t = newValue
        }
    }
}

class CloudKitAnalyticsEngine: AnalyticsEngine {
    private let database: CKDatabase
    init(dataBase: CKDatabase = .sharedInstance) {
        self.database = dataBase
    }

    func sendAnalyticsEvent(named name: String, metadata: [String: String]) {
        let record = CKRecord(recordType: "AnalyticsEvent.\(name)")
        for (key, value) in metadata {
            record[key] = value
        }
        database.save()
    }
}
