//
//  Settings.swift
//  ToWatcher
//
//  Created by Alex Delin on 11.04.2021.
//  Copyright © 2021 Alex Delin. All rights reserved.
//

import Foundation

class Settings {
    enum StartScreen: Int {
        case toWatch = 0
        case search = 1
    }
    
    private static let keyStartScreen = "key_StartScreen"
    
    private static var startScreenValue: Int {
        get {
            UserDefaults.standard.integer(forKey: keyStartScreen)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: keyStartScreen)
        }
    }
    
    static var startScreen: StartScreen { StartScreen.init(rawValue: startScreenValue) ?? .toWatch }
    
    class func setAppInfo() {
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.0"
        UserDefaults.standard.set(version, forKey: "key_Version")
        let build = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "0"
        UserDefaults.standard.set(build, forKey: "key_Build")
    }
    
}

