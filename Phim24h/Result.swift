//
//  Result.swift
//  Phim24h
//
//  Created by Chung on 10/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Result {
    
    var status_code: Int?
    var status_message: String?
    
    init?(JSon : AnyObject) {
        guard let status_code = JSon["status_code"] as? Int else {
            return nil
        }
        guard let status_message = JSon["status_message"] as? String else {
            return nil
        }
        
        
        self.status_code = status_code
        self.status_message = status_message
    }
    
}
