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

import Cleanse
import Combine
import CoreLocation
import Foundation
import OpenWeather

var Current: AppContext!

struct AppContext {
  let json: JSON
  struct JSON {
    let encoder: JSONEncoder
    let decoder: JSONDecoder
  }

  let release: ReleaseInfo
  let licenses: [License]
  let exercises: [Exercise]
  let levels: [Level]

  let repository: Repository
  let location: LocationService
  let weather: WeatherService

  let openWeather: OpenWeather
}

struct AppComponent: Cleanse.RootComponent {
  typealias Root = AppContext

  static func configureRoot(binder bind: ReceiptBinder<AppContext>) -> BindingReceipt<AppContext> {
    bind.to(factory: AppContext.init)
  }

  static func configure(binder: Binder<Singleton>) {
    binder.include(module: ExercisesModule.self)
    binder.include(module: LevelsModule.self)
    binder.include(module: LicensesModule.self)
    binder.include(module: LocationModule.self)
    binder.include(module: JSONModule.self)
    binder.include(module: OpenWeatherModule.self)
    binder.include(module: ReleaseInfoModule.self)
    binder.include(module: RepositoryModule.self)
    binder.include(module: UnsplashModule.self)
    binder.include(module: WeatherModule.self)
  }
}

struct ExercisesModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([Exercise].self)
      .sharedInScope()
      .to { (decoder: JSONDecoder) in
        decoder.decode(resource: "exercises.json", into: [Exercise].self)
      }
  }
}

struct LevelsModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([Level].self)
      .sharedInScope()
      .to { (decoder: JSONDecoder) in
        decoder.decode(resource: "levels.json", into: [Level].self)
      }
  }
}

struct LicensesModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([License].self)
      .sharedInScope()
      .to { (decoder: JSONDecoder) in
        decoder.decode(resource: "licenses.json", into: [License].self)
      }
  }
}

struct LocationModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(LocationService.self)
      .sharedInScope()
      .to(factory: LocationService.init)
  }
}

struct JSONModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(AppContext.JSON.self)
      .sharedInScope()
      .to {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return AppContext.JSON(encoder: encoder, decoder: decoder)
      }

    binder.bind(JSONDecoder.self)
      .sharedInScope()
      .to { (json: AppContext.JSON) in
        json.decoder
      }
  }
}

struct OpenWeatherAPIKey: Cleanse.Tag {
  typealias Element = String
}

struct OpenWeatherModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind()
      .tagged(with: OpenWeatherAPIKey.self)
      .to { "123" }

    binder.bind(OpenWeather.self)
      .sharedInScope()
      .to { (appId: TaggedProvider<OpenWeatherAPIKey>) in
        OpenWeather(appId: appId.get())
      }
  }
}

struct ReleaseInfoModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(ReleaseInfo.self)
      .sharedInScope()
      .to { (decoder: JSONDecoder) in
        decoder.decode(resource: "release.json", into: ReleaseInfo.self)
      }
  }
}

struct RepositoryModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(Repository.self)
      .sharedInScope()
      .to(factory: FileSystemRepository.init)
  }
}

struct UnsplashModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([Photo].self)
      .sharedInScope()
      .to { (decoder: JSONDecoder) in
        decoder.decode(resource: "unsplash.json", into: [Photo].self)
      }
  }
}

struct WeatherModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(WeatherService.self)
      .sharedInScope()
      .to { (ls: LocationService, ow: OpenWeather) in
        let placemarks =
          ls.$placemark
          .compactMap { $0 }
          .eraseToAnyPublisher()

        return WeatherService(
          placemarks: placemarks,
          openWeather: ow
        )
      }
  }
}

extension JSONDecoder {
  func decode<T: Decodable>(resource: String, into ty: T.Type) -> T {
    let data =
      try! Data(contentsOf: Bundle.module.url(forResource: resource, withExtension: nil)!)
    return try! self.decode(T.self, from: data)
  }
}
