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
    let locationName: String?
    let poiList: [String]
    var body: some View {
        VStack(alignment:.leading) {
            if let locationName = locationName {
                Text("Places near \(locationName)")
                    .font(.footnote)
                    .bold()
                    .fixedSize(horizontal: false, vertical: true)
                Divider()
                
                var poiList = poiList
                let _ = poiList.removeAll { poi in
                    poi == locationName
                }
                
                let maxIndex = poiList.count > 3 ? 2 : poiList.count - 1
                
                if maxIndex >= 0 {
                    ForEach(0...maxIndex, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(poiList[index])
                                .font(.footnote)
                            if (index != 2) {
                                Divider()
                            }
                        }
                    }
                }
                Spacer()
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
        SampleWidgetMediumView(locationName: "San Jose", poiList: mockPOIs)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
