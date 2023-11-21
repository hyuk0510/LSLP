//
//  SignUpTextField.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/18.
//

import UIKit

class SignUpTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.clearButtonMode = .whileEditing
        self.autocapitalizationType = .none
        self.delegate = self
        self.autocorrectionType = .no
    }
    
    func insertImage(image: UIImage) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        imageView.image = image
        imageView.tintColor = .black
        let imageContainerView = UIView(frame: CGRect(x: 20, y: 0, width: 40, height: 30))
        imageContainerView.addSubview(imageView)
        leftView = imageContainerView
        leftViewMode = .always
    }
}

extension SignUpTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
