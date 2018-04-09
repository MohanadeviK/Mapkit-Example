//
//  ViewController.swift
//  MapKitExample
//
//  Created by Devi on 08/04/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        let homeLocation = CLLocation(latitude: 13.0551, longitude: 80.2221)
        self.setAnnotation(location: homeLocation)
        self.centerMapOnLocation(location: homeLocation)
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        
        //Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        //        self.setAnnotation(location: manager.location!)
        //        self.centerMapOnLocation(location: manager.location!)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let regionRadius = 200.0
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 1.4, regionRadius * 1.4)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func setAnnotation(location: CLLocation) {
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Hostel"
        sourceAnnotation.coordinate = location.coordinate
        self.mapView.addAnnotation(sourceAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKind(of: MKUserLocation.self)){
            return nil
        }
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.pinTintColor = UIColor.red
        return annotationView
    }
}


