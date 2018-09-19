//
//  ModelСontrollers.swift
//  MyWork
//
//  Created by Vladislav Gushin on 20/08/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

private struct Post {
    var group: Group = Group()
}

private class UserModelController {
    private var user: User
    init(user: User) {
        self.user = user
    }

    func allowComments(on post: Post) -> Bool {
        guard (user.groups?.contains(post.group)) != nil else {
            return false
        }
        if let res = user.permissions?.contains(.comments) {
            return res
        }
        return false
    }
}

extension UserModelController {
    typealias PermissionsClosure = (Permission, Permission.Status) -> Void

    var displayName: String {
        return "\(user.firstName ?? "") \(user.lastName ?? "")"
    }
//    
//    func enumeratePermissions(using closure: PermissionsClosure) {
//        for permission in Permission.allCases {
//            let isGranted = user.permissions.contains(permission)
//            closure(permission, isGranted ? .granted : .denied)
//        }
//    }

}
