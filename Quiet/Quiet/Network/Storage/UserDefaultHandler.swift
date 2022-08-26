//
//  UserDefaultHandler.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import Foundation

struct UserDefaultHandler {
    static func clearAllData() {
        UserData<Any>.clearAll()
    }
    
    static func setKeywords(keyword: String) {
        guard !keyword.isEmpty else { return }
        var keywords: [String] = UserDefaultStorage.keywords
        
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
        }
        
        if keywords.count > 9 {
            keywords.removeFirst()
        }
        
        keywords.append(keyword)
        UserData.setValue(keywords, forKey: .keywords)
    }
    
    static func clearKeyword(keyword: String) {
        var keywords: [String] = UserDefaultStorage.keywords
        
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
            UserData.setValue(keywords, forKey: .keywords)
        }
    }
    
    static func clearAllKeywords() {
        UserData<Any>.clear(forKey: .keywords)
    }
}
