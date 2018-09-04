//
//  ConfigurationsCell.swift
//  Sapiens
//
//  Created by Daniel Araújo on 03/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation

import UIKit

class ConfigurationsCell : UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var imageI: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.arredondandoImagem()
        
    }
    
    /* Função responsavel por arredondar os cantos para os botoes e views */
    func arredondandoImagem(){
        imageI.layer.cornerRadius = 5;
        imageI.clipsToBounds = true;
    }
}
