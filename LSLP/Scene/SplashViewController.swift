//
//  SplashViewController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/12/07.
//

import UIKit

final class SplashViewController: BaseViewController {
    
    private let imageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        return view
    }()
    
    private let label = {
        let view = UILabel()
        view.text = "LSLP"
        view.font = .systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sleep(1)
        checkDidSignIn()
    }
    
    override func configure() {
        view.backgroundColor = .white
        [imageView, label].forEach { subView in
            view.addSubview(subView)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.size.equalTo(150)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(imageView.snp.centerX)
        }
    }
    
    private func checkDidSignIn() {

        if let _ = UserDefaults.standard.string(forKey: "RefreshToken") {
            AccountManager.shared.refreshToken { [weak self] response in
                switch response {
                case .success(let success):
                    print("토큰 재발급 성공!!!")
                    UserDefaults.standard.setValue(success.token, forKey: "Token")
                    self?.pushToTabBarController()
                case .failure(let error):
                    switch error {
                    case .expiredRefreshToken:
                        self?.loginViewAlert(title: "로그인 세션이 만료되었습니다.", message: "다시 로그인 해주세요")
                    case .inValidToken:
                        self?.loginViewAlert(title: "유효하지 않은 토큰입니다.", message: nil)
                    case .forbidden:
                        self?.loginViewAlert(title: "forbidden", message: nil)
                    case .inExpiredToken:
                        self?.pushToTabBarController()
                    }
                        
                }
                
            }
            
        } else {
            self.pushToSignInViewController()
        }
            
    }
    
    private func loginViewAlert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.pushToSignInViewController()
        }
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
}
