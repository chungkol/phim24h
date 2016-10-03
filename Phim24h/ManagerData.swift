//
//  ManagerData.swift
//  Phim24h
//
//  Created by Chung on 9/22/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import Foundation
import Alamofire
import JASON
class ManagerData {
    static let API_KEY = "b7f3fcf9abbb6d309e2a52b55cc8127c"
    static let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?language=en-US"
    static let POPULAR = "https://api.themoviedb.org/3/movie/popular?language=en-US"
    static let UPCOMING = "https://api.themoviedb.org/3/movie/upcoming?language=en-US"
    static let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?language=en-US"
    static let GENRE = "https://api.themoviedb.org/3/genre/movie/list?language=en-US"
    static let FILM_WITH_GENRE = "https://api.themoviedb.org/3/genre/"
    static let GET_ALL_INFO_WITH_ID = "https://api.themoviedb.org/3/movie/"
    //    static let GET_ALL_IMAGE_WITH_ID = "https://api.themoviedb.org/3/movie/"
    
    static let instance = ManagerData()
    
    private var list_Top_Rated : [Film] = []
    private var list_Popular : [Film] = []
    private var list_Up_Coming : [Film] = []
    private var list_Now_Playing : [Film] = []
    private var list_genres: [Genre] = []
    private var list_Film_With_Genre: [Film] = []
    private var list_Trailer: [Trailer] = []
    private var list_Image: [Backdrop] = []
    private var list_cast: [Cast] = []
    private var list_crew: [Crew] = []
    
    var pageTopRated = 1
    var pagePopular = 1
    var pageUpComing = 1
    var pageNowPlaying = 1
    private init() {
        
    }
    
    
    
    //singleton
    
    func getAllCrew(movie_id: Int, completetion: @escaping ([Crew])->()) {
        
        getCrew(movie_ID: movie_id, completetion: { [unowned self] results in
            self.list_crew = results
            completetion(results)
            })
    }
    func getAllCast(movie_id: Int, completetion: @escaping ([Cast])->()) {
        
        getCast(movie_ID: movie_id, completetion: { [unowned self] results in
            self.list_cast = results
            completetion(results)
            })
    }
    
    //lấy list ảnh theo id
    func getAllImageWithID(movie_id: Int, completetion: @escaping ([Backdrop])->()) {
        
        getImageWithID(movie_ID: movie_id, completetion: { [unowned self] backdrops in
            self.list_Image = backdrops
            completetion(backdrops)
            })
    }
    
    
    // lấy danh sách video theo id
    func getAllVideoWithID(movie_id: Int, completetion: @escaping ([Trailer])->()) {
        
        getVideoWithID(movie_ID: movie_id, completetion: { [unowned self] trailers in
            self.list_Trailer = trailers
            completetion(trailers)
            })
        
    }
    
    //lấy film theo từng thể loại
    
    func getAllFilmWithGenre(genre_id: Int, completetion:@escaping ([Film])->())
    {
        
        getFilmWithGenre(genre_id: genre_id, completetion: { [unowned self] films in
            self.list_Film_With_Genre = films
            completetion(films)
            })
        
    }
    
    
    // lấy ra tên thể loại film
    func getAllGenre(completetion: @escaping ([Genre])->()) {
        if list_genres.count == 0  {
            getGenres(completetion: { [unowned self] genres in
                self.list_genres = genres
                completetion(genres)
                
                })
        }else{
            completetion(list_genres)
        }
    }
    
    
    //get list film top rated
    func getTopRated(page: Int,type: String,
                     completetion:@escaping ([Film])->())
    {
        if (list_Top_Rated.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Top_Rated = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Top_Rated)
        }
    }
    
    //get lish film popular
    func getPopular(page: Int,type: String,
                    completetion:@escaping ([Film])->())
    {
        if (list_Popular.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Popular = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Popular)
        }
    }
    
    //get list film up coming
    func getUpComing(page: Int,type: String,
                     completetion:@escaping ([Film])->())
    {
        if (list_Up_Coming.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Up_Coming = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Up_Coming)
        }
    }
    
    //get lish film now playing
    func getNowPlaying(page: Int,type: String,
                       completetion:@escaping ([Film])->())
    {
        if (list_Now_Playing.count == 0)
        {
            getFilms(page: page, type: type, completetion: { [unowned self] films in
                self.list_Now_Playing = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Now_Playing)
        }
    }
    
    private func getFilms(page: Int, type: String,
                          completetion:@escaping ([Film])->()){
        let parameters: Parameters = ["api_key": ManagerData.API_KEY,
                                      "page": page]
        
        Alamofire.request(type, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Film.init)
                    completetion(results)
                }
        }
    }
    
    //get genre of film
    private func getGenres(completetion: @escaping ([Genre])->()) {
        
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        
        Alamofire.request(ManagerData.GENRE, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["genres"].map(Genre.init)
                    completetion(results)
                    
                }
        }
        
    }
    private func getFilmWithGenre(genre_id: Int, completetion: @escaping ([Film])->()) {
        let path = "\(ManagerData.FILM_WITH_GENRE)\(genre_id)/movies?language=en-US&sort_by=created_at.asc"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(path, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Film.init)
                    completetion(results)
                    
                }
        }
        
    }
    private func getVideoWithID(movie_ID: Int, completetion: @escaping ([Trailer])->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)/videos"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(path, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Trailer.init)
                    completetion(results)
                    
                }
        }
        
    }
    private func getImageWithID(movie_ID: Int, completetion: @escaping ([Backdrop])->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)/images"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(path, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["backdrops"].map(Backdrop.init)
                    completetion(results)
                    
                }
        }
        
    }
    
    private func getCrew(movie_ID: Int, completetion: @escaping ([Crew])->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)/credits"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(path, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["crew"].map(Crew.init)
                    completetion(results)
                   
                }
        }
        
    }
    
    private func getCast(movie_ID: Int, completetion: @escaping ([Cast])->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)/credits"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(path, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["cast"].map(Cast.init)
                    completetion(results)
                   
                }
        }
        
    }
    
    
    
}


extension DataRequest {
    /**
     Creates a response serializer that returns a JASON.JSON object constructed from the response data.
     
     - returns: A JASON.JSON object response serializer.
     */
    static public func JASONReponseSerializer() -> DataResponseSerializer<JASON.JSON> {
        return DataResponseSerializer { _, _, data, error in
            guard error == nil else { return .failure(error!) }
            
            return .success(JASON.JSON(data))
        }
    }
    
    /**
     Adds a handler to be called once the request has finished.
     
     - parameter completionHandler: A closure to be executed once the request has finished.
     
     - returns: The request.
     */
    @discardableResult
    public func responseJASON(completionHandler: @escaping (DataResponse<JASON.JSON>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.JASONReponseSerializer(), completionHandler: completionHandler)
    }
    
}
