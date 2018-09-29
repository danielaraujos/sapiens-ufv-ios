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
