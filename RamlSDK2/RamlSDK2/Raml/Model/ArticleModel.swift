//
//  ArticleModel.swift
//  Mango
//
//  Created by wuxiaoyue on 16/8/31.
//  Copyright © 2016年 lianpian. All rights reserved.
//

import Foundation

//enum ArticleTemplateType:String {
//    case article = "TEXT_VENTI"
//    case article_grande = "TEXT_GRANDE"
//    case multi_pic_venti = "MULTI_PIC_VENTI"
//    case single_pic_venti = "SINGLE_PIC_VENTI"
//    case other = ""
//}

class ArticleModel: NSObject {
    // article property
//    var docId: Int64 = 0
//    var idString:String = ""
//    var title: String = ""
//    var snippet: String?
//    var author:String?
//    
//    var publishedDate: Date?
//    var docDate: Date?
//    var webURL:String?
//    
    var contentHtml:String?
    
//    var templateType:ArticleTemplateType = .other
//    
//    var isRecommend:Bool = false
//    
//    var stat: ArticleStatistics?
//    var interest: InterestModel?
 
//    var tags = [TagModel]()
//    var notes = [PaperNoteItem]()
    
//    var imageTotalCount: Int = 0
//    var covers = [ImageModel]()
//    var images = [ImageModel]()
//    
//    var videos = [VideoModel]()
//    var keywords = [String]()
//    
    // Provider property
//    var appName: String = ""
//    var packageName: String?
//    var appIcon: String?
//    
    //RippleModel merge need refactor
//    var relatedModelArray:[RippleModel]?
    
//    var rippleModel:RippleModel?
    
    // More Detail
//    lazy var isPlatformProvider:Bool = {
//        var isPlatformProvider = false
//        if (self.packageName == "com.sina.weibo" || self.packageName == "com.instagram.android") {
//            if let authorName = self.author, authorName != "" {
//                isPlatformProvider  = true
//            }
//        }
//        return isPlatformProvider
//    }()
        
//    convenience init(id:Int64) {
//        self.init()
//        docId = id
//    }
    
    init(contentHtml:String) {
        super.init()
//        self.idString = model.idString
//        self.docId = model.modelId
//        self.appIcon = model.icon
//        self.appName = model.providerTitle
//        self.packageName = model.packageName
//        self.title = model.title
//        self.author = model.author?.name
//        self.snippet = model.snippet
//        self.publishedDate = model.datePublished
        //self.docDate = model.articleDetail?.publishedDate
//        self.docDate = model.datePublished
        self.contentHtml = contentHtml
        //self.templateType = model.templateType
        
//        self.webURL = model.action?.url
//        self.rippleModel = model
//        self.relatedModelArray = model.relativeArticles
//        model.tags?.forEach({ (tag) in
//            
//        })
//        if json["stat"].exists() {
//            stat = ArticleStatistics(json["stat"])
//        }
        
//        json["tags"].array?.forEach({ (tagJson) in
//            self.tags.append(TagModel(tagJson))
//        })
        
//        json["keywords"].array?.forEach({ (keywordJson) in
//            self.keywords.append(keywordJson.stringValue)
//        })
//        model.covers.forEach { (cover) in
//            if let cover = cover as? Image {
//                let imageModel = ImageModel()
//                imageModel.url = cover.url
//                imageModel.width = Int(cover.width)
//                imageModel.height = Int(cover.height)
//                self.covers.append(imageModel)
//            }
//        }
//        model.images.forEach { (image) in
//            if let image = image as? Image {
//                let imageModel = ImageModel()
//                imageModel.url = image.url
//                imageModel.width = Int(image.width)
//                imageModel.height = Int(image.height)
//                self.covers.append(imageModel)
//            }
//        }
//        
//        model.videos.forEach { (video) in
//            if let video = video as? Video {
//                let videoModel = VideoModel()                
//                if let coverStr = video.cover?.first as? String {
//                    videoModel.cover = coverStr   
//                }                
//                videoModel.duration = Double(video.duration)
//                videoModel.height = Int(video.height)
//                videoModel.width = Int(video.width)
//                videoModel.url = video.url
//                self.videos.append(videoModel)
//            }
//            
//        }
//        json["covers"].array?.forEach({ (coverJson) in
//            self.covers.append(ImageModel(coverJson))
//        })
        
//        if let cover = json["cover"].string, self.covers.count == 0{
//            let imageModel = ImageModel()
//            imageModel.url = cover
//            self.covers.append(imageModel)
//        }
        
//        json["images"].array?.forEach({ (imageJson) in
//            self.images.append(ImageModel(imageJson))
//        })
        /* 在没有自动播放视频卡片之前先屏蔽
         json["videos"].array?.forEach({ (videoJson) in
         if videoJson["duration"].exists() {
         self.videos.append(VideoModel(videoJson))
         }
         })*/
        
//        let noteArray = json["notes"].arrayValue
//        if noteArray.count > 0 {
//            let article = ArticleModel.tinyArticle(self)
//            noteArray.forEach({ (noteJson) in
//                let note = PaperNoteItem(noteJson)
//                if note.article?.title == nil && self.title != "" {
//                    note.article = article
//                }
//                self.notes.append(note)
//            })
//        }
        
//        imageTotalCount = self.images.count
        
    }
    
//    static func tinyArticle(_ article:ArticleModel) -> ArticleModel {
//        let model = ArticleModel(id:article.docId)
//        model.idString = article.idString
//        model.appIcon = article.appIcon
//        model.appName = article.appName
//        model.packageName = article.packageName
//        model.title = article.title
//        model.author = article.author
//        model.snippet = article.snippet
//        model.publishedDate = article.publishedDate
//        model.docDate = article.docDate
//        model.templateType = article.templateType
//        return model
//    }
    
//    override func parseJson(_ json: JSON) {
//        appName = json["appName"].stringValue
//        packageName = json["packageName"].string
//        appIcon = json["appIcon"].string
//        
//        docId = json["docId"].int64Value
//        idString = json["docIdString"].stringValue
//        title = json["title"].stringValue
//        author = json["author"].string
//        snippet = json["snippet"].string
//        
//        isRecommend = json["isRecommend"].boolValue
//        
//        webURL = json["webUrl"].string
//        docDate = json["docDate"].date
//        
//        if json["publishDate"].intValue == 0 {
//            publishedDate = docDate
//        }else {
//            publishedDate = json["publishDate"].date
//        }
//        
//        let templateStr = json["templateType"].stringValue
//        templateType = ArticleTemplateType(rawValue: templateStr) ?? .other
//
//        if templateType == .other && templateStr == "SINGLE_VIDEO" {
//            templateType = .article
//        }
//        
//        contentHtml = json["contentHtml"].string
        
//        if let array = json["interests"].array {
//            if let interestJson = array.first {
//                interest = InterestModel(interestJson)
//            }
//        }
                
//        imageTotalCount = self.images.count
//    }
        
//    func shortMonthDayFormatString() -> String {
//        guard let date = publishedDate else {
//            return ""
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "M 月 d 日";
//        return formatter.string(from: date)
//    }
}
