//
//  SampleWidgetMockView.swift
//  SampleWidgetExtension
//
//  Created by Rishab Sukumar on 10/5/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import SwiftUI
import WidgetKit

struct SampleWidgetMockView: View {
    @Environment(\.widgetFamily) var family
    let stationStatusColors: [Color] = [Color.green, Color.gray, Color.blue]
    var body: some View {
        VStack(alignment:.leading, spacing: 0) {
            Text("Nearby Chargers")
                .font(.footnote)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            Divider()
                .padding(.top, 5)
                .padding(.bottom, 8)
            
            let maxIndex = family == .accessoryRectangular ? 0 : 2
            
            ForEach(0...maxIndex, id: \.self) { index in
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Image(systemName: "bolt.circle.fill")
                            .foregroundColor(stationStatusColors[index])
                        Text(mockPOIs[index].name)
                            .font(.footnote)
                        Spacer()
                        Text("\(mockPOIs[index].distance, specifier: "%.1f") mi")
                            .font(.footnote)
                            .foregroundColor(Color.secondary)
                    }
                    if (index != 2 && family != .accessoryRectangular ) {
                        Divider()
                            .padding([.top, .bottom], 8)
                    }
                }
            }
            Spacer()
            if (family != .accessoryRectangular) {
                TimerView()
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding([.leading, .trailing, .top, .bottom], 10)
    }
}

struct SampleWidgetMockView_Previews: PreviewProvider {
    static var previews: some View {
        SampleWidgetMockView().previewContext(WidgetPreviewContext.init(family: .systemSmall))
    }
}
