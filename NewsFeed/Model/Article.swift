//
//  VergeArticle.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation

struct Article {
    let title: String
    let summary: String
    let pictureLink: String
    let articleLink: String
    let datePublished: String
    let source: String
    var isSaved: Bool = false
}
