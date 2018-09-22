//
//  SchedulesViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 24/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import SVProgressHUD
import SpreadsheetView
import LIHAlert

class SchedulesViewController: BaseViewController{

    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    var user = User(user: COREDATA.loginUserCore().user!, pass: COREDATA.loginUserCore().pass!)
    
    let days = ["SEGUNDA", "TERÇA", "QUARTA", "QUINTA", "SEXTA", "SABADO", ]
    let dayColors = [UIColor(red: 0.918, green: 0.224, blue: 0.153, alpha: 1),
                     UIColor(red: 0.106, green: 0.541, blue: 0.827, alpha: 1),
                     UIColor(red: 0.200, green: 0.620, blue: 0.565, alpha: 1),
                     UIColor(red: 0.953, green: 0.498, blue: 0.098, alpha: 1),
                     UIColor(red: 0.400, green: 0.584, blue: 0.141, alpha: 1),
                     UIColor(red: 0.835, green: 0.655, blue: 0.051, alpha: 1)]
    let hours = ["07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00", "15:00",
                "16:00", "17:00", "18:00", "19:00", "19:50", "21:00", "21:50"]
    let evenRowColor = UIColor(red: 0.914, green: 0.914, blue: 0.906, alpha: 1)
    let oddRowColor: UIColor = .white
    
    var data = [
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""],
        ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    ]
    
    var v1: [(String)] = [],v2: [(String)] = [],v3: [(String)] = [],v4: [(String)] = [],v5: [(String)] = [],v6: [(String)] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spreadsheetView.dataSource = self
        spreadsheetView.delegate = self
        
        spreadsheetView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        spreadsheetView.intercellSpacing = CGSize(width: 4, height: 1)
        spreadsheetView.gridStyle = .none
        
        spreadsheetView.register(DateCell.self, forCellWithReuseIdentifier: String(describing: DateCell.self))
        spreadsheetView.register(TimeTitleCell.self, forCellWithReuseIdentifier: String(describing: TimeTitleCell.self))
        spreadsheetView.register(TimeCell.self, forCellWithReuseIdentifier: String(describing: TimeCell.self))
        spreadsheetView.register(DayTitleCell.self, forCellWithReuseIdentifier: String(describing: DayTitleCell.self))
        spreadsheetView.register(ScheduleCell.self, forCellWithReuseIdentifier: String(describing: ScheduleCell.self))
        
        self.showProgressing(message: "Carregando Horários")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ViewDidAppear")
        DispatchQueue.main.async {
            self.reloadFecth()
        }
        spreadsheetView.flashScrollIndicators()
    }
    
    @IBAction func btReload(_ sender: UIBarButtonItem) {
        self.processingAlert?.show(nil, hidden: nil)
        self.reloadFecth()
        self.processingAlert?.hideAlert(nil)
    }
   
    func reloadFecth(){
        SVProgressHUD.show(withStatus: "Carregando")
        REST.schedulesResponse(user: self.user, onComplete: { (arrayResponse ) in
    
            DispatchQueue.global(qos: .userInitiated).async {
                for i in arrayResponse.horarios {
                        self.v1.append(i.segunda.codigo+" - "+i.segunda.sala)
                        self.v2.append(i.terca.codigo+" - "+i.terca.sala)
                        self.v3.append(i.quarta.codigo+" - "+i.quarta.sala)
                        self.v4.append(i.quinta.codigo+" - "+i.quinta.sala)
                        self.v5.append(i.sexta.codigo+" - "+i.sexta.sala)
                        self.v6.append(i.sabado.codigo+" - "+i.sabado.sala)
                }
                DispatchQueue.main.async {
                    self.data.removeAll()
                    self.data = [self.v1,self.v2,self.v3,self.v4,self.v5,self.v6]
                    self.spreadsheetView.reloadData()
                    self.processingAlert?.hideAlert(nil)
                    SVProgressHUD.dismiss()
                }
            }
          
        }) { (error) in
            self.errorAlert?.show(nil, hidden: nil)
            SVProgressHUD.dismiss()
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

extension SchedulesViewController :SpreadsheetViewDataSource, SpreadsheetViewDelegate {
 
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + days.count
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + 1 + hours.count
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        if case 0 = column {
            return 80
        } else {
            return 140
        }
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        if case 0 = row {
            return 24
        } else if case 1 = row {
            return 32
        } else {
            return 40
        }
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 2
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
         if case (1...(days.count + 1), 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: DayTitleCell.self), for: indexPath) as! DayTitleCell
            cell.label.text = days[indexPath.column - 1]
            cell.label.textColor = dayColors[indexPath.column - 1]
            return cell
        } else if case (0, 1) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeTitleCell.self), for: indexPath) as! TimeTitleCell
            cell.label.text = "HORÁRIOS"
            return cell
        } else if case (0, 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeCell.self), for: indexPath) as! TimeCell
            cell.label.text = hours[indexPath.row - 2]
            cell.backgroundColor = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
            return cell
        } else if case (1...(days.count + 1), 2...(hours.count + 2)) = (indexPath.column, indexPath.row) {
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: ScheduleCell.self), for: indexPath) as! ScheduleCell
            let text = data[indexPath.column - 1][indexPath.row - 2]
            if text.count > 3 {
                cell.label.text = text
                let color = dayColors[indexPath.column - 1]
                cell.label.textColor = color
                cell.color = color.withAlphaComponent(0.2)
                cell.borders.top = .solid(width: 1, color: color)
                cell.borders.bottom = .solid(width: 1, color: color)
                cell.label.textAlignment = .center
            } else {
                cell.label.text = nil
                cell.color = indexPath.row % 2 == 0 ? evenRowColor : oddRowColor
                cell.borders.top = .none
                cell.borders.bottom = .none
            }
            return cell
        }
        return nil
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: (row: \(indexPath.row), column: \(indexPath.column))")
        self.showAlertSheet(title: "NUR 340", message: "Nome da Materia")
        //print(self.data[indexPath.row])
        switch indexPath.row {
        case 1:
            print("1")
        case 2:
            print("2")
        case 3:
            print("3")
        case 4:
            print("4")
        case 5:
            print("5")
        case 6:
            print("6")
        default:
            break
        }
        
    }
    
}

