//
//  UserDefaultHandler.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import Foundation
import MapKit

struct UserDefaultHandler {
    static func clearAllData() {
        UserData<Any>.clearAll()
    }
    
    static func setKeywords(keyword: String) {
        guard !keyword.isEmpty else { return }
        var keywords: [String] = UserDefaultStorage.keywords
        var subLocality: [String?] = UserDefaultStorage.subLocality
        var latitude: [Double] = UserDefaultStorage.latitude
        var longitude: [Double] = UserDefaultStorage.longitude
        
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
            subLocality.remove(at: index)
            latitude.remove(at: index)
            longitude.remove(at: index)
        }
        
        if keywords.count > 9 {
            keywords.removeFirst()
            subLocality.removeFirst()
            latitude.removeFirst()
            longitude.removeFirst()
        }
        
        keywords.append(keyword)
        UserData.setValue(keywords, forKey: .keywords)
    }
    
    static func setLocality(subLocality: String?) {
        var subLocalities: [String?] = UserDefaultStorage.subLocality
        
        subLocalities.append(subLocality)
        UserData.setValue(subLocalities, forKey: .subLocality)
    }
    
    static func setCLLocation2D(latitude: Double, longitude: Double) {
        var latitudes: [Double] = UserDefaultStorage.latitude
        var longitudes: [Double] = UserDefaultStorage.longitude
        
        latitudes.append(latitude)
        longitudes.append(longitude)
        UserData.setValue(latitudes, forKey: .latitude)
        UserData.setValue(longitudes, forKey: .longitude)
    }
    
    static func clearKeyword(keyword: String) {
        var keywords: [String] = UserDefaultStorage.keywords
        var subLocality: [String?] = UserDefaultStorage.subLocality
        var latitude: [Double] = UserDefaultStorage.latitude
        var longitude: [Double] = UserDefaultStorage.longitude
        
        if let index = keywords.firstIndex(of: keyword) {
            keywords.remove(at: index)
            subLocality.remove(at: index)
            latitude.remove(at: index)
            longitude.remove(at: index)
            UserData.setValue(keywords, forKey: .keywords)
            UserData.setValue(subLocality, forKey: .subLocality)
            UserData.setValue(latitude, forKey: .latitude)
            UserData.setValue(longitude, forKey: .longitude)
        }
    }
    
    static func clearAllKeywords() {
        UserData<Any>.clear(forKey: .keywords)
        UserData<Any>.clear(forKey: .subLocality)
        UserData<Any>.clear(forKey: .latitude)
        UserData<Any>.clear(forKey: .longitude)
    }
}
