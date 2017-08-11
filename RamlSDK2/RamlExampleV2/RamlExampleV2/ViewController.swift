//
//  ViewController.swift
//  RamlExampleV2
//
//  Created by ChenHeng on 11/08/2017.
//  Copyright © 2017 qingmang. All rights reserved.
//

import UIKit
import RamlSDK2
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let path = Bundle.main.path(forResource: "article3", ofType: "json") {
            do {
                let str = try String(contentsOfFile: path)
                let json = JSON(parseJSON:str)
                let articleJson = json["article"]
                let contentHtml = articleJson["contentHtml"].stringValue                            
                let view = RamlRenderView(frame: self.view.bounds, contentHtml: contentHtml)
                view.viewController = self
                self.view.addSubview(view)
            } catch {
                
            }
        }
        
    }


}

