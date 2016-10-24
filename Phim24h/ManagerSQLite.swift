//
//  ManagerSQLite.swift
//  Phim24h
//
//  Created by Chung on 10/12/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import SQLite
class ManagerSQLite : NSObject {
    static let shareInstance = ManagerSQLite()
    static let PATH = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    static let DB_NAME = "manager.sqlite3"
    
    
    
    
    let id = Expression<Int>("id")
    let poster_path = Expression<String?>("poster_path")
    let adult = Expression<Bool?>("adult")
    let overview = Expression<String?>("overview")
    let release_date = Expression<String?>("release_date")
    let genre_ids = Expression<String?>("genre_ids")
    let original_title = Expression<String?>("original_title")
    let original_language = Expression<String?>("original_language")
    let title = Expression<String?>("title")
    let backdrop_path = Expression<String?>("backdrop_path")
    let popularity = Expression<Double?>("popularity")
    let vote_count = Expression<Int?>("vote_count")
    let video = Expression<Bool?>("video")
    let vote_average = Expression<Double?>("vote_average")
    var db: Connection! = nil
    private override init() {
        
    }
    
    func connectDatabase() throws {
        db = try! Connection("\(ManagerSQLite.PATH)//\(ManagerSQLite.DB_NAME)")
        print(ManagerSQLite.PATH)
        try! db.execute("PRAGMA foreign_keys = ON;")
        db.trace( { (info) in
            print(info)
        })
        
    }
    
    func createTable(table_name: String) throws {
        let films = Table(table_name)
        if db != nil {
            try! db.run(films.create(ifNotExists: true)  { t in
                t.column(id, primaryKey: true)
                t.column(poster_path)
                t.column(adult)
                t.column(overview)
                t.column(release_date)
                t.column(genre_ids)
                t.column(original_title)
                t.column(original_language)
                t.column(title)
                t.column(backdrop_path)
                t.column(popularity)
                t.column(vote_count)
                t.column(video)
                t.column(vote_average)
            })
            
        }
        
        
    }
    
    func insertValues(film: Film, table_name: String) throws -> Bool {
        try createTable(table_name: table_name)
        let table = Table(table_name)
        if db != nil {
            
            let insertValues = table.insert(id <- film.id!, poster_path <- film.poster_path, adult <- film.adult, overview <- film.overview, release_date <- film.release_date, genre_ids <- self.convertArrToString(arr: film.genre_ids as! [Int]), original_title <- film.original_title, original_language <- film.original_language, title <- film.title, backdrop_path <- film.backdrop_path, popularity <- film.popularity, vote_count <- film.vote_count, video <- film.video, vote_average <- film.vote_average  )
            try db.run(insertValues)
            return true
        }else {
            return false
        }
        
    }
    func getAllFavorite(table_name: String) throws -> [Film]
    {
        let table = Table(table_name)
        var datas: [Film] = []
        if db != nil {
            for value in try db.prepare(table) {
                var item: Film = Film()
                item.id = value[id]
                item.poster_path = value[poster_path]
                item.adult = value[adult]
                item.overview = value[overview]
                item.release_date = value[release_date]
                item.genre_ids = convertStringToArr(text: value[genre_ids]!) as NSArray?
                item.original_title = value[original_title]
                item.original_language = value[original_language]
                item.title = value[title]
                item.backdrop_path = value[backdrop_path]
                item.popularity = value[popularity]
                item.vote_count = value[vote_count]
                item.video = value[video]
                item.vote_average = value[vote_average]
                
                datas.append(item)
                
            }
            
        }
        
        return datas
        
    }
    
    
    
    
    func convertArrToString(arr: [Int]) -> String {
        var result = ""
        for value in arr {
            result += "\(value),"
        }
        return result
    }
    func convertStringToArr(text: String) -> [Int] {
        var result: [Int] = []
        var temp = text.characters.split{$0 == ","}
        for (index,value) in temp.enumerated()  {
//            if value != nil {
//                temp.remove(at: index)
//            }
            result.append(Int(String(value))!)
        }
        
        return result
    }
    
    
}
