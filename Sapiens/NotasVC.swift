//
//  NotasVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 16/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire

class NotasVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(BASE_URL + "notas", method:.post, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseJSON { response in
            
            if let json: AnyObject = response.result.value! as AnyObject {
                
              print(response)
                
            }
        }


    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotas", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
