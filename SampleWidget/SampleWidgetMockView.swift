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
    var body: some View {
        VStack(alignment:.leading) {
            Text("Places near San Jose")
                .font(.footnote)
                .bold()
                .fixedSize(horizontal: false, vertical: true)
            Divider()
            
            ForEach(0...2, id: \.self) { index in
                VStack(alignment: .leading) {
                    Text(mockPOIs[index])
                        .font(.footnote)
                    if (index != 2) {
                        Divider()
                    }
                }
            }
            Spacer()
        }
        .padding([.leading, .trailing, .top, .bottom], 10)
    }
}

struct SampleWidgetMockView_Previews: PreviewProvider {
    static var previews: some View {
        SampleWidgetMockView().previewContext(WidgetPreviewContext.init(family: .systemSmall))
    }
}
