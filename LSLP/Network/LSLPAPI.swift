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
    // Account
    case signUp(model: Account)
    case isValidEmail(email: String)
    case signIn(email: String, password: String)
    case refreshToken
    case withdraw
    
    // Post
    case uploadPost(model: Post)
//    case searchPost(model: SearchPost)
//    case changePost(_id: String, model: Post)
//    case removePost(_id: String)
//    case searchUserPost(_id: String, model: SearchPost)
}

extension LSLPAPI: TargetType, AccessTokenAuthorizable {
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .signUp(_), .isValidEmail(_):
            return .none
        case .signIn(_, _), .refreshToken, .withdraw, .uploadPost(_):
            return .bearer
        }
    }
    
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
        case .uploadPost(model: _):
            return "post"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp(model: _), .isValidEmail(email: _), .signIn(email: _, password: _), .uploadPost(model: _):
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
        case .uploadPost(let model):
            return .requestJSONEncodable(model)
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
       
        case .refreshToken, .withdraw:
            return [
                "SesacKey" : "\(APIKey.key)"
                
            ]
        
        case .uploadPost(_):
            return [
                "Content-Type" : "",
                "SesacKey" : "\(APIKey.key)"
            ]
        }
    }
    
    var validationType: ValidationType {
            return .successCodes
    }
    
}
