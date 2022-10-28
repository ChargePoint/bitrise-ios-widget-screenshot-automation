//
//  ViewController.swift
//  bitrise-screenshot-automation
//
//  Created by Alexander Botkin on 4/20/20.
//  Copyright © 2020 ChargePoint, Inc. All rights reserved.
//

import MapKit
import UIKit

enum ZoomLocation {
    case SanFrancisco
    case NewYork
    case Chicago
    
    var description: String {
        switch self {
        case .SanFrancisco:
            return "San Francisco"
        case .NewYork:
            return "New York"
        case .Chicago:
            return "Chicago"
        }
    }
}

class DarkMapViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MKMapViewDelegate {
    var locationList: [ZoomLocation] = [.SanFrancisco, .NewYork, .Chicago]
    let stationStatusColors = [
        UIColor(red: 0.2039, green: 0.7804, blue: 0.3490, alpha: 1),
        UIColor(red: 0.2039, green: 0.7804, blue: 0.3490, alpha: 1),
        UIColor(red: 0.5569, green: 0.5569, blue: 0.5765, alpha: 1),
        UIColor(red: 0, green: 0.4784, blue: 1, alpha: 1)
    ]
    var coordinateDict: Dictionary<ZoomLocation, (Double, Double)> = [.SanFrancisco: (37.7749, -122.4194), .NewYork: (40.7128, -74.0060), .Chicago: (41.8781, -87.6298)]
    var annotationCoordDict: Dictionary<ZoomLocation, [CLLocationCoordinate2D]> = [.SanFrancisco: [CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4494), CLLocationCoordinate2D(latitude: 37.7649, longitude: -122.4094), CLLocationCoordinate2D(latitude: 37.7849, longitude: -122.4094), CLLocationCoordinate2D(latitude: 37.7949, longitude: -122.4354), CLLocationCoordinate2D(latitude: 37.7509, longitude: -122.4244)], .NewYork: [CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), CLLocationCoordinate2D(latitude: 40.7228, longitude: -74.0360), CLLocationCoordinate2D(latitude: 40.6928, longitude: -73.9860), CLLocationCoordinate2D(latitude: 40.7428, longitude: -73.9999), CLLocationCoordinate2D(latitude: 40.6828, longitude: -73.9940)], .Chicago: [CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298), CLLocationCoordinate2D(latitude: 41.8981, longitude: -87.6498), CLLocationCoordinate2D(latitude: 41.8381, longitude: -87.6598), CLLocationCoordinate2D(latitude: 41.8681, longitude: -87.6498), CLLocationCoordinate2D(latitude: 41.8831, longitude: -87.6438)]]
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet var locationPickerView: UIPickerView!
    @IBOutlet weak var zoomButton: UIButton?
    
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationPickerView.delegate = self
        self.locationPickerView.dataSource = self

        zoomButton?.accessibilityIdentifier = "ZoomButton"
        
        self.mapView?.delegate = self
        let (centerLatitude, centerLongitude) = self.coordinateDict[.SanFrancisco] ?? (0, 0)
        self.zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 8000, longitudinalMeters: 8000)
        
        self.addAnnotations(location: .SanFrancisco)
        self.addAnnotations(location: .NewYork)
        self.addAnnotations(location: .Chicago)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.requestLocationPermission()
    }
    
    func requestLocationPermission() {
        if self.locationManager == nil {
            let locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.requestWhenInUseAuthorization()
            
            self.locationManager = locationManager
        }
    }
    
    func requestAndSendNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            guard error == nil else {
                return
            }
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("Charging Notification", comment: "")
            content.body = NSLocalizedString("Your vehicle has finished charging",comment: "")
            content.categoryIdentifier = "alarm"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    @IBAction func zoomToCityTapped() {
        
        // send a notification for testing
        requestAndSendNotifications()
        // Do nothing for now
        let city = self.locationList[self.locationPickerView.selectedRow(inComponent: 0)]
        switch city {
        case .SanFrancisco:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.SanFrancisco] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 8000, longitudinalMeters: 8000)
        case .NewYork:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.NewYork] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 8000, longitudinalMeters: 8000)
        case .Chicago:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.Chicago] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 8000, longitudinalMeters: 8000)
        }
    }
    
    func zoomToLocation(latitude: Double, longitude: Double, latitudinalMeters: Double, longitudinalMeters: Double) {
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        self.mapView?.setRegion(region, animated: true)
    }
    
    func addAnnotations(location: ZoomLocation) {
        if let points = annotationCoordDict[location] {
            for point in points {
                let annotation = MKPointAnnotation()
                annotation.coordinate = point
                mapView?.addAnnotation(annotation)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.locationList[row].description
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "ChargerPin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if (annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            let annotationImage = UIImage(systemName: "bolt.circle.fill")?.withTintColor(stationStatusColors.randomElement() ?? UIColor(red: 0.2039, green: 0.7804, blue: 0.3490, alpha: 1))
            let size = CGSize(width: 30, height: 30)
            annotationView?.image = UIGraphicsImageRenderer(size: size).image {
                _ in annotationImage?.draw(in: CGRect(origin:.zero, size: size))
            }
            
            annotationView?.layer.cornerRadius = (annotationView?.frame.height ?? 1)/2
            annotationView?.layer.backgroundColor = UIColor.white.cgColor
            annotationView?.layer.shadowColor = UIColor.black.cgColor
            annotationView?.layer.shadowOpacity = 0.25
            annotationView?.layer.shadowOffset = .zero
            annotationView?.layer.shadowRadius = 10
            annotationView?.layer.shadowPath = UIBezierPath(rect: annotationView?.bounds ?? CGRectZero).cgPath
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
}

