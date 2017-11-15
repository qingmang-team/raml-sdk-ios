//
//  NSAttributeString+DetailTheme.swift
//  RamlExample
//
//  Created by ChenHeng on 09/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    class func paragraphHtmlBodyText() -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 14
        style.lineBreakMode = .byWordWrapping
        style.alignment = .natural
        let titleAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 11),
                               NSParagraphStyleAttributeName: style]
        return NSMutableAttributedString(string: "\n\n", attributes: titleAttributes)
    }
    
    class func mutableHtmlBodyText(text: String,
                                   textColor: UIColor,
                                   font: UIFont,
                                   shouldSmallFont: Bool,
                                   alignment: NSTextAlignment) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        //        style.maximumLineHeight = shouldSmallFont ? 0 : 28
        style.lineSpacing = 1.5
        style.lineBreakMode = .byWordWrapping
        let baselineOffet = shouldSmallFont ? 0 : 4
        style.alignment = alignment
        let titleAttbutes: [String: Any] = [NSFontAttributeName: font,
                                            NSForegroundColorAttributeName: textColor,
                                            NSBaselineOffsetAttributeName: baselineOffet,
                                            NSKernAttributeName: 0,
                                            NSParagraphStyleAttributeName: style]
        return NSMutableAttributedString(string: text, attributes: titleAttbutes)
    }
    
    class func mangoHtmlHrefLinkAttribute(_ font: UIFont, fontColor: UIColor) -> [String: Any] {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 28
        style.lineBreakMode = .byWordWrapping
        style.alignment = .left
        let dashed = NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.styleSingle.rawValue
        let linkAttr: [String: Any] = [NSFontAttributeName: font,                                       
                                       NSUnderlineStyleAttributeName: NSNumber(value: dashed),
                                       NSUnderlineColorAttributeName: fontColor,
                                       NSBaselineOffsetAttributeName: NSNumber(value: 4),
                                       NSParagraphStyleAttributeName: style]
        return linkAttr
    }
    
    class func imageTitleHtmlBodyText(_ title: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 14
        style.lineBreakMode = .byWordWrapping
        style.alignment = .natural
        let titleAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName: UIColor.gray, NSParagraphStyleAttributeName: style]
        return NSMutableAttributedString(string: title, attributes: titleAttributes)
    }
    
    class func mediaTitleHtmlBodyText(_ title: String) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        style.lineBreakMode = .byWordWrapping
        style.alignment = .natural
        let titleAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName: UIColor.gray, NSParagraphStyleAttributeName: style]
        return NSMutableAttributedString(string: title, attributes: titleAttributes)
    }
}
