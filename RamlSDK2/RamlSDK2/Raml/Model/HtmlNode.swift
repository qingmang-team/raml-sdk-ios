//
//  HtmlNode.swift
//  RamlExample
//
//  Created by ChenHeng on 08/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class HtmlNode: NSObject {
    
    var contentHeight:CGFloat = 0
    var contentWidth:CGFloat = 0
    var tagID:String = ""
    var orderIndex = 0    
    var top:CGFloat = 0
    var bottom:CGFloat = 0
    var rawJsonString = ""
    
    var textLeftPadding:CGFloat = 0
    var textRightPadding:CGFloat = 0
    
    var rowHeight:CGFloat {
        get {
            return self.contentHeight + self.top + self.bottom
        }
    }
    
    var contentSize:CGSize {
        get {            
            return CGSize(width: self.contentWidth, height: self.rowHeight)
        }                
    }
}
