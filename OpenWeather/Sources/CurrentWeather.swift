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

import Foundation
import Siesta

public protocol CurrentWeather {
  func city(name: String, state: String?, country: String?) -> Resource
  func city(id: String) -> Resource
  func city(ids: String...) -> Resource
  func coord(lat: Double, lon: Double) -> Resource
  func zip(zip: Int, country: String) -> Resource
}

/// https://openweathermap.org/current#current_JSON
public struct CurrentWeatherResponse: Codable {
  public let coord: Coord
  public struct Coord: Codable {
    public let lon: Double
    public let lat: Double
  }

  public let weather: [Weather]
  public struct Weather: Codable {
    public let id: Int
    public let main: String
    public let description: String
    public let icon: String
  }

  public let base: String

  public let main: Main
  public struct Main: Codable {
    public let temp: Double
    public let feelsLike: Double
    public let tempMin: Double
    public let tempMax: Double
    public let pressure: Int
    public let humidity: Int
  }

  public let visibility: Int

  public let wind: Wind
  public struct Wind: Codable {
    public let speed: Double
    public let deg: Int
  }

  public let clouds: Clouds
  public struct Clouds: Codable {
    public let all: Int
  }

  public let dt: Int

  public let sys: Sys
  public struct Sys: Codable {
    public let type: Int
    public let id: Int
    public let message: Double
    public let country: String
    public let sunrise: Int
    public let sunset: Int
  }

  public let timezone: Int

  public let id: Int

  public let name: String

  public let cod: Int
}
