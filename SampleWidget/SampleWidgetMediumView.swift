//
//  SampleWidgetMediumView.swift
//  SampleWidgetExtension
//
//  Created by Rishab Sukumar on 10/5/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import SwiftUI
import WidgetKit
import MapKit

struct SampleWidgetMediumView: View {
    let stationStatusColors: [Color]
    let locationName: String?
    let poiList: [PointOfInterest]
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            if let locationName = locationName {
                Text("Nearby Chargers")
                    .font(.footnote)
                    .bold()
                Divider()
                    .padding(.bottom, 8)
                    .padding(.top, 5)
                
                var poiList = poiList
                let _ = poiList.removeAll { poi in
                    poi.name == locationName
                }
                
                let maxIndex = poiList.count > 3 ? 2 : poiList.count - 1
                
                if maxIndex >= 0 {
                    ForEach(0...maxIndex, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 0) {
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
                            if (index != 2) {
                                Divider()
                                    .padding([.top, .bottom], 8)
                            }
                        }
                    }
                }
                Spacer()
                TimerView()
                    .multilineTextAlignment(.trailing)
            } else {
                Text("Edit configuration to explore a location.")
                    .font(.footnote)
            }
        }
        .padding([.leading, .trailing, .top, .bottom], 10)
    }
}

struct SampleWidgetMediumView_Previews: PreviewProvider {
    static var previews: some View {
        SampleWidgetMediumView(stationStatusColors:[Color.green, Color.gray, Color.blue], locationName: "San Jose", poiList: mockPOIs)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
