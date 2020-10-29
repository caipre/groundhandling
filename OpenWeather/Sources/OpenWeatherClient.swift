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

public enum Mode: String {
  case json = "json"
  case xml = "xml"
}

public enum Units: String {
  case standard = "standard"
  case metric = "metric"
  case imperial = "imperial"
}

public class OpenWeather {
  public static let baseURL = "https://api.openweathermap.org/data/2.5/"
  public static let current = "/weather"

  private let service: Service
  private let appId: String
  private let mode: Mode?
  private let units: Units?
  private let lang: String?

  private lazy var baseQueryItems: [URLQueryItem] = {
    var items: [URLQueryItem] = [.init(name: "appid", value: appId)]
    if let mode = self.mode { items.append(.init(name: "mode", value: mode.rawValue)) }
    if let units = self.units { items.append(.init(name: "units", value: units.rawValue)) }
    if let lang = self.lang { items.append(.init(name: "lang", value: lang)) }
    return items
  }()

  public convenience init(
    appId: String,
    mode: Mode? = .json,
    units: Units = .metric,
    lang: String = "en-US"
  ) {
    let decoder = JSONDecoder()
    let service = Service(baseURL: OpenWeather.baseURL, standardTransformers: [.text])
    self.init(
      decoder: decoder,
      service: service,
      appId: appId,
      mode: mode,
      units: units,
      lang: lang
    )
  }

  internal init(
    decoder: JSONDecoder,
    service: Service,
    appId: String,
    mode: Mode? = nil,
    units: Units? = nil,
    lang: String? = nil
  ) {
    self.service = OpenWeather.configure(service, with: decoder)
    self.appId = appId
    self.mode = mode
    self.units = units
    self.lang = lang
  }

  static internal func configure(
    _ service: Service,
    with decoder: JSONDecoder
  ) -> Service {
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    service.configure { $0.pipeline[.parsing].removeTransformers() }
    service.configureTransformer("\(OpenWeather.current)*") {
      try decoder.decode(CurrentWeatherResponse.self, from: $0.content)
    }
    return service
  }
}

extension OpenWeather {
  public var unitSpeed: UnitSpeed {
    switch units {
    case nil, .standard, .metric:
      return UnitSpeed.metersPerSecond
    case .imperial:
      return UnitSpeed.milesPerHour
    }
  }

  public var unitAngle: UnitAngle { UnitAngle.degrees }

  public var unitTemperature: UnitTemperature {
    switch units {
    case nil, .standard:
      return UnitTemperature.kelvin
    case .metric:
      return UnitTemperature.celsius
    case .imperial:
      return UnitTemperature.fahrenheit
    }
  }
}

extension OpenWeather: CurrentWeather {
  public func city(name: String, state: String? = nil, country: String? = nil) -> Resource {
    var items = [name]
    if let state = state { items.append(state) }
    if let country = country { items.append(country) }

    return service.resource(OpenWeather.current)
      .withParams(baseQueryItems.toParams())
      .withParam("q", items.joined(separator: ","))
  }

  public func city(id cityId: String) -> Resource {
    return city(ids: cityId)
  }

  public func city(ids cityIds: String...) -> Resource {
    return service.resource(OpenWeather.current)
      .withParams(baseQueryItems.toParams())
      .withParam("id", cityIds.joined(separator: ","))
  }

  public func coord(lat: Double, lon: Double) -> Resource {
    return service.resource(OpenWeather.current)
      .withParams(baseQueryItems.toParams())
      .withParams(["lat": "\(lat)", "lon": "\(lon)"])
  }

  public func zip(zip: Int, country: String) -> Resource {
    return service.resource(OpenWeather.current)
      .withParams(baseQueryItems.toParams())
      .withParam("zip", "\(zip),\(country)")
  }
}

extension Array where Element == URLQueryItem {
  fileprivate func toParams() -> [String: String] {
    reduce(into: [:]) { result, next in result[next.name] = next.value ?? "" }
  }
}
