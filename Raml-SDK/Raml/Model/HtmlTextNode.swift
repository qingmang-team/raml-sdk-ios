//
//  HtmlTextNode.swift
//  RamlExample
//
//  Created by ChenHeng on 08/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class HtmlTextListNode: NSObject {
    var type:String = ""
    var level = 0
    var order = 0
}

class HtmlTextNode: HtmlNode {
    var isBlockquote = false
    var isListTag = false
    var isTabTag = false
    var isHeading = false
    var isImageSubTitle = false

    var orderListIndex = 0
    var isOrderList = false
    var isUnOrderList = false    
    var listIndentLevel = 0
    var listNode:HtmlTextListNode?
    
    var imageAttachArray = [InnerLineImageAttachment]()
    
    var shouldAlignCenter = false
    
    var contentString:NSMutableAttributedString?
        
}
