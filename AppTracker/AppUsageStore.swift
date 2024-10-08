import SwiftUI

class AppUsageStore: ObservableObject {
    static let shared = AppUsageStore()
    
    @Published var usageData: [String: AppUsage] = [:]
    
    private init() {
        print("AppUsageStore initialized")
        // addSampleData()
    }
    
    func logAppOpened(appName: String, time: Double) {
        print("AppUsageStore - logAppOpened called for \(appName) at \(time)")
        if usageData[appName] == nil {
            print("Creating new AppUsage for \(appName)")
            usageData[appName] = AppUsage(name: appName)
        }
        usageData[appName]?.lastOpenTime = time
        print("Current usage data: \(usageData)")
    }
    
    func logAppClosed(appName: String, time: Double) {
        print("AppUsageStore - logAppClosed called for \(appName) at \(time)")
        guard var usage = usageData[appName], let openTime = usage.lastOpenTime else {
            print("Failed to find usage data for \(appName) or no open time recorded")
            return
        }
        
        let sessionDuration = time - openTime
        usage.totalUsageTime += sessionDuration
        usage.sessionCount += 1
        usage.lastOpenTime = nil
        usageData[appName] = usage
        print("Updated usage data for \(appName): \(usage)")
        
    }
    
    func addSampleData() {
        let apps = ["Facebook", "Instagram", "Twitter"]
        for app in apps {
            usageData[app] = AppUsage(name: app, totalUsageTime: Double.random(in: 600...3600), sessionCount: Int.random(in: 5...20))
        }
    }
}

struct AppUsage {
    let name: String
    var totalUsageTime: Double = 0
    var sessionCount: Int = 0
    var lastOpenTime: Double?
    
    var averageSessionDuration: Double {
        return sessionCount > 0 ? totalUsageTime / Double(sessionCount) : 0
    }
}
