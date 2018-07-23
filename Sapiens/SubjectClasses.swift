//
//  Subject.swift
//  Sapiens
//
//  Created by Daniel Araújo on 16/06/17.
//  Copyright © 2017 Daniel Araújo Silva. All rights reserved.
//

import Foundation

struct SubjectData: Codable {
    var nome: String
    let alteracao : String
    let calculo: String
    let nota : NoteData?
    let faltas : FaultData?
}

struct FaultData : Codable {
    let teoricas: String
    let praticas: String
}

struct NoteData : Codable {
    let conceito : String
    let exame: String
    let final: String
    let notas:[NotesData]?
}

struct NotesData : Codable {
    let max: String
    let nome: String
    let valor: String
}


