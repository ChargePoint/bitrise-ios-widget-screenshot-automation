//
//  SampleWidgetTimelineProvider.swift
//  SampleWidgetExtension
//
//  Created by Rishab Sukumar on 10/5/22.
//  Copyright © 2022 ChargePoint, Inc. All rights reserved.
//

import Foundation
import WidgetKit
import Intents
import MapKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SampleWidgetEntry {
        SampleWidgetEntry(date: Date(), pointsOfInterest: [], configuration: SelectLocationIntent(), viewType: .Preview)
    }

    func getSnapshot(for configuration: SelectLocationIntent, in context: Context, completion: @escaping (SampleWidgetEntry) -> ()) {
        let entry = SampleWidgetEntry(date: Date(), pointsOfInterest: [], configuration: configuration, viewType: .Preview)
        completion(entry)
    }

    func getTimeline(for configuration: SelectLocationIntent, in context: Context, completion: @escaping (Timeline<SampleWidgetEntry>) -> ()) {
        var entries: [SampleWidgetEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let calendar = Calendar.current
        let currentDate = Date()
        let entryDate = calendar.date(byAdding: .hour, value: 1, to: currentDate) ?? Date()
        
        var pointsOfInterest: [MKMapItem] = []
        if let location = configuration.Location?.location {
            let configLocationCenter = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let request = MKLocalPointsOfInterestRequest(center: configLocationCenter, radius: 500)
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                pointsOfInterest = response?.mapItems ?? []
                var pois: [PointOfInterest] = []
                for poi in pointsOfInterest {
                    let poiCoords = poi.placemark.coordinate
                    let distance = location.distance(from: CLLocation(latitude: poiCoords.latitude, longitude: poiCoords.longitude))
                    
                    if let name = poi.name {
                        pois.append(PointOfInterest(name: name, distance: distance))
                    }
                }
                let entry = SampleWidgetEntry(date: entryDate, pointsOfInterest: pois, configuration: configuration, viewType: .LocationSelected)
                entries.append(entry)

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        } else {
            let entry = SampleWidgetEntry(date: entryDate, pointsOfInterest: [], configuration: configuration, viewType: .LocationSelected)
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}
