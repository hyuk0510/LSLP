//
//  AccountManager.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import Foundation
import Moya
import Realm
import Alamofire

final class AccountManager {
    
    static let shared = AccountManager()
    
//    private let authPlugin = AccessTokenPlugin { _ in
//        UserDefaults.standard.string(forKey: "Token") ?? ""
//    }
    private lazy var provider = MoyaProvider<LSLPAPI>(session: Session(interceptor: Interceptor.shared))//, plugins: [authPlugin])
    
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
    
    func refreshToken(completion: @escaping (Result<AccountToken, RefreshTokenError>) -> Void) {
        provider.request(.refreshToken) { result in
            switch result {
            case .success(let response):
                guard let value = try? JSONDecoder().decode(AccountToken.self, from: response.data) else {
                    return
                }
                
                completion(.success(value))
            case .failure(let error):
                
                guard let response = error.response else {
                    return
                }
                
                switch response.statusCode {
                case 409:
                    completion(.failure(.inExpiredToken))
                case 418:
                    completion(.failure(.expiredRefreshToken))
                case 401:
                    completion(.failure(.inValidToken))
                default:
                    completion(.failure(.forbidden))
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
