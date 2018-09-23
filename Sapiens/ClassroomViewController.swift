//
//  ClassroomViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 25/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//
import UIKit
import SwiftDataTables
import SVProgressHUD

class ClassroomViewController: BaseViewController {

    var user = User(user: COREDATA.loginUserCore().user!, pass: COREDATA.loginUserCore().pass!)
    
    var dataTable: SwiftDataTable! = nil
    var dataSource: DataTableContent = []
    
    var arraySchedules : [SchedulesInfo] = []
    
    let headerTitles = ["Código","Nome","Créditos","Prática","Teorica"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataTable = SwiftDataTable(dataSource: self)
        self.dataTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.dataTable.frame = self.view.frame
        self.view.addSubview(self.dataTable);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadClassRoomInformations()
    }
    
    @IBAction func btReload(_ sender: UIBarButtonItem) {
        SVProgressHUD.show(withStatus: "Carregando Horários")
        self.loadClassRoomInformations()
        SVProgressHUD.dismiss(withDelay: 2)
    }
    
    
    func loadClassRoomInformations(){
        print("Pedindo requsição das materias")
        REST.schedulesResponse(user: self.user, onComplete: { (arrayResponse) in
            for i in arrayResponse.disciplinas {
                self.dataSource.append([
                    DataTableValueType.string(i.codigo),
                    DataTableValueType.string(i.nome),
                    DataTableValueType.string(i.creditos),
                    DataTableValueType.string(i.turma.pratica),
                    DataTableValueType.string(i.turma.teorica)
                    ])
            }
            self.dataTable.reload()
        }) { (error) in
            switch error {
            case .noResponse:
                self.showAlertSheet(title: "Erro!", message: MESSAGE.MESSAGE_NORESPONSE)
            case .noJson:
                self.showAlertSheet(title: "Erro!", message: MESSAGE.MESSAGE_NOJSON)
            case .nullResponse:
                self.showAlertSheet(title: "Erro!", message: MESSAGE.MESSAGE_NULLJSON)
            case .responseStatusCode(code: let codigo):
                self.showAlertSheet(title: "Erro!", message: MESSAGE.returnStatus(valueStatus:codigo!))
            case .noConectionInternet:
                self.showAlertSheet(title: "OPS!", message: MESSAGE.MESSAGE_NO_INTERNET)
            default:
                self.showAlertSheet(title: "OPS!", message: MESSAGE.MESSAGE_DEFAULT)
            }
        }
        self.dataSource.removeAll()
    }
    
}

extension ClassroomViewController: SwiftDataTableDataSource {
    public func dataTable(_ dataTable: SwiftDataTable, headerTitleForColumnAt columnIndex: NSInteger) -> String {
        return self.headerTitles[columnIndex]
    }
    
    public func numberOfColumns(in: SwiftDataTable) -> Int {
        return self.headerTitles.count
    }
    
    func numberOfRows(in: SwiftDataTable) -> Int {
        return self.dataSource.count
    }
    
    public func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataTableValueType] {
        return self.dataSource[index]
    }
}
