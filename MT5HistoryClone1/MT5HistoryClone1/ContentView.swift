import SwiftUI

// ۱. ساختار داده
struct Trade: Identifiable {
    let id = UUID()
    let symbol: String
    let type: String
    let volume: Double
    let openPrice: Double
    let closePrice: Double
    let time: String
    let profit: Double
}

// ۲. نمای اصلی
struct ContentView: View {
    @State private var selectedTab = 4
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Quotes")
                .tabItem { Label("Quotes", systemImage: "arrow.up.arrow.down") }
                .tag(1)
            
            Text("Chart")
                .tabItem { Label("Chart", systemImage: "chart.bar.xaxis") }
                .tag(2)
            
            Text("Trade")
                .tabItem { Label("Trade", systemImage: "arrow.up.right") }
                .tag(3)
            
            HistoryView()
                .tabItem { Label("History", systemImage: "clock.fill") }
                .tag(4)
            
            Text("Settings")
                .tabItem { Label("Settings", systemImage: "gearshape") }
                .tag(5)
        }
        // اجبار به استفاده از استایل کلاسیک نوار پایین (رفع مشکل دایره مشکی)
        .tabViewStyle(.automatic)
    }
}

// ۳. نمای صفحه تاریخچه
struct HistoryView: View {
    let trades = [
        Trade(symbol: "XAUUSD", type: "Buy", volume: 0.50, openPrice: 2015.40, closePrice: 2020.10, time: "2024.02.24 10:23", profit: 235.00),
        Trade(symbol: "EURUSD", type: "Sell", volume: 1.00, openPrice: 1.0850, closePrice: 1.0865, time: "2024.02.24 09:15", profit: -150.00),
        Trade(symbol: "GBPUSD", type: "Buy", volume: 0.25, openPrice: 1.2640, closePrice: 1.2680, time: "2024.02.24 08:30", profit: 100.00),
        Trade(symbol: "XAUUSD", type: "Sell", volume: 0.10, openPrice: 2025.00, closePrice: 2026.50, time: "2024.02.23 18:45", profit: -15.00),
        Trade(symbol: "USDJPY", type: "Buy", volume: 2.00, openPrice: 150.20, closePrice: 150.45, time: "2024.02.23 14:20", profit: 332.80),
        Trade(symbol: "BTCUSD", type: "Sell", volume: 0.05, openPrice: 51200.00, closePrice: 50800.00, time: "2024.02.23 11:10", profit: 20.00),
        Trade(symbol: "US30", type: "Buy", volume: 1.50, openPrice: 38900.0, closePrice: 38950.0, time: "2024.02.23 09:05", profit: 75.00),
        Trade(symbol: "XAUUSD", type: "Buy", volume: 1.00, openPrice: 2010.00, closePrice: 2018.50, time: "2024.02.22 16:30", profit: 850.00),
        Trade(symbol: "EURGBP", type: "Sell", volume: 0.50, openPrice: 0.8540, closePrice: 0.8540, time: "2024.02.22 10:15", profit: 0.00),
        Trade(symbol: "XAGUSD", type: "Buy", volume: 0.10, openPrice: 22.50, closePrice: 22.10, time: "2024.02.22 08:00", profit: -40.00)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(spacing: 12) {
                        SummaryRow(title: "Profit:", value: "1,407.80", color: .blue)
                        SummaryRow(title: "Deposit:", value: "10,000.00")
                        SummaryRow(title: "Balance:", value: "11,407.80")
                    }
                    .padding()
                    
                    Divider().padding(.bottom, 8)
                    
                    ForEach(trades) { trade in
                        TradeRowView(trade: trade)
                        Divider().padding(.leading, 16)
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack(spacing: 16) {
                        Button(action: {}) { Image(systemName: "arrow.up.arrow.down").font(.system(size: 16, weight: .semibold)) }
                        Button(action: {}) { Image(systemName: "calendar").font(.system(size: 16, weight: .semibold)) }
                    }
                }
            }
            // کدهای جدید برای اجبار نمایش افکت شیشه‌ای
            .toolbarBackground(.visible, for: .navigationBar, .tabBar)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar, .tabBar)
        }
    }
}

// ۴. خلاصه حساب
struct SummaryRow: View {
    let title: String
    let value: String
    var color: Color = .primary

    var body: some View {
        HStack {
            Text(title).foregroundColor(.gray)
            Spacer()
            Text(value).bold().foregroundColor(color)
        }
        .font(.system(size: 15))
    }
}

// ۵. ردیف معامله
struct TradeRowView: View {
    let trade: Trade
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(trade.symbol).font(.system(size: 16, weight: .bold))
                HStack(spacing: 4) {
                    Text(trade.type).foregroundColor(trade.type == "Buy" ? .blue : .red)
                    Text(String(format: "%.2f", trade.volume))
                    Text("at \(String(format: "%g", trade.openPrice)) \u{2192} \(String(format: "%g", trade.closePrice))")
                        .foregroundColor(.gray)
                }
                .font(.system(size: 13))
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 6) {
                Text(trade.time).font(.system(size: 12)).foregroundColor(.gray)
                Text(trade.profit > 0 ? String(format: "%.2f", trade.profit) : String(format: "%.2f", trade.profit))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(trade.profit > 0 ? .blue : (trade.profit < 0 ? .red : .primary))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
}
