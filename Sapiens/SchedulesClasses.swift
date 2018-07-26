//
//  SchedulesClass.swift
//  Sapiens
//
//  Created by Daniel Araújo on 24/07/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation


// Array de Disciplinas
struct SubjectsDataT : Codable {
    let disciplinas : [SchedulesData]
    let horarios : [SchedulesInfo]
}

//struct SubjectsDataD : Codable {
//    let disciplinas : [SchedulesData]
//}
//struct SubjectsDataH : Codable {
//    let horarios : [SchedulesInfo]
//}

// Conteudo da disciplica
struct SchedulesData : Codable {
    let codigo: String
    let nome : String
    let creditos : String
    let turma : ClassData
}

// Tipo da Turma
struct ClassData : Codable {
    let pratica : String
    let teorica : String
}

//horarios
struct SchedulesInfo : Codable {
    let hora: String
    let segunda: Monday
    let terca : Tuesday
    let quarta : Wednesday
    let quinta : Thursday
    let sexta : Friday
    let sabado : Saturday
}

struct Monday  : Codable{
    let codigo : String
    let sala : String
}

struct Tuesday   : Codable{
    let codigo : String
    let sala : String
}

struct Wednesday  : Codable{
    let codigo : String
    let sala : String
}

struct Thursday  : Codable{
    let codigo : String
    let sala : String
}

struct Friday  : Codable{
    let codigo : String
    let sala : String
}

struct Saturday  : Codable{
    let codigo : String
    let sala : String
}

