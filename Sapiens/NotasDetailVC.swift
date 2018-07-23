//
//  NotasDetailVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 24/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotasDetailVC: UIViewController {

    var array : SubjectData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = array!.nome
        print(array)
        // Do any additional setup after loading the view.
    }

}
