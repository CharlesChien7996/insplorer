//
//  PlaceListView.swift
//  Insplorer
//
//  Created by Charles on 2020/4/24.
//  Copyright © 2020 Charles. All rights reserved.
//

import SwiftUI
import MapKit

struct PlaceListView: View {
    let landmarks: Array<Landmark>
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .top) {
                HStack {
                    EmptyView()
                }.frame(width: UIScreen.main.bounds.width,height: 40.0)
                    .background(Color(UIColor.systemBackground))
                    .gesture(TapGesture()
                        .onEnded(self.onTap))
                Capsule()
                    .frame(width: 40.0,height: 5.0)
                    .foregroundColor(Color.gray)
                    .padding(.top, 5.0)
            }.padding(.bottom, -10.0)
            
            List(self.landmarks, id: \.id) { landmark in
               VStack(alignment: .leading) {
                   Text(landmark.name)
                   Text(landmark.title)
               }
            }.animation(nil)
        }.cornerRadius(10.0).gesture(DragGesture().onEnded({ _ in
            self.onTap()
        }))
    }
}

struct PlaceListView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceListView(landmarks: [], onTap: {})
    }
}






