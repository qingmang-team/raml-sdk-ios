//
//  RAMLDetailVideoCell.swift
//  RamlExample
//
//  Created by ChenHeng on 10/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit
import SDWebImage


class RAMLDetailVideoCell: UICollectionViewCell {
    
    var multimediaNode:HtmlMultimediaNode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(imageView)
        addSubview(playButton)     
    }
    
    func config(multimediaNode:HtmlMultimediaNode) {
        self.multimediaNode = multimediaNode
        
        if let urlStr = multimediaNode.coverImageURL, let url = URL(string:urlStr){
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setImage(with: url)
        }
        imageView.frame = self.bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
        playButton.frame = self.bounds
    }
    
    //Action
    func SELTapPlayButtonAction() {
        if let urlStr = self.multimediaNode?.videoURL{
            playBlock?(urlStr)
        }
    }
    
    //Other
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Property
    var playBlock:((String) -> Void)?
    lazy var playButton:UIButton = {
        let button = UIButton(type: UIButtonType.custom)        
        button.setImage(UIImage(named: "video_player"), for: UIControlState.normal)
        button.frame = self.bounds
        button.alpha = 0.7
        button.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        button.addTarget(self, action: #selector(SELTapPlayButtonAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var imageView:FLAnimatedImageView = {
        return FLAnimatedImageView()
    }()
}
