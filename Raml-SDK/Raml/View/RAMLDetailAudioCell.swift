//
//  RAMLDetailAudioCell.swift
//  RamlExample
//
//  Created by ChenHeng on 11/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class RAMLDetailAudioCell: UICollectionViewCell {
    var multimediaNode:HtmlMultimediaNode?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        addSubview(borderView)
        addSubview(imageView)
        addSubview(textLabel)
        addSubview(playButton)                  
    }
    
    func config(multimediaNode:HtmlMultimediaNode) {
        self.multimediaNode = multimediaNode
        
        if let urlStr = multimediaNode.coverImageURL, let url = URL(string:urlStr){            
            imageView.sd_setShowActivityIndicatorView(true)
            imageView.sd_setImage(with: url)
        }
        imageView.frame = CGRect(x: 20, y: 0, width: multimediaNode.coverSize.width, height: multimediaNode.coverSize.height)
        if let titleNode = multimediaNode.titleTextNode {
            textLabel.attributedText = titleNode.contentString
            textLabel.frame = CGRect(x: imageView.frame.size.width + imageView.frame.origin.x + 10, y: imageView.frame.origin.y, width: titleNode.contentWidth, height: titleNode.contentHeight)    
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()        
        playButton.frame = imageView.frame 
        if let multimediaNode = self.multimediaNode {
            borderView.frame = CGRect(x: 20, y: 0, width: self.frame.size.width - 40, height: multimediaNode.contentHeight)   
        }else {
            borderView.frame = CGRect(x: 20, y: 0, width: self.frame.size.width - 40, height: self.frame.size.height)            
        }        
    }
    
    //Action
    func SELTapPlayButtonAction() {
        if let urlStr = self.multimediaNode?.audioURL{
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
        button.setImage(UIImage(named: "audio_card_icon"), for: UIControlState.normal)
        button.frame = self.bounds
        button.imageView?.contentMode = .center
        button.alpha = 0.7
        button.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        button.addTarget(self, action: #selector(SELTapPlayButtonAction), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var imageView:FLAnimatedImageView = {
        let imageView = FLAnimatedImageView()
        imageView.backgroundColor = UIColor.gray
        return imageView
    }()
    
    lazy var textLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var borderView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()

}

