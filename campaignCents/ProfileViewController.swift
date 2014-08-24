//
//  ProfileViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/18/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var politician = NSDictionary()
    
    @IBOutlet var politicianImage: UIImageView!
    @IBOutlet var politicianName: UIButton!
    @IBOutlet var politicianPosition: UILabel!
    @IBOutlet var currentFunding: UILabel!
    @IBOutlet var lifetimeFunding: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController.navigationBar.tintColor = UIColor(red: 24/255, green: 89/255, blue: 68/255, alpha: 1)
        
        // Grabs photo from url
        let url = NSURL.URLWithString(politician["photo"] as String);
        var err: NSError?
        var imageData:NSData? = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        
        politicianImage.image = UIImage(data:imageData)
        
        politicianName.setTitle(politician["name"] as String, forState: .Normal)
        
        // Hard-code data for Pat Toomey
        var pos:String = "U.S. Senator"
        var par:String = "R"
        
        var sta:String = politician["state"] as String
        
        politicianPosition.text = "\(pos) (\(sta)-\(par))"
        
        currentFunding.text = politician["currentFunding"] as String
        lifetimeFunding.text = politician["lifetimeFunding"] as String
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