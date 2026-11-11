//
//  ChartView.swift
//  Stonx
//
//  Created by Lucas Schretzenmayr on 11/11/26.
//

import Charts
import SwiftUI
import HealthKit

struct ChartView: View {
    let samples: [HKQuantitySample]
    let unit: HKUnit
    
    private var yDomain: ClosedRange<Double> {
        let vo2MaxValues = samples.map {
            $0.quantity.doubleValue(for: unit)
        }
        let lowerBound = (vo2MaxValues.min() ?? 5) - 5
        let upperBound = (vo2MaxValues.max() ?? 65) + 5
        return lowerBound...upperBound
    }
    
    struct LeftClipShape: Shape {
        func path(in rect: CGRect) -> Path {
            Path(
                CGRect(
                    x: rect.minX,
                    y: rect.minY - 1000,
                    width: rect.width + 1000,
                    height: rect.height + 2000
                )
            )
        }
    }
    
    let healthManager = HealthManager.shared
    
    private var chart: some View {
        Chart(samples, id: \.endDate) { sample in
            LineMark(
                x: .value("date", sample.endDate),
                y: .value("value", sample.quantity.doubleValue(for: unit))
                
            )
            .interpolationMethod(.linear)
        }
        .chartLegend(.hidden)
        .chartXAxis {
            AxisMarks(position: .top    ) {
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks {
                AxisValueLabel()
            }
        }
        .chartYScale(domain: yDomain)
    }
    
    var body: some View {
        chart
        .overlay() {
            chart
                .background(Color(uiColor: .systemBackground))
                .blur(radius: 5)
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: .black, location: -0.2),
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.1),
                            .init(color: .white, location: 0.2),
                            .init(color: .clear, location: 0.75)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                }
                .allowsHitTesting(false)
        }
        .overlay {
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0),
                        .init(color: .black.opacity(0.75), location: 0.1),
                        .init(color: .black.opacity(0.35), location: 0.2),
                        .init(color: .clear, location: 0.4)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .allowsHitTesting(false)
            }
        .overlay(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("VO2 Max")
                    .fontWeight(.semibold)
                    .font(.headline)
                }
            .padding(.leading, 16)
        }
        .compositingGroup()
        .clipShape(LeftClipShape())
    
        
        .task {
            await healthManager.fetchVo2Max()
        }
    }
}

//#Preview {
//    ChartView()
//}
