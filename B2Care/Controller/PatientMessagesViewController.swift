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

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
        fetchData()
    }
    

    // MARK: - Actions
    
    
    
    // MARK: - Helpers
    
    private func fetchData(){
        let annotation1 = MKPointAnnotation()
        
        annotation1.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(49.5322767), longitude: CLLocationDegrees(17.7506514))
        annotation1.title = "Hranická Propast"
        
        let annotation2 = MKPointAnnotation()
        annotation2.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(49.5178683), longitude: CLLocationDegrees(17.628270))
       // annotation2.color = MKPinAnnotationView.greenPinColor()
        annotation2.title = "Helfštýn"
        mapView.addAnnotations([annotation2])
    }
    
    private func prepareView(){
        view.backgroundColor = .backgroundLight
        
        prepareMapViewStyle()
    }
    
    private func prepareMapViewStyle(){
        mapView.delegate = self
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

extension PatientMessagesViewController: UIViewControllerTransitioningDelegate{
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
         return VerticalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
}

extension PatientMessagesViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {return}
        
        let controller = PlaceDetailViewController()
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        controller.view.layer.cornerRadius = 20
        
       
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: CLLocationDistance(1000), longitudinalMeters: CLLocationDistance(1000))
        
      //  let point = CGPoint(x: mapView.bounds.size.width/2, y: -20)
       //region.center = mapView.convert(point, toCoordinateFrom: mapView)
        mapView.setRegion(region, animated: true)
               
        present(controller, animated: true, completion: nil)
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
           // toViewController.view.frame = CGRect(x: 0, y: finalFrameForVC.height / 2, width: finalFrameForVC.width, height: finalFrameForVC.height)
            toViewController.view.frame = finalFrameForVC
        }, completion: {
            finished in
            transitionContext.completeTransition(true)
        })
    }
}
