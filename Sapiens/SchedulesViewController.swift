//
//  SchedulesViewController.swift
//  Sapiens
//
//  Created by Daniel Araújo on 24/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import UIKit
import SwiftDataTables

class SchedulesViewController: UIViewController {

    var user = User(user: "ER04325", pass: "142563")
    
    var dataTable: SwiftDataTable! = nil
    var dataSource: DataTableContent = []
    
    var arraySchedules : [SchedulesInfo] = []
    
    let headerTitles = [
        "Hs",
        "Se",
        "Te",
        "Qu",
        "Qu",
        "Se",
        "Sa"
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataTable = SwiftDataTable(dataSource: self)
        self.dataTable.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.dataTable.frame = self.view.frame
        self.view.addSubview(self.dataTable);
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("------------------HORARIOS--------------------")
        REST.schedulesResponse(user: self.user) { (arrayResponse) in
            for i in arrayResponse.horarios {
                self.dataSource.append([
                    DataTableValueType.string(i.hora),
                    DataTableValueType.string(i.segunda.sala),
                    DataTableValueType.string(i.terca.sala),
                    DataTableValueType.string(i.quarta.sala),
                    DataTableValueType.string(i.quinta.sala),
                    DataTableValueType.string(i.sexta.sala),
                    DataTableValueType.string(i.sabado.sala)
                ])
            }
             self.dataTable.reload()
            print(self.dataSource)
        }
        self.dataSource.removeAll()
        
    }
    
    
}
extension SchedulesViewController: SwiftDataTableDataSource {
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
