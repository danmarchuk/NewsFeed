//
//  VergeManager.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Alamofire
import SwiftSoup
import Foundation

class VergeParser {
    
    func fetchAndParseFeed(completion: @escaping ([Article]?) -> Void) {
        let url = "https://www.theverge.com/rss/index.xml"
        
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
            let entries = try doc.select("entry")
            var vergeArticles = [Article]()
            
            for entry in entries {
                let title = try entry.select("title").first()?.text() ?? ""
                let link = try entry.select("id").first()?.text() ?? ""
                let datePublishedStringFromXML = try entry.select("updated").first()?.text() ?? ""
                let datePublished = FuncManager.iso8601StringToDate(datePublishedStringFromXML) ?? Date()
                let datePublishedString = FuncManager.timeAgoString(from: datePublished, to: Date())
                
                
                var imageUrl = ""
                var description = ""
                let contentHtml = try entry.select("content").html()
                
                if let decodedContent = decodeHTMLEntities(string: contentHtml),
                   let contentDoc: Document = try? SwiftSoup.parse(decodedContent) {

                    if let imgUrl = try? contentDoc.select("img").attr("src") {
                        imageUrl = imgUrl
                    }
                    
                    // Extracting the description
                    let paragraphs = try? contentDoc.select("p")

                    if let paragraphs = paragraphs, paragraphs.count > 1 {
                        for i in 0..<paragraphs.count - 1 { // Excluding the last paragraph
                            description += try paragraphs[i].text() + " "
                        }
                    }
                    
                }
                
                let vergeArticle = Article(title: title, summary: description, pictureLink: imageUrl, articleLink: link, datePublished: datePublishedString, source: "verge", isSaved: false)
                vergeArticles.append(vergeArticle)
            }
            return vergeArticles
        } catch {
            print("Error \(error.localizedDescription)")
            return nil
        }
    }
    
    func decodeHTMLEntities(string: String) -> String? {
        guard let data = string.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        return attributedString.string
    }

}



