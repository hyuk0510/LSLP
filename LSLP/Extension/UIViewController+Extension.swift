//
//  UIViewController+Extension.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/23.
//

import UIKit
import RxSwift

extension UIViewController {
    
//    func presentAlert(title: String?, message: String?) -> Observable<Void> {
//            let result = PublishSubject<Void>()
//            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//                result.onCompleted()
//            }
//            alert.addAction(cancel)
//            present(alert, animated: true)
//        
//            return result
//    }
    
    func showAlert(title: String, message: String?)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .cancel)
        
        alert.addAction(ok)
        
        self.present(alert, animated: true)
    }
}
