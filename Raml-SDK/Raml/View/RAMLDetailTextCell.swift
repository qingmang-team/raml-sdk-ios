//
//  RAMLDetailTextCell.swift
//  RamlExample
//
//  Created by ChenHeng on 10/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class RAMLDetailTextCell: UICollectionViewCell {    
    
    var textNode:HtmlTextNode?
    
    override init(frame: CGRect) {
//        self.textNode = textNode
        super.init(frame: frame)
//        setup()
    }
    
    func setup() {
        contentView.addSubview(textLabel)
    }
    
    func config(textNode:HtmlTextNode) {
        setup()
        self.textNode = textNode
        textLabel.attributedText = textNode.contentString
//        textLabel.sizeToFit()
//        textLabel.frame = self.bounds
//        setNeedsLayout()        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let textNode = self.textNode, textNode.shouldAlignCenter {
            textLabel.sizeToFit()
            textLabel.center = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        }else {
            textLabel.frame = self.bounds;   
        }                
    }
    
    //Other
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
}
