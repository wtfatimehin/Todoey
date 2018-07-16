//
//  AppDelegate.swift
//  Todoey
//
//  Created by Willie Fatimehin on 6/27/18.
//  Copyright © 2018 Opia. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

// gets called when load opens up even before view did load
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
             _ = try Realm()
        } catch {
            print("Error initializing new realm, \(error)")
        }
        
        return true
    }



    
}

