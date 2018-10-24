//
//  DelegateCall.swift
//  SupportLib
//
//  Created by Vladislav Gushin on 24/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import Foundation

public struct DelegatedCall<Input> {
    private(set) var callback: ((Input) -> Void)?

    public var execute: ((Input) -> Void)? {
        return callback
    }

    public mutating func delegate<T>(to object: T, with callback: @escaping (T, Input) -> Void) where T: AnyObject {
        self.callback = { [weak object] input in
            guard let object = object else { return }
            callback(object, input)
        }
    }
    public init() { }
}
/*
 class ImageDownloader {
 var didDownload = DelegatedCall<UIImage>()
 func downloadImage(for url: URL) {
    download(url: url) { image in
        self.didDownload.callback?(image)
    }
 }
}
 */
