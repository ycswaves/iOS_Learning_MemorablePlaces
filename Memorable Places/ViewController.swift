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
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
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
                println(annote)
                var annot = MKPointAnnotation()
                annot.coordinate = newCoord
                annot.title = annote
                self.map.addAnnotation(annot)
            })
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation:CLLocation = locations[0] as CLLocation
        var latitude = userLocation.coordinate.latitude
        var longitude = userLocation.coordinate.longitude
        var latDelta:CLLocationDegrees = 0.01
        var logDelta:CLLocationDegrees = 0.01
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, logDelta)
        var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        self.map.setRegion(region, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

