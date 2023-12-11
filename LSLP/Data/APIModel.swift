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

struct Post: Encodable {
    let title: String?
    let content: String?
    let file: Data?
    let product_id: String?
    let content1: String?
    let content2: String?
    let content3: String?
    let content4: String?
    let content5: String?
}

struct SearchPost: Encodable {
    let next: String?
    let limit: String?
    let product_id: String?
}

struct SignUpResponse: Decodable {
    let email: String
    let nick: String
}

struct SignInResult: Decodable {
    let _id: String
    let token: String
    let refreshToken: String
}

struct AccountToken: Decodable {
    let token: String
}

struct RequestMessage: Decodable {
    let message: String
}
