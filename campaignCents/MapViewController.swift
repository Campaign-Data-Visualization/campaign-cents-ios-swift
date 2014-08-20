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
    
    // Defaults to Austin, TX
    var latSelected:Double = 30.274751
    var lngSelected:Double = -97.739141
    
    
    // Defaults to city-level view
    var deltaSelected:Double = 0.11
    var politician = Dictionary<String, String>()
    
    // Temp array of politicians
    var politicians = [
        ["voteSmartID":"34230","name":"Marlin Stutzman","street":"0250 West 600 North","city":"Howe","state":"IN","zip":"46746","lifetimeFunding":"$12600","currentFunding":"$5000","photo":"http://static.votesmart.org/canphoto/34230.jpg"],
        ["voteSmartID":"116570","name":"Bobby Schilling","street":"1 Goembel Court","city":"Colona","state":"IL","zip":"61241","lifetimeFunding":"$25000","currentFunding":"$7500","photo":"http://static.votesmart.org/canphoto/116570.jpg"],
        ["voteSmartID":"50895","name":"Robert Hurt","street":"10 North Main Street","city":"Chatham","state":"VA","zip":"24531","lifetimeFunding":"$20500","currentFunding":"$4500","photo":"http://static.votesmart.org/canphoto/50895.jpg"],
        ["voteSmartID":"8751","name":"Mike Rogers","street":"1000 West Saint Joseph Suite 300","city":"Lansing","state":"MI","zip":"48915","lifetimeFunding":"$105860","currentFunding":"$1000","photo":"http://static.votesmart.org/canphoto/8751.jpg"],
        ["voteSmartID":"18829","name":"Brett Guthrie","street":"1005 Wrenwood Drive","city":"Bowling Green","state":"KY","zip":"42103","lifetimeFunding":"$27000","currentFunding":"$7000","photo":"http://static.votesmart.org/canphoto/18829.jpg"],
        ["voteSmartID":"119474","name":"Patrick Meehan","street":"1029 Edmonds Avenue","city":"Drexel Hill","state":"PA","zip":"19026","lifetimeFunding":"$20350","currentFunding":"$2250","photo":"http://static.votesmart.org/canphoto/119474.jpg"],
        ["voteSmartID":"116906","name":"Bill Flores","street":"1030 Longworth House Office Building","city":"Washington","state":"DC","zip":"20515","lifetimeFunding":"$26700","currentFunding":"$14000","photo":"http://static.votesmart.org/canphoto/116906.jpg"],
        ["voteSmartID":"46034","name":"Tom Cole","street":"104 Briarwood Street","city":"Moore","state":"OK","zip":"73160","lifetimeFunding":"$47500","currentFunding":"$500","photo":"http://static.votesmart.org/canphoto/46034.jpg"],
        ["voteSmartID":"21873","name":"Ed Whitfield","street":"108 Alumni Avenue","city":"Hopkinsville","state":"KY","zip":"42240","lifetimeFunding":"$30000","currentFunding":"$10000","photo":"http://static.votesmart.org/canphoto/21873.jpg"],
        ["voteSmartID":"102964","name":"David Rouzer","street":"108 Peach Orchard Drive","city":"Benson","state":"NC","zip":"27504","lifetimeFunding":"$6000","currentFunding":"$1000","photo":"http://static.votesmart.org/canphoto/102964.jpg"],
        ["voteSmartID":"102026","name":"Randy Weber","street":"1100 Gulf Freeway Suite 100","city":"League City","state":"TX","zip":"77573","lifetimeFunding":"$13000","currentFunding":"$2500","photo":"http://static.votesmart.org/canphoto/102026.jpg"],
        ["voteSmartID":"26911","name":"Dave Camp","street":"112 Spruce Street, Suite A","city":"Cadillac","state":"MI","zip":"49601","lifetimeFunding":"$40500","currentFunding":"$5000","photo":"http://static.votesmart.org/canphoto/26911.jpg"],
        ["voteSmartID":"82026","name":"Dan Logue","street":"11445 Loma Rica Road","city":"Marysville","state":"CA","zip":"95901","lifetimeFunding":"$5000","currentFunding":"$5000","photo":"http://static.votesmart.org/canphoto/82026.jpg"],
        ["voteSmartID":"6051","name":"Virginia Foxx","street":"11468 North Carolina Highway 105 Highway South","city":"Banner Elk","state":"NC","zip":"28604","lifetimeFunding":"$6525","currentFunding":"$1000","photo":"http://static.votesmart.org/canphoto/6051.jpg"],
        ["voteSmartID":"32008","name":"Ed Lindsey","street":"1150 Angelo Court","city":"Atlanta","state":"GA","zip":"30319","lifetimeFunding":"$500","currentFunding":"$500","photo":"http://static.votesmart.org/canphoto/32008.jpg"]
    ]
    
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

        kochPoliticiansNationwide.text = "Koch Politicians Nationwide: \(politicians.count)"

        for var i = 0; i < politicians.count; i++ {
            var politician = MKPointAnnotation()
            
            var politicianName:String = politicians[i]["name"]! as String
            var politicianLifetimeFunding:String = politicians[i]["lifetimeFunding"]! as String
            
            var street:String = politicians[i]["street"]!
            var city:String = politicians[i]["city"]!
            var state:String = politicians[i]["state"]!
            
            var address = "\(street), \(city) \(state)"
            
            // Converts address to latitude and lonjgitude and then plots it on map
            var geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address, completionHandler:{
                (placemarks, error) in
                
                if (error) {
                    println("JASEN|Error: \(error)")
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
            
            for var i = 0; i < politicians.count; i++ {
                if annotation.title == politicians[i]["name"] {
                    var imageview = UIImageView(frame: CGRectMake(0, 0, 45, 45))
                    
                    let url = NSURL.URLWithString(politicians[i]["photo"]);
                    var err: NSError?
                    var imageData:NSData = NSData.dataWithContentsOfURL(url,options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
                    imageview.image = UIImage(data:imageData)
                    
                    pinView!.leftCalloutAccessoryView = imageview
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
        
        for var i = 0; i < politicians.count; i++ {
            if politicians[i]["name"] == annotationView.annotation.title {
                politician = politicians[i]
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
