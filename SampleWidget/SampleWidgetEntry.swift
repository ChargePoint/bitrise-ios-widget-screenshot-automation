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

struct SampleWidgetEntry: TimelineEntry {
    let date: Date
    let pointsOfInterest: [String]
    let configuration: SelectLocationIntent
    let viewType: SampleWidgetViewType
}

let mockPOIs = ["CineArts", "Santana Row", "Westfield Valley Fair"]
