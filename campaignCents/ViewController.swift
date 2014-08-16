//
//  ViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/15/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
    // Geographic center of the contiguous United States: http://en.wikipedia.org/wiki/Geographic_center_of_the_contiguous_United_States
    var latSelected:Double = 39.50
    var lngSelected:Double = -98.35
    
    // Defaults to Country Level zoom
    var deltaSelected:Double = 60.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides navigationController on first VC, which is loaded on app load
        self.navigationController.navigationBarHidden = true
    }
    
    // Function to send politician information to next Politicians TVC
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "toKochMap" {
            println("seguing toKochMap")
            var kochMapVC = segue.destinationViewController as MapViewController
            kochMapVC.latSelected = latSelected
            kochMapVC.lngSelected = lngSelected
            kochMapVC.deltaSelected = deltaSelected
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}