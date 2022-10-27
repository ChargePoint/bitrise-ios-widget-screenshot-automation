//
//  Double+DistanceUnit.swift
//  bitrise-screenshot-automation
//
//  Created by Rishab Sukumar on 10/27/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import Foundation

extension Double {
    func getMilesFromMeters() -> Double {
        return self * 0.000621371192
    }
    
    func getKilometersFromMeters() -> Double {
        return self * 0.001
    }
    
    func getFeetFromMeters() -> Double {
        return self * 3.28084
    }
}
