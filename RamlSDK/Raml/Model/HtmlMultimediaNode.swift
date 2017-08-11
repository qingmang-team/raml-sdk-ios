//
//  HtmlMultimediaNode.swift
//  RamlExample
//
//  Created by ChenHeng on 08/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit

class HtmlMultimediaNode: HtmlNode {
    var audioURL:String?
    var videoURL:String?
    var coverImageURL:String?
    var coverSize:CGSize = .zero
    var durTime:CGFloat = 0    
    var titleTextNode:HtmlTextNode?
    
    var isAudio:Bool {
        guard let audioURL = self.audioURL else {
            return false
        }
        return audioURL.characters.count > 0
    }
}
