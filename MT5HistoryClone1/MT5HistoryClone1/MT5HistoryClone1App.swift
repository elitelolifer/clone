import SwiftUI

// MARK: - 1. نقطه شروع برنامه
@main
struct MT5HistoryClone1App: App {
    var body: some Scene {
        WindowGroup {
            MT5MasterView()
        }
    }
}

// MARK: - 2. مدل داده‌ها
struct CleanTradeItem: Identifiable {
    let id = UUID()
    let symbol: String
    let type: String
    let volume: Double
    let time: String
    let profit: Double
    let openPrice: Double
    let closePrice: Double
}

// MARK: - 3. نمای اصلی (ریشه برنامه)
struct MT5MasterView: View {
    // لیست ۱۰ معامله متنوع
    let trades = [
        CleanTradeItem(symbol: "XAUUSD", type: "Buy", volume: 0.50, time: "2026.02.26 10:23", profit: 235.00, openPrice: 2015.40, closePrice: 2020.10),
        CleanTradeItem(symbol: "EURUSD", type: "Sell", volume: 1.00, time: "2026.02.26 09:15", profit: 150.00, openPrice: 1.0865, closePrice: 1.0850),
        CleanTradeItem(symbol: "GBPUSD", type: "Buy", volume: 0.20, time: "2026.02.26 08:30", profit: -40.00, openPrice: 1.2600, closePrice: 1.2580),
        CleanTradeItem(symbol: "US30", type: "Sell", volume: 2.00, time: "Yesterday", profit: 100.00, openPrice: 38900.0, closePrice: 38850.0),
        CleanTradeItem(symbol: "BTCUSD", type: "Buy", volume: 0.05, time: "2026.02.24", profit: 750.00, openPrice: 62000.0, closePrice: 63500.0),
        CleanTradeItem(symbol: "USDJPY", type: "Sell", volume: 1.50, time: "2026.02.25 15:30", profit: 320.40, openPrice: 150.50, closePrice: 150.20),
        CleanTradeItem(symbol: "NAS100", type: "Buy", volume: 0.10, time: "2026.02.25 14:00", profit: -120.00, openPrice: 17950.0, closePrice: 17930.0),
        CleanTradeItem(symbol: "ETHUSD", type: "Buy", volume: 2.00, time: "2026.02.24 20:15", profit: 450.00, openPrice: 3200.0, closePrice: 3250.0),
        CleanTradeItem(symbol: "USDCAD", type: "Sell", volume: 0.80, time: "2026.02.24 11:45", profit: -55.50, openPrice: 1.3550, closePrice: 1.3560),
        CleanTradeItem(symbol: "AUDUSD", type: "Buy", volume: 1.00, time: "2026.02.23 09:10", profit: 85.00, openPrice: 0.6540, closePrice: 0.6550)
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            
            // بخش الف: لیست اصلی
            NavigationStack {
                List {
                    // هدر
                    Section {
                        VStack(spacing: 8) {
                            HStack { Text("Profit").foregroundStyle(.secondary); Spacer(); Text("1,874.90").foregroundStyle(.blue).bold() }
                            HStack { Text("Deposit").foregroundStyle(.secondary); Spacer(); Text("10,000.00").bold() }
                            HStack { Text("Balance").foregroundStyle(.secondary); Spacer(); Text("11,874.90").bold() }
                        }
                        .font(.subheadline)
                        .padding(.vertical, 4)
                    }
                    
                    // لیست پوزیشن‌ها
                    Section(header: Text("Positions").font(.caption)) {
                        ForEach(trades) { trade in
                            CleanTradeRow(trade: trade)
                        }
                    }
                    
                    // فضای خالی برای اسکرول شدن آخرین آیتم به بالای نوار
                    Section {
                        Color.clear
                            .frame(height: 100)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("History")
                .ignoresSafeArea(edges: .bottom) // برای اینکه لیست زیر نوار برود
            }
            
            // بخش ب: نوار شناور با استفاده از API رسمی Liquid Glass
            GlassTabBar()
                .padding(.bottom, 20) // فاصله از پایین صفحه (حالت شناور)
        }
    }
}

// MARK: - 4. ردیف ترید
struct CleanTradeRow: View {
    let trade: CleanTradeItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .firstTextBaseline) {
                    Text(trade.symbol)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text(trade.type)
                        .font(.caption)
                        .foregroundStyle(trade.type == "Buy" ? Color.blue : Color.red)
                    
                    Text(String(format: "%.2f", trade.volume))
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                }
                
                Text(trade.time)
                    .font(.caption2)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(trade.profit > 0 ? "+\(String(format: "%.2f", trade.profit))" : "\(String(format: "%.2f", trade.profit))")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(trade.profit >= 0 ? Color.blue : Color.red)
                
                Text("\(trade.openPrice, specifier: "%.2f") → \(trade.closePrice, specifier: "%.2f")")
                    .font(.caption2)
                    .foregroundStyle(Color.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - 5. نوار نویگیشن با استفاده از .glassEffect()
struct GlassTabBar: View {
    @State private var selectedTab = "History"
    let tabs = ["Quotes", "Chart", "Trade", "History", "Settings"]
    let icons = ["arrow.up.down", "chart.xyaxis.line", "arrow.triangle.2.circlepath", "clock.fill", "gearshape"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button {
                    selectedTab = tabs[index]
                } label: {
                    VStack(spacing: 5) {
                        Image(systemName: icons[index])
                            .font(.system(size: 22))
                            // استفاده از حالت سلسله‌مراتبی برای زیبایی بیشتر روی شیشه
                            .symbolRenderingMode(.hierarchical)
                        
                        Text(tabs[index])
                            .font(.system(size: 10, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(selectedTab == tabs[index] ? Color.primary : Color.secondary)
                    .padding(.vertical, 12)
                }
            }
        }
        .padding(.horizontal, 10) // فاصله داخلی محتوا از لبه‌های شیشه
        
        // *** استفاده از API رسمی Liquid Glass ***
        // طبق مستندات اپل، این دستور به طور پیش‌فرض یک کپسول (Capsule)
        // در پشت ویو ایجاد می‌کند که افکت شیشه‌ای، تاری و بازتاب نور دارد.
        .glassEffect()
        
        // محدود کردن عرض نوار برای اینکه تمام عرض صفحه را نگیرد و شناور باشد
        .padding(.horizontal, 24)
    }
}

#Preview {
    MT5MasterView()
}
