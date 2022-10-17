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
    let locationName: String?
    let poiList: [String]
    var body: some View {
        VStack(alignment:.leading) {
            if let locationName = locationName {
                Text("Places near \(locationName)")
                    .font(.footnote)
                    .bold()
                Divider()
                
                var poiList = poiList
                let _ = poiList.removeAll { poi in
                    poi == locationName
                }
                
                let maxIndex = poiList.count > 1 ? 0 : poiList.count - 1
                
                if maxIndex >= 0 {
                    ForEach(0...maxIndex, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(poiList[index])
                                .font(.footnote)
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
        SampleWidgetAccessoryRectangularView(locationName: "San Francisco", poiList: mockPOIs)
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
