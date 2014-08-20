//
//  MapViewController.swift
//  campaignCents
//
//  Created by Jasen Lew on 8/16/14.
//  Copyright (c) 2014 Jasen Lew. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    
    // Elements on storyboard
    @IBOutlet var navBar: UINavigationItem!
    @IBOutlet var kochMap: MKMapView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var kochPoliticiansNationwide: UILabel!
    
    // Will hold data from plist
    var kochPoliticiansDictionary: AnyObject? = nil;

    
    // Defaults to Austin, TX
    var latSelected:Double = 30.274751
    var lngSelected:Double = -97.739141
    
    
    // Defaults to city-level view
    var deltaSelected:Double = 0.11
    var politician = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController.navigationBarHidden = false
        
        kochMap.delegate = self
        searchBar.delegate = self
        searchBar.showsScopeBar = true
        
        var latLocation:CLLocationDegrees = latSelected
        var lngLocation:CLLocationDegrees = lngSelected
        
        var coordDelta:CLLocationDegrees = deltaSelected
        
        var selectedSpan:MKCoordinateSpan = MKCoordinateSpanMake(coordDelta, coordDelta)
        
        var selectedLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latLocation, lngLocation)
        var selectedRegion:MKCoordinateRegion = MKCoordinateRegionMake(selectedLocation, selectedSpan)

        kochMap.setRegion(selectedRegion, animated: true)

        kochPoliticiansNationwide.text = "Koch Politicians Nationwide: 242"

        
        // Loading dictionary from kochPoliticians.plist
        var documentList = NSBundle.mainBundle().pathForResource("kochPoliticians", ofType:"plist")
        kochPoliticiansDictionary = NSDictionary(contentsOfFile: documentList)
        println(" \(__FUNCTION__)Fetching 'kochPoliticians.plist 'file \n \(kochPoliticiansDictionary) \n")
        

        for var i = 0; i < (kochPoliticiansDictionary!["New item"]! as NSArray).count; i++ {
            var politician = MKPointAnnotation()
            
            var politicianName:String = (kochPoliticiansDictionary!["New item"]! as NSArray)[i]["name"]! as String
            println("JASEN|politicianName: \(politicianName)")
            var politicianLifetimeFunding:String = (kochPoliticiansDictionary!["New item"]! as NSArray)[i]["lifetimeFunding"]! as String
            
            var street:String = (kochPoliticiansDictionary!["New item"]! as NSArray)[i]["street"] as String
            var city:String = (kochPoliticiansDictionary!["New item"]! as NSArray)[i]["city"] as String
            var state:String = (kochPoliticiansDictionary!["New item"]! as NSArray)[i]["state"] as String
            
            var address = "\(street), \(city) \(state)"
            
            // Converts address to latitude and lonjgitude and then plots it on map
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler:{
                (placemarks, error) in
                
                if ((error) != nil) {
                    println("JASEN|geocoder error: \(error)")
                } else {
                    println("JASEN|Placemarks: \(placemarks)")
                    
                    let p = CLPlacemark(placemark: placemarks?[0] as CLPlacemark)
                    
                    var pLat:Double = p.location.coordinate.latitude
                    var pLng:Double = p.location.coordinate.longitude
                    
                    politician.coordinate = CLLocationCoordinate2DMake(pLat as CLLocationDegrees, pLng as CLLocationDegrees)

                    politician.title = politicianName
                    politician.subtitle = "Lifetime Funding: \(politicianLifetimeFunding)"
                    
                    self.kochMap.addAnnotation(politician)
                }
            })
        }
    }

    func googleAPI(location: String) {
    
        let mySession = NSURLSession.sharedSession()
        
        // Only works with ZIP and cities with no spaces in name (ex: "San Jose" would not work)
        var urlString:String = "https://maps.googleapis.com/maps/api/geocode/json?address=\(location)"
        println("JASEN| \(urlString)")
        
        let url:NSURL = NSURL(string: urlString)
        
        let networkTask = mySession.dataTaskWithURL(url, completionHandler : {data, response, error -> Void in
            var err: NSError?
            var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSMutableDictionary
            let results : NSArray = theJSON["results"]! as NSArray
            var enteredLat:Double = (results[0]["geometry"]!["location"]!["lat"]) as Double
            var enteredLng:Double = (results[0]["geometry"]!["location"]!["lng"]) as Double

            // START: Recenters map on search
            var latLocation:CLLocationDegrees = enteredLat // Boston Latitude: 42.364506
            var lngLocation:CLLocationDegrees = enteredLng // Boston Longitude: -71.038887
            
            var coordDelta:CLLocationDegrees = 0.21
            
            var selectedSpan:MKCoordinateSpan = MKCoordinateSpanMake(coordDelta, coordDelta)
            
            var selectedLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latLocation, lngLocation)
            var selectedRegion:MKCoordinateRegion = MKCoordinateRegionMake(selectedLocation, selectedSpan)
            
            self.kochMap.setRegion(selectedRegion, animated: true)
            // END: Recenters map on search
            
            println("Latitude: \(enteredLat) and Longitude: \(enteredLng)")
        })
        
        networkTask.resume()
    }
    
    // Delegate method called when search button clicked
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        var location:String = searchBar.text
        println(location)
        
        // Runs googleAPI with user input city or ZIP
        googleAPI(location)
        
        // Clears search bar field upon enter
        searchBar.text = ""
        
        // Hides keyboard on search
        searchBar.resignFirstResponder()
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
            
            for var i = 0; i < (kochPoliticiansDictionary!["New item"]! as NSArray).count; i++ {
                if annotation.title == (kochPoliticiansDictionary!["New item"]! as NSArray)[i]["name"]! as? String {
                    var imageview = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                    
                    let url = NSURL.URLWithString((kochPoliticiansDictionary!["New item"]! as NSArray)[i]["photo"]! as? String);
                    var err: NSError?
                    var imageData:NSData? = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
                    if imageData != nil {
                        imageview.image = UIImage(data:imageData)
                        pinView!.leftCalloutAccessoryView = imageview
                    }
                }
            }
            
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    // Segues to profileVC when annotation tapped
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        for var i = 0; i < (kochPoliticiansDictionary!["New item"]! as NSArray).count; i++ {
            if (kochPoliticiansDictionary!["New item"]![i]! as NSDictionary)["name"]! as String == annotationView.annotation.title! {
                politician = (kochPoliticiansDictionary!["New item"]![i]! as NSDictionary)
            }
        }
        
        println("Politician Name: \(politician)")
        self.performSegueWithIdentifier("fromMaptoProfile", sender: view)
    }

    // Sends politician information to ProfileVC
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "fromMaptoProfile" {
            println("JASEN|seguing fromMaptoProfile")
            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.politician = politician
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
