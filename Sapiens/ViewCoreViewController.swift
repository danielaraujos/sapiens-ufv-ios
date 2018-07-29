//
//  ViewCoreViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 26/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {

    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
