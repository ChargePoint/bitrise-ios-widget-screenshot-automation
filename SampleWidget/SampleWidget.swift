//
//  SampleWidget.swift
//  SampleWidget
//
//  Created by Rishab Sukumar on 10/4/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import MapKit

@main
struct SampleWidget: Widget {
    let kind: String = "SampleWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectLocationIntent.self, provider: Provider()) { entry in
            SampleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description(NSLocalizedString("Explore your favorite cities.", comment: ""))
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}
