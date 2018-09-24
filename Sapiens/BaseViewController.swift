//
//  BaseViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 16/08/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit

import CoreData
import LIHAlert
import UserNotifications

class BaseViewController: UIViewController {

    var alert: LIHAlert?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func alertShow(title: String?, message: String, color: UIColor?, type: String) {
        switch type {
        case "S":
            self.alert = LIHAlertManager.getSuccessAlert(message: message)
            self.alert?.initAlert(self.view)
            self.alert?.icon = UIImage(named: "SuccessIcon")
        case "E":
            self.alert = LIHAlertManager.getErrorAlert(message: message)
            self.alert?.initAlert(self.view)
            self.alert?.icon = UIImage(named: "ErrorIcon")
            self.alert?.animationDuration = 0.9
            self.alert?.hasNavigationBar = false
        case "T":
            if let vTitle = title {self.alert = LIHAlertManager.getTextWithTitleAlert(title: vTitle, message: message)}
            if let vColor = color {self.alert?.alertColor = vColor}
            self.alert?.initAlert(self.view)
            self.alert?.animationDuration = 0.7
            self.alert?.hasNavigationBar = false
            self.alert?.paddingTop = 0.0
            self.alert?.autoCloseTimeInterval = 3.5
        case "P":
            self.alert = LIHAlertManager.getProcessingAlert(message: message)
            self.alert?.initAlert(self.view)
            self.alert?.animationDuration = 0.7
            self.alert?.autoCloseTimeInterval = 3.0
            self.alert?.autoCloseEnabled=true
        default:
            break
        }
    }
    
    func showAlertSheet(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
  
}

extension BaseViewController {
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}


