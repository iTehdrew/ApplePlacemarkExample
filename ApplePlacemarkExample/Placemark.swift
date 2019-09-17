//
//  Placemark.swift
//  ApplePlacemarkExample
//
//  Copyright © 2019 Andrew Konovalskiy. All rights reserved.
//

import Foundation
import MapKit

struct Placemark {
    
    let locationName: String
    let thoroughfare: String?
    
    init(item: MKMapItem) {
        
        var locationString: String = ""
        
        if let name = item.name {
            locationString += "\(name)"
        }
        
        if let locality = item.placemark.locality, locality != item.name {
            locationString += ", \(locality)"
        }
        
        if let administrativeArea = item.placemark.administrativeArea,
            administrativeArea != item.placemark.locality {
            locationString += ", \(administrativeArea)"
        }
        
        if let country = item.placemark.country, country != item.name {
            locationString += ", \(country)"
        }
        
        locationName = locationString
        thoroughfare = item.placemark.thoroughfare
    }
}
