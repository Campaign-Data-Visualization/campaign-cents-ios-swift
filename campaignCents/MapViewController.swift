//
//  MapViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/16/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var kochMap: MKMapView!
    
    // Geographic center of the contiguous United States: http://en.wikipedia.org/wiki/Geographic_center_of_the_contiguous_United_States
    var latSelected:Double = 39.50
    var lngSelected:Double = -98.35
    
    // Defaults to Country Level zoom
    var deltaSelected:Double = 60.0
    
    var politician = Dictionary<String, String>()
    
    var politicians = [
        [
            "name" : "Ted Cruz",
            "position" : "U.S. Senator",
            "party" : "R",
            "lat" : "30.269402",
            "lng" : "-97.739141",
            "state" : "TX",
            "totalFunding" : "$230,000",
            "photo" : "Cruz, Ted.png"
        ],
        [
            "name" : "Roger Williams",
            "position" : "U.S. Representative",
            "party" : "R",
            "lat" : "30.272060",
            "lng" : "-97.740949",
            "state" : "TX",
            "totalFunding" : "$107,000",
            "photo" : "Williams, Roger.png"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kochMap.delegate = self
        
        var latLocation:CLLocationDegrees = latSelected
        var lngLocation:CLLocationDegrees = lngSelected
        
        var coordDelta:CLLocationDegrees = deltaSelected
        
        var selectedSpan:MKCoordinateSpan = MKCoordinateSpanMake(coordDelta, coordDelta)
        
        var selectedLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latLocation, lngLocation)
        var selectedRegion:MKCoordinateRegion = MKCoordinateRegionMake(selectedLocation, selectedSpan)

        kochMap.setRegion(selectedRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
