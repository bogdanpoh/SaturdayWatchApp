//
//  ComplicationController.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 27.03.2022.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Saturday", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        if complication.family == .circularSmall {
            NetworkManager.shared.getSystemInfo() { result in
                switch result {
                case .failure(_):
                    handler(nil)
                    
                case .success(let info):
                    guard let batteryCharg = Float(info.batteryCharg.replacingOccurrences(of: "%", with: "")) else {
                        print("[dev] error convert to float")
                        return
                    }
                    
                    let template = CLKComplicationTemplateCircularSmallRingText(
                        textProvider: CLKTextProvider(format: info.batteryCharg),
                        fillFraction: batteryCharg / 100,
                        ringStyle: .open
                    )
                    
                    let timelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
                    handler(timelineEntry)
                }
            }
        } else {
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}
