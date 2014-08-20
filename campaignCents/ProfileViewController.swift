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
        
        // Grabs photo from url
        let url = NSURL.URLWithString(politician["photo"] as String);
        var err: NSError?
        var imageData:NSData? = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
        politicianImage.image = UIImage(data:imageData)
        
        politicianName.setTitle(politician["name"] as String, forState: .Normal)
        
        if politician["position"] != nil {
            var pos:String = politician["position"] as String
        }
        
        if politician["party"] != nil {
            var par:String = politician["party"] as String
        }
        
        var sta:String = politician["state"] as String
        
        // UNCOMMENT BELOW LINE WHEN PASSING IN PARTY AND POSITION
//        politicianPosition.text = "\(pos) (\(par)-\(sta))"
        
        politicianPosition.text = "\(sta)"
        
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