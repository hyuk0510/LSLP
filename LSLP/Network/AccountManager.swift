//
//  AccountManager.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import Foundation
import Moya
import Realm

enum SignUpError: String, Error {
    case inValidRequest = "필수값을 채워주세요."
    case inValidInput = "중복된 계정입니다."
}

enum inValidEmailError: String, Error {
    case inValidInput = "이메일을 입력해주세요."
    case inValidEmail = "중복된 아이디입니다."
}

enum SignInError: String, Error {
    case inValidInput = "필수값을 채워주세요."
    case inValidAccount = "계정을 확인해주세요."
}

enum RefreshTokenError: String, Error {
    case inValidToken
    case forbidden
    case inExpiredToken
    case expiredRefreshToken
}

enum WithDrawError: String, Error {
    case inValidToken
    case forbidden
    case expiredToken
}

final class AccountManager {
    
    static let shared = AccountManager()
    
//    let plugIn = AccessTokenPlugin { _ in
//        Token.token ?? ""
//    }
    private lazy var provider = MoyaProvider<LSLPAPI>()//plugins: [plugIn])
    
    private init() { }
    
    func signUp(email: String, password: String, nick: String, phoneNum: String?, birthDay: String?, completion: @escaping (Result<SignUpResponse, SignUpError>) -> Void) {
        
        let data = Account(email: email, password: password, nick: nick, phoneNum: phoneNum, birthDay: birthDay)
        
        provider.request(.signUp(model: data)) { result in
            switch result {
            case .success(let response):
                print("success", response.statusCode, response.data)
                
                guard let value = try? JSONDecoder().decode(SignUpResponse.self, from: response.data) else {
                    return
                }
                completion(.success(value))
            case .failure(let error):
                print("error", error)
                if email.isEmpty || password.isEmpty || nick.isEmpty {
                    completion(.failure(.inValidInput))
                } else {
                    completion(.failure(.inValidRequest))
                }
            }
        }
        
    }
    
    func isValidEmail(email: String, completion: @escaping (Result<String, inValidEmailError>) -> Void) {
        
        provider.request(.isValidEmail(email: email)) { result in
            switch result {
            case .success(let response):
                print(response.statusCode, response.data)

                guard let value = try? JSONDecoder().decode(RequestMessage.self, from: response.data) else {
                    return
                }
                completion(.success(value.message))
            case .failure(let error):
                print(error)
                print("error code: ", error.response?.statusCode)
                if email.isEmpty {
                    completion(.failure(.inValidInput))
                } else {
                        completion(.failure(.inValidEmail))
                }
            }
        }
            
        
    }
    
    func signIn(email: String, password: String, completion: @escaping (Result<SignInResult, SignInError>) -> Void) {
        provider.request(.signIn(email: email, password: password)) { result in
            switch result {
            case .success(let response):
                guard let value = try? JSONDecoder().decode(SignInResult.self, from: response.data) else {
                    return
                }
                completion(.success(value))
            case .failure(_):
                if email.isEmpty || password.isEmpty {
                    completion(.failure(.inValidInput))
                } else {
                    completion(.failure(.inValidAccount))
                }
            }
        }
    }
    
    func refreshToken(completion: @escaping (RefreshTokenError) -> Void) {
        provider.request(.refreshToken(token: Token.token ?? "", refreshToken: Token.refreshToken ?? "")) { result in
            switch result {
            case .success(let response):
                print("REFRESH")
                guard let value = try? JSONDecoder().decode(AccountToken.self, from: response.data) else {
                    return
                }
                
                Token.token = value.token
            case .failure(let error):
                
                print(error.response?.statusCode)
                
                guard let response = error.response else {
                    return
                }
                
                if response.statusCode == 418 {
                    completion(.expiredRefreshToken)
                }
            }
        }
    }
    
    
//    func withdraw() {
//        provider.request(.withdraw(token: Token().token ?? "")) { result in
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
