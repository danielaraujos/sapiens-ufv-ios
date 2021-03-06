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
import Foundation

class NotasDetailViewController: BaseViewController{

    @IBOutlet weak var tableView: UITableView!
    var array : SubjectData!
    var arrayTupla: [(title: String, detail : String, tipo: String, max: String)] = [(" ", " ", " ", " ")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = array.nome
        DispatchQueue.main.async {
            self.returnTuplas()
            self.tableView.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Configuration.shared.storageColor == 1 {
            self.tableView.backgroundColor = UIColor.black
        }
    }
    
    func returnTuplas (){
        self.arrayTupla.remove(at: 0)
        var faltasPraticas = self.array.faltas!.praticas
        var faltasTeoricas = self.array.faltas!.teoricas
        var notaFinal = self.array.nota!.final
        var notaConceito = self.array.nota!.conceito
        
        if (faltasPraticas.isEmpty) {faltasPraticas = String(0)}
        if (faltasTeoricas.isEmpty) {faltasTeoricas = String(0)}
        if (notaFinal.isEmpty) {notaFinal = String(0)}
        if (notaConceito.isEmpty) {notaConceito = String(0)}
        
        
        self.arrayTupla.append((title: "Faltas Práticas", detail: faltasPraticas,tipo:"1", max: ""))
        self.arrayTupla.append((title: "Faltas Teóricas", detail: faltasTeoricas,tipo:"2",max: ""))
        self.arrayTupla.append((title: "Nota Final", detail: notaFinal,tipo:"3",max: "60"))
        self.arrayTupla.append((title: "Conceito", detail: notaConceito,tipo:"4",max: ""))
        
        if (self.array.nota?.notas?.isEmpty == false) {
            for a in (self.array.nota!.notas)! {
                self.arrayTupla.append((title: "\(a.nome)", detail: "\(a.valor)", tipo: String("0"),max: "\(a.max)"))
            }
        }
    }

}

extension NotasDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTupla.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubject", for: indexPath) as! SubjectCell
        let subject = self.arrayTupla[indexPath.row]
        print(subject)
        
        cell.title.text = subject.title
        cell.detail.text = subject.detail
        
        cell.selectionStyle = .none
        
        if Configuration.shared.storageColor == 1 {
            changeColorBackgraung(tableView: cell, titleLabel: cell.title, detailLabel: cell.detail)
        }
        
        cell.backgraundView.layer.cornerRadius = 7
        if(subject.tipo == "0"){
            let value = subject.detail.convertCommaToDecimal
            let maximo = subject.max.convertCommaToDecimal
            
            if(value >= (maximo*0.6)){
                cell.backgraundView.backgroundColor = UIColor(hexString: "E6C43D")
            }else{
                cell.backgraundView.backgroundColor = UIColor.red
            }
            if maximo != 0{
                cell.detail.text = "\(value) de \(maximo) (\((value/maximo)*100)%)"
            }else{
                cell.detail.text = "\(value) de \(maximo)"
            }
        }else {
            cell.backgraundView.backgroundColor = UIColor(hexString: "E6C43D")
            
            
        }
        cell.backgraundView.clipsToBounds = true
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if Configuration.shared.storageColor == 1 {
            cell.backgroundColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}


/*Responsavel por transformar virgula em ponto*/
extension String {
    
    var convertCommaToDecimal: Double {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        if let result = numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            numberFormatter.decimalSeparator = ","
            if let result = numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
}
