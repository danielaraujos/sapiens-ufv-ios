//
//  Configuration.swift
//  Sapiens
//
//  Created by Daniel Araújo on 03/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class Setting : NSObject{
    var id: Int!
    var nome: String!
    var image: UIImage!
    
    init(id:Int, nome:String, image:UIImage) {
        self.id = id
        self.nome = nome
        self.image = image
    }
    
    
}

