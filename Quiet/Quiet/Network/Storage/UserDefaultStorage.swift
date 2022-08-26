//
//  UserDefaultStorage.swift
//  Quiet
//
//  Created by SHIN YOON AH on 2022/08/25.
//

import Foundation

enum DataKeys: String, CaseIterable {
    case keywords = "keywords"
    case playing = "play"
    case subLocality = "subLocality"
    case latitude = "latitude"
    case longitude = "longitude"
}

struct UserDefaultStorage {
    static var keywords: [String] {
        return UserData<[String]>.getValue(forKey: .keywords) ?? []
    }
    
    static var subLocality: [String?] {
        return UserData<[String?]>.getValue(forKey: .subLocality) ?? []
    }
    
    static var latitude: [Double] {
        return UserData<[Double]>.getValue(forKey: .latitude) ?? []
    }
    
    static var longitude: [Double] {
        return UserData<[Double]>.getValue(forKey: .longitude) ?? []
    }
}

struct UserData<T> {
    static func getValue(forKey key: DataKeys) -> T? {
        if let data = UserDefaults.standard.value(forKey: key.rawValue) as? T {
            return data
        } else {
            return nil
        }
    }
    
    static func setValue(_ value: T, forKey key: DataKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    static func clearAll() {
        DataKeys.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    static func clear(forKey key: DataKeys) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
