//
//  HtmlImageNode.swift
//  RamlExample
//
//  Created by ChenHeng on 08/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class HtmlImageNode: HtmlNode {
    var imageURL:String?
    var imageWidth:CGFloat = 0
    var imageHeight:CGFloat = 0
    var isUnknownSize = false
    var titleTextNode:HtmlTextNode?
}
