//
//  Utilities.swift
//  ParticleSDK
//
//  Created by Craig Spell on 9/12/23.
//
#if os(macOS)
import AppKit
#elseif os(iOS) || os(tvOS) || os(visionOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

fileprivate let jSonDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    formatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
    formatter.formatterBehavior = .default
    return formatter
}()

internal func descriptionDateString(jsonDate: String) -> String {
    if let date = try? Date.date(jSonDate: jsonDate) {
        return descriptionDateFormatter.string(from: date)
    }
    return "error"
}


internal let descriptionDateFormatter: DateFormatter = {
   
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

public enum PCDateFormatterError: Error {
    case couldNotParseDate(from: String)
    case couldNotParsejSonDate(from: Date)
    case nilPassedAsDateArgument
}

public extension Date {
    
    static func date(jSonDate: String?) throws -> Date {
        guard let jSonDate = jSonDate else {
            throw PCDateFormatterError.nilPassedAsDateArgument
        }
        if let date = jSonDateFormatter.date(from: jSonDate) {
            return date
        } else {
            throw PCDateFormatterError.couldNotParseDate(from: jSonDate)
        }
    }
    
    func jSonDate() throws -> String {
        let jsonDate = jSonDateFormatter.string(from: self)
        let originalCheck = try Date.date(jSonDate: jsonDate)
        guard originalCheck == self
        else {
            throw PCDateFormatterError.couldNotParsejSonDate(from: self )
        }
        return jsonDate
    }
}


public extension Progress {
    func increment(_ by: Int64 = 1) {
        self.totalUnitCount += by
    }
    
    func decrement(_ by: Int64 = 1) {
        self.completedUnitCount += by
    }
}


#if os(iOS) || os(tvOS) || os(visionOS)
public extension UITextContentType {
    static let email = UITextContentType.emailAddress
}
#elseif os(watchOS)
public extension WKTextContentType {
    static let email = WKTextContentType.emailAddress
}
#elseif os(macOS)
public extension NSTextContentType {
    static let email = NSTextContentType.username
}
#endif


public extension Dictionary.Keys {
    
    func arrayValue() -> [Key] {
        
        var array = [Key]()
        
        for key in self {
            array.append(key)
        }
        
        return array
    }
}
