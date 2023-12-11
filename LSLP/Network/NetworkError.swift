//
//  NetworkError.swift
//  LSLP
//
//  Created by 선상혁 on 2023/12/11.
//

import UIKit

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
    
//    func ah(vc: UIViewController) {
//        switch self {
//        case .inValidToken:
//            return
//        case .forbidden:
//            return
//        case .inExpiredToken:
//            vc.pushToTabBarController()
//        case .expiredRefreshToken:
//            
//        }
//    }
}

enum WithDrawError: String, Error {
    case inValidToken
    case forbidden
    case expiredToken
}
