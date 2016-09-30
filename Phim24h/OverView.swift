//
//  OverView.swift
//  Phim24h
//
//  Created by Chung on 9/30/16.
//  Copyright © 2016 techmaster. All rights reserved.
//

import UIKit

class OverView: UIViewController {

    
    @IBOutlet weak var contentDetail: UILabel!
    
    @IBOutlet weak var myCollection: UICollectionView!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var revenue: UILabel!
    
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var runTime: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
