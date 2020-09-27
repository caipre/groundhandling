//  Copyright (C) 2020 Nick Platt <platt.nicholas@gmail.com>
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

import CoreLocation
import Foundation

enum LocationServiceMsg {
  case requestAuth
}

protocol LocationService {
  var location: CLLocation? { get }
  var placemark: CLPlacemark? { get }
  func recv(msg: LocationServiceMsg)
}

class LocationServiceImpl: NSObject, LocationService {
  public private(set) var location: CLLocation?
  public private(set) var placemark: CLPlacemark?

  private var manager: CLLocationManager!
  private lazy var geocoder: CLGeocoder = { CLGeocoder() }()

  func start() {
    guard CLLocationManager.significantLocationChangeMonitoringAvailable() == true else { return }
    manager = CLLocationManager()
    manager.delegate = self
  }

  func recv(msg: LocationServiceMsg) {
    switch msg {
    case .requestAuth:
      manager.requestWhenInUseAuthorization()
      manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
      manager.startMonitoringSignificantLocationChanges()
    }
  }

  func stop() {
    manager.stopMonitoringSignificantLocationChanges()
  }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    switch manager.authorizationStatus {
    case .restricted, .denied:
      manager.stopMonitoringSignificantLocationChanges()
      self.manager = nil
    default:
      break
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("\(error)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    //    guard Date().timeIntervalSince(location.timestamp) <= 60*15 else { return } // fresh to within 15mins
    geocoder.reverseGeocodeLocation(location) { (marks: [CLPlacemark]?, error: Error?) in
      guard let mark = marks?.last else {
        return
      }
      self.location = location
      self.placemark = mark
    }
  }
}
