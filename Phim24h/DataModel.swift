//
//  DataModel.swift
//  Phim24h
//
//  Created by Chung on 9/24/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
class DataModel {
    var title: String!
    var key: String!
    var datas: [Film]!
    
    init(title: String , key: String , datas : [Film]) {
        self.title = title
        self.key = key
        self.datas = datas
    }
}
