//
//  ContentView.swift
//  Stonx
//
//  Created by Lucas Schretzenmayr on 11/4/26.
//

import HealthKit
import HealthKitUI
import SwiftUI


struct ContentView: View {
    
    let healthStore = HKHealthStore()
    
    @State var accessRequested = false
    @State var trigger = false
    
        var body: some View {
            
            Button("Access health data") {
                //
            }
            .disabled(!accessRequested)
        
            // If HealthKit data is available, request authorization
            // when this view appears.
            .onAppear() {
                
                // Check that Health data is available on the device.
                if HKHealthStore.isHealthDataAvailable() {
                    // Modifying the trigger initiates the health data
                    // access request.
                    trigger.toggle()
                }
            }
               
            // Requests access to share and read HealthKit data types
            // when the trigger changes.
            .healthDataAccessRequest(store: healthStore,
                                shareTypes: allTypes,
                                    readTypes: allTypes,
                                    trigger: trigger) { result in
                switch result {
                       
                   case .success(_):
                       accessRequested = true
                   case .failure(let error):
                       // Handle the error here.
                       fatalError("*** An error occurred while requesting authentication: \(error) ***")
                   }
               }
           }
}

#Preview {
    ContentView()
}
