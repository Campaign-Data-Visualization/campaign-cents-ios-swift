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
    @IBOutlet var kochPoliticiansNationwide: UILabel!
    
    // Defaults to Austin, TX
    var latSelected:Double = 30.274751
    var lngSelected:Double = -97.739141
    
    
    // Defaults to city-level view
    var deltaSelected:Double = 0.11
    var politician = Dictionary<String, String>()
    
    var politicians = [
        [
            "name" : "Ted Cruz",
            "position" : "U.S. Senator",
            "party" : "R",
            "lat" : "30.269402",
            "lng" : "-97.739141",
            "state" : "TX",
            "lifetimeFunding" : "$230,000",
            "photo" : "Cruz, Ted.png"
        ],
        [
            "name" : "Roger Williams",
            "position" : "U.S. Representative",
            "party" : "R",
            "lat" : "30.272060",
            "lng" : "-97.740949",
            "state" : "TX",
            "lifetimeFunding" : "$107,000",
            "photo" : "Williams, Roger.png"
        ],
        [
            "name" : "Samuel Frederickson",
            "position" : "U.S. Representative",
            "party" : "D",
            "lat" : "30.232060",
            "lng" : "-97.720949",
            "state" : "TX",
            "lifetimeFunding" : "$237,000",
            "photo" : "Frederickson, Samuel.png"
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController.navigationBarHidden = false
         
        kochMap.delegate = self
        
        var latLocation:CLLocationDegrees = latSelected
        var lngLocation:CLLocationDegrees = lngSelected
        
        var coordDelta:CLLocationDegrees = deltaSelected
        
        var selectedSpan:MKCoordinateSpan = MKCoordinateSpanMake(coordDelta, coordDelta)
        
        var selectedLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latLocation, lngLocation)
        var selectedRegion:MKCoordinateRegion = MKCoordinateRegionMake(selectedLocation, selectedSpan)

        kochMap.setRegion(selectedRegion, animated: true)

        kochPoliticiansNationwide.text = "Koch Politicians Nationwide: \(politicians.count)"

        for var i = 0; i < politicians.count; i++ {
            var politician = MKPointAnnotation()
            
            var politicianLifetimeFunding:String = politicians[i]["lifetimeFunding"]! as String
            
            // Converts string to "double" data type
            var lat = NSString(string: politicians[i]["lat"]).doubleValue
            var lng = NSString(string: politicians[i]["lng"]).doubleValue
            
            politician.coordinate = CLLocationCoordinate2DMake(lat as CLLocationDegrees, lng as CLLocationDegrees)
            politician.title = politicians[i]["name"]! as String
            politician.subtitle = "Lifetime Funding: \(politicianLifetimeFunding)"
            
            kochMap.addAnnotation(politician)
        }
    }

    // Delegate method called each time an annotation appears in the visible window
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
            pinView!.pinColor = .Red
            
            for var i = 0; i < politicians.count; i++ {
                if annotation.title == politicians[i]["name"] {
                    var imageview = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                    imageview.image = UIImage(named: politicians[i]["photo"])
                    pinView!.leftCalloutAccessoryView = imageview
                }
            }
            
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // Function of what happens when callout per annotation touched (clicked)
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for var i = 0; i < politicians.count; i++ {
            if politicians[i]["name"] == annotationView.annotation.title {
                politician = politicians[i]
            }
        }
        
        println("Politician Name: \(politician)")
        self.performSegueWithIdentifier("fromMaptoProfile", sender: view)
    }

    // Function to send politician information to ProfileVC
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "fromMaptoProfile" {
            println("JASEN|seguing fromMaptoProfile")
            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.politician = politician
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
