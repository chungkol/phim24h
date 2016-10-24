//
//  Account.swift
//  Phim24h
//
//  Created by Chung on 9/19/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
class User: NSObject {
    var email: String?
    var url_image: URL?
    var type: String!
    var uid: String!
    init(email: String?, url_image: URL?, type: String , uid: String) {
        self.email = email
        self.url_image = url_image
        self.type = type
        self.uid = uid
    }
}
