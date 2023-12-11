//
//  Interceptor.swift
//  LSLP
//
//  Created by 선상혁 on 2023/12/07.
//

import Foundation
import Moya
import Alamofire

final class Interceptor: RequestInterceptor {
    
    static let shared = Interceptor()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard urlRequest.url?.absoluteString.hasPrefix(LSLPURL.testURL) == true,
        let accessToken = UserDefaults.standard.string(forKey: "Token"),
        let refreshToken = UserDefaults.standard.string(forKey: "RefreshToken")
        else {
            completion(.success(urlRequest))
            return
        }
        var urlRequest = urlRequest
        urlRequest.setValue(accessToken, forHTTPHeaderField: "Authorization")
        urlRequest.setValue(refreshToken, forHTTPHeaderField: "Refresh")
        print("token 적용 \(urlRequest.headers)")
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
//        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 418 else {
//            completion(.doNotRetryWithError(error))
//            return
//        }
        completion(.doNotRetryWithError(error))
    }
}
