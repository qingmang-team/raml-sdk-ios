//
//  HtmlHrTagNode.swift
//  RamlExample
//
//  Created by ChenHeng on 08/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class HtmlHrTagNode: HtmlNode {
    override var contentHeight: CGFloat {
        get {
            return 5   
        }        
        set {
            self.contentHeight = newValue
        }
    }
}
