//
//  NotasVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 16/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire

class NotasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var arraySubjects = [SubjectData]()
    var user = User(user: "ER04325", pass: "142563")
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        REST.subjectResponse(user: self.user) { (array) in
            self.arraySubjects = array
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySubjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotas", for: indexPath)
        
        let subject = self.arraySubjects[indexPath.row]
        
        cell.textLabel?.text = subject.nome
        cell.detailTextLabel?.text = "Data da Alteração: \(subject.alteracao)"
        
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MateriasSegue" {
            let vc = segue.destination as! NotasDetailVC
            vc.array = self.arraySubjects[tableView.indexPathForSelectedRow!.row]
            
        }
    }
    
    
    
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
   
    

}
