//
//  UserProfileViewController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/12/03.
//

import UIKit

final class UserProfileViewController: BaseViewController {
    
    private let UserImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "heart")
        view.contentMode = .scaleAspectFit
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .orange
    }
    
    override func configure() {
        [UserImageView].forEach { subView in
            view.addSubview(subView)
        }
        
        UserImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.size.equalTo(100)
        }
    }
}
