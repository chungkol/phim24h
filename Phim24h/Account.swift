//
//  Account.swift
//  Phim24h
//
//  Created by Chung on 9/19/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
class Account: NSObject {
    var email: String!
    var password: String!
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
