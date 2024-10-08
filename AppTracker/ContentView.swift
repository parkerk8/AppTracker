import SwiftUI

struct ContentView: View {
    @ObservedObject var store = AppUsageStore.shared
    
    var body: some View {
        NavigationView {
            List(store.usageData.values.sorted(by: { $0.totalUsageTime > $1.totalUsageTime }), id: \.name) { usage in
                VStack(alignment: .leading) {
                    Text(usage.name)
                        .font(.headline)
                    Text("Total usage: \(formatTime(usage.totalUsageTime))")
                    Text("Sessions: \(usage.sessionCount)")
                    Text("Avg session: \(formatTime(usage.averageSessionDuration))")
                }
            }
            .navigationTitle("App Usage")
        }
    }
    
    private func formatTime(_ seconds: Double) -> String {
        let hours = Int(seconds) / 3600
        let minutes = (Int(seconds) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
