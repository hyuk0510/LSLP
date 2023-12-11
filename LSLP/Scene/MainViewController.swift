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
        label.text = "\(UserDefaults.standard.string(forKey: "Token"))\n\(UserDefaults.standard.string(forKey: "RefreshToken"))"
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
