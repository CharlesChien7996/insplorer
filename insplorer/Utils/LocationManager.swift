//
//  LocationManager.swift
//  BucketList
//
//  Created by Charles on 2020/4/23.
//  Copyright © 2020 Charles. All rights reserved.
//

import Foundation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let locationManager: CLLocationManager = CLLocationManager()
    var location: CLLocation?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.stopUpdatingLocation()

    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print(status)
        self.location = manager.location
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
    
}
