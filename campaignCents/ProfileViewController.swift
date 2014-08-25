//
//  ProfileViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/18/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit

// VC for every politician up touch from map
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
        
        // Default, temporary data
        var pos:String = "POSITION"
        var par:String = "PARTY"
        
        // Loading dictionary from nationalCandidatesList
        var documentList = NSBundle.mainBundle().pathForResource("nationalCandidatesList", ofType:"plist")
        var candidatesDictionary = NSDictionary(contentsOfFile: documentList)
        println(" \(__FUNCTION__)Fetching 'kochPoliticians.plist 'file \n \(candidatesDictionary) \n")
        
        // loop through candidatesDictionary and grabs position and party for chosen polition
        for var i = 0; i < (candidatesDictionary["New item"]! as NSArray).count; i++ {
            if (((candidatesDictionary as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["voteSmartID"]! as NSInteger == self.politician["voteSmartID"] as NSInteger {
                println(self.politician["voteSmartID"] as NSInteger)
                
                pos = (((candidatesDictionary as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["position"]! as NSString
                par = (((candidatesDictionary as NSDictionary)["New item"] as? NSArray)![i] as NSDictionary!)["partyLetter"]! as NSString
            }
        }

        var sta:String = politician["state"] as String
        
        politicianPosition.text = "\(pos) (\(sta)-\(par))"
        
        currentFunding.text = politician["currentFunding"] as String
        lifetimeFunding.text = politician["lifetimeFunding"] as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}