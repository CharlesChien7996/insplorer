//
//  MapView.swift
//  Insplorer
//
//  Created by Charles on 2020/4/23.
//  Copyright © 2020 Charles. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let landmarks: Array<LandmarkRowViewModel>
    @Binding var showingPlaceDetails: Bool
    @Binding var shouldUpdateMap: Bool
    @Binding var seletedLandmark: LandmarkAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        //        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if self.shouldUpdateMap {
            self.updateAnnotations(from: uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    private func updateAnnotations(from mapview: MKMapView) {
        mapview.removeAnnotations(mapview.annotations)
        let annotations = self.landmarks.map(LandmarkAnnotation.init)
        mapview.showAnnotations(annotations, animated: true)
    }
    
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var mapControl: MapView
    
    init(_ control: MapView) {
        self.mapControl = control
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if let annotationView = views.first {
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // this is our unique identifier for view reuse
            let identifier = "Placemark"
            
            if annotation.isKind(of: MKUserLocation.self) {
                return nil
            }
            // attempt to find a cell we can recycle
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            
            if annotationView == nil{
                // we didn't find one; make a new one
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                // allow this to show pop up information
                annotationView?.canShowCallout = true
                
//                annotationView?.animatesWhenAdded = true
//
//
//                annotationView?.markerTintColor = UIColor.orange
                
                //            annotationView?.tintColor = UIColor.green
                //            annotationView?.pinTintColor = UIColor.green
                //            annotationView?.backgroundColor = UIColor.green
                annotationView!.image = UIImage.init(named: "terrible")
                // attach an information button to the view
                annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                annotationView!.leftCalloutAccessoryView = UIImageView.init(image:  UIImage.init(named: "terrible"))
                
            }
            
//            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: .autoreverse,
//                                                           animations: {
//                                                            annotationView?.frame = CGRect(x: 10, y: 150, width: 40, height: 40)
//                })
            return annotationView
        }
    
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let placemark = view.annotation as? LandmarkAnnotation else { return }
            mapControl.seletedLandmark = placemark
            mapControl.showingPlaceDetails = true
            mapControl.shouldUpdateMap = false
        }
    
}
