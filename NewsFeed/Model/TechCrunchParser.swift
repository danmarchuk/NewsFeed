//
//  TechCrunchParser.swift
//  NewsFeed
//
//  Created by Данік on 14/08/2023.
//

import Foundation
import Alamofire
import SwiftSoup

class TechCrunchParser {
    
    func fetchAndParseFeed(completion: @escaping ([ArticleInfo]?) -> Void) {
        let url = "https://feeds.feedburner.com/techcrunch"
        
        AF.request(url).responseString { response in
            guard let xml = response.value else {
                completion(nil)
                return
            }
            let items = self.parseXML(xml: xml)
            completion(items)
        }
    }
    
    private func parseXML(xml: String) -> [ArticleInfo]? {
        do {
            let doc: Document = try SwiftSoup.parse(xml)
            
            let imageUrl = try doc.select("url").first()?.text() ?? ""
            
            // for now we return 10 items as there are a big amount of articles in the NY times
            let items = try doc.select("item").array().prefix(10)
            var vergeArticles = [ArticleInfo]()
            
            for item in items {
                let title = try item.select("title").first()?.text() ?? ""
                let link = try item.select("link").first()?.text() ?? ""

                let datePublishedStringFromXML = try item.select("pubDate").first()?.text() ?? ""
                let datePublished = FuncManager.convertToDate(from: datePublishedStringFromXML) ?? Date()
                let datePublishedString = FuncManager.timeAgoString(from: datePublished, to: Date())
                
                let description = try item.select("itunes|summary").first()?.text() ?? ""
                
                let imageUrl = try item.select("media|thumbnail").attr("url")
                
                print("link")
                print(link)
                
                
                let nyTimesArticle = ArticleInfo(title: title, summary: description, pictureLink: imageUrl, articleLink: link, datePublished: datePublishedString, source: "Tech Crunch")
                vergeArticles.append(nyTimesArticle)
            }
            return vergeArticles
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }
    }
}

