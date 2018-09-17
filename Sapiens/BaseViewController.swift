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

class BaseViewController: UIViewController {

    var errorAlert: LIHAlert?
    var informationsAlert : LIHAlert?
    var sucessAlert : LIHAlert?
    var textWithButtonAlert: LIHAlert?
    var processingAlert: LIHAlert?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showError(message: String) {
        self.errorAlert = LIHAlertManager.getErrorAlert(message: message)
        self.errorAlert?.initAlert(self.view)
        self.errorAlert?.icon = UIImage(named: "ErrorIcon")
    }
    
    func showSucess(message: String) {
        self.sucessAlert = LIHAlertManager.getSuccessAlert(message: message)
        self.sucessAlert?.initAlert(self.view)
        self.sucessAlert?.icon = UIImage(named: "SuccessIcon")
    }
    
    func showInformations(message: String) {
        self.informationsAlert = LIHAlertManager.getTextAlert(message: message)
        self.informationsAlert?.initAlert(self.view)
    }
    
    func showProgressing(message: String) {
        self.processingAlert = LIHAlertManager.getProcessingAlert(message: message)
        self.processingAlert?.initAlert(self.view)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    func showAlertSheet(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
  
}

extension BaseViewController {
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}


