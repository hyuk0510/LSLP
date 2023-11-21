//
//  AccountManager.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import Foundation
import Moya

final class AccountManager {
    
    static let shared = AccountManager()
    private init() { }
    
    let provider = MoyaProvider<LSLPAPI>()
    
    func signUp(email: String, password: String, nick: String, phoneNum: String?, birthDay: String?, completion: @escaping (SignUpResponse) -> Void) {
        let data = Account(email: email, password: password, nick: nick, phoneNum: phoneNum, birthDay: birthDay)
        
        provider.request(.signUp(model: data)) { result in
            switch result {
            case .success(let value):
                print("success", value.statusCode, value.data)
                
                let value = try! JSONDecoder().decode(SignUpResponse.self, from: value.data)
                completion(value)
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
//    func isValidEmail(email: String) {
//        provider.request(.isValidEmail(email: email)) { result in
//            switch result {
//            case .success(_):
//                <#code#>
//            case .failure(_):
//                <#code#>
//            }
//        }
//    }
//    
//    func signIn(email: String, password: String) {
//        provider.request(.signIn(email: email, password: password)) { result in
//            switch result {
//            case .success(_):
//                <#code#>
//            case .failure(_):
//                <#code#>
//            }
//        }
//    }
//    
//    func refreshToken() {
//        provider.request(.refreshToken) { result in
//            switch result {
//            case .success(_):
//                <#code#>
//            case .failure(_):
//                <#code#>
//            }
//        }
//    }
//    
//    func content() {
//        provider.request(.content) { result in
//            switch result {
//            case .success(_):
//                <#code#>
//            case .failure(_):
//                <#code#>
//            }
//        }
//    }
//    
//    func withdraw() {
//        provider.request(.withdraw) { result in
//            switch result {
//            case .success(let value):
//                
//                let value = try! JSONDecoder().decode(SignUpResponse.self, from: value.data)
//                
//            case .failure(let error):
//                <#code#>
//            }
//        }
//    }
}
