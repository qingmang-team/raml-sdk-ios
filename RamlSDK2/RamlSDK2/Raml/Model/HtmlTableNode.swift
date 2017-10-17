//
//  HtmlTableNode.swift
//  RamlExample
//
//  Created by ChenHeng on 08/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class HtmlTableRowNode: HtmlNode {
    var columCount:Int {        
        return self.columnNodeArray.count        
    }
    var columnNodeArray = [HtmlTableColumnNode]()    
}

class HtmlTableColumnNode: HtmlNode {
    var textNode: HtmlTextNode?
}

class HtmlTableNode: HtmlNode {
    var rowCount:Int = 0
    var colCount:Int = 0
    
    var tableRowArray = [HtmlTableRowNode]()
}
