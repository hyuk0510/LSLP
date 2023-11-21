//
//  DateTextField.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/18.
//

import UIKit

final class DateTextField: UITextField {
    
    private lazy var birthDayDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko-KR")
        return view
    }()
    
    private lazy var toolBar = {
        let view = UIToolbar()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let ok = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(okButtonPressed))
        
        view.items = [space, ok]
        view.sizeToFit()
        
        return view
    }()
    
    @objc
    private func okButtonPressed() {
        self.text = birthDayDatePicker.date.dateFormat()
        self.resignFirstResponder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        self.inputView = birthDayDatePicker
        self.placeholder = "생일(선택)"
        self.inputAccessoryView = toolBar
        self.delegate = self
        self.tintColor = .clear
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10
        self.clearButtonMode = .whileEditing
        self.autocapitalizationType = .none
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

extension DateTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
