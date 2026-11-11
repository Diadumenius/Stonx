//
//  ContentView.swift
//  Stonx
//
//  Created by Lucas Schretzenmayr on 11/4/26.
//

import Charts
import HealthKit
import HealthKitUI
import SwiftUI


struct ContentView: View {

    @ObservedObject private var healthManager = HealthManager.shared
    
    var testSamples: [HKQuantitySample] = [
        HKQuantitySample(type: HKQuantityType(.vo2Max), quantity: HKQuantity(unit: HealthManager.vo2maxUnit, doubleValue: 60.23), start: Date(), end: Date()),
        HKQuantitySample(type: HKQuantityType(.vo2Max), quantity: HKQuantity(unit: HealthManager.vo2maxUnit, doubleValue: 60.23), start: Date(), end: Date().addingTimeInterval(1000))
    ]
    
    var body: some View {
        NavigationStack {
            List {
                ChartView(samples: healthManager.vo2maxSamples, unit: HealthManager.vo2maxUnit)
                ChartView(samples: healthManager.vo2maxSamples, unit: HealthManager.vo2maxUnit)
            }
            .listStyle(.plain)
            .navigationTitle("Stonx")
            .listRowInsets(
                EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            )
        }
    }
}

#Preview {
    ContentView()
}
