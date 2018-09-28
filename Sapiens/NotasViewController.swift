//
//  NotasVC.swift
//  Sapiens
//
//  Created by Daniel Araújo on 16/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class NotasViewController: BaseViewController {

    var arraySubjects = [SubjectData]()
    var messageEmpty = UILabel()
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageEmpty.text = "Materias não carregadas."
        messageEmpty.textAlignment = .center
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadFecth()
    }
    
    @IBAction func btReload(_ sender: UIBarButtonItem) {
        
        self.alert?.show(nil, hidden: nil)
        REST.checkUpdate(user: user) { (isValide) in
            if isValide == true {
                self.alertShow(title: nil, message: "Carregando Notas", color: nil, type: "P")
                self.alert?.show(nil, hidden: nil)
                REST.pushNotifications()
                self.reloadFecth()
            }else{
                self.alertShow(title: nil, message: "Informações estão atualizadas!", color: nil, type: "S")
                self.alert?.show(nil, hidden: nil)
            }
        }
        
    }
    
    func reloadFecth(){
        SVProgressHUD.show(withStatus: "Carregando")
        REST.subjectResponse(user: self.user, onComplete: { (array) in
            self.arraySubjects = array
            DispatchQueue.main.async {
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }
        }) { (error) in
            self.alert?.show(nil, hidden: nil)
            SVProgressHUD.dismiss()
            switch error {
            case .noResponse:
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NORESPONSE, color: UIColor(named: "errorDefault"), type: "T")
            case .noJson:
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NOJSON, color: UIColor(named: "errorDefault"), type: "T")
            case .nullResponse:
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NULLJSON, color: UIColor(named: "errorDefault"), type: "T")
            case .responseStatusCode(code: let codigo):
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.returnStatus(valueStatus:codigo!), color: UIColor(named: "errorDefault"), type: "T")
            case .noConectionInternet:
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_NO_INTERNET, color: UIColor(named: "errorDefault"), type: "T")
            case .alertData:
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_ALERT, color: UIColor(named: "errorDefault"), type: "T")
            default:
                self.alertShow(title: MESSAGE.MESSAGE_TITLE, message: MESSAGE.MESSAGE_DEFAULT, color: UIColor(named: "errorDefault"), type: "T")
            }
        }
    }
}

extension NotasViewController: UITableViewDelegate, UITableViewDataSource {
    
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
}
