//
//  MapViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 29/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import MapKit
import UIKit

public class MapViewController: UIViewController {
    // Properties
    @IBOutlet private weak var mapView: MKMapView!
    
    public var lat: Double = 0.0
    public var lon: Double = 0.0
    public var annotation = MKPointAnnotation()
    
    // Init
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupAnnotation()
    }
    
    // Methods
    public func setupAnnotation() {
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        mapView.addAnnotation(annotation)
        
        setupLocation()
    }
    
    private func setupLocation() {
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}
