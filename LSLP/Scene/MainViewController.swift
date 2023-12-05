//
//  MainViewController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/12/03.
//

import UIKit

final class MainViewController: BaseViewController {
    
    let label = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        label.text = "\(Token.token)\n\(Token.refreshToken)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        AccountManager.shared.refreshToken { response in
            
            let alert = UIAlertController(title: "로그인 세션이 만료되었습니다.", message: "다시 로그인 해주세요", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel) { _ in
                self.dismiss(animated: true)
            }
            
            alert.addAction(ok)
            
            self.present(alert, animated: true)
        }
    }
    
    override func configure() {
        [label].forEach { subView in
            view.addSubview(subView)
        }
        
        label.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
