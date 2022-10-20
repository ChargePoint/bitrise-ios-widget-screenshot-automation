//
//  SampleShortcutSnippet.swift
//  bitrise-screenshot-automation
//
//  Created by Rishab Sukumar on 10/20/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import SwiftUI

struct SampleShortcutSnippet: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("This is a Sample Shortcut.")
            }
            Spacer()
        }
        .padding()
    }
}

struct SampleShortcutSnippet_Previews: PreviewProvider {
    static var previews: some View {
        SampleShortcutSnippet()
    }
}
