//
//  RAMLDetailImageCell.swift
//  RamlExample
//
//  Created by ChenHeng on 10/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit
import SDWebImage


class RAMLDetailImageCell: UICollectionViewCell {
    var imageNode:HtmlImageNode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        contentView.addSubview(imageView)
    }
    
    func config(imageNode:HtmlImageNode) {
//        setup()
        self.imageNode = imageNode
        if let urlStr = imageNode.imageURL, let url = URL(string:urlStr){
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setImage(with: url)
        }
        imageView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    //Other
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Property
    lazy var imageView:FLAnimatedImageView = {
        return FLAnimatedImageView()
    }()
}
