//
//  ArgumentArranger.swift
//  Movietopia
//
//  Created by Bora Özel on 29/8/25.
//

import Foundation

protocol ArgumentArrangerProtocol {
    func formatYear(from dateString: String) -> String
    func getFormatteddVote(vote: Double) -> String
}

class ArgumentArranger: ArgumentArrangerProtocol {
    func formatYear(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        guard let date = inputFormatter.date(from: dateString) else {
            return "-"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy"
        return outputFormatter.string(from: date)
    }

    func getFormatteddVote(vote: Double) -> String {
        let truncatedVote = floor(vote * 100) / 100
        let formattedVote = String(format: "%.1f", truncatedVote)
        return formattedVote
    }
}
