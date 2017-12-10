//
//  Date.swift
//  RottenPotatoesMobile
//
//  Created by Daniel Capacio on 2017-12-09.
//  Copyright © 2017 Daniel Capacio. All rights reserved.
//

import Foundation
import UIKit

func getToday() -> String {
    let today = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let strToday = dateFormatter.string(from: today)
    return strToday
}

func getLastMonth() -> String {
    let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let strLastMonth = dateFormatter.string(from: lastMonth!)
    return strLastMonth
}
