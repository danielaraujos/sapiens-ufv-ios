//
//  NotificationsViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 03/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTempo: UILabel!
    @IBOutlet weak var lblEsquema: UILabel!
    
    @IBOutlet weak var isOn: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var colorSegmented: UISegmentedControl!
    
    var times = ["5","10","15","25","30","35","40"]
    var itemAtDefaultPosition: String?
    
    var config = Configuration.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        formatedView()
        
        if config.storageColor == 1 {
            self.view.backgroundColor = UIColor.black
            self.lblTempo.textColor = UIColor.white
            self.lblNotification.textColor = UIColor.white
            self.lblEsquema.textColor = UIColor.white
        }
    }
    
    @IBAction func btIsOn(_ sender: UISwitch) {
        config.storageNotifications = sender.isOn
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
    }
    @IBAction func changeSegmented(_ sender: Any) {
        config.storageColor = (sender as AnyObject).selectedSegmentIndex
    }
    
    
    func formatedView(){
        
        //Verificar o status
        if config.storageNotifications == true {
            isOn.isOn = true
        }else {
            isOn.isOn = false
        }
        
        if let index = times.index(of: String(config.storageTime)){
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        
        if config.storageColor == 0 {
            colorSegmented.selectedSegmentIndex = 0
        }else  {
            colorSegmented.selectedSegmentIndex = 1
        }
    }
    
}
extension NotificationsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return times[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        config.storageTime = Int(times[row])!
    }
}
