//
//  Genre.swift
//  Phim24h
//
//  Created by Chung on 9/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Genre {
    var id: Int!
    var name: String!
    
    init(_ json: JSON) {
        
        id = json[.id]
        name = json[.name]
    }
}



