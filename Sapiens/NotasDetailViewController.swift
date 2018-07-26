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

class NotasDetailViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView: UITableView!
    var array : SubjectData!
    var arraySubjects: [SubjectData] = []
    var arrayTupla: [(title: String, detail : String, tipo: String)] = [(" ", " ", " ")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = array.nome
        print(array)
        DispatchQueue.main.async {
            self.returnTuplas()
            self.tableView.reloadData()
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
        
        
        self.arrayTupla.append((title: "Faltas práticas", detail: faltasPraticas,tipo:"1"))
        self.arrayTupla.append((title: "Faltas teóricas", detail: faltasTeoricas,tipo:"2"))
        self.arrayTupla.append((title: "Nota Final", detail: notaFinal,tipo:"3"))
        self.arrayTupla.append((title: "Conceito", detail: notaConceito,tipo:"4"))
        
        if (self.array.nota?.notas?.isEmpty == false) {
            for a in (self.array.nota!.notas)! {
                self.arrayTupla.append((title: "\(a.nome)", detail: "\(a.valor) de \(a.max)", tipo: String("0")))
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayTupla.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSubject", for: indexPath) as! SubjectCell
        let subject = self.arrayTupla[indexPath.row]
        
        cell.title.text = subject.title
        cell.detail.text = subject.detail
        
        
        cell.detail.layer.cornerRadius = 10
        if(subject.tipo == "3" || subject.tipo == "4"){
            if(Int(subject.detail)! >= Int("60")!){
                cell.detail.backgroundColor = UIColor(hexString: "1C93D1")
            }else{
                cell.detail.backgroundColor = UIColor.red
            }
        }else {
            cell.detail.backgroundColor = UIColor(hexString: "1C93D1")
        }
        cell.detail.clipsToBounds = true
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

}
