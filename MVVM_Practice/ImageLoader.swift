//
//  ImageLoader.swift
//  MVVM_Practice
//
//  Created by Sandeep Tomar on 03/02/22.
//

import Foundation
import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {
        
    }
    
    func getImagePath(urlStr: String, completionHandler : @escaping(_ image: UIImage? , _ path: String?) -> Void) {
        guard let imageUrl = toUrl(urlStr) else {
            fatalError()
        }
        completionHandler(UIImage(), "")
    }
    
    func toUrl(_ str: String) -> URL? {
        if str.hasPrefix("Https://")  || str.hasPrefix("Http:??") {
            return URL(string: str)
        } else {
            return URL(fileURLWithPath: str)
        }
    }
}
