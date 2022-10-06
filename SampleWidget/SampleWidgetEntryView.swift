//
//  SampleWidgetEntryView.swift
//  SampleWidgetExtension
//
//  Created by Rishab Sukumar on 10/5/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import SwiftUI
import WidgetKit
import MapKit

struct SampleWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    var body: some View {
        switch entry.viewType {
        case .LocationSelected:
            switch family {
            case .systemSmall:
                SampleWidgetSmallView(locationName: entry.configuration.Location?.name, poiList: entry.pointsOfInterest)
            case.systemMedium:
                SampleWidgetMediumView(locationName: entry.configuration.Location?.name, poiList: entry.pointsOfInterest)
            case.accessoryRectangular:
                SampleWidgetAccessoryRectangularView(locationName: entry.configuration.Location?.name, poiList: entry.pointsOfInterest)
            default:
                SampleWidgetMediumView(locationName: entry.configuration.Location?.name, poiList: entry.pointsOfInterest)
            }
        case .Preview:
            SampleWidgetMockView()
        }
    }
}

struct SampleWidget_Previews: PreviewProvider {
    static var previews: some View {
        SampleWidgetEntryView(entry: SampleWidgetEntry(date: Date(), pointsOfInterest: [], configuration: SelectLocationIntent(), viewType: .Preview))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
