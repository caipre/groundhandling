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

protocol LocationService {
  var location: CLLocation? { get }
  var placemark: CLPlacemark? { get }
}

class LocationServiceImpl: NSObject, LocationService, Service {
  public private(set) var location: CLLocation?
  public private(set) var placemark: CLPlacemark?

  private var manager: CLLocationManager!
  private lazy var geocoder: CLGeocoder = { CLGeocoder() }()

  func start() {
    guard CLLocationManager.significantLocationChangeMonitoringAvailable() == true else { return }
    manager = CLLocationManager()
    manager.delegate = self

    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    manager.requestWhenInUseAuthorization()
    manager.startMonitoringSignificantLocationChanges()
  }

  func stop() {
    manager.stopMonitoringSignificantLocationChanges()
  }
}

extension LocationServiceImpl: CLLocationManagerDelegate {
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    NSLog("status: \(manager.authorizationStatus.rawValue)")
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    NSLog("error: \(error)")
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    geocoder.reverseGeocodeLocation(location) { (marks: [CLPlacemark]?, error: Error?) in
      guard let mark = marks?.last else {
        NSLog("error: \(error)")
        return
      }
      self.location = location
      self.placemark = mark
    }
  }
}
