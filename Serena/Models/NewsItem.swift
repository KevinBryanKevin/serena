//
//  NewsItem.swift
//  Serena
//
//  Created by Luis Perez on 7/22/18.
//  Copyright © 2018 Luis Perez. All rights reserved.
//

import Foundation

class NewsItemXMLDelegate : NSObject, XMLParserDelegate {
    
    var itemTag = "item"
    var dictionaryKey: [String] = ["title", "ht:news_item_snippet"]
    
    // This is nil if I have no value to store.
    var currentText: String? = nil
    var currentDictionary: [String : String]? = nil
    
    var results: [NewsItem] = []
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        // We started an element.
        print("Starting Element \(elementName)")
        if elementName == itemTag {
            currentDictionary = [:]
        }
        if dictionaryKey.contains(elementName) {
            currentText = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // We know we ecountered some text.
        currentText? += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        // We know we ended an element.
        print("Ending element: \(elementName)")
        if elementName == itemTag {
            // What to do here!?
            results.append(NewsItem(dict: currentDictionary!))
            currentDictionary = nil
        }
        if dictionaryKey.contains(elementName) {
            // ["title" : "Nicole Maines"]
            // ["ht:news_item_snippet": "At Comic-Con on Saturday, July 21, it was revealed that the hit CW series will feature television"]
            currentDictionary?[elementName] = currentText
            currentText = nil
        }
    }
}

class NewsItem {
    var title: String
    var description: String
    var rank : Int
    
    init(dict: [String: String]) {
        title = dict["title"] ?? "Unavailable"
        description = dict["ht:news_item_snippet"] ?? "Unavailble"
        rank = 0
    }
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
        self.rank = 0
    }
    
    class func fetchTrendingNews(callback: @escaping (([NewsItem], String?) -> Void) ) {
        // make a network request to https://trends.google.com/trends/hottrends/atom/feed
        // I want to parse the data which is XML
        // I want to make my list of NewsItem
        // callback(list)
        
        let url = URL(string: "https://trends.google.com/trends/hottrends/atom/feed")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            // need to do something
            guard let xmlPage = data else {
                return callback([], "Error in network request. Unable to retrieve feed data.")
            }
            
            let parser = XMLParser(data: xmlPage)
            let delegate = NewsItemXMLDelegate()
            parser.delegate = delegate
            if parser.parse() {
                // success code here
                callback(delegate.results, nil)
            } else {
                return callback([], "Invalid XML. Unable to parse.")
            }
        })
        task.resume()
        
    }
}
