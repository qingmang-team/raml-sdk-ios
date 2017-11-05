//
//  RAMLDetailTextCell.swift
//  RamlExample
//
//  Created by ChenHeng on 10/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit
import SDWebImage

class RAMLDetailTextCell: UICollectionViewCell {
    
    var textNode: HtmlTextNode?
    
    override init(frame: CGRect) {        
        super.init(frame: frame)        
    }
    
    func setup() {
        contentView.addSubview(textLabel)
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
        textLabel.attributedText = textNode.contentString
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
            //            textLabel.frame = self.bounds;
            let leftPadding = textNode?.textLeftPadding ?? 0
            let rightPadding = textNode?.textRightPadding ?? 0
            textLabel.frame = CGRect(x: leftPadding, y: 0, width: frame.size.width - rightPadding - leftPadding, height: frame.size.height)
        }
    }
    
    // Other
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
}
