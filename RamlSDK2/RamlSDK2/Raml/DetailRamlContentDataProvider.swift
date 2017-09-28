//
//  DetailRamlContentDataProvider.swift
//  Mango
//
//  Created by ChenHeng on 23/07/2016.
//  Copyright © 2016 lianpian. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailRamlContentDataProvider: NSObject {
      
    var contentNodeArray = [HtmlNode]()
    var imageURLArray = [String]()
    var imageNodeArray = [HtmlImageNode]()    
    var contentHtml:String?
    var contentMaxWidth: CGFloat    
    var setting:RAMLRenderSetting
    var htmlParseDoneBlock:(()->())?
           
    override init() {
        let minWidth = min(UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        contentMaxWidth = minWidth
        self.setting = RAMLRenderSetting()
        super.init()
    }
    
    init(contentWidth: CGFloat) {
        self.contentMaxWidth = contentWidth
        self.setting = RAMLRenderSetting()
        super.init()
    }
    
    init(setting:RAMLRenderSetting) {
        let minWidth = min(UIScreen.main.bounds.width,UIScreen.main.bounds.height)
        contentMaxWidth = minWidth        
        self.setting = setting
        super.init()
    }
    
    func reset() {
        contentNodeArray.removeAll()
        imageURLArray.removeAll()
        imageNodeArray.removeAll()
    }
    
    func checkImageNodeLayout(node:HtmlImageNode, index:Int) {
        if node.isUnknownSize {
            node.imageHeight = 40
            node.contentWidth = self.contentMaxWidth
            node.contentHeight = 40
            node.imageWidth = self.contentMaxWidth
        }
    }
    
    func parseJsonStr(jsonString:String) {
        var resultArray = [HtmlNode]()
        let json = JSON(parseJSON: jsonString)
        for (idx, subJson): (String, JSON) in json {
            if let type = subJson["type"].int {
                switch type {
                case 0:
                    let fontSize = setting.fontSize
                    let font = detailNormalFont()
                    let fontColor = setting.fontColor
                    if let textNode = DetailRamlContentDataProvider.createTextNode(subJson, font:font, fontSize:fontSize, fontColor:fontColor) {
                        resultArray.append(textNode)
                    }
                case 1:
                    if let imageNode = self.createImageNode(subJson) {
                        self.checkImageNodeLayout(node: imageNode, index: idx == "0" ? 0 : 1)
                        resultArray.append(imageNode)
                        if let titleTextNode = imageNode.titleTextNode {
                            resultArray.append(titleTextNode)
                        }
                    }
                case 2:
                    if let videoNode = self.createVideoNode(subJson) {
                        resultArray.append(videoNode)
                        if let titleTextNode = videoNode.titleTextNode{
                            resultArray.append(titleTextNode)
                        }
                    }
                case 3:
                    if let audioNode = self.createAudioNode(subJson) {
                        resultArray.append(audioNode)
                        if let titleTextNode = audioNode.titleTextNode {
                            resultArray.append(titleTextNode)
                        }
                    }
                case 4:
                    if let tableNode = self.createTableNode(subJson) {
                        resultArray.append(tableNode)
                    }
                case 10:
                    resultArray.append(self.createNewLineTextNode())
                case 11:
                    continue
                default:
                    continue
                }
            }
        }
     
        reset()
        var nodeArray = [HtmlNode]()
        var previousNode: HtmlNode?
        for (idx,htmlNode) in resultArray.enumerated() {
            htmlNode.orderIndex = idx
            if let imageHtmlNode = htmlNode as? HtmlImageNode, let url = imageHtmlNode.imageURL {
                self.imageNodeArray.append(imageHtmlNode)
                self.imageURLArray.append(url)
            }
            if previousNode == nil {
                htmlNode.top = 0
            } else if let htmlTextNode = htmlNode as? HtmlTextNode {
                htmlTextNode.textLeftPadding = self.setting.textLeftPadding
                htmlTextNode.textRightPadding = self.setting.textRightPadding
                let size = sizeOfTextNode(node: htmlTextNode)
                htmlTextNode.contentWidth = self.contentMaxWidth
                htmlTextNode.contentHeight = size.height
                if (htmlTextNode.isHeading) {
                    htmlNode.top = 28
                } else if (htmlTextNode.isImageSubTitle) {
                    htmlNode.top = 10
                } else if let preTextNode = previousNode as? HtmlTextNode, preTextNode.isHeading {
                    htmlNode.top = 14
                } else {
                    htmlNode.top = 14
                }
            } else if previousNode is HtmlImageNode, let imageNode = htmlNode as? HtmlImageNode {
                imageNode.top = 14
            } else {
                htmlNode.top = 14
            }
            if (htmlNode.top > 0) {
                htmlNode.top = htmlNode.top - 4
            }
            htmlNode.bottom = 4
            
            nodeArray.append(htmlNode)
            previousNode = htmlNode
        }
        self.contentNodeArray.append(contentsOf: nodeArray)
    }
    
    func sizeOfTextNode(node:HtmlTextNode) -> CGSize {
        if let str = node.contentString {
            let maxWidth = contentMaxWidth - node.textLeftPadding - node.textRightPadding
            let bounds = str.boundingRect(with: CGSize(width:maxWidth, height:1000000), options: [NSStringDrawingOptions.usesLineFragmentOrigin,.usesFontLeading], context: nil)
            return bounds.size
        }
        return .zero
    }
    
    func parseModel(contentHtml:String, async: Bool) {                
        self.contentHtml = contentHtml
        
        let actionBlock = {
            [weak self] in
            if let str = self?.contentHtml {
                self?.parseJsonStr(jsonString: str)   
            }            
            if async {
                DispatchQueue.main.async {
                    [weak self] in
                    self?.htmlParseDoneBlock?()
                }
            }else {                
                self?.htmlParseDoneBlock?()                   
            }            
        }
        if async {            
            DispatchQueue.global(qos: .background).async {
                actionBlock()    
            }    
        }else {
            actionBlock()
        }
        
    }
        
    class func createTextNode(_ textJson: JSON, font:UIFont, fontSize:CGFloat , fontColor:UIColor) -> HtmlTextNode? {
        let idStr = textJson["id"].stringValue
        if let text = textJson["text"]["text"].string,
            let rawString = textJson.rawString(String.Encoding(rawValue: String.Encoding.utf8.rawValue), options: []) {            
            let textNode = HtmlTextNode()            
            textNode.rawJsonString = rawString                                    
            var shouldAlignCenter = false
            var shouldSmallFont = false
            if let textAlign = textJson["text"]["align"].string {
                if textAlign == "center" {
                    shouldAlignCenter = true
                }
            }
            var _font = font
            if let style = textJson["text"]["linetype"].string {
                switch style {
                case "aside":
                    shouldAlignCenter = true
                case "big":
                    _font = UIFont.boldSystemFont(ofSize: fontSize)
                case "h1","h2":
                    _font = UIFont.boldSystemFont(ofSize: fontSize)                
                case "h3":
                    _font = UIFont.systemFont(ofSize: fontSize)                    
                case "small": // TODO: Line height
                    _font = DetailRamlContentDataProvider.detailSmallFont()
                    shouldSmallFont = true                
                default:
                    print("not support \(style)")
                }
            }
            
            var mutableAttr: NSMutableAttributedString
            let list = textJson["li"]
            var blockLevel = 0
            if !list.isEmpty, let type = list["type"].string, let level = list["level"].int, let order = list["order"].int {
                let listNode = HtmlTextListNode()
                listNode.type = type
                listNode.level = level
                listNode.order = order
                blockLevel = level
                textNode.listNode = listNode
                textNode.isListTag = true
                textNode.isUnOrderList = type == "ul"
                textNode.isOrderList = type == "ol"
            }
            textNode.shouldAlignCenter = shouldAlignCenter
            if let blockquote = textJson["blockquote"].int, blockquote == 1 {
                textNode.isBlockquote = true
            }
            let rawText = text            
            if textNode.isListTag || textNode.isBlockquote {
                if blockLevel == 0 {
                    blockLevel = 1
                }
               shouldSmallFont = false
            } 
            mutableAttr = NSMutableAttributedString.mutableHtmlBodyText(text:rawText,
                                                                        textColor: fontColor,
                                                                        font: _font,                                                                            
                                                                        shouldSmallFont:shouldSmallFont,
                                                                        alignment: shouldAlignCenter ? .center : .left)
            
            for (_, subJson): (String, JSON) in textJson["text"]["markups"] {
                DetailRamlContentDataProvider.applyMarkups(mutableAttr,
                                                           subJson: subJson,
                                                           shouldAlignCenter: shouldAlignCenter,
                                                           textNode: textNode,
                                                           shouldSmallFont: shouldSmallFont, 
                                                           fontSize:fontSize, font:_font, fontColor:fontColor)
            }
            do {                
                let dataDector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let color:UIColor = fontColor
                dataDector.enumerateMatches(in: mutableAttr.string, options: [], range: NSMakeRange(0, mutableAttr.length), using: { (result, flag, stop) in
                    if let result = result, result.resultType == .link, let url = result.url {
                        var foundLink = false
                        mutableAttr.enumerateAttributes(in: result.range, options: [], using: { (dict, range, stop) in
                            if dict.keys.contains("kCustomKeyOnlyWork") {
                                foundLink = true
                            }
                        })
                        if !foundLink {
                            if let dict = NSMutableAttributedString.mangoHtmlHrefLinkAttribute(font,
                                                                                        fontColor:color) as NSDictionary as? [String: AnyObject] {
                                mutableAttr.addAttributes(["kCustomKeyOnlyWork": url], range: result.range)
                                mutableAttr.addAttributes(dict, range: result.range)                            
                            }    
                        }
                        
                    }                     
                })
            }catch {                
            }                        
            textNode.shouldAlignCenter = shouldAlignCenter
            textNode.listIndentLevel = blockLevel
            textNode.contentString = mutableAttr
            textNode.tagID = idStr
            return textNode
        }
        return nil
    }
    
    class func applyMarkups(_ mutableAttr: NSMutableAttributedString, 
                            subJson: JSON, 
                            shouldAlignCenter: Bool, 
                            textNode: HtmlTextNode?, 
                            shouldSmallFont: Bool, 
                            fontSize:CGFloat = 16, 
                            font:UIFont,
                            fontColor:UIColor,
                            maxWidth:CGFloat = 0) {
        if let tag = subJson["tag"].string, let start = subJson["start"].int, let end = subJson["end"].int {
            let maxLength = mutableAttr.length
            var range = NSMakeRange(start, end-start)
            if end > maxLength {
                range = NSMakeRange(start, maxLength-start)
            }
            if tag == "strong" || tag == "em" {
                if shouldSmallFont {
                    mutableAttr.addAttributes([NSFontAttributeName: strongSmallTextFont()], range: range)
                } else {
                    let font = detailBoldFont(fontSize)
                    mutableAttr.addAttributes([NSFontAttributeName: font as Any], range: range)
                }
                mutableAttr.addAttributes([NSForegroundColorAttributeName: fontColor], range: range)
            } else if tag == "sup" {
                mutableAttr.addAttributes([NSFontAttributeName: subSmallTextFont()], range: range)
                mutableAttr.addAttributes([NSBaselineOffsetAttributeName: 10], range: range)
            } else if tag == "sub" {
                mutableAttr.addAttributes([NSFontAttributeName: subSmallTextFont()], range: range)
                mutableAttr.addAttributes([NSBaselineOffsetAttributeName: 1], range: range)
            } else if tag == "small" {
                mutableAttr.addAttributes([NSFontAttributeName: smallTextFont()], range: range)
            } else if tag == "a", let href = subJson["source"].string, let url = URL(string: href) {
                mutableAttr.addAttributes(["kCustomKeyOnlyWork": url], range: range)
                if let dict = NSMutableAttributedString.mangoHtmlHrefLinkAttribute(font,
                                                                            fontColor:fontColor) as NSDictionary as? [String: AnyObject] {
                    mutableAttr.addAttributes(dict, range: range)
                }
            } else if tag == "img", let source = subJson["source"].string {
                let attachment = InnerLineImageAttachment()
                attachment.image = UIImage(named: "image_space")
                var size = CGSize.zero
                if let width = subJson["width"].float, let height = subJson["height"].float, width > 0 , height > 0 {
                    if maxWidth > 0 , width > Float(maxWidth) {
                        let imageHeight = Float(maxWidth)/(width/height)
                        size = CGSize(width: maxWidth, height: CGFloat(imageHeight))
                    }else {
                        size = CGSize(width: CGFloat(width), height: CGFloat(height))   
                    }                    
                } else {
                    size = CGSize(width: 30, height: 30)
                }
                attachment.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                attachment.imageURL = source
                let attachAttr = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
                let style = NSMutableParagraphStyle()
                style.alignment = shouldAlignCenter ? .center : .left
                attachAttr.addAttributes([NSParagraphStyleAttributeName: style], range: NSMakeRange(0, attachAttr.length))
                mutableAttr.insert(attachAttr, at: start)                
                textNode?.imageAttachArray.append(attachment)
            }
        }
    }
    
    func createImageNode(_ imageJson: JSON) -> HtmlImageNode? {
        let image = imageJson["image"]
        if let originalWidth = image["width"].float, let originalHeight = image["height"].float, let url = image["source"].string, let rawString = imageJson.rawString(String.Encoding(rawValue: String.Encoding.utf8.rawValue), options: []) {
            let imageNode = HtmlImageNode()
            if originalWidth > 0 && originalHeight > 0 {
                imageNode.imageWidth = min(CGFloat(originalWidth), contentMaxWidth)
                imageNode.imageHeight = ceil(imageNode.imageWidth / CGFloat(originalWidth / originalHeight))                
                imageNode.contentHeight = imageNode.imageHeight
            } else {
                imageNode.isUnknownSize = true
                imageNode.contentHeight = 100
            }
            imageNode.contentWidth = self.contentMaxWidth
            imageNode.rawJsonString = rawString
            imageNode.imageURL = url
            imageNode.tagID = imageJson["id"].stringValue
            
            if let title = image["title"].string, title != "" {
                let titleTextNode = HtmlTextNode()
                var imageTitle = title
//                if title.range(of: "%") != nil {
//                    imageTitle = StringHelper.string(byDecodingURLFormat:title)
//                }
                titleTextNode.isImageSubTitle = true
                titleTextNode.contentString = NSMutableAttributedString.imageTitleHtmlBodyText(imageTitle)
                let size = CGSize.zero //Remove me
                titleTextNode.contentWidth = size.width
                titleTextNode.contentHeight = size.height
                imageNode.titleTextNode = titleTextNode
            }
            return imageNode
        }
        return nil
    }
    
    func createVideoNode(_ videoJson: JSON) -> HtmlMultimediaNode? {
        guard let idStr = videoJson["id"].string else {
            return nil
        }
        let media = videoJson["media"]
        if let cover = media["cover"].string, let source = media["source"].string {
            let node = createMultimediaNode(url: source, coverURL: cover, isVideo: true)
            node?.tagID = idStr
            if let title = media["title"].string, title != "" {
                var imageTitle = title
//                if title.range(of: "%") != nil {
//                    imageTitle = StringHelper.string(byDecodingURLFormat:title)
//                }
                let titleTextNode = HtmlTextNode()
                titleTextNode.isImageSubTitle = true
                titleTextNode.contentString = NSMutableAttributedString.mediaTitleHtmlBodyText(imageTitle)
                let size = CGSize.zero //Remove me
                titleTextNode.contentWidth = size.width
                titleTextNode.contentHeight = size.height
                node?.titleTextNode = titleTextNode
            }
            return node
        }
        return nil
    }
    
    func createAudioNode(_ audioJson: JSON) -> HtmlMultimediaNode? {
        guard let idStr = audioJson["id"].string else {
            return nil
        }
        let media = audioJson["media"]
        if let cover = media["cover"].string, let source = media["source"].string {
            let node = createMultimediaNode(url: source, coverURL: cover, isVideo: false)
            node?.tagID = idStr
            if let title = media["title"].string, title != "" {
                var imageTitle = title
                //                if title.range(of: "%") != nil {
                //                    imageTitle = StringHelper.string(byDecodingURLFormat:title)
                //                }
                let titleTextNode = HtmlTextNode()
                titleTextNode.isImageSubTitle = true
                titleTextNode.contentString = NSMutableAttributedString.mediaTitleHtmlBodyText(imageTitle)
                let size = CGSize.zero //Remove me
                titleTextNode.contentWidth = size.width
                titleTextNode.contentHeight = size.height
                node?.titleTextNode = titleTextNode
            }
            return node
        }
        return nil
    }
    

    func createMultimediaNode(url:String, coverURL:String, isVideo:Bool) -> HtmlMultimediaNode? {
//        guard let contentModel = self.contentModel else {
//            return nil
//        }
        let node = HtmlMultimediaNode()
        var rawURL = url
        if isVideo {
//            if contentModel.packageName == "com.wandoujia.eyepetizer" {
//                if url.hasPrefix("http://api.qingmang.me/v1/video.redirect?url") {
//                    rawURL = url.replacingOccurrences(of: "http://api.qingmang.me/v1/video.redirect?url=", with: "")
////                    rawURL = StringHelper.string(byDecodingURLFormat: rawURL)
//                }
//            }
            node.videoURL = rawURL
        }else {
            node.audioURL = rawURL
        }
        
        if isVideo {            
            node.coverImageURL = coverURL
            node.contentHeight = ceil(self.contentMaxWidth / 1.6)
            let size = ImageURLHelper.imageSize(with: coverURL)
            if size.width > 0, size.height > 0 {
                let width = self.contentMaxWidth
                var height = ceil(size.height/(size.width/width))
                height = max(210,height)
                node.coverSize = CGSize(width:width, height:height)
                node.contentWidth = self.contentMaxWidth
                node.contentHeight = height
            }            
        }else {             
            node.coverImageURL = coverURL
            node.contentWidth = self.contentMaxWidth
            node.contentHeight = 80
            node.coverSize = CGSize(width:80, height:80)
        }
        
        return node
    }
    
    func createTableNode(_ tableJson: JSON) -> HtmlTableNode? {
        guard let idStr = tableJson["id"].string else {
            return nil
        }
        let node = HtmlTableNode()
        node.tagID = idStr
        var rowArray = [HtmlTableRowNode]()
        let rowItems = tableJson["table"]["items"]
        var tableHeight: CGFloat = 0
        if let _ = tableJson["table"]["rowCount"].int,
            let colCount = tableJson["table"]["colCount"].int,
            let rawString = tableJson.rawString(String.Encoding(rawValue: String.Encoding.utf8.rawValue), options: []) {            
            var realRowCount = 0
            for (_, rowJson): (String, JSON) in rowItems {
                let rowNode = HtmlTableRowNode()
                var array = [HtmlTableColumnNode]()
                let width = (self.contentMaxWidth - 28) / CGFloat(rowJson.count) - 20
                for (_, colJson): (String, JSON) in rowJson {
                    var shouldAlignCenter = false
                    if let textAlign = colJson["textAlign"].string {
                        if textAlign == "center" {
                            shouldAlignCenter = true
                        }
                    }
                    if let text = colJson["text"].string, let rawString = colJson.rawString(String.Encoding(rawValue: String.Encoding.utf8.rawValue), options: []) {
                        let textNode = HtmlTextNode()
                        let columnTextNode = HtmlTableColumnNode()
                        columnTextNode.textNode = textNode
                        let mutableAttr:NSMutableAttributedString = NSMutableAttributedString.mutableHtmlBodyText(text:text,
                                                                                                                  textColor: normalTextColor(),
                                                                                                                  font: detailNormalFont(),
                                                                                                                  shouldSmallFont: false,
                                                                                                                  alignment: shouldAlignCenter ? .center : .left)
                        
                        for (_, subJson): (String, JSON) in colJson["markups"] {
                            DetailRamlContentDataProvider.applyMarkups(mutableAttr,
                                                                       subJson: subJson,
                                                                       shouldAlignCenter: shouldAlignCenter,
                                                                       textNode: textNode,
                                                                       shouldSmallFont: false,
                                                                       font:detailNormalFont(), 
                                                                       fontColor:normalTextColor(),
                                                                       maxWidth: width)
                        }
                        textNode.contentString = mutableAttr                        
                        columnTextNode.tagID = idStr // FIXME: add column base
                        columnTextNode.rawJsonString = rawString
                        array.append(columnTextNode)
                    }
                }
                let count = array.count
                var maxHeight: CGFloat = 0
                if count > 0 {                    
                    let width = (self.contentMaxWidth - 28) / CGFloat(count) - 20 
                    for colNode in array {
                        if let textNode = colNode.textNode, let contentString = textNode.contentString {                            
                            let size = sizeOfTableNodeAttributeString(contentString, maxWidth: width)
                            colNode.contentHeight = size.height
                            colNode.contentWidth = width
                            maxHeight = max(maxHeight, size.height)
                        }
                    }
                }
                if maxHeight > 0 {
                    rowNode.contentHeight = maxHeight + 10 + 10
                    rowNode.columnNodeArray = array
                    rowArray.append(rowNode)
                    tableHeight += rowNode.contentHeight
                    realRowCount += 1
                }                
            }
            node.rowCount = realRowCount
            node.colCount = colCount
            node.contentHeight = tableHeight
            node.rawJsonString = rawString
            node.tableRowArray = rowArray
        }
        return node
    }
    
    func createNewLineTextNode() -> HtmlTextNode {
        let textNode = HtmlTextNode()
        textNode.contentString = NSMutableAttributedString.paragraphHtmlBodyText()
        return textNode
    }
    
    func createHrLineTagNode() -> HtmlHrTagNode {
        let node = HtmlHrTagNode()
        return node
    }
    
//    func createAttachmentNode(model:RippleModel) -> HtmlAttachmentNode {        
//        let attachmentNode = HtmlAttachmentNode()
//        attachmentNode.attachModel = model
//        attachmentNode.contentHeight = 80
//        attachmentNode.contentWidth = self.contentMaxWidth
//        return attachmentNode 
//    }
    
    func sizeOfTableNodeAttributeString(_ attr:NSAttributedString, maxWidth:CGFloat) -> CGSize {
//        let node = ASTextNode()
//        node.attributedText = attr
//        let range = ASSizeRange(min: .zero, max: CGSize(width: maxWidth - 10 - 10, height: CGFloat.greatestFiniteMagnitude))
//        return node.layoutThatFits(range).size
        return .zero
    }
    
    // Adapter
    func numberOfNode() -> Int {
        return contentNodeArray.count
    }
    
    @available(*, deprecated)
    func node(atIndexPath row: Int, width: CGFloat) -> HtmlNode! {
        return contentNodeArray[row]
    }
    
    func node(atIndexPath row: Int) -> HtmlNode! {
        return contentNodeArray[row]
    }
    
    func imutableImageArray() -> [HtmlImageNode] {
        return imageNodeArray
    }
    
    func indexOfImageNodeInAllNode(_ selectedImageNode:HtmlImageNode) -> Int {
        for (idx, node) in contentNodeArray.enumerated() {
            if let node = node as? HtmlImageNode {
                if node.imageURL == selectedImageNode.imageURL {
                    return idx
                }
            }
        }
        return -1
    }
    
    func indexOfImageNodeInAllImage(_ selectedImageNode:HtmlImageNode) -> Int {
        for (idx, node) in imageNodeArray.enumerated() {
            if node.imageURL == selectedImageNode.imageURL {
                return idx
            }
        }
        return -1
    }
    
    //Utils style
    //Font
    func detailNormalFont() -> UIFont {        
        return UIFont.systemFont(ofSize: setting.fontSize)
    }
            
    class func detailSmallFont() -> UIFont {        
        return UIFont.systemFont(ofSize: 11)
    }
    
    class func detailBoldFont(_ ofSize: CGFloat) -> UIFont {        
        return UIFont.boldSystemFont(ofSize: 11)
    }
    
    class func smallTextFont() -> UIFont {        
        return UIFont.systemFont(ofSize: 12)
    }
    
    class func strongSmallTextFont() -> UIFont {        
        return UIFont.boldSystemFont(ofSize: 12)
    }    
    
    class func subSmallTextFont() -> UIFont {        
        return UIFont.systemFont(ofSize: 9)
    }
        
    //Color
    func normalTextColor() -> UIColor {
        return setting.fontColor
    }        
        
}
