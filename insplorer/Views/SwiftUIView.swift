//
//  SwiftUIView.swift
//  Insplorer
//
//  Created by Charles on 2020/4/30.
//  Copyright © 2020 Charles. All rights reserved.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI

struct Photo: Identifiable {
    let id = UUID()
    
    let displayURL: String
    let text: String
    let thumbnailURL: String
}


struct PhotoView: View {
    
    let photo: Photo
    
    var body: some View {
        WebImage(url: URL(string: photo.thumbnailURL)!)
             .placeholder(Image(systemName: "photo")) 
                    .resizable()
            .frame(width: 136, height: 136)
    }
}

struct PhotoRow: View {
    let photoList:[Photo]
    
    var body: some View {
        HStack(spacing: 2){
            PhotoView(photo: photoList[0])
            PhotoView(photo: photoList[1])
            PhotoView(photo: photoList[2])
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: Photo(displayURL: "", text: "", thumbnailURL: ""))
    }
}
