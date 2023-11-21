//
//  AccountManager.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import Foundation
import Moya

enum AccountError: Error {
    case invalidAPIKey
    case overcall
    case invalidResponse
}

enum LSLPAPI {
    case signUp(model: Account)
    case isValidEmail(email: String)
    case signIn(email: String, password: String)
    case refreshToken
    case content
    case withdraw
}

extension LSLPAPI: TargetType {
    var baseURL: URL {
        URL(string: LSLPURL.url)!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "join"
        case .isValidEmail:
            return "validation/email"
        case .signIn:
            return "login"
        case .refreshToken:
            return "refresh"
        case .content:
            return "content"
        case .withdraw:
            return "withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .isValidEmail, .signIn, .withdraw:
                .post
        case .refreshToken, .content:
                .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let data):
            return .requestJSONEncodable(data)
        case .isValidEmail(let email):
            return .requestJSONEncodable(email)
        case .signIn(let email, let password):
            let data = Login(email: email, password: password)
            return .requestJSONEncodable(data)
        case .refreshToken, .content, .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp, .isValidEmail, .signIn:
            [
                "Content-Type" : "application/json",
                "SesacKey" : "\(APIKey.key)"
            ]
       
        case .refreshToken:
            [
                "Authorization" : "token",
                "Refresh" : "refreshtoken",
                "SesacKey" : "\(APIKey.key)"
                
            ]
        case .content, .withdraw:
            [
                "Authorization" : "token",
                "SesacKey" : "\(APIKey.key)"
            ]
        }
    }
    
    
}
