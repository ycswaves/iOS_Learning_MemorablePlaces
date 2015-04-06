//
//  ViewController.swift
//  Memorable Places
//
//  Created by YCS on 5/4/15.
//  Copyright (c) 2015 ycswaves. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    var manager: CLLocationManager!
    
    @IBOutlet weak var map: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        if activePlace == -1 {
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        } else {
            let latitude = NSString(string: userPlaces[activePlace]["lat"]!).doubleValue
            let longitude = NSString(string: userPlaces[activePlace]["lon"]!).doubleValue
            var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            mapInit(latitude, lon: longitude)
            makeAnnote(coordinate, msg: userPlaces[activePlace]["name"]!)
        }
        
        
        
        
        var uiLongPress = UILongPressGestureRecognizer(target: self, action: "action:")
        uiLongPress.minimumPressDuration = 2.0
        map.addGestureRecognizer(uiLongPress)
        
    }
    
    func action(gestureRec: UIGestureRecognizer) {
        if gestureRec.state == UIGestureRecognizerState.Began { //1st indication of a particular long press
            var touchPt = gestureRec.locationInView(self.map)
            var newCoord = self.map.convertPoint(touchPt, toCoordinateFromView: self.map)
            var location = CLLocation(latitude: newCoord.latitude, longitude: newCoord.longitude)
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (places, error) -> Void in
                var annote = ""
                if error == nil {
                    if let p = CLPlacemark(placemark: places?[0] as CLPlacemark) {
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare
                        }
                        
                        if p.thoroughfare != nil {
                            thoroughfare = p.thoroughfare
                        }
                        
                        annote = "\(subThoroughfare) \(thoroughfare)"
                    }
                }
                
                if annote == "" {
                    annote = "added \(NSDate())"
                }
                userPlaces.append(["name":annote, "lat":"\(newCoord.latitude)", "lon":"\(newCoord.longitude)"])
                self.makeAnnote(newCoord, msg: annote)
            })
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation:CLLocation = locations[0] as CLLocation
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        mapInit(latitude, lon: longitude)
    }
    
    func mapInit(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        var latDelta:CLLocationDegrees = 0.01
        var logDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, logDelta)
        var coordinate = CLLocationCoordinate2DMake(lat, lon)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
    }
    
    func makeAnnote(newCoord: CLLocationCoordinate2D, msg: String) {
        var annot = MKPointAnnotation()
        annot.coordinate = newCoord
        annot.title = msg
        self.map.addAnnotation(annot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

