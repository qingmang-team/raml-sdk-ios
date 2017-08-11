//
//  ImageURLHelper.swift
//  RamlExample
//
//  Created by ChenHeng on 09/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import Foundation
import UIKit

class ImageURLHelper: NSObject {
    
    class func imageSize(with originURL:String) -> CGSize{ 
        let charCount = originURL.characters.count
        if charCount == 0 {
            return .zero   
        }
        do {
            let regexSize = try NSRegularExpression(pattern: "^(http://.+/image/orion/.+)_(\\d{1,6})_(\\d{1,6})\\.(.+)$", options: NSRegularExpression.Options.caseInsensitive)
            if let result = regexSize.firstMatch(in: originURL, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: charCount)) {
                let str = originURL as NSString 
                let width = str.substring(with: result.rangeAt(2))
                let height = str.substring(with: result.rangeAt(3))
                if let widthF = Float(width), let heightF = Float(height) {
                    return CGSize(width: CGFloat(widthF), height: CGFloat(heightF))
                }                                
            }            
        } catch  {
//            return .zero
        }        
        
        return .zero
    }
}
