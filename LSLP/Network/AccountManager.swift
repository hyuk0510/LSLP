//
//  AccountManager.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import Foundation
import Moya
import RxSwift
import RxMoya
import Realm

enum AccountError: Error {
    case inValidRequest
    case inValidInput
}

enum inValidEmailError: String, Error {
    case inValidInput = "이메일을 입력해주세요."
    case inValidEmail = "중복된 아이디입니다."
}

final class AccountManager {
    
    static let shared = AccountManager()
    
    private let provider = MoyaProvider<LSLPAPI>()
    private let disposeBag = DisposeBag()
    
    private init() { }
    
    func signUp(email: String, password: String, nick: String, phoneNum: String?, birthDay: String?, completion: @escaping (Result<SignUpResponse, Error>) -> Void) {
        
        let data = Account(email: email, password: password, nick: nick, phoneNum: phoneNum, birthDay: birthDay)
        
                        
            provider.rx.request(.signUp(model: data)).subscribe { result in
                switch result {
                case .success(let response):
                    print("success", response.statusCode, response.data)
                    
                    guard let value = try? JSONDecoder().decode(SignUpResponse.self, from: response.data) else {
                        return
                    }
                    completion(.success(value))
                case .failure(let error):
                    print("error", error)
                    completion(.failure(error))
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func isValidEmail(email: String, completion: @escaping (String) -> Void ) {
        
        provider.request(.isValidEmail(email: email)) { result in
            switch result {
            case .success(let response):
                print(response.statusCode, response.data)

                guard let value = try? JSONDecoder().decode(RequestMessage.self, from: response.data) else {
                    return
                }
                completion(value.message)
            case .failure(let error):
                print(error)
                print("error code: ", error.response?.statusCode)
                if email.isEmpty {
                    completion(inValidEmailError.inValidInput.rawValue)
                } else {
                    completion(inValidEmailError.inValidEmail.rawValue)
                }
            }
        }
            
        
    }
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
