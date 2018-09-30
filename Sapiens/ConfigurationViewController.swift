//
//  ConfigurationViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 26/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import MessageUI

class ConfigurationViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblMatricula: UILabel!
    
    var settings : [Setting] = []
    var CELL_ID = "AjusteCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lista()
        self.lblMatricula.text = self.user.user?.uppercased() ?? "0"
        
        if Configuration.shared.storageColor == 1 {
            self.tableView.backgroundColor = UIColor.black
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Configuration.shared.storageColor == 1 {
            self.tableView.backgroundColor = UIColor.black
        }
    }
  
    func lista(){
        var config: Setting;
        config = Setting(id: 1, nome: "Ajustes Gerais", image: #imageLiteral(resourceName: "settingConfig"))
        self.settings.append(config)
        config = Setting(id: 2, nome: "Sobre o aplicativo", image: #imageLiteral(resourceName: "informa"))
        self.settings.append(config)
        config = Setting(id: 3, nome: "Ajuda", image:#imageLiteral(resourceName: "user"))
        self.settings.append(config)
        config = Setting(id: 4, nome: "Contar a um amigo", image: #imageLiteral(resourceName: "contar"))
        self.settings.append(config)
        config = Setting(id: 5, nome: "Avaliar aplicativo", image: #imageLiteral(resourceName: "relatar"))
        self.settings.append(config)
        
    }
    
    @IBAction func btLogout(_ sender: UIBarButtonItem) {
        print("Redirecionar para inicio")
        self.deleteUser()
        REST.deleteStorage()
        let loginViewController = REST.logoutHome()
        self.present(loginViewController, animated:true, completion:nil)
    }
    
}

extension ConfigurationViewController:  UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let config: Setting = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! ConfigurationsCell
        cell.lblTitle.text = config.nome
        cell.imageI.image = config.image
        
        if Configuration.shared.storageColor == 1 {
            changeColorBackgraung(tableView: cell, titleLabel: cell.lblTitle, detailLabel: nil )
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Configuration.shared.storageColor == 1 {
            cell.backgroundColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let selecionado = self.settings[indexPath.row]
        
        if selecionado.id == 1 {
            //self.performSegue(withIdentifier: "NotificationCell", sender: nil)
            openModal(identified: "NotificationsViewController")
        }else if selecionado.id == 2{
            //self.shouldPerformSegue(withIdentifier: "AboutCell", sender: nil)
            openModal(identified: "AboutViewController")
        }else if selecionado.id == 3{
            //ajuda
            self.padrao("daniel.araujos@icloud.com", "Preciso de ajuda - Sapiens iOS")
        }else  if selecionado.id == 4{
            //contar a um amigo
            self.compartilhar()
        }else if selecionado.id == 5 {
            self.avaliarApp(appId: "1437726885", completion: { (success) in
                print("RateApp \(success)")
            })
        }
    }
    
    func openModal(identified: String){
        let vc = (
            storyboard?.instantiateViewController(
                withIdentifier: identified)
            )!
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
    

    
    
    func avaliarApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func padrao(_ email: String, _ descricao: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            mail.setMessageBody("<p>Dispositivo: \(UIDevice.current.name) - \(UIDevice.current.model)</p>", isHTML: true)
            mail.setSubject(descricao)
            
            present(mail, animated: true)
        } else {
            self.showAlertSheet(title: "Ops.", message: "Ocorreu algum problema no envio. Tente novamente mais tarde!")
        }
    }
    
    func compartilhar(){
        let site = "https://itunes.apple.com/us/app/sapiens/id1437726885"
        let activitiVC = UIActivityViewController(activityItems: [site], applicationActivities: nil)
        activitiVC.popoverPresentationController?.sourceView = self.view
        self.present(activitiVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}
