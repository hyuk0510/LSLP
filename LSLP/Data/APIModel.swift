//
//  APIModel.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import Foundation

struct Account: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
}

struct Login: Encodable {
    let email: String
    let password: String
}

struct SignUpResponse: Decodable {
    let email: String
    let nick: String
}

struct Token: Decodable {
    let _id: String
    let token: String
    let refreshToken: String
}

struct RequestMessage: Decodable {
    let message: String
}
