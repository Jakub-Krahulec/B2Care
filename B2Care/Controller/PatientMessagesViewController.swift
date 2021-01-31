//
//  PatientMessagesViewController.swift
//  B2Care
//
//  Created by Jakub Krahulec on 28.01.2021.
//

import UIKit
import MapKit

class PatientMessagesViewController: UIViewController {
    
    // MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private var currentPlace: CLPlacemark?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        fetchData()
    }
    

    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    private func fetchData(){
        var annotations = [MKAnnotation]()
        for place in placesHardCoded.places{
            let annotation = MKPointAnnotation()
            annotation.coordinate = place.coordinates
            annotation.title = place.name
            annotations.append(annotation)
        }
    
        mapView.addAllAnnotationsCentered(annotations, andShow: true)
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareMapViewStyle()
        attemptLocationAccess()
    }
    
    private func prepareMapViewStyle(){
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
    }
    
    private func attemptLocationAccess(){
        guard CLLocationManager.locationServicesEnabled() else {return}
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        if locationManager.authorizationStatus == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
    }

}

extension PatientMessagesViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if let vc = presented as? PlaceDetailViewController{
            let presentationController = VerticalPresentationController(presentedViewController: presented, presenting: presenting)
            presentationController.scrollView = vc.scrollView
            
            return presentationController
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       // mapView.fitAll()
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    
}

extension PatientMessagesViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation,
              annotation.title != "Já" else {return}
        
        presentedViewController?.dismiss(animated: true, completion: nil)
        
        let controller = PlaceDetailViewController()
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.view.layer.cornerRadius = 20
        controller.delegate = self
       
        if let title = annotation.title as? String{
            controller.data = placesHardCoded.places.first(where: {$0.name == title})
        }
        
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
        mapView.setRegion(region, animated: true)

        present(controller, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
       
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .mainColor
        return renderer
    }
}

extension PatientMessagesViewController: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {return}
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: 0, dy: bounds.height)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.4, options: .transitionFlipFromLeft, animations: {
            toViewController.view.frame = finalFrameForVC
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
}

extension PatientMessagesViewController: PlaceDetailViewControllerDelegate{
    func navigationButtonTapped(coordinates: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        guard let userLocation: CLLocationCoordinate2D = locationManager.location?.coordinate else {return}
        let overlays = mapView.overlays
        mapView.removeOverlays(overlays)
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: userLocation.latitude, longitude: userLocation.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [weak self] response, error in
            if let er = error{
                print(er)
            }
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self?.mapView.addOverlay(route.polyline)
                self?.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
}

extension PatientMessagesViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue:CLLocationCoordinate2D = manager.location?.coordinate else {return}
        
        mapView.mapType = MKMapType.standard
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Já"
        annotation.subtitle = "Současná poloha"
        mapView.addAnnotation(annotation)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
