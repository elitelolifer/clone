import SwiftUI

// MARK: - 1. Entry Point
@main
struct MT5SimulatorApp: App {
    var body: some Scene {
        WindowGroup {
            MT5UltimateView()
        }
    }
}

// MARK: - 2. Data Models
struct TradeItem: Identifiable {
    let id = UUID()
    let symbol: String
    let type: TradeType
    let volume: String
    let openPrice: String
    let closePrice: String
    let time: String
    let profit: Double
    
    var formattedProfit: String {
        return profit > 0 ? "+\(String(format: "%.2f", profit))" : String(format: "%.2f", profit)
    }
}

enum TradeType {
    case buy, sell
    
    var color: Color {
        switch self {
        case .buy: return .blue
        case .sell: return .red
        }
    }
    
    var title: String {
        switch self {
        case .buy: return "buy"
        case .sell: return "sell"
        }
    }
}

// MARK: - 3. Main View
struct MT5UltimateView: View {
    // داده‌های نمونه (شامل موارد منفی برای تست نوار قرمز)
    let trades = [
        TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5193.93", closePrice: "5191.63", time: "2026.02.25 17:01:01", profit: 230.00),
                TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5194.18", closePrice: "5191.63", time: "2026.02.25 17:01:04", profit: 255.00),
                TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5194.44", closePrice: "5191.44", time: "2026.02.25 17:01:07", profit: 300.00),
                TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5194.46", closePrice: "5199.56", time: "2026.02.25 17:04:27", profit: -510.00),
                TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5177.90", closePrice: "5177.68", time: "2026.02.26 10:28:12", profit: -22.00),
                TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5178.37", closePrice: "5177.72", time: "2026.02.26 10:28:14", profit: -65.00),
                TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5177.10", closePrice: "5177.44", time: "2026.02.26 10:28:44", profit: 34.00),
                TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5177.65", closePrice: "5172.34", time: "2026.02.26 10:34:00", profit: -531.00),
                TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5185.01", closePrice: "5184.27", time: "2026.02.26 11:49:11", profit: 74.00),
                
        TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5193.86", closePrice: "5191.32", time: "2026.02.25 17:00:56", profit: 254.00),
        TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5193.93", closePrice: "5191.63", time: "2026.02.25 17:01:01", profit: 230.00),
        TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5194.46", closePrice: "5199.56", time: "2026.02.25 17:04:27", profit: -510.00), // ضررده (نوار قرمز باید باشد)
        TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5177.90", closePrice: "5177.68", time: "2026.02.26 10:28:12", profit: -22.00), // ضررده
        TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5178.37", closePrice: "5177.72", time: "2026.02.26 10:28:14", profit: -65.00), // ضررده
        TradeItem(symbol: "XAUUSD", type: .buy, volume: "1", openPrice: "5177.10", closePrice: "5177.44", time: "2026.02.26 10:28:44", profit: 34.00),
        TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5185.01", closePrice: "5184.27", time: "2026.02.26 11:49:11", profit: 74.00),
        TradeItem(symbol: "XAUUSD", type: .sell, volume: "1", openPrice: "5185.16", closePrice: "5190.18", time: "2026.02.26 12:06:02", profit: -502.00) // ضررده
    ]
    
    @State private var selectedSegment = "Positions"
    
    var body: some View {
        ZStack {
            // LAYER 1: Background Content (Scrollable)
            ScrollView {
                LazyVStack(spacing: 0) {
                    Color.clear
                        .frame(height: 110) // فضای خالی برای هدر
                    
                    ForEach(trades) { trade in
                        MT5TradeRow(trade: trade)
                        Divider()
                            .padding(.leading, 16)
                    }
                    
                    Color.clear
                        .frame(height: 100) // فضای خالی برای فوتر
                }
            }
            .ignoresSafeArea(.all)
            
            // LAYER 2: Top Floating Bar
            VStack {
                GlassTopBar(selectedSegment: $selectedSegment)
                    .padding(.top, 60)
                Spacer()
            }
            .ignoresSafeArea()
            
            // LAYER 3: Bottom Floating Bar
            VStack {
                Spacer()
                GlassTabBar()
                    .padding(.bottom, 30)
            }
            .ignoresSafeArea()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

// MARK: - 4. Components

struct MT5TradeRow: View {
    let trade: TradeItem
    
    var body: some View {
        HStack(spacing: 0) { // spacing 0 بسیار مهم است
            
            // --- نوار قرمز (Red Bar) ---
            // این نوار دقیقا در ابتدای HStack قرار دارد
            Rectangle()
                .fill(trade.profit < 0 ? Color.red : Color.clear)
                .frame(width: 4) // عرض نوار
                .frame(maxHeight: .infinity) // پر کردن ارتفاع کل سطر
                .padding(.vertical, 4) // کمی فاصله از بالا و پایین (طبق رفرنس)
            
            // --- محتوای اصلی سطر ---
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 6) {
                    // Row 1: Symbol & Type
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(trade.symbol)
                            .font(.system(size: 17, weight: .bold))
                        
                        Text(trade.type.title)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(trade.type.color)
                        
                        Text(trade.volume)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(trade.type.color)
                    }
                    
                    // Row 2: Prices
                    HStack(spacing: 4) {
                        Text(trade.openPrice)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10))
                        Text(trade.closePrice)
                    }
                    .font(.system(size: 13))
                    .foregroundStyle(Color.secondary)
                }
                .padding(.leading, 8) // فاصله متن از نوار قرمز
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    // Profit
                    Text(trade.formattedProfit)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(trade.profit >= 0 ? .blue : .red)
                    
                    // Time
                    Text(trade.time)
                        .font(.system(size: 12))
                        .foregroundStyle(Color(uiColor: .systemGray2))
                }
                .padding(.trailing, 16)
            }
        }
        .padding(.vertical, 8)
        .background(Color(uiColor: .systemBackground))
        // اینجا در کد رفرنس شما یک فراخوانی .glassEffect وجود داشت،
        // اما چون می‌خواهیم شبیه کد اول بماند و روی کل لیست نباشد، اینجا چیزی اضافه نمی‌کنیم.
    }
}

// MARK: - 5. Liquid Glass Navigation Bars

// نوار بالای شناور (اصلاح شده با آیکون‌های درخواستی)
struct GlassTopBar: View {
    @Binding var selectedSegment: String
    let segments = ["Positions", "Orders", "Deals"]
    
    var body: some View {
        HStack(spacing: 0) {
            
            // آیکون سمت چپ (طبق رفرنس شما)
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 16, weight: .semibold))
                .padding(.leading, 20)
                .foregroundStyle(Color.primary)
            
            Spacer()
            
            // دکمه‌های وسط (سگمنت‌ها)
            HStack(spacing: 0) {
                ForEach(segments, id: \.self) { segment in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedSegment = segment
                        }
                    } label: {
                        Text(segment)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selectedSegment == segment ? Color.primary : Color.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(selectedSegment == segment ? Color.primary.opacity(0.1) : Color.clear)
                            )
                    }
                }
            }
            .padding(4)
            // حذف کردیم بک‌گراند خاکستری داخلی را تا شیشه بیرونی دیده شود
            
            Spacer()
            
            // آیکون سمت راست (طبق رفرنس شما: ساعت)
            Image(systemName: "clock")
                .font(.system(size: 18, weight: .semibold))
                .padding(.trailing, 20)
                .foregroundStyle(Color.primary)
        }
        .frame(height: 50)
        .padding(.horizontal, 6)
        
        // --- نقطه کلیدی ---
        // استفاده از دستور glassEffect بدون تعریف آن (برای شبیه شدن به کد اول)
        .glassEffect()
        
        .padding(.horizontal, 16)
    }
}

// نوار پایین شناور (بدون تغییر)
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
                    VStack(spacing: 3) {
                        Image(systemName: icons[index])
                            .font(.system(size: 20))
                            .symbolRenderingMode(.hierarchical)
                        
                        Text(tabs[index])
                            .font(.system(size: 9, weight: .medium))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(selectedTab == tabs[index] ? Color.blue : Color.secondary)
                    .padding(.vertical, 8)
                }
            }
        }
        .padding(.horizontal, 10)
        
        // استفاده از دستور glassEffect بدون تعریف آن
        .glassEffect()
        
        .padding(.horizontal, 20)
    }
}

// نکته: هیچ اکستنشنی برای تعریف glassEffect در این فایل وجود ندارد.
// این کد با ارور "Value of type ... has no member 'glassEffect'" مواجه می‌شود.

// #Preview {
//     MT5UltimateView()
// }
