//
//  Configuration.swift
//  Sapiens
//
//  Created by Daniel Araújo on 26/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation


enum UserDefaultsKeys: String {
    case storageSubject = "storageSubject"
    case storageSchedules = "storageSchedules"
    case storageNotifications = "storageNotifications"
    case storageTime  = "storageTime"
}


class Configuration {
    
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    
    var storageSubject : String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.storageSubject.rawValue)!
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.storageSubject.rawValue)
        }
    }
    
    var storageSchedules : String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.storageSchedules.rawValue)!
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.storageSchedules.rawValue)
        }
    }
    
    
    var storageNotifications : Bool {
        get {
            return defaults.bool(forKey: UserDefaultsKeys.storageNotifications.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.storageNotifications.rawValue)
        }
    }
    
    
    var storageTime : Int {
        get {
            return defaults.integer(forKey: UserDefaultsKeys.storageTime.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.storageTime.rawValue)
        }
    }
    
    private init(){
        if defaults.integer(forKey: UserDefaultsKeys.storageTime.rawValue) == 0 {
            defaults.set(5, forKey: UserDefaultsKeys.storageTime.rawValue)
        }
        if defaults.bool(forKey: UserDefaultsKeys.storageNotifications.rawValue) == false {
            defaults.set(true, forKey: UserDefaultsKeys.storageNotifications.rawValue)
        }
    }
    
}
