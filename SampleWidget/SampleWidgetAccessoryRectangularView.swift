//
//  SampleWidgetAccessoryRectangularView.swift
//  SampleWidgetExtension
//
//  Created by Rishab Sukumar on 10/5/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import SwiftUI
import WidgetKit
import MapKit

struct SampleWidgetAccessoryRectangularView: View {
    let stationStatusColors: [Color]
    let locationName: String?
    let poiList: [PointOfInterest]
    var body: some View {
        VStack(alignment:.leading) {
            if let locationName = locationName {
                Text("Nearby Chargers")
                    .font(.footnote)
                    .bold()
                Divider()
                
                var poiList = poiList
                let _ = poiList.removeAll { poi in
                    poi.name == locationName
                }
                
                let maxIndex = poiList.count > 1 ? 0 : poiList.count - 1
                
                if maxIndex >= 0 {
                    ForEach(0...maxIndex, id: \.self) { index in
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "bolt.circle.fill")
                                    .foregroundColor(stationStatusColors.randomElement() ?? Color.green)
                                Text(poiList[index].name)
                                    .font(.footnote)
                                Spacer()
                                let locale = NSLocale.autoupdatingCurrent
                                if (locale.measurementSystem == Locale.MeasurementSystem.metric) {
                                    if (poiList[index].distance.getKilometersFromMeters() < 0.1) {
                                        Text("\(poiList[index].distance, specifier: "%.1f") m")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    } else {
                                        Text("\(poiList[index].distance.getKilometersFromMeters(), specifier: "%.1f") km")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    }
                                } else {
                                    if (poiList[index].distance.getMilesFromMeters() < 0.1) {
                                        Text("\(poiList[index].distance.getFeetFromMeters(), specifier: "%.1f") ft")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    } else {
                                        Text("\(poiList[index].distance.getMilesFromMeters(), specifier: "%.1f") mi")
                                            .font(.footnote)
                                            .foregroundColor(Color.secondary)
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                Text("Edit configuration to explore a location.")
                    .font(.footnote)
            }
            Spacer()
        }
        .padding([.leading, .trailing, .top, .bottom], 10)
    }
}

@available(iOS 16, *)
struct SampleWidgetAccessoryRectangularView_Previews: PreviewProvider {
    static var previews: some View {
        SampleWidgetAccessoryRectangularView(stationStatusColors: [Color.green, Color.gray, Color.blue], locationName: "San Francisco", poiList: mockPOIs)
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
