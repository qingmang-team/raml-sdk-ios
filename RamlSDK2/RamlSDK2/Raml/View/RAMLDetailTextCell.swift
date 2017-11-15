//
//  RAMLDetailTextCell.swift
//  RamlExample
//
//  Created by ChenHeng on 10/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit
import SDWebImage
import TTTAttributedLabel

class RAMLDetailTextCell: UICollectionViewCell {
    
    var textNode: HtmlTextNode?
    
    override init(frame: CGRect) {        
        super.init(frame: frame)        
    }
    
    func setup() {                        
        addSubview(textLabel)
        textLabel.isUserInteractionEnabled = true
        textLabel.delegate = self
        textLabel.lineBreakMode = .byTruncatingTail        
        textLabel.numberOfLines = 0
        
        let dashed = NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.styleSingle.rawValue
        textLabel.linkAttributes = [NSUnderlineStyleAttributeName: NSNumber(value: dashed)]        
    }
    
    func checkAttachImageLoadFinish(image: UIImage, attachment: InnerLineImageAttachment) {
        guard let contentString = textNode?.contentString else {
            return
        }
        let range = NSRange(location: 0, length: contentString.length)
        textNode?.contentString?.enumerateAttribute(NSAttachmentAttributeName, in: range,
                                                    options: NSAttributedString.EnumerationOptions.reverse,
                                                    using: {[weak self, weak attachment] value, _, _ in
                                                        if let attach = value as? InnerLineImageAttachment, attach.imageURL == attachment?.imageURL {
                                                            attachment?.image = image
                                                            self?.textLabel.setNeedsDisplay()
                                                        }
        })
    }
    
    func config(textNode: HtmlTextNode) {
        setup()
        self.textNode = textNode
        if let contentString = textNode.contentString {
            textLabel.attributedText = contentString
            contentString.enumerateAttribute(NSLinkAttributeName, in: NSRange(location: 0, length: contentString.length), options: NSAttributedString.EnumerationOptions.reverse, using: {
                [weak self] (value, range, stop) in
                guard let value = value else {
                    return
                }
                if let url = value as? URL {
                    _ = self?.textLabel.addLink(to: url, with: range)   
                }            
            })    
        }                 
        for attach in textNode.imageAttachArray {
            let urlStr = attach.imageURL
            SDWebImageManager.shared().loadImage(with: URL(string: urlStr), options: SDWebImageOptions.avoidAutoSetImage, progress: { _, _, _ in                
            }, completed: {[weak self, weak attach] image, _, _, _, _, _ in
                if let attachment = attach, let image = image {
                    self?.checkAttachImageLoadFinish(image: image, attachment: attachment)   
                }                
            })        
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textNode = self.textNode, textNode.shouldAlignCenter {
            textLabel.sizeToFit()
            textLabel.center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        } else {            
            let leftPadding = textNode?.textLeftPadding ?? 0
            let rightPadding = textNode?.textRightPadding ?? 0
            let maxWidth = frame.size.width - rightPadding - leftPadding
            textLabel.frame = CGRect(x: leftPadding, y: 0, width:maxWidth , height: frame.size.height)            
//            
        }
    }
    
    // Other
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onLinkTappedActionBlock: ((URL) -> Void)?
    
    lazy var textLabel: TTTAttributedLabel = {        
        let label = TTTAttributedLabel(frame: .zero)
        return label
    }()
}

extension RAMLDetailTextCell : TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {        
        onLinkTappedActionBlock?(url)
    }   
}
