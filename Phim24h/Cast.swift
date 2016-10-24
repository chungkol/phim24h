//
//  Cast.swift
//  Phim24h
//
//  Created by Chung on 10/3/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import JASON
struct Cast {
    
    
    //    "cast_id": 5,
    //    "character": "Andrew Neimann",
    //    "credit_id": "52fe4ef7c3a36847f82b3fc3",
    //    "id": 996701,
    //    "name": "Miles Teller",
    //    "order": 0,
    //    "profile_path": "/g9DoeCHyn2C110gHbnh6nrD08Id.jpg"
    var adult: Bool?
    var popularity : Double?
    var known_for: [Film]?
    var cast_id: Int?
    var character: String?
    var credit_id: String?
    var id: Int?
    var name: String?
    var order : Int?
    var profile_path: String?
    
    
    
    init(_ json: JSON) {
        
        adult = json[.adult]
        popularity = json[.popularity]
        if json[.known_for] != nil {
            known_for = getFilms(array: ((json[.known_for])))
        }
        
        cast_id = json[.cast_id]
        character = json[.character]
        credit_id = json[.credit_id]
        id = json[.id]
        name = json[.name]
        order = json[.order]
        profile_path = json[.profile_path]
    }
    func getFilms(array: NSArray?) -> [Film]?
    {
        var films = [Film]()
        if array != nil {
            for film in array!
            {
                films.append(Film(JSON(film)))
            }
            return films
        }
        else {
            return nil
        }
    }
}
