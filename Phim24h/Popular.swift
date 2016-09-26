//
//  Popular.swift
//  Phim24h
//
//  Created by Chung on 9/26/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class Popular: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let detail = TableWithPage(nibName: "TableWithPage", bundle: nil)
        detail.data_key = ManagerData.POPULAR
        detail.data_title = "Popular"
        self.navigationController?.pushViewController(detail, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
