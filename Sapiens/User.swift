//
//  Usuario.swift
//  Sapiens
//
//  Created by Daniel Araújo on 21/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//


/*
 ACESSADO VIA: http://danielaraujos.com/webservicesapiens/index.php?info=login
 
 */
import Foundation
import CoreData

class User {
    var user: String?
    var pass: String?
    
    init(user: String, pass: String){
        self.user = user
        self.pass = pass
    }
    
}




