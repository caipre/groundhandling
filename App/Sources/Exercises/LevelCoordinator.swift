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

import Kite
import UIKit

class LevelCoordinator: Coordinator {
  public let navc: UINavigationController

  private let level: Level
  private var repository: Repository { AppContext.shared.repository }

  init(navc: UINavigationController, level: Level) {
    self.navc = navc
    self.level = level
  }

  func start() {
    let exercises = AppContext.shared.exercises.filter { $0.level == level.id }
    let repository = AppContext.shared.repository

    let vc = ExercisesPage(level: level, exercises: exercises, repository: repository)
    navc.show(vc, sender: self)
    vc.delegate = self
  }
}

// MARK: - ExercisesPageDelegate

extension LevelCoordinator: ExercisesPageDelegate {
  func show(page: PageId.Challenge) {
    switch page {
    case .details(let exercise):
      let records = repository.fetchRecords(for: exercise)
      let vc = DetailsContainer(exercise: exercise, records: records)
      navc.show(vc, sender: self)
    default:
      fatalError()  // invalid navigation
    }
  }
}
