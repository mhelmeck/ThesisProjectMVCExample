//
//  ShowMapViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 29/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import MapKit
import UIKit

public class ShowMapViewController: UIViewController {
    // MARK: - Private properties
    @IBOutlet private weak var mapView: MKMapView!
    private var annotationView = MKPointAnnotation()
    
    // MARK: - Public properties
    public var coordinates: Coordinates!
    
    /// MARK: - Init
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadView()
    }
    
    // MARK: - Private methods
    public func reloadView() {
        setupLocation()
        setupAnnotation()
    }
    
    private func setupLocation() {
        let center = CLLocationCoordinate2D(latitude: coordinates.latitude,
                                            longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.7,
                                    longitudeDelta: 0.7)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func setupAnnotation() {
        annotationView.coordinate = CLLocationCoordinate2D(latitude: coordinates.latitude,
                                                           longitude: coordinates.longitude)
        
        mapView.addAnnotation(annotationView)
    }
}
