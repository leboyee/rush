//
//  AddLocationLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MapKit
import CoreLocation
import GooglePlaces
import GoogleMapsBase

extension AddLocationViewController {
        
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return self.isRegister == true ? self.searchList.count : self.completerResults.count
    }
    
    func fillLocationCell(_ cell: AddEventLocationCell, _ indexPath: IndexPath) {
        if self.isRegister == true {
            cell.setup(titleText: self.searchList[indexPath.row])
        } else {
             cell.setup(titleText: self.completerResults[indexPath.row].title + " " + self.completerResults[indexPath.row].subtitle)
        }
    }
}
// Search location based on user search.
extension AddLocationViewController {
    
    func search(_ searchResult: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: searchResult)
        let search = MKLocalSearch(request: request)
        search.start { result, error in
            if let result = result, let mapItem = result.mapItems.first {
                self.mapItemToPresent = mapItem
                // pass this "self.mapItemToPresent" to previous screen
                print("selected map item is : \(String(describing: self.mapItemToPresent))")
                self.delegate?.addEventLocationData(searchResult.title + " " + searchResult.subtitle, latitude: self.mapItemToPresent?.placemark.location?.coordinate.latitude ?? 0.0, longitude: self.mapItemToPresent?.placemark.location?.coordinate.longitude ?? 0.0)
                if self.isRegister == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                    //self.dismiss(animated: true, completion: nil)
                }

            } else if let error = error {
                print("Failed to fetch address information: \(error.localizedDescription)")
            }
        }
    }
    
    func searchLatLong(address: String) {
        Utils.showSpinner()

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, _) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                // handle no location found
                Utils.hideSpinner()
                return
            }
            self.delegate?.addEventLocationData(address, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            Utils.hideSpinner()
            self.navigationController?.popViewController(animated: true)
            // Use your location
        }
    }
    
}

extension AddLocationViewController: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        print(completer.results)
        self.completerResults = completer.results
        self.tableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        self.view.makeToast("Failed to fetch addresses from server.")
    }
    
}

extension AddLocationViewController {
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center: CLLocationCoordinate2D = CLLocationCoordinate2D()
        let latitude: Double = Double("\(pdblLatitude)") ?? 0.0
        //21.228124
        let longitude: Double = Double("\(pdblLongitude)") ?? 0.0
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let location: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        ceo.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                
                let placeMark = placemarks
                if placeMark?.count ?? 0 > 0 {
                    let place = placemarks![0]
                    print(place.country as Any)
                    print(place.locality as Any)
                    print(place.subLocality as Any)
                    print(place.thoroughfare as Any)
                    print(place.postalCode as Any)
                    print(place.subThoroughfare as Any)
                    var addressString: String = ""
                    _ = place.subLocality ?? ""
                
                    let locality = place.locality ?? ""
                     if locality.isEmpty == false {
                        addressString  += locality
                        addressString += ", "
                    }
                  
                    let country = place.country ?? ""
                    if country.isEmpty == false {
                        addressString  += country
                        addressString += ", "
                    }
                    
                    let postalCode = place.postalCode ?? ""
                    if postalCode.isEmpty == false {
                        addressString  += postalCode
                    }
                    
                    print(addressString)
                    self.usersCurrentLocation = location
                    self.curentAdressLabel.text = addressString
                    self.locationManager.stopUpdatingLocation()
                }
        })
        
    }
}

extension AddLocationViewController {

    func searchPlaces(text: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        placesClient.autocompleteQuery(text, bounds: nil, filter: filter, callback: { [weak self] (results, error) -> Void in
            guard let uwself = self else { return }
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                uwself.searchList = results.map({ $0.attributedFullText.string })
            }
            uwself.tableView.reloadData()
        })
    }
    
}
