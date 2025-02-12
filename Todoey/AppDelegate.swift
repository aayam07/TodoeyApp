//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // first method which always happens when the app is opened. It is called before the viewDidLoad is triggered
        
        print("didFinishLaunchingWithOptions")
        
        // to print the path where our data has been saved as user defaults
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        // the point basically when the app will be terminated (Can be user triggered or System triggered)
        print("applicationWillTerminate")
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    // lazy variable only gets its value when the variable is used i.e. the following block of code only gets executed and the variable occupies the memory only when it utilized somewhere.
    // NSPersistentContainer is basically a SQLite database, where our data is saved just like other databases such as MySQl
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        
        // context is just like the staging area in GIT (a temporary area/scratch pad) where we can update or modify our data as we like before saving it to the permanent storage (which is our SQLite database in this app)
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

