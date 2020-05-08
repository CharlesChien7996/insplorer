//
//  LandmarkAnnotation.swift
//  Insplorer
//
//  Created by Charles on 2020/4/23.
//  Copyright © 2020 Charles. All rights reserved.
//

import UIKit
import MapKit

class LandmarkAnnotation: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(landmark: LandmarkRowViewModel) {
        self.title = landmark.name
        self.coordinate = landmark.coordinate
    }
}
