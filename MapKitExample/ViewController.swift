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

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var flag = Bool()
    
    var locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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
        if self.mapView.annotations.count == 2 {
            self.mapView.removeAnnotations(self.mapView.annotations)
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performForwardGeocoding()
        return true
    }
    
    func performForwardGeocoding() {
        if let addressText = addressTextField.text {
            geocoder.geocodeAddressString(addressText) { (placemarks, error) in
                self.processResponse(withPlacemarks: placemarks, error: error)
            }
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
        } else {
            var location: CLLocation?
            if let placemarks = placemarks, placemarks.count > 0 {
                location = placemarks.first?.location
            }
            if let location = location {
                let coordinate = location.coordinate
                self.setAnnotation(location: location)
                self.centerMapOnLocation(location: location)
                print("coordinates", "\(coordinate.latitude), \(coordinate.longitude)")
            } else {
                print("No Matching Location Found")
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        addressTextField.resignFirstResponder()
    }
}


