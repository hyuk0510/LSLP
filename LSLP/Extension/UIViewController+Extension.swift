//
//  UIViewController+Extension.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/23.
//

import UIKit
import RxSwift

extension UIViewController {
    
    func showAlert(title: String, message: String?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true)
    }
    
    func pushToTabBarController() {
        let vc = TabBarController()
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushToSignInViewController() {
        let vc = SignInViewController()
        vc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
