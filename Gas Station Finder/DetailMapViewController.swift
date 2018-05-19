//
//  DetailMapViewController.swift
//  Gas Station Finder
//
//  Created by crow on 19/5/18.
//

import UIKit
import MapKit
import CoreData

class DetailMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var selectedGas: GasLocationAnnotation? = nil
    var managedObjectContext : NSManagedObjectContext
    var gasStations = [GasStation]()
    var annotations = [GasLocationAnnotation]()
    var circularRegion: CLCircularRegion?
    var data: GasStation?

    // init viewContext
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (data?.lat)!, longitude: (data?.lon)!), span: span)
        mapView.setRegion(region, animated: true)
        let ann = GasLocationAnnotation(data: data!, location: CLLocationCoordinate2D(latitude: (data?.lat)!, longitude: (data?.lon)!))
        mapView.addAnnotation(ann)
    }

    // view for annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "gasAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        annotationView?.annotation = annotation
        annotationView?.canShowCallout = true
        
        let button = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30)))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(showDirection), for: .touchUpInside)
        annotationView?.leftCalloutAccessoryView = button
        
        // logo image
        var logoImage = UIImage(data: (annotation as! GasLocationAnnotation).data?.logo! as! Data)
        let sizeChange = CGSize(width: 45,height: 20)
        UIGraphicsBeginImageContextWithOptions(sizeChange, false, 0.0)
        logoImage?.draw(in: CGRect(origin: (annotationView?.frame.origin)!, size: sizeChange))
        logoImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        annotationView?.image = logoImage
        return annotationView
    }
    
    // did select annotation
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        selectedGas = view.annotation as? GasLocationAnnotation
    }
    
    // direction
    @objc func showDirection(){
        if let selectedGas = selectedGas
        {
            selectedGas.data?.visit = (selectedGas.data?.visit)! + 1
            do {
                try managedObjectContext.save()
            } catch {
            }
            var placeMark = MKPlacemark(coordinate: selectedGas.coordinate)
            let mapItem = MKMapItem(placemark: placeMark as! MKPlacemark)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
}
