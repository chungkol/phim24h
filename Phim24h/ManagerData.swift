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
    static let SESSION_ID = "b3f02cec306e8d3bb6a272b7e9433640f97b533a"
    static let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?language=en-US"
    static let POPULAR = "https://api.themoviedb.org/3/movie/popular?language=en-US"
    static let UPCOMING = "https://api.themoviedb.org/3/movie/upcoming?language=en-US"
    static let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?language=en-US"
    static let GENRE = "https://api.themoviedb.org/3/genre/movie/list?language=en-US"
    static let FILM_WITH_GENRE = "https://api.themoviedb.org/3/genre/"
    static let GET_ALL_INFO_WITH_ID = "https://api.themoviedb.org/3/movie/"
    static let SEARCH_MOVIE = "https://api.themoviedb.org/3/search/movie?language=en-US"
    static let SEARCH_PEOPLE = "https://api.themoviedb.org/3/search/person?language=en-US"
    static let CREATE_GUEST_ID = "https://api.themoviedb.org/3/authentication/guest_session/new"
    
    static let instance = ManagerData()
    
    fileprivate var list_Top_Rated : [Film] = []
    fileprivate var list_Popular : [Film] = []
    fileprivate var list_Up_Coming : [Film] = []
    fileprivate var list_Now_Playing : [Film] = []
    fileprivate var list_genres: [Genre] = []
    fileprivate var list_Film_With_Genre: [Film] = []
    fileprivate var list_Trailer: [Trailer] = []
    fileprivate var list_Image: [Backdrop] = []
    fileprivate var list_cast: [Cast] = []
    fileprivate var list_crew: [Crew] = []
    fileprivate var list_similar: [Film] = []
    fileprivate var detail_Movies: MovieDetail!
    fileprivate var list_Search: [Film] = []
    fileprivate var list_Cast: [Cast] = []
    var page: Int!
    
    private var guest: Guest!
    fileprivate init() {
        
    }
    
    
    
    
    //singleton
    
    func rateForMovie(movie_ID: Int, guest_session_id: String,value: Int, completetion:@escaping (Result) -> ())
    {
        rateMovie(movie_ID, guest_session_id: guest_session_id,value: value, completetion: { [unowned self] (result) in
            
            completetion(result)
            })
    }
    
    func createAccountGuest(completetion:@escaping (Guest)->())
    {
        createGuest(completetion: { [unowned self] result in
            self.guest = result
            completetion(result)
            })
    }
    
    
    func getListSearchMovie(_ page: Int,query: String,
                            completetion:@escaping ([Film])->())
    {
        
        searchMovie(page, query: query, completetion: { [unowned self] films in
            //            self.list_Search = films
            completetion(films)
            })
        
    }
    func getListSearchPeople(_ page: Int,query: String,
                             completetion:@escaping ([Cast])->())
    {
        
        searchPeople(page, query: query, completetion: { [unowned self] casts in
            //            self.list_Cast = casts
            completetion(casts)
            })
        
    }
    
    
    
    
    func getAllMovieDetail(_ movie_ID: Int,
                           completetion:@escaping (MovieDetail)->())
    {
        
        getMovieDetail(movie_ID, completetion: { [unowned self] movieDetails in
            self.detail_Movies = movieDetails
            completetion(movieDetails)
            })
        
    }
    func getAllMovieSimilar(_ page: Int, movie_ID: Int,
                            completetion:@escaping ([Film])->())
    {
        self.page = page
        getMovieSimilar(page, movie_ID: movie_ID, completetion: { [unowned self] films in
            self.list_similar = films
            completetion(films)
            })
        
    }
    
    func getAllCrew(_ movie_id: Int, completetion: @escaping ([Crew])->()) {
        
        getCrew(movie_id, completetion: { [unowned self] results in
            self.list_crew = results
            completetion(results)
            })
    }
    func getAllCast(_ movie_id: Int, completetion: @escaping ([Cast])->()) {
        
        getCast(movie_id, completetion: { [unowned self] results in
            self.list_cast = results
            completetion(results)
            })
    }
    
    //lấy list ảnh theo id
    func getAllImageWithID(_ movie_id: Int, completetion: @escaping ([Backdrop])->()) {
        getImageWithID(movie_id, completetion: { [unowned self] backdrops in
            self.list_Image = backdrops
            completetion(backdrops)
            })
    }
    
    
    // lấy danh sách video theo id
    func getAllVideoWithID(_ movie_id: Int, completetion: @escaping ([Trailer])->()) {
        getVideoWithID(movie_id, completetion: { [unowned self] trailers in
            self.list_Trailer = trailers
            completetion(trailers)
            })
    }
    
    //lấy film theo từng thể loại
    
    func getAllFilmWithGenre(_ genre_id: Int, completetion:@escaping ([Film])->())
    {
        getFilmWithGenre(genre_id, completetion: { [unowned self] films in
            self.list_Film_With_Genre = films
            completetion(films)
            })
        
    }
    
    
    // lấy ra tên thể loại film
    func getAllGenre(_ completetion: @escaping ([Genre])->()) {
        if list_genres.count == 0  {
            getGenres({ [unowned self] genres in
                self.list_genres = genres
                completetion(genres)
                })
        }else{
            completetion(list_genres)
        }
    }
    
    
    
    //get lish film now playing
    func getListMovieForPullToRefresh(_ page: Int,type: String,
                                      completetion:@escaping ([Film])->())
    {
        self.page = page
        getFilms(page, type: type, completetion: { [unowned self] films in
            completetion(films)
            })
        
    }
    
    
    func getTopRated(_ page: Int,type: String,
                     completetion:@escaping ([Film])->())
    {
        self.page = page
        if (list_Top_Rated.count == 0)
        {
            getFilms(page, type: type, completetion: { [unowned self] films in
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
    func getPopular(_ page: Int,type: String,
                    completetion:@escaping ([Film])->())
    {
        self.page = page
        if (list_Popular.count == 0)
        {
            getFilms(page, type: type, completetion: { [unowned self] films in
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
    func getUpComing(_ page: Int,type: String,
                     completetion:@escaping ([Film])->())
    {
        self.page = page
        if (list_Up_Coming.count == 0)
        {
            getFilms(page, type: type, completetion: { [unowned self] films in
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
    func getNowPlaying(_ page: Int,type: String,
                       completetion:@escaping ([Film])->())
    {
        self.page = page
        if (list_Now_Playing.count == 0)
        {
            getFilms(page, type: type, completetion: { [unowned self] films in
                self.list_Now_Playing = films
                completetion(films)
                })
        }
        else
        {
            completetion(list_Now_Playing)
        }
    }
    fileprivate func getFilms(_ page: Int, type: String,
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
    fileprivate func getGenres(_ completetion: @escaping ([Genre])->()) {
        
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        
        Alamofire.request(ManagerData.GENRE, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["genres"].map(Genre.init)
                    completetion(results)
                    
                }
        }
        
    }
    fileprivate func getFilmWithGenre(_ genre_id: Int, completetion: @escaping ([Film])->()) {
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
    fileprivate func getVideoWithID(_ movie_ID: Int, completetion: @escaping ([Trailer])->()) {
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
    fileprivate func getImageWithID(_ movie_ID: Int, completetion: @escaping ([Backdrop])->()) {
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
    
    fileprivate func getCrew(_ movie_ID: Int, completetion: @escaping ([Crew])->()) {
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
    
    fileprivate func getCast(_ movie_ID: Int, completetion: @escaping ([Cast])->()) {
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
    private func getMovieSimilar(_ page: Int, movie_ID: Int, completetion: @escaping ([Film])->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)/similar"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY,
                                      "page": page]
        Alamofire.request(path, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Film.init)
                    completetion(results)
                    
                }
        }
        
    }
    private func getMovieDetail(_ movie_ID: Int, completetion: @escaping (MovieDetail)->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(path, parameters: parameters).responseJSON(completionHandler: {response in
            if let json = response.result.value {
                let movie = MovieDetail.init(JSon: json as AnyObject)
                completetion(movie!)
                
                
            }
            
        })
        
    }
    private func searchMovie(_ page: Int, query: String, completetion: @escaping ([Film])->()) {
        let parameters: Parameters = ["api_key": ManagerData.API_KEY,"query": query,
                                      "page": page]
        Alamofire.request(ManagerData.SEARCH_MOVIE, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Film.init)
                    completetion(results)
                    
                }
        }
        
    }
    private func searchPeople(_ page: Int, query: String, completetion: @escaping ([Cast])->()) {
        let parameters: Parameters = ["api_key": ManagerData.API_KEY,"query": query,
                                      "page": page]
        Alamofire.request(ManagerData.SEARCH_PEOPLE, parameters: parameters).responseJASON
            {response in
                
                if let json = response.result.value {
                    let results = json["results"].map(Cast.init)
                    completetion(results)
                    
                }
        }
        
    }
    private func createGuest(completetion: @escaping (Guest)->()) {
        let parameters: Parameters = ["api_key": ManagerData.API_KEY]
        Alamofire.request(ManagerData.CREATE_GUEST_ID, parameters: parameters).responseJSON(completionHandler: {response in
            if let json = response.result.value {
                let guest = Guest.init(JSon: json as AnyObject)
                completetion(guest!)
            }
            
        })
        
    }
    fileprivate func rateMovie(_ movie_ID: Int,guest_session_id: String,value: Int, completetion: @escaping (Result)->()) {
        let path = "\(ManagerData.GET_ALL_INFO_WITH_ID)\(movie_ID)/rating"
        let parameters: Parameters = ["api_key": ManagerData.API_KEY, "guest_session_id": guest_session_id, "session_id": ManagerData.SESSION_ID, "value" : value]
        Alamofire.request(path, method: .post, parameters: parameters).responseJSON(completionHandler: { response in
            
            
            if let json = response.result.value {
                let result = Result.init(JSon: json as AnyObject)
                completetion(result!)
            }
            
        })
        
    }
    
    
    //
    
}

//if let data = json as? [AnyObject] {
//    for catJSON in data {
//        let categoryObj = catJSON as! [String : AnyObject]
//        let category = CategoryStory.init(JSON: categoryObj)
//        self.getStory(idCategory: (category?.idCategory)!) //-- get ID3333
//        self.catogoryList.append(category!)
//    }
//
//}




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
    public func responseJASON(_ completionHandler: @escaping (DataResponse<JASON.JSON>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.JASONReponseSerializer(), completionHandler: completionHandler)
    }
    
}
