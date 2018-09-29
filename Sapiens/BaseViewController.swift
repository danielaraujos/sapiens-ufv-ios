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
    var user: User!
    static let config = Configuration.shared
    var dataManager = CoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = returnUser()
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
            
        case "L":
            if let vTitle = title {self.alert = LIHAlertManager.getTextCustom(title: vTitle, message: message)}
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
    
    
    
    func changeColorBackgraung(tableView: UITableViewCell,titleLabel: UILabel?, detailLabel: UILabel?){
        tableView.backgroundColor = UIColor.black
        tableView.textLabel?.textColor = UIColor.white
        tableView.detailTextLabel?.textColor = UIColor.white
        titleLabel?.textColor = UIColor.white
        detailLabel?.textColor = UIColor.white
    }
  
}

extension BaseViewController : CoreDataManagerType {
    func saveUser(user: User) {
        let managedContext = dataManager.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserDataBase", in: managedContext)!
        let usuario = NSManagedObject(entity: entity, insertInto: managedContext)
        usuario.setValue(user.user, forKey: "user")
        usuario.setValue(user.pass, forKey: "pass")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func returnUser() -> User {
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDataBase")
        do {
            let user = try dataManager.persistentContainer.viewContext.fetch(requisicao).first
            if user != nil{
                let usuario = (user as AnyObject).value(forKey:"user") as! String
                let senha = (user as AnyObject).value(forKey:"pass") as! String
                return User(user: usuario, pass: senha)
            }
        } catch  let error as NSError {
            print("Could not open. \(error), \(error.userInfo)")
        }
        return User(user: "-1", pass: " " )
    }
    
    func deleteUser() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDataBase")
        
        let result = try? dataManager.persistentContainer.viewContext.fetch(fetchRequest)
        if let resultData = result {for object in resultData {dataManager.persistentContainer.viewContext.delete(object as! NSManagedObject)}}
        do {
            try dataManager.persistentContainer.viewContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
}



