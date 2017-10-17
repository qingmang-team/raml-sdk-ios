//
//  InnerLineImageAttachment.swift
//  RamlExample
//
//  Created by ChenHeng on 09/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class InnerLineImageAttachment: NSTextAttachment {
    var imageURL:String = ""
    var topOffset:CGFloat = 0
    
    override func attachmentBounds(for textContainer: NSTextContainer?, 
                                   proposedLineFragment lineFrag: CGRect, 
                                   glyphPosition position: CGPoint, 
                                   characterIndex charIndex: Int) -> CGRect {
        if self.topOffset == 0 {
            return super.attachmentBounds(for: textContainer, proposedLineFragment: lineFrag, glyphPosition: position, characterIndex: charIndex)
        }
        let bounds = CGRect(x: 0, y: self.topOffset, width: image?.size.width ?? 0, height: image?.size.height ?? 0)
        return bounds
    }
}
