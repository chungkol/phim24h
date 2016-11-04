//
//  Similar.swift
//  Phim24h
//
//  Created by Chung on 9/30/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit
import Kingfisher
class Similar: UIViewController {
    var tableDetail: TableWithPage!
    var movie_id: Int! {
        didSet {
            tableDetail.type = 5
            tableDetail.movie_id = movie_id
            tableDetail.addPullToRefresh()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addTable()
        
    }
    func addTable() {
        if tableDetail == nil {
            tableDetail = TableWithPage(nibName: "TableWithPage", bundle: nil)
            
            tableDetail.willMove(toParentViewController: self)
            
            self.view.addSubview(tableDetail.view)
            self.addChildViewController(tableDetail)
            tableDetail.didMove(toParentViewController: self)
            
            tableDetail.view.translatesAutoresizingMaskIntoConstraints = false
            
            let layoutTop = NSLayoutConstraint(item: tableDetail.view, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0)
            
            let layoutBot = NSLayoutConstraint(item: tableDetail.view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
            
            let layoutRight = NSLayoutConstraint(item: tableDetail.view, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: 0)
            
            
            let layoutLeft = NSLayoutConstraint(item: tableDetail.view, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0)
            NSLayoutConstraint.activate([layoutTop, layoutLeft, layoutBot, layoutRight])
        }
        
        
    }
    
}
