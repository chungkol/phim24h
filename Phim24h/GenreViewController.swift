//
//  GenreViewController.swift
//  Phim24h
//
//  Created by Chung on 9/27/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class GenreViewController: BaseViewController {
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var myTable: UITableView!
    var datas: [Genre] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTable.delegate = self
        myTable.dataSource = self
        loading.startAnimating()
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "CellGenre")
        ManagerData.instance.getAllGenre(completetion: { [unowned self] (genres) in
            self.datas = genres
            self.myTable.reloadData()
            })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.clear
        self.myTable.backgroundColor = UIColor.clear
    }
    
    
}
extension GenreViewController: UITableViewDelegate {
    
}

extension GenreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  datas.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CellGenre", for: indexPath)
        cell.textLabel?.text = datas[indexPath.row].name
        cell.textLabel?.textColor = UIColor.black
        cell.backgroundColor = UIColor.white
        if(indexPath.row == datas.count-1 ){
            loading.isHidden = true
            loading.stopAnimating()
        }
        return cell
    }
    @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = TableWithPage(nibName: "TableWithPage", bundle: nil)
        detailVC.genre_id = datas[indexPath.row].id
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
