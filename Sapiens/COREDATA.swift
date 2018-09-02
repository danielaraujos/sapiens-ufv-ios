//
//  COREDATA.swift
//  Sapiens
//
//  Created by Daniel Araújo on 27/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class COREDATA {
    
    static var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }


    class func loginUserCore() -> User{
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDataBase")
        do {
            let users = try context.fetch(requisicao)
            if users.count > 0 {
                for a in users as! [NSManagedObject]{
                    let usuario = (a as AnyObject).value(forKey:"user") as! String
                    let senha = (a as AnyObject).value(forKey:"pass") as! String
                    return User(user: usuario, pass: senha)
                }
            }else{
                print("Usuario está vazio!")
            }
        } catch  {
            print("Nao foi possivel listar os dados!")
        }
        return User(user: "-1", pass: " " )
    }
    
    
    
    class func deleteLoginCore(){
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDataBase")
        do {
            let users = try context.fetch(requisicao)
            if users.count > 0 {
                for user in users {
                    context.delete(user as! NSManagedObject)
                }
                print("Deletado com sucesso")
            }else{
                print("Usuários está vazio!!")
            }
        } catch  {
            print("Nao foi possivel listar os dados!")
        }
    }
    
    
    class func saveUserResponse (user: UserDataBase?, usuario: User, onSucess: (Bool)-> Void){
        //var userBD : UserDataBase!
//            if(user == nil ){
//                user = user(context: context)
//            }
        print("Entrou aqui")
            user?.user = usuario.user
            user?.pass = usuario.pass
    
            do {
                try COREDATA.context.save()
                onSucess(true)
            }catch{
                print(error.localizedDescription)
                onSucess(false)
            }
        }
    
    
    
}
