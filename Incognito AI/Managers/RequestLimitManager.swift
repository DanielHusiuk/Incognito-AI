//
//  RequestLimitManager.swift
//  Incognito AI
//
//  Created by Daniel Husiuk on 15.01.2026.
//

import UIKit

final class RequestLimitManager {
    
    static let shared = RequestLimitManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private var calendar: Calendar { .current }
    
    private var currentModel: String {
        defaults.string(forKey: "buttonModel") ?? "unknown"
    }
    
    private var dailyLimit: Int {
        defaults.integer(forKey: "buttonRequestsPerDay")
    }
    
    private func todayKey() -> String {
        let day = calendar.startOfDay(for: Date()).timeIntervalSince1970
        return "requests_\(currentModel)_\(Int(day))"
    }
    
    
    func requestsToday() -> Int {
        defaults.integer(forKey: todayKey())
    }
    
    func registerRequest() {
         let key = todayKey()
         defaults.set(requestsToday() + 1, forKey: key)
     }
    
    func remainingRequestsToday() -> Int {
        max(0, dailyLimit - requestsToday())
    }
    
    func canSendRequest() -> Bool {
        requestsToday() < dailyLimit
    }
    
}
