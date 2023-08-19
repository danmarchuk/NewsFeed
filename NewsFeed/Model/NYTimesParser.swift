//
//  NYTimesParser.swift
//  NewsFeed
//
//  Created by Данік on 14/08/2023.
//

import Foundation
import Alamofire
import SwiftSoup

class NYTimesParser {
    
    func fetchAndParseFeed(completion: @escaping ([Article]?) -> Void) {
        let url = "https://feeds.simplecast.com/54nAGcIl"
        
        AF.request(url).responseString { response in
            guard let xml = response.value else {
                completion(nil)
                return
            }
            let items = self.parseXML(xml: xml)
            completion(items)
        }
    }
    
    private func parseXML(xml: String) -> [Article]? {
        do {
            let doc: Document = try SwiftSoup.parse(xml)
            
            let imageUrl = try doc.select("url").first()?.text() ?? ""
            
            // for now we return 10 items as there are a big amount of articles in the NY times
            let items = try doc.select("item").array().prefix(10)
            var vergeArticles = [Article]()
            
            for item in items {
                let title = try item.select("title").first()?.text() ?? ""
                let link = try item.select("enclosure").attr("url")

                let datePublishedStringFromXML = try item.select("pubDate").first()?.text() ?? ""
                let datePublished = FuncManager.convertToDate(from: datePublishedStringFromXML) ?? Date()
                let datePublishedString = FuncManager.timeAgoString(from: datePublished, to: Date())
                
                let description = try item.select("itunes|summary").first()?.text() ?? ""
                
                let nyTimesArticle = Article(title: title, summary: description, pictureLink: imageUrl, articleLink: link, datePublished: datePublishedString, source: "The New York Times")
                vergeArticles.append(nyTimesArticle)
            }
            return vergeArticles
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }
    }
}
