//
//  GasLocationAnnotation.swift
//  Gas Station Finder
//
//  Created by cuichen on 19/5/18.
//

import UIKit
import MapKit

class GasLocationAnnotation: NSObject, MKAnnotation{
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var data: GasStation?
    
    // init
    init( data: GasStation, location: CLLocationCoordinate2D){
        self.data = data
        title = data.name
        coordinate = location
    }
}

