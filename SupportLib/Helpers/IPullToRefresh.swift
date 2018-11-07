//
//  IPullToRefresh.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 07/11/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit

@objc public protocol IPullToRefresh {
    @objc func handleRefresh(_ refreshControl: UIRefreshControl)
}
