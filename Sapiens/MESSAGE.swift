//
//  MESSAGE.swift
//  Sapiens
//
//  Created by Daniel Araújo on 26/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation

class MESSAGE {
    init (){}
    
    static let MESSAGE_NORESPONSE = "Servidor não respondendo"
    static let MESSAGE_NOJSON = "Não foi possivel converter a requisição"
    static let MESSAGE_NULLJSON = "Ocorreu algum erro na aplicação, e não está retornando nada"
    static let MESSAGE_NODECODER = "Ocorreu algum erro na aplicação, e não está retornando nada."
    
    
    class func returnStatus(valueStatus: Int)-> String {
        if valueStatus == 403 {
            return  "ERRO 403: Aplicação não possui autorização para isso."
        }else if valueStatus ==  404 {
            return "ERRO 404: Servidor da aplicação não está funcionando."
        }else if valueStatus == 500 {
            return "Erro 500: Algum script ou solicitação não foi compreendida"
        }else if valueStatus == 503 {
            return "ERRO 503: Serviço do servidor está temporareamente indisponivel."
        }else {
            return " "
        }
    }
//    case noResponse
//    case noJson
//    case nullResponse
//    case noDecoder
}
