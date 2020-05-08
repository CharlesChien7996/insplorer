//
//  LandmarkRowViewModel.swift
//  Insplorer
//
//  Created by Charles on 2020/4/29.
//  Copyright © 2020 Charles. All rights reserved.
//

import Foundation
import MapKit

struct LandmarkRowViewModel: Identifiable {
  let placemark: MKPlacemark
  var id: UUID = UUID()
  
  var name: String {
      self.placemark.name ?? ""
  }
  var title: String {
      self.placemark.title ?? ""
  }
  var coordinate: CLLocationCoordinate2D {
      self.placemark.coordinate
  }
}


