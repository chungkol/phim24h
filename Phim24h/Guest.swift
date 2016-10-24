//
//  Guest.swift
//  Phim24h
//
//  Created by Chung on 10/21/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Guest {
    
    var success: Bool?
    var guest_session_id: String?
    var expires_at: String?
    
    
    init?(JSon : AnyObject) {
        guard let success = JSon["success"] as? Bool else {
            return nil
        }
        guard let guest_session_id = JSon["guest_session_id"] as? String else {
            return nil
        }
        guard let expires_at = JSon["expires_at"] as? String else {
            return nil
        }
        
        self.success = success
        self.guest_session_id = guest_session_id
        self.expires_at = expires_at
    }
    
}
