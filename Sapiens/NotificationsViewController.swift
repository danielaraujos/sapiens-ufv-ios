//
//  NotificationsViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 03/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    @IBOutlet weak var isOn: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    var times = ["5","10","15","25","30","35","40"]
    var itemAtDefaultPosition: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //RESPONSAVEL POR DEFINIR SE O SWICTH ESTÁ ATIVO
        if defaults.bool(forKey: REST.localStorageNotifications) == true {
            isOn.isOn = true
        }else{
            isOn.isOn = false
        }
        
        // RESPONSAVEL POR SALVAR O TEMPO
        if let index = times.index(of: String(defaults.integer(forKey: REST.localStorageTime))){
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    @IBAction func btIsOn(_ sender: UISwitch) {
        if isOn.isOn == true {defaults.set(true, forKey: REST.localStorageNotifications)
        }else {defaults.set(false, forKey: REST.localStorageNotifications)}
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil);
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
        defaults.set(Int(times[row]), forKey: REST.localStorageTime)
    }
}
