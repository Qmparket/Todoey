//
//  AppDelegate.swift
//  Todoey
//
//  Created by d.genkov on 9/4/18.
//  Copyright © 2018 d.genkov. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        do {
            _ = try Realm()
        } catch {
            print(error)
        }
        
        
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
       
    }
    
}

