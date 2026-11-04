//
//  HealthDataAccess.swift
//  Stonx
//
//  Created by Lucas Schretzenmayr on 11/4/26.
//

import Foundation
import HealthKit

let healthStore = HKHealthStore()

let allTypes: Set = [
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
    HKQuantityType(.rowingSpeed),
    HKQuantityType(.runningStrideLength),
    HKQuantityType(.stepCount),
    HKQuantityType(.vo2Max)
]

func askForHealthPermission() async {
    do {
        if HKHealthStore.isHealthDataAvailable() {
            try await healthStore.requestAuthorization(toShare: allTypes, read: allTypes)
        }
    } catch {
        fatalError("*** An unexpected error occurred while requesting authorization: \(error.localizedDescription) ***")
    }
}
