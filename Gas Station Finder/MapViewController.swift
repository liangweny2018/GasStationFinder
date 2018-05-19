//
//  MapViewController.swift
//  Gas Station Finder
//
//  Created by cuichen on 19/5/18.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var selectedGas: GasLocationAnnotation? = nil
    var managedObjectContext : NSManagedObjectContext
    var gasStations = [GasStation]()
    var annotations = [GasLocationAnnotation]()
    var circularRegion: CLCircularRegion?
    
    // init viewContext
    required init(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedObjectContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)!
    }
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        mapView.delegate = self
    }
    
    // fetch data
    func fetchData() {
        if circularRegion == nil
        {
            return
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GasStation")
        mapView.removeAnnotations(mapView.annotations)
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            if result.count != 0
            {
                annotations.removeAll()
                self.gasStations = (result as? [GasStation])!
                for data in self.gasStations {
                    let coordinate = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
                    // check if inside the region
                    if (circularRegion?.contains(coordinate))!
                    {
                        let ann = GasLocationAnnotation(data: data, location: coordinate)
                        annotations.append(ann)
                        mapView.addAnnotation(ann)
                    }
                }
            }
        } catch {
            print(error as NSError)
        }
    }
    
    // refresh annotations
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // location manager request authorization
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    // reset current location
    @IBAction func resetCurrentLocation(_ sender: Any) {
        locationManager.requestLocation()
        fetchData()
    }
    
    // current location updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            circularRegion = CLCircularRegion(center: location.coordinate, radius: 5000, identifier: "currentRegion")
            mapView.setRegion(region, animated: true)
            fetchData()
        }
    }
    
    // locationManager failed
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
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
