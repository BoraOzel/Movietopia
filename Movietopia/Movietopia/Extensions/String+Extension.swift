//
//  String+Extension.swift
//  Movietopia
//
//  Created by Bora Özel on 2/9/25.
//

import Foundation

extension String {
    func toFormattedYear() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: self) else {
            return "-"
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy"
        return outputFormatter.string(from: date)
    }
}

