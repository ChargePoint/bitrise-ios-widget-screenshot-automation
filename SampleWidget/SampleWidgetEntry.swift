//
//  SampleWidgetEntry.swift
//  SampleWidgetExtension
//
//  Created by Rishab Sukumar on 10/5/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import Foundation
import WidgetKit
import MapKit

enum SampleWidgetViewType {
    case Preview
    case LocationSelected
}

struct PointOfInterest {
    let name: String
    let distance: Double
    
    init(name: String, distance: Double) {
        self.name = name
        self.distance = distance
    }
}

struct SampleWidgetEntry: TimelineEntry {
    let date: Date
    let pointsOfInterest: [PointOfInterest]
    let configuration: SelectLocationIntent
    let viewType: SampleWidgetViewType
}

let mockPOIs = [PointOfInterest(name: "CineArts", distance: 0.4), PointOfInterest(name: "Santana Row", distance: 0.6), PointOfInterest(name: "Westfield Valley Fair", distance: 1.4)]
