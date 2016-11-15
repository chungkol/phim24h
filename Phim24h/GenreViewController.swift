//
//  GenreViewController.swift
//  Phim24h
//
//  Created by Chung on 9/27/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class GenreViewController: BaseDetailViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    var datas: [Genre] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Genre"
        myTable.delegate = self
        myTable.dataSource = self
        loading.startAnimating()
        myTable.register(UINib(nibName: "CellGenre", bundle: nil), forCellReuseIdentifier: "CellOfGenre")
        
        ManagerData.instance.getAllGenre({ [unowned self] (genres) in
            self.datas = genres
            self.myTable.reloadData()
            if self.datas.count > 0 {
                self.loading.isHidden = true
                self.loading.stopAnimating()
            }
            })
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}
extension GenreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension GenreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CellOfGenre", for: indexPath) as! CellGenre
        if let item: Genre = datas[indexPath.row] {
            cell.titleCell.text = item.name
            cell.imageCell.image = UIImage(named: "type_film")
        }
        cell.selectionStyle = .none
        
        return cell
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = TableWithPage(nibName: "TableWithPage", bundle: nil)
        
        detailVC.genre_id = datas[indexPath.row].id
        detailVC.data_title = datas[indexPath.row].name
        detailVC.type = 2
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
