//
//  ConfirmLocationViewController.swift
//  On the map
//
//  Created by Bashayer AlGhamdi on 29/04/1440 AH.
//  Copyright © 1440 Bashayer. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var location: StudentInformation?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
    }
    
    private func setupMap() {
        guard let location = location else { return }
        
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = location.mapString
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    

    @IBAction func submit(_ sender: Any) {
        
        // Updating current user fileds
        CurrentClient.sharedInstance().currentStudent.mapString = self.location?.mapString
        CurrentClient.sharedInstance().currentStudent.mediaURL = self.location?.mediaURL
        CurrentClient.sharedInstance().currentStudent.latitude = self.location?.latitude
        CurrentClient.sharedInstance().currentStudent.longitude = self.location?.longitude
        
        Parser.postLocation(location: self.location!) { (error) in
            guard error == nil else {
                let alertController = UIAlertController(title: "Error", message: error!, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            //Locations.LocationsArray.append(self.location!)
            var Loc = Locations.sharedInstance().LocationsArray
            Loc[Loc.count] = self.location!
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    

}
