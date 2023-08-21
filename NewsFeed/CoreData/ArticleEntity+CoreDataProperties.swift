//
//  ArticleEntity+CoreDataProperties.swift
//  
//
//  Created by Данік on 21/08/2023.
//
//

import Foundation
import CoreData


extension ArticleEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleEntity> {
        return NSFetchRequest<ArticleEntity>(entityName: "ArticleEntity")
    }

    @NSManaged public var articleLink: String?
    @NSManaged public var datePublishedString: String?
    @NSManaged public var isSaved: Bool
    @NSManaged public var pictureLink: String?
    @NSManaged public var source: String?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var datePublished: Date?

}
