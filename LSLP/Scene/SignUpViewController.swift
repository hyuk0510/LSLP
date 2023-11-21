//
//  SignUpViewController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: BaseViewController {
    
    private let idTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "person.fill")!)
        view.placeholder = "아이디"
        return view
    }()
    
    private let pwTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "lock.fill")!)
        view.placeholder = "비밀번호"
        return view
    }()
    
    private let nickTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "pencil")!)
        view.placeholder = "닉네임"
        return view
    }()
    
    private let phoneNumTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "phone.fill")!)
        view.placeholder = "전화번호(선택)"
        return view
    }()
    
    private let signUpButton = {
        let view = UIButton()
        var configure = UIButton.Configuration.filled()
        configure.title = "가입하기"
        configure.baseBackgroundColor = .systemIndigo
        configure.baseForegroundColor = .white
        view.configuration = configure
        return view
    }()
    
    private let birthDayTextField = {
        let view = DateTextField()
        view.insertImage(image: UIImage(systemName: "calendar")!)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "회원가입"
        bind()
    }
    
    func bind() {
        
    }
    
    override func configure() {
        [idTextField, pwTextField, nickTextField, phoneNumTextField, birthDayTextField, signUpButton].forEach { subView in
            view.addSubview(subView)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(50)
        }
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
            make.height.equalTo(50)
        }
        nickTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
            make.height.equalTo(50)
        }
        phoneNumTextField.snp.makeConstraints { make in
            make.top.equalTo(nickTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
            make.height.equalTo(50)
        }
        birthDayTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneNumTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
            make.height.equalTo(50)
        }
        signUpButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(100)
        }
    }
}
