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

import Combine
import CoreLocation
import Foundation
import OpenWeather

class WeatherService {
  @Published public private(set) var conditions: Conditions?

  private let placemarks: AnyPublisher<Placemark, Never>
  private let openWeather: OpenWeather

  init(placemarks: AnyPublisher<Placemark, Never>, openWeather: OpenWeather) {
    self.placemarks = placemarks
    self.openWeather = openWeather
  }

  private var cancellable: Cancellable?
  func start() {
    cancellable =
      placemarks
      .sink { self.coord(lat: $0.latitude, lon: $0.longitude) }
  }

  private func coord(lat: Double, lon: Double) {
    // todo: cache requests for cancellation
    openWeather.coord(lat: lat, lon: lon)
      .addObserver(owner: self) { res, ev in
        guard let response: CurrentWeatherResponse = res.latestData?.typedContent() else { return }
        self.conditions = Conditions(
          windSpeed: Measurement(
            value: response.wind.speed,
            unit: self.openWeather.unitSpeed
          ),
          windDirection: Measurement(
            value: Double(response.wind.deg),
            unit: self.openWeather.unitAngle
          ),
          temperature: Measurement(
            value: response.main.feelsLike,
            unit: self.openWeather.unitTemperature
          )
        )
      }
      .loadIfNeeded()
  }
}
