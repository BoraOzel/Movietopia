//
//  Double+Extension.swift
//  Movietopia
//
//  Created by Bora Özel on 2/9/25.
//

import Foundation

extension Double {
    func toFormattedVote() -> String {
        let truncatedVote = floor(self * 100) / 100
        let formattedVote = String(format: "%.1f", truncatedVote)
        return formattedVote
    }
}
