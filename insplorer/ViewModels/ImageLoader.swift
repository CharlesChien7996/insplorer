//
//  ImageLoader.swift
//  Insplorer
//
//  Created by Charles on 2020/4/30.
//  Copyright © 2020 Charles. All rights reserved.
//

import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cancellable: AnyCancellable?
    
    
    init(url: URL) {
        self.url = url
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        
        guard !isLoading else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            if let data = data {
                self.image = UIImage(data: data)
                
            }
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        image = nil

        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
//
//    private func cache(_ image: UIImage?) {
//        image.map { cache?[url] = $0 }
//    }
}
