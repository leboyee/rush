//
//  CreateEventLogics.swift
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


extension AddLocationViewController {
        
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func cellCount(_ section: Int) -> Int {
        return self.completerResults.count
    }
    
    func fillLocationCell(_ cell: AddEventLocationCell, _ indexPath: IndexPath) {
        cell.setup(titleText: self.completerResults[indexPath.row].title + " " + self.completerResults[indexPath.row].subtitle)
//        cell.setup(titleText: self.completerResults[indexPath.row].subtitle)
    }
}
// Search location based on user search.
extension AddLocationViewController {
    
    func search(_ searchResult: MKLocalSearchCompletion) {
//        self.view.makeToast("Started fetching information...")
        let request = MKLocalSearch.Request(completion: searchResult)
        if #available(iOS 13.0, *) {
            //request.region
        } else {
            // Fallback on earlier versions
        }
        let search = MKLocalSearch(request: request)
        search.start { result, error in
//            self.view.hideAllToasts()
            if let result = result, let mapItem = result.mapItems.first {
                self.mapItemToPresent = mapItem
                // pass this "self.mapItemToPresent" to previous screen
                print("selected map item is : \(String(describing: self.mapItemToPresent))")
                self.delegate?.addEventLocationData(searchResult.title + " " + searchResult.subtitle, latitude: self.mapItemToPresent?.placemark.location?.coordinate.latitude ?? 0.0, longitude: self.mapItemToPresent?.placemark.location?.coordinate.longitude ?? 0.0)
                if self.isRegister == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            } else if let error = error {
//                self.view.makeToast("Failed to fetch address information: \(error.localizedDescription)")
                print("Failed to fetch address information: \(error.localizedDescription)")
            }
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
                    /*
                    if subLocality.isEmpty == false {
                        addressString  += subLocality
                        addressString += ", "
                    }

                    let thoroughfare = place.thoroughfare ?? ""
                    if thoroughfare.isEmpty == false {
                        addressString  += thoroughfare
                        addressString += ", "
                    } */
                
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
/*
   func cellCount(_ section: Int) -> Int {
         let array = self.completerResults.map({ $0.subtitle })
         print("count",array.count)
         return array.count
     }
     
     func fillLocationCell(_ cell: AddEventLocationCell, _ indexPath: IndexPath) {
         let array = self.completerResults.map({ $0.subtitle })
         print("count\n",array)
         cell.setup(titleText: array[indexPath.row])
 //        cell.setup(titleText: self.completerResults[indexPath.row].subtitle)
     }
 
 self.searchResults = completer.results.filter { result in
           if !result.title.contains(",") {
               return false
           }

           if result.title.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
               return false
           }

           if result.subtitle.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
               return false
           }

           return true
       }

 */

extension AddLocationViewController {
    /*
    func searchPlaces(text: String) {
        let filter = GMSAutocompleteFilter()
        filter.type = .region
        GMSPlacesClient.shared().autocompleteQuery(text, bounds: nil, filter: filter, callback: {
            [weak self] (results, error) -> Void in
            guard let self_ = self else { return }
            if let error = error {
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                
                if self_.type == .city_state {
                    let list = results.filter({ $0.attributedPrimaryText.string.count > 2})
                    //get unique values
                    self_.searchList = list.map({ $0.attributedFullText.string })
                } else {
                    
                    var list: [GMSAutocompletePrediction]!
                    if self_.type == .country {
                        list = results.filter({ $0.types.contains("country")})
                        for short in self_.shortCountryNames {
                            if let index = list.index(where: { $0.attributedPrimaryText.string == short}) {
                                list.remove(at: index)
                            }
                        }
                    } else if self_.type == .city {
                        list = results.filter({ $0.attributedPrimaryText.string.count > 2})
                    } else if self_.type == .state {
                        list = results.filter({ $0.types.contains("administrative_area_level_1") && $0.attributedPrimaryText.string.count > 2})
                    } else {
                        list = results.filter({ $0.types.contains("postal_code")})
                    }
                    
                    self_.searchList = list.map({ $0.attributedPrimaryText.string })
                }
                //get unique values
                self_.searchList = Array(Set(self_.searchList))
            }
            self_.mediator?.reload()
        })
    }*/
    
}
