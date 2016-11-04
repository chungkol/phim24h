//
//  SearchView.swift
//  Phim24h
//
//  Created by Chung on 10/18/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class SearchView: BaseDetailViewController {
        
    @IBOutlet weak var table_Search: UITableView!
    @IBOutlet weak var seagment_Search: UISegmentedControl!
    var searchBar: UISearchBar!

    var list_Search_Movie : [Film] = []
    var list_Search_People : [Cast] = []
    var temp: String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        addSearchController()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = ""
        list_Search_People.removeAll()
        list_Search_Movie.removeAll()
        DispatchQueue.main.async {
             self.table_Search.reloadData()
        }
    }
    

    func addSearchController() {
        table_Search.delegate = self
        table_Search.dataSource = self
        table_Search.register(UITableViewCell.self, forCellReuseIdentifier: "CellForSearch")
        seagment_Search.setFontSizeForScope(14)
        if searchBar == nil {
            searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            searchBar.isSearchResultsButtonSelected = true
            searchBar.showsCancelButton = false
            searchBar.backgroundColor = UIColor.clear
            searchBar.delegate = self
            self.navigationItem.titleView = searchBar
        }
    }
    func filterContentForSearch (searchText: String,page: Int, scope: String ) {
        if scope == "movies"{
            ManagerData.instance.getListSearchMovie(1, query: searchText, completetion: { [unowned self] (films) in
                self.list_Search_Movie = films
                DispatchQueue.main.async {
                    self.table_Search.reloadData()
                }
                                })
        }
        if scope == "people"{
            ManagerData.instance.getListSearchPeople(1, query: searchText, completetion: { [unowned self] (casts) in
                self.list_Search_People = casts
                DispatchQueue.main.async {
                    self.table_Search.reloadData()
                }
                })
        }
    }
    @IBAction func changeSeagment(_ sender: UISegmentedControl) {
        switch seagment_Search.selectedSegmentIndex {
        case 0:
            filterContentForSearch(searchText: temp, page: 1, scope: "movies")
            list_Search_People.removeAll()
            
            DispatchQueue.main.async {
                self.table_Search.reloadData()
            }
            
        case 1:
            filterContentForSearch(searchText: temp, page: 1, scope: "people")
            
            list_Search_Movie.removeAll()
            DispatchQueue.main.async {
                self.table_Search.reloadData()
            }
            
            
        default:
            break
        }
    }
    
}
extension SearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
extension SearchView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list_Search_Movie.count >= 10 || list_Search_People.count >= 10 {
            return 10
        }else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForSearch", for: indexPath)
        if seagment_Search.selectedSegmentIndex == 0 {
            if let item: Film = list_Search_Movie[indexPath.row] {
                cell.textLabel?.text = item.title
            }
        }else{
            if let item: Cast = list_Search_People[indexPath.row] {
                cell.textLabel?.text = item.name
            }
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if seagment_Search.selectedSegmentIndex == 0 && table_Search.isHidden == false{
            
            if let item: Film = list_Search_Movie[indexPath.row] {
                setData(item)
            }
        }else{
            
            let tableDetail = TableWithPage(nibName: "TableWithPage", bundle: nil) as TableWithPage
            if let item : Cast = list_Search_People[indexPath.row]{
                print(item.known_for)
                tableDetail.type = 4
                tableDetail.title = item.name
                tableDetail.temp = item.known_for! as! [Film]
                self.navigationController?.pushViewController(tableDetail, animated: true)
            }
        }
    }
    func setData(_ film: Film) {
    
        let detaiMovie = DetailMovieVC(nibName: "DetailMovieVC", bundle: nil) as! DetailMovieVC
        detaiMovie.film = film
        self.navigationController?.pushViewController(detaiMovie, animated: true)
    }
}
extension SearchView: UISearchBarDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        
        list_Search_People.removeAll()
        list_Search_Movie.removeAll()
        DispatchQueue.main.async {
            self.table_Search.reloadData()
        }
        
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsCancelButton = true
        
        if searchText != "" {
            temp = searchText
            if seagment_Search.selectedSegmentIndex == 0 {
                filterContentForSearch(searchText: searchText, page: 1 , scope: "movies")
            }else if seagment_Search.selectedSegmentIndex == 1 {
                filterContentForSearch(searchText: searchText, page: 1, scope: "people")
            }
            
            
        }
        
    }
    
}




