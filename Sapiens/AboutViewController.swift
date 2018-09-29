//
//  AboultViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 29/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    @IBOutlet weak var tvMotivacions: UITextView!
    @IBOutlet weak var tvInformations: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tvMotivacions.text = " O Sapiens é uma das ferramentas mais importantes na vida acadêmica de docentes na UFV. Ela possibilita o acesso ao histórico, disciplinas, notas e demais funcionalidades.  Devido esta importância, não poderia faltar aplicativos para otimizar e facilitar a vida dos docentes. Como só existia esta funcionalidade para dispositivos Android, motivou o desenvolvimento para a plataforma iOS."
        self.tvInformations.text = " Devido as diversas regras da plataforma iOS, não é possível a verificação continua das notas em segundo plano. Desta forma esta rotina, é executada de acordo com a liberação na fila de execuções da plataforma."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnLinkedinD(_ sender: UIButton) {
        self.open(scheme: "https://www.linkedin.com/in/daniel-araujo-silva-6ba881129")
    }
    
    @IBAction func btnLinkedinH(_ sender: UIButton) {
        self.open(scheme: "https://www.linkedin.com/in/higor-cavalcanti/")
    }
    
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                                            print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
}
