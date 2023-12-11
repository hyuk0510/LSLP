//
//  SignUpViewController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/16.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    private lazy var idCheckButton = {
        let view = UIButton()
        var configure = UIButton.Configuration.filled()
        configure.title = "중복 확인"
        configure.cornerStyle = .capsule
        configure.baseBackgroundColor = .lightGray
        view.configuration = configure
        view.addTarget(self, action: #selector(idCheckButtonPressed), for: .touchUpInside)
        return view
    }()
    
    @objc
    private func idCheckButtonPressed() {
        //이메일 유효 통신
        AccountManager.shared.isValidEmail(email: idTextField.text ?? "") { result in
            switch result {
            case .success(let success):
                self.showAlert(title: success, message: nil)
            case .failure(let failure):
                self.showAlert(title: failure.rawValue, message: nil)
            }
        }
    }
    
    private lazy var idTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "person.fill")!)
        view.rightView = self.idCheckButton
        view.rightViewMode = .always
        view.placeholder = "아이디"
        return view
    }()

    private lazy var pwSecureButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        view.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        view.tintColor = .lightGray
        view.addTarget(self, action: #selector(pwSecureButtonPressed), for: .touchUpInside)
        return view
    }()
    
    @objc
    private func pwSecureButtonPressed() {
        pwSecureButton.isSelected.toggle()
        pwTextField.isSecureTextEntry.toggle()
    }
    
    private lazy var pwTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "lock.fill")!)
        view.placeholder = "비밀번호"
        view.rightView = self.pwSecureButton
        view.rightViewMode = .always
        view.isSecureTextEntry = true
        return view
    }()
    
    private lazy var pwCheckSecureButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        view.setImage(UIImage(systemName: "eye.slash.fill"), for: .selected)
        view.tintColor = .lightGray
        view.addTarget(self, action: #selector(pwCheckSecureButtonPressed), for: .touchUpInside)
        return view
    }()
    
    @objc
    private func pwCheckSecureButtonPressed() {
        pwCheckSecureButton.isSelected.toggle()
        pwCheckTextField.isSecureTextEntry.toggle()
    }
    
    private lazy var pwCheckTextField = {
        let view = SignUpTextField()
        view.insertImage(image: UIImage(systemName: "checkmark")!)
        view.placeholder = "비밀번호 확인"
        view.rightView = self.pwCheckSecureButton
        view.rightViewMode = .always
        view.isSecureTextEntry = true
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
    
    private let birthDayTextField = {
        let view = DateTextField()
        view.insertImage(image: UIImage(systemName: "calendar")!)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonPressed))
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        self.title = "회원가입"
        bind()
    }
    
    @objc
    private func backButtonPressed() {
        if isAnyInput.value {
            print("input")
            let alert = UIAlertController(title: "회원가입을 그만두시겠습니까?", message: "입력된 값들은 사라집니다.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(ok)
            self.present(alert, animated: true)
        } else {
            print("noinput")
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    var userID = PublishRelay<String>()
    var userPW = PublishRelay<String>()
    var userPWCheck = PublishRelay<String>()
    var userNick = PublishRelay<String>()
    var userPhoneNum = PublishRelay<String>()
    var userBirth = PublishRelay<String>()
    
    var isAnyInput = BehaviorRelay(value: false)
    var dataCheck = BehaviorRelay(value: false)
    var pwCheck = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()
    
    private func bind() {
        
        let validation = Observable.combineLatest(idTextField.rx.text.orEmpty, pwTextField.rx.text.orEmpty, pwCheckTextField.rx.text.orEmpty, nickTextField.rx.text.orEmpty) {
            return !($0.isEmpty || $1.isEmpty || $2.isEmpty || $3.isEmpty)
        }
        
        let pwValidation = Observable.combineLatest(pwTextField.rx.text.orEmpty, pwCheckTextField.rx.text.orEmpty) { pw, pwCheck in
            return pw == pwCheck
        }
        
        let anyInput = Observable.combineLatest(idTextField.rx.text.orEmpty, pwTextField.rx.text.orEmpty, pwCheckTextField.rx.text.orEmpty, nickTextField.rx.text.orEmpty, birthDayTextField.rx.text.orEmpty) {
            return !($0.isEmpty && $1.isEmpty && $2.isEmpty && $3.isEmpty && $4.isEmpty)
        }
        
        validation
            .subscribe(with: self, onNext: { owner, value in
                owner.dataCheck.accept(value)
            })
            .disposed(by: disposeBag)
        
        pwValidation
            .subscribe(with: self, onNext: { owner, value in
                owner.pwCheck.accept(value)
            })
            .disposed(by: disposeBag)
        
        anyInput
            .bind(to: isAnyInput)
            .disposed(by: disposeBag)
        
        idTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.userID.accept(value)
            } onDisposed: { _ in
            }
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.userPW.accept(value)
            }
            .disposed(by: disposeBag)
        
        pwCheckTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.userPWCheck.accept(value)
            }
            .disposed(by: disposeBag)
        
        nickTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.userNick.accept(value)
            }
            .disposed(by: disposeBag)
        
        phoneNumTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.userPhoneNum.accept(value)
            }
            .disposed(by: disposeBag)
        
        birthDayTextField.rx.text.orEmpty
            .subscribe(with: self) { owner, value in
                owner.userBirth.accept(value)
            }
            .disposed(by: disposeBag)
        
        userID
            .bind(to: idTextField.rx.text)
            .disposed(by: disposeBag)
        
        userPW
            .bind(to: pwTextField.rx.text)
            .disposed(by: disposeBag)
        
        userPWCheck
            .bind(to: pwCheckTextField.rx.text)
            .disposed(by: disposeBag)
        
        userNick
            .bind(to: nickTextField.rx.text)
            .disposed(by: disposeBag)
        
        userPhoneNum
            .bind(to: phoneNumTextField.rx.text)
            .disposed(by: disposeBag)
        
        userBirth
            .bind(to: birthDayTextField.rx.text)
            .disposed(by: disposeBag)


        signUpButton.rx.tap
            .subscribe(with: self) { owner, value in
                owner.checkValidation()
                owner.pwCheck.value ? (owner.dataCheck.value ? owner.signUp() : owner.showAlert(title: "필수 입력 정보가 누락되어있습니다.", message: nil)) : owner.showAlert(title: "비밀번호와 비밀번호 확인 입력이 일치하지 않습니다.", message: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func checkValidation() {
        
        idTextField.rx.text.orEmpty
            .map { $0.count > 0 }
            .subscribe(with: self) { owner, value in
                let borderColor = value ? UIColor.black.cgColor : UIColor.red.cgColor
                
                owner.idTextField.layer.borderColor = borderColor
            }
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .map { $0.count > 0 }
            .subscribe(with: self) { owner, value in
                let borderColor = value ? UIColor.black.cgColor : UIColor.red.cgColor
                
                owner.pwTextField.layer.borderColor = borderColor
            }
            .disposed(by: disposeBag)
        
        pwCheckTextField.rx.text.orEmpty
            .map { $0.count > 0 }
            .subscribe(with: self) { owner, value in
                let borderColor = value ? UIColor.black.cgColor : UIColor.red.cgColor
                
                owner.pwCheckTextField.layer.borderColor = borderColor
            }
            .disposed(by: disposeBag)
        
        nickTextField.rx.text.orEmpty
            .map { $0.count > 0 }
            .subscribe(with: self) { owner, value in
                let borderColor = value ? UIColor.black.cgColor : UIColor.red.cgColor
                
                owner.nickTextField.layer.borderColor = borderColor
            }
            .disposed(by: disposeBag)
    }
    
    private func signUp() {
        AccountManager.shared.signUp(email: idTextField.text ?? "", password: pwTextField.text ?? "", nick: nickTextField.text ?? "", phoneNum: phoneNumTextField.text ?? "", birthDay: birthDayTextField.text ?? "") { response in
            switch response {
            case .success(_):
                self.finishSignUp()
                
            case .failure(let failure):
                self.showAlert(title: failure.rawValue, message: nil)
            }
        }
    }
    
    private func finishSignUp() {
        let alert = UIAlertController(title: "회원가입이 완료되었습니다.", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    override func configure() {
        [idTextField, pwTextField, pwCheckTextField, nickTextField, phoneNumTextField, birthDayTextField, signUpButton].forEach { subView in
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
        pwCheckTextField.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(idTextField.snp.horizontalEdges)
            make.height.equalTo(50)
        }
        nickTextField.snp.makeConstraints { make in
            make.top.equalTo(pwCheckTextField.snp.bottom).offset(10)
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
