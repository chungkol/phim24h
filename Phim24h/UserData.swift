//
//  UserData.swift
//  Phim24h
//
//  Created by Chung on 10/12/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation

class UserData {
    static let instance = UserData()
    var user: User?
    
    private init() {
        
    }
}
