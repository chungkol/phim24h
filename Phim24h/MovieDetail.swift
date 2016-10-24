//
//  MovieDetail.swift
//  Phim24h
//
//  Created by Chung on 10/5/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation

struct MovieDetail {
    
    var budget: Double?
    var release_date: String?
    var revenue: Double?
    var runtime: Int?
    
    init?(JSon : AnyObject) {
        guard let budget = JSon["budget"] as? Double else {
            return nil
        }
        guard let release_date = JSon["release_date"] as? String else {
            return nil
        }
        guard let revenue = JSon["revenue"] as? Double else {
            return nil
        }
        
        guard let runtime = JSon["runtime"] as? Int else {
            return nil
        }
        
        self.budget = budget
        self.release_date = release_date
        self.revenue = revenue
        self.runtime = runtime
    }
    
    
    
}
