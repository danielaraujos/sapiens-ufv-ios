//
//  NotasVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 16/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire


class NotasViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var arraySubjects = [SubjectData]()
    var messageEmpty = UILabel()
    var user = User(user: COREDATA.loginUserCore().user!, pass: COREDATA.loginUserCore().pass!)
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageEmpty.text = "Materias não carregadas."
        messageEmpty.textAlignment = .center
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        self.showProgressing(message: "Carregando Notas")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadInformations()
    }
    
    @IBAction func btReload(_ sender: UIBarButtonItem) {
        self.processingAlert?.show(nil, hidden: nil)
        self.loadInformations()
        REST.checkUpdate(user: user) { (isValide) in
            if isValide == true {
                REST.pushNotifications()
            }
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.backgroundView = arraySubjects.count == 0 ? messageEmpty : nil
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
            let vc = segue.destination as! NotasDetailViewController
            vc.array = self.arraySubjects[tableView.indexPathForSelectedRow!.row]            
        }
    }
    
    func loadInformations(){
        print("Pedindo requsição das notas")
        REST.subjectResponse(user: self.user, onComplete: { (array) in
            self.arraySubjects = array
            self.processingAlert?.hideAlert(nil)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { (error) in
            self.errorAlert?.show(nil, hidden: nil)
            switch error {
            case .noResponse:
                self.showError(message: MESSAGE.MESSAGE_NORESPONSE)
            case .noJson:
                self.showError(message: MESSAGE.MESSAGE_NOJSON)
            case .nullResponse:
                self.showError(message: MESSAGE.MESSAGE_NULLJSON)
            case .responseStatusCode(code: let codigo):
                self.showError(message: MESSAGE.returnStatus(valueStatus:codigo!))
            case .noConectionInternet:
                self.showError(message: MESSAGE.MESSAGE_NO_INTERNET)
            case .alertData:
                self.showError(message: MESSAGE.MESSAGE_ALERT)
            default:
                self.showError(message: MESSAGE.MESSAGE_DEFAULT)
            }
            
        }
    }
    
}
