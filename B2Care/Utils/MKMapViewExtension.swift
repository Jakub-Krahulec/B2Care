//
//  MKMapViewExtension.swift
//  B2Care
//
//  Created by Jakub Krahulec on 30.01.2021.
//

import UIKit
import MapKit


extension MKMapView {
    
    func addAllAnnotationsCentered(_ annotations: [MKAnnotation], andShow show: Bool) {
        var zoomRect:MKMapRect = MKMapRect.null
        
        for annotation in annotations {
            let aPoint = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)
            
            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        if(show) {
            addAnnotations(annotations)
        }
        setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
}

