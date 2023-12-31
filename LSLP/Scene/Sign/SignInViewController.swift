//
//  SignInViewController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class SignInViewController: BaseViewController {
    
    private let imageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "figure.wave")
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.green.cgColor
        return view
    }()
    
    private let idTextField = {
        let view = SignInTextField()
        view.placeholder = "아이디를 입력해주세요"
        return view
    }()
    
    private let pwTextField = {
        let view = SignInTextField()
        view.placeholder = "비밀번호를 입력해주세요"
        view.isSecureTextEntry = true
        return view
    }()
    
    private lazy var loginButton = {
        let view = UIButton()
        var configure = UIButton.Configuration.filled()
        configure.baseBackgroundColor = .systemIndigo
        configure.baseForegroundColor = .white
        configure.title = "로그인"
        view.configuration = configure
        view.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return view
    }()
    
    private lazy var signUpButton = {
        let view = UIButton()
        
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 17, weight: .semibold)
        
        var configure = UIButton.Configuration.borderless()
        configure.attributedTitle = AttributedString("회원가입", attributes: container)
        configure.baseBackgroundColor = .white
        configure.baseForegroundColor = .black
        view.configuration = configure
        view.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        return view
    }()
    
    @objc
    private func loginButtonPressed() {
        AccountManager.shared.signIn(email: idTextField.text ?? "", password: pwTextField.text ?? "") { result in
            switch result {
            case .success(let success):
                let vc = TabBarController()
                vc.navigationItem.hidesBackButton = true
                
                UserDefaults.standard.setValue(success.token, forKey: "Token")
                UserDefaults.standard.setValue(success.refreshToken, forKey: "RefreshToken")
                
                //                UserDefaults.standard.setValue(idTextField.text, forKey: "UserID")
                //                UserDefaults.standard.setValue(pwTextField, forKey: "UserPW")
                self.navigationController?.pushViewController(vc, animated: true)
            case .failure(let failure):
                self.showAlert(title: failure.rawValue, message: nil)
            }
        }

    }
    
    @objc
    private func signUpButtonPressed() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    let a = PublishSubject<String>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        idTextField.text = nil
        pwTextField.text = nil
    }
    
    func bind() {
        a
            .bind(to: idTextField.rx.text, pwTextField.rx.text)
            .disposed(by: disposeBag)
    }
    
    override func configure() {
        [imageView, idTextField, pwTextField, loginButton, signUpButton].forEach { subView in
            view.addSubview(subView)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(120)
        }
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(UIScreen.main.bounds.size.height / 3)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.height.equalTo(40)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
            make.height.equalTo(40)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(50)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
}
