//
//  LandmarkViewModel.swift
//  Insplorer
//
//  Created by Charles on 2020/4/29.
//  Copyright © 2020 Charles. All rights reserved.
//

import SwiftUI
import Combine
import MapKit

class LandmarkViewModel: ObservableObject, Identifiable {
    @ObservedObject var locationManager = LocationManager()
    @Published var city: String = ""
    @Published var dataSource: [LandmarkRowViewModel] = []
    private var disposables = Set<AnyCancellable>()
    
    init() {
        $city
            .dropFirst(1)
            .sink(receiveValue: getNearByLandmarks(for:))
            .store(in: &disposables)
    }
    
    
    private func getNearByLandmarks(for searchText: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(center: locationManager.location!.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else{
                if let error = error {
                    print("error: \(error)")
                }
                return
            }
            let mapItems = response.mapItems
            self.dataSource = mapItems.map { (item) -> LandmarkRowViewModel in
                LandmarkRowViewModel(placemark: item.placemark)
            }
        }
    }
    
}
