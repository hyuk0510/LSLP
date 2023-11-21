//
//  SignInTextField.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/18.
//

import UIKit

final class SignInTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.textAlignment = .center
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = 10
        self.autocapitalizationType = .none
    }
}
