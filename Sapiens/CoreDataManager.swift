//
//  CoreDataManager.swift
//  Sapiens
//
//  Created by Daniel Araújo on 27/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerType {
    func saveUser(user: User)
    func returnUser() -> User
    func deleteUser()
    //func fetchTitles() -> [NSManagedObject]
}

class CoreDataManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Sapiens")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
