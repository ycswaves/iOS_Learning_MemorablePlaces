Udemy iOS programming using swift:
Memorable places

![screen shot 1](/screenshot/sc1.png)
![screen shot 2](/screenshot/sc2.png)
![screen shot 3](/screenshot/sc3.png)

## Takeaways

### CLLocationManager

- Delegate: CLLocationManagerDelegate
- CLLocationManager.desiredAccuracy = kCLLocationAccuracyBest
- CLLocationManager.requestWhenInUseAuthorization()
- CLLocationManager.startUpdatingLocation()

#### import library
in _Build Phases_, under _Link Binary With Libraries, add _CoreLocation.framework (required)

#### Get permission to use user's location
inside info.plist, add:

|                    Key                      |     Type     |            Value                |
| ------------------------------------------- |:------------:| ------------------------------- |
|   **NSLocationWhenInUseUsageDescription**   |   `String`   |   *I need your location*        |
|   **NSLocationAlwaysUsageDescription**      |   `String`   |   *I always need your location* |


### Create coordinate
```
let latitude = NSString(string: STRING_VALUE!).doubleValue
let longitude = NSString(string: STRING_VALUE!).doubleValue
var coordinate = CLLocationCoordinate2DMake(latitude, longitude)
```

### Map init
import _MapKit_ in the controller
```
var latDelta:CLLocationDegrees = 0.01  //map scale
var logDelta:CLLocationDegrees = 0.01
var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, logDelta)
var coordinate = CLLocationCoordinate2DMake(lat, lon) // lat: CLLocationDegrees, lon: CLLocationDegrees
var region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
self.map.setRegion(region, animated: true)
```

### Make annotation on map (put pin)
```
var annot = MKPointAnnotation()
//newCoord: CLLocationCoordinate2D, msg: String
annot.coordinate = newCoord
annot.title = msg
self.map.addAnnotation(annot)
```

### Add Gesture Recognizer
```
@IBOutlet weak var map: MKMapView!
var uiLongPress = UILongPressGestureRecognizer(target: self, action: "action:")
uiLongPress.minimumPressDuration = 2.0
map.addGestureRecognizer(uiLongPress)
```

#### Define the action function for Gesture Recognizer
```
func action(gestureRec: UIGestureRecognizer) {
    if gestureRec.state == UIGestureRecognizerState.Began { //1st indication of a particular long press
      // do something
    }
}
```

#### Reverse Geolocation
```
func action(gestureRec: UIGestureRecognizer) {
    if gestureRec.state == UIGestureRecognizerState.Began {

        // ...

        var touchPt = gestureRec.locationInView(self.map) //get touch point on screen
        var newCoord = self.map.convertPoint(touchPt, toCoordinateFromView: self.map) //convert the touch point into coordinate
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

            // ...
        })

    }
}
```



