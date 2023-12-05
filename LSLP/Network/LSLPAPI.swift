//
//  LSLPAPI.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/24.
//

import Foundation
import Moya

enum LSLPError: Error {
    case invalidAPIKey
    case overcall
    case invalidURL
    case serverError
}

enum LSLPAPI {
    case signUp(model: Account)
    case isValidEmail(email: String)
    case signIn(email: String, password: String)
    case refreshToken(token: String, refreshToken: String)
    case withdraw(token: String)
    
}

extension LSLPAPI: TargetType {//}, AccessTokenAuthorizable {
//    var authorizationType: Moya.AuthorizationType? {
//        switch self {
//        case .signUp(model: _), .isValidEmail(email: _), .signIn(email: _, password: _):
//            return nil
//        case .refreshToken(token: _, refreshToken: _):
//            return .basic
//        case .withdraw(token: _):
//            return .bearer
//        }
//    }
    
    var baseURL: URL {
        guard let url = URL(string: LSLPURL.testURL) else {
            fatalError()
        }
        return url
    }
    
    var path: String {
        switch self {
        case .signUp(model: _):
            return "join"
        case .isValidEmail(email: _):
            return "validation/email"
        case .signIn(email: _, password: _):
            return "login"
        case .refreshToken:
            return "refresh"
        case .withdraw:
            return "withdraw"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp(model: _), .isValidEmail(email: _), .signIn(email: _, password: _):
            return .post
        case .refreshToken, .withdraw:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .signUp(let model):
            return .requestJSONEncodable(model)
        case .isValidEmail(let email):
            return .requestParameters(parameters: ["email" : email], encoding: JSONEncoding.default)
        case .signIn(let email, let password):
            let data = Login(email: email, password: password)
            return .requestJSONEncodable(data)
        case .refreshToken, .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .signUp(model: _), .isValidEmail(email: _), .signIn(email: _, password: _):
            return [
                "Content-Type" : "application/json",
                "SesacKey" : "\(APIKey.key)"
            ]
       
        case .refreshToken(let token, let refreshToken):
            return [
                "Authorization" : "\(token)",
                "Refresh" : "\(refreshToken)",
                "SesacKey" : "\(APIKey.key)"
                
            ]
        case .withdraw(let token):
            return [
                "Authorization" : "\(token)",
                "SesacKey" : "\(APIKey.key)"
            ]
        }
    }
    
    var validationType: ValidationType {
            return .successCodes
    }
    
}
