//
//  ProfileViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/18/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var politician = Dictionary<String, String>()
    
    @IBOutlet var politicianImage: UIImageView!
    @IBOutlet var politicianName: UIButton!
    @IBOutlet var politicianPosition: UILabel!
    @IBOutlet var currentFunding: UILabel!
    @IBOutlet var lifetimeFunding: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}