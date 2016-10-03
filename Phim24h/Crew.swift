//
//  Crew.swift
//  Phim24h
//
//  Created by Chung on 10/3/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Crew {
    
    
    //    "credit_id": "57898296c3a368365d004bb4",
    //    "department": "Crew",
    //    "id": 1403508,
    //    "job": "Transportation Coordinator",
    //    "name": "James G. Brill",
    //    "profile_path": null
    
    var credit_id: String?
    var department: String?
    var id: Int?
    var job: String?
    var name: String?
    var profile_path: String?
    
    init(_ json: JSON) {
        
        credit_id = json[.credit_id]
        department = json[.department]
        id = json[.id]
        job = json[.job]
        name = json[.name]
        profile_path = json[.profile_path]
    }
}
