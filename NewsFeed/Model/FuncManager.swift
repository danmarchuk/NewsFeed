//
//  FuncManager.swift
//  NewsFeed
//
//  Created by Данік on 13/08/2023.
//

import Foundation

struct FuncManager {
    static func iso8601StringToDate(_ dateString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString)
    }
    
    static func convertToDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        
        // Set the date format according to the string format you provided
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        
        return dateFormatter.date(from: string)
    }
    
    static func timeAgoString(from oldDate: Date, to currentDate: Date) -> String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: oldDate, to: currentDate)

        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        }
        if let weeks = components.weekOfYear, weeks > 0 {
            return weeks == 1 ? "1 week ago" : "\(weeks) weeks ago"
        }
        if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        }
        if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        }
        if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        }

        return "Just now"
    }
}
