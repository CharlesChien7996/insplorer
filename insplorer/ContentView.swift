//
//  ContentView.swift
//  Insplorer
//
//  Created by Charles on 2020/4/23.
//  Copyright © 2020 Charles. All rights reserved.
//

import SwiftUI
import MapKit
import Alamofire
import QGrid

struct ContentView: View {
    
    @ObservedObject var landmarkViewModel = LandmarkViewModel()
    
    @State private var searchText: String = ""
    @State private var showingPlaceDetails: Bool = false
    @State private var seletedPlace: LandmarkAnnotation?
    @State var shouldUpdateMap: Bool = false
    
    @State private var photoList: [Photo] = []
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                MapView(landmarks: landmarkViewModel.dataSource, showingPlaceDetails: $showingPlaceDetails, shouldUpdateMap: $shouldUpdateMap, seletedLandmark: $seletedPlace)
                TextField("探索附近", text: self.$searchText) {
                    self.landmarkViewModel.city = self.searchText
                    self.shouldUpdateMap = true
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }
            
            List(self.landmarkViewModel.dataSource, id: \.id) {
                landmark in
                VStack(alignment: .leading) {
                    Text(landmark.name)
                    Text(landmark.title)
                }
            }
        }.sheet(isPresented: $showingPlaceDetails, onDismiss: {
            print("dismiss")
            self.photoList = []
        }) {
            if self.photoList.isEmpty {
                Text("Loading").onAppear {
                    print("appear")
                    AF.request("https://explore-dot-pythonprojectspot.df.r.appspot.com/instagram/search", method: .post,parameters:["tag": self.seletedPlace?.title?.replacingOccurrences(of: " ", with: "")], encoder: JSONParameterEncoder.default).responseJSON { response in
                        switch response.result {
                        case .success:
                            print("Validation Successful")
                            if let data = response.value as? [String: String]{
                                AF.request("https://explore-dot-pythonprojectspot.df.r.appspot.com/instagram/location/posts", method: .get,parameters:["location_id": data["location_id"], "slug": data["slug"]]).responseJSON { response in
                                    switch response.result {
                                    case .success:
                                        print("Validation Successful")
                                        
                                        if let data = response.value as? [String: Any]{
                                            if let photoList = data["posts"] as? [[String: Any]] {
                                                var temp:[Photo] = []
                                                for i in photoList {
                                                    if let url = i["thumbnail_url"] as? String {
                                                        temp.append(Photo(displayURL: url, text: "", thumbnailURL: url))
                                                    }
                                                }
                                                self.photoList = temp
                                            }
                                        }
                                    case let .failure(error):
                                        print(error)
                                    }
                                }
                            }
                            
                        case let .failure(error):
                            print(error)
                        }
                    }
                }
            }else {
                QGrid(self.photoList, columns: 3){ photo in
                    PhotoView(photo: photo)
                }
            }

            }}
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            Text("test")
            Text("t")
            Divider().padding(-8)
        }.padding(.horizontal)
    }
}
