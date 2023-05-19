//
//  Common.swift
//  SwipeTracker
//
//  Created by Praveen Pinjala on 5/13/23.
//

import Foundation

func getCurrentTimestamp() -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timestampString = dateFormatter.string(from: currentDate)
    return timestampString
}
