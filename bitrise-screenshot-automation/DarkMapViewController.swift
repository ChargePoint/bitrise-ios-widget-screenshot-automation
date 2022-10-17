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
    case Default
    case SanFrancisco
    case NewYork
    case Chicago
    
    var description: String {
        switch self {
        case .Default:
            return "Default"
        case .SanFrancisco:
            return "San Francisco"
        case .NewYork:
            return "New York"
        case .Chicago:
            return "Chicago"
        }
    }
}

class DarkMapViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var locationList: [ZoomLocation] = [.Default, .SanFrancisco, .NewYork, .Chicago]
    var coordinateDict: Dictionary<ZoomLocation, (Double, Double)> = [.Default: (54.5260, -105.2551), .SanFrancisco: (37.7749, -122.4194), .NewYork: (40.7128, -74.0060), .Chicago: (41.8781, -87.6298)]
    
    @IBOutlet weak var mapView: MKMapView?
    @IBOutlet var locationPickerView: UIPickerView!
    @IBOutlet weak var zoomButton: UIButton?

    var locationManager: CLLocationManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationPickerView.delegate = self
        self.locationPickerView.dataSource = self
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

    @IBAction func zoomToCityTapped() {
        // Do nothing for now
        let city = self.locationList[self.locationPickerView.selectedRow(inComponent: 0)]
        switch city {
        case .Default:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.Default] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 6000000, longitudinalMeters: 6000000)
        case .SanFrancisco:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.SanFrancisco] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 50000, longitudinalMeters: 50000)
        case .NewYork:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.NewYork] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 50000, longitudinalMeters: 50000)
        case .Chicago:
            let (centerLatitude, centerLongitude) = self.coordinateDict[.Chicago] ?? (0, 0)
            zoomToLocation(latitude: centerLatitude, longitude: centerLongitude, latitudinalMeters: 50000, longitudinalMeters: 50000)
        }
    }
    
    func zoomToLocation(latitude: Double, longitude: Double, latitudinalMeters: Double, longitudinalMeters: Double) {
        let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        self.mapView?.setRegion(region, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.locationList[row].description
    }

}

