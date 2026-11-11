//
//  HealthManager.swift
//  Stonx
//
//  Created by Lucas Schretzenmayr on 11/8/26.
//

import Foundation
import HealthKit
internal import Combine

@MainActor
class HealthManager: ObservableObject {
    
    @Published var vo2maxSamples: [HKQuantitySample] = []
    
    
    static let vo2maxUnit = HKUnit.literUnit(with: .milli)
        .unitDivided(by: .gramUnit(with: .kilo))
        .unitDivided(by: .minute())
    
    private let allRead: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceCycling),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.estimatedWorkoutEffortScore),
        HKQuantityType(.heartRate),
        HKQuantityType(.workoutEffortScore),
        HKQuantityType(.cyclingFunctionalThresholdPower),
        HKQuantityType(.cyclingPower),
        HKQuantityType(.cyclingSpeed),
        HKQuantityType(.dietaryCaffeine),
        HKQuantityType(.bodyTemperature),
        HKQuantityType(.heartRateRecoveryOneMinute),
        HKQuantityType(.heartRateVariabilityRMSSD),
        HKQuantityType(.oxygenSaturation),
        HKQuantityType(.respiratoryRate),
        HKQuantityType(.runningGroundContactTime),
        HKQuantityType(.runningPower),
        HKQuantityType(.runningSpeed),
        HKQuantityType(.runningStrideLength),
        HKQuantityType(.stepCount),
        HKQuantityType(.vo2Max)
    ]
    
    private let allWrite: Set = [
        HKQuantityType(.estimatedWorkoutEffortScore),
        HKQuantityType(.workoutEffortScore),
        HKQuantityType(.cyclingFunctionalThresholdPower),
        HKQuantityType(.cyclingPower),
        HKQuantityType(.dietaryCaffeine),
        HKQuantityType(.bodyTemperature),
        HKQuantityType(.heartRateVariabilityRMSSD),
        HKQuantityType(.oxygenSaturation),
        HKQuantityType(.respiratoryRate),
        HKQuantityType(.stepCount),
    ]
    
    static let shared = HealthManager()
    
    let healthStore = HKHealthStore()
    
    init () {
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: allWrite, read: allRead)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func fetchVo2Max() async {
        let vo2maxtype = HKQuantityType(.vo2Max)
        
        let query = HKSampleQueryDescriptor(
            predicates: [
                .quantitySample(type: vo2maxtype)
            ],
            
            sortDescriptors: [
                SortDescriptor(\.endDate, order: .forward)
            ]
        )
        
        do {
            vo2maxSamples = try await query.result(for: healthStore)
            print("VO2Max-Werte gefunden: \(vo2maxSamples.count)")
        } catch {
            print(error.localizedDescription)
        }
    }
}
