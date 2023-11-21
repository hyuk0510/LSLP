//
//  String+Extension.swift
//  LSLP
//
//  Created by 선상혁 on 2023/11/18.
//

import Foundation

extension Date {
    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: self)
    }
}
