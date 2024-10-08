import SwiftUI

class AppUsageStore: ObservableObject {
    static let shared = AppUsageStore()
    
    @Published var usageData: [String: AppUsage] = [:]
    
    private init() {
        // Uncomment this line for testing with sample data
        // addSampleData()
    }
    
    func logAppOpened(appName: String, time: Double) {
        if usageData[appName] == nil {
            usageData[appName] = AppUsage(name: appName)
        }
        usageData[appName]?.lastOpenTime = time
    }
    
    func logAppClosed(appName: String, time: Double) {
        guard var usage = usageData[appName], let openTime = usage.lastOpenTime else {
            return
        }
        
        let sessionDuration = time - openTime
        usage.totalUsageTime += sessionDuration
        usage.sessionCount += 1
        usage.lastOpenTime = nil
        usageData[appName] = usage
        
        // Here you would save data to persistent storage
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
