//
//  ViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/15/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    // Creates the variables that will be passed onto MapVC
    var latSelected:Double = 0.0
    var lngSelected:Double = 0.0
    var deltaSelected:Double = 0.0
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        // NOTE: requestWhenInUseAuthorization is only available on iOS 8
        // manager.requestWhenInUseAuthorization()
        
        manager.startUpdatingLocation()
        
        // Hides navigationController on first VC, which is loaded on app load
        self.navigationController.navigationBarHidden = true
    }
    
    // The "National" button that sets the location information before segueing to map
    @IBAction func national(sender: AnyObject) {
        // Geographic center of the contiguous United States: http://en.wikipedia.org/wiki/Geographic_center_of_the_contiguous_United_States
        latSelected = 39.50
        lngSelected = -98.35
        
        // Defaults to Country Level zoom
        deltaSelected = 60.0
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        // NOTE: By default, will be an object, so need to cast to CLLocation
        var userLocation:CLLocation = locations[0] as CLLocation
        
        // Prints in console the object of the user's location information
        println("JASEN|userLocation: \(userLocation)")
        
        // NOTE: Use string interpolation to convert CLLocationDegrees type to String type
        latSelected = userLocation.coordinate.latitude
        lngSelected = userLocation.coordinate.longitude
        
        deltaSelected = 0.21
    }
    
    // The "Near Me" button that retrieves the user location information before segueing to map
    @IBAction func nearMe(sender: AnyObject) {
        println("JASEN|'Near Me' button pressed")
    }
    
    // Function to send location information to Map VC
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "toKochMap" {
            println("JASEN|seguing toKochMap")
            var kochMapVC = segue.destinationViewController as MapViewController
            kochMapVC.latSelected = latSelected
            kochMapVC.lngSelected = lngSelected
            kochMapVC.deltaSelected = deltaSelected
        }
    }
    
    // Hide the keyboard when the background is touched
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}