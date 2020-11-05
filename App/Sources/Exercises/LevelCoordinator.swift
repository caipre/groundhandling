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
import Kite
import UIKit

class LevelCoordinator: Coordinator {
  public let navc: UINavigationController

  private let level: Level
  private let exercises: [Exercise]
  private let location: LocationService
  private let weather: WeatherService
  private let repository: Repository

  init(
    navc: UINavigationController,
    level: Level,
    exercises: [Exercise],
    location: LocationService,
    weather: WeatherService,
    repository: Repository
  ) {
    self.navc = navc
    self.level = level
    self.exercises = exercises
    self.location = location
    self.weather = weather
    self.repository = repository
  }

  func start() {
    let vc = ExercisesPage(
      level: level,
      exercises: exercises,
      placemark: Provider { self.location.placemark },
      conditions: Provider { self.weather.conditions },
      repository: repository
    )
    navc.show(vc, sender: self)
    vc.delegate = self
  }
}

// MARK: - ExercisesPageDelegate

extension LevelCoordinator: ExercisesPageDelegate {
  func show(page: PageId.Challenge) {
    switch page {
    case .details(let exercise):
      let records = repository.records(for: exercise)
      let vc = DetailsContainer(exercise: exercise, records: records)
      navc.show(vc, sender: self)
    default:
      fatalError()  // invalid navigation
    }
  }
}
