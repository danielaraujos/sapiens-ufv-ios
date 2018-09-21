//
//  ProviderFecth.swift
//  Sapiens
//
//  Created by Daniel Araújo on 21/09/2018.
//  Copyright © 2018 Daniel Araújo Silva. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ProviderFecth {
    
    class func subjectFetch(user: User, onComplete: @escaping ([SubjectData]) -> Void, onFail: @escaping (RESTFail) -> ()){
        Alamofire.request(REST.pathBase + "notas", method: .post, parameters: REST.parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if REST.isConnectedToInternet() {
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        onFail(.noJson)
                        return
                    }
                    do{
                        let subjects = try JSONDecoder().decode([SubjectData].self, from: data)
                        REST.defaults.set(data, forKey: REST.localStorageSubject)
                        onComplete(subjects)
                    }catch{
                        onFail(.noDecoder)
                    }
                }else {
                    onFail(.responseStatusCode(code: response.response?.statusCode  ?? 0))
                }
            }else {
                onFail(.noConectionInternet)
            }
        }
    }
    
    
    class func schedulesFecth(user: User, onComplete: @escaping (SubjectsDataT) -> Void, onFail: @escaping (RESTFail) -> ()){
        Alamofire.request(REST.pathBase + "horarios", method: .post, parameters: REST.parametersAlamofire(user: user.user!, pass: user.pass!),encoding: JSONEncoding.default).responseJSON { (response) in
            if REST.isConnectedToInternet() {
                if response.response?.statusCode == 200 {
                    guard let data = response.data else {
                        onFail(.noJson)
                        return
                    }
                    do{
                        let subjects = try JSONDecoder().decode(SubjectsDataT.self, from: data)
                        REST.defaults.set(data, forKey: REST.localStorageSchedules)
                        onComplete(subjects)
                    }catch{
                        onFail(.noDecoder)
                    }
                }else {
                    onFail(.responseStatusCode(code: response.response?.statusCode ?? 0))
                }
            }else {
                onFail(.noConectionInternet)
            }
        }
    }
    
}
