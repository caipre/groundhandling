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
import CoreLocation
import Foundation

struct AppContext {
  static var shared: AppContext!

  let release: ReleaseInfo

  let levels: [Level]
  let exercises: [Exercise]
  let repository: Repository

  let licenses: [License]
  let photos: [Photo]
}

struct AppContextComponent: Cleanse.RootComponent {
  typealias Root = AppContext

  static func configureRoot(binder bind: ReceiptBinder<AppContext>) -> BindingReceipt<AppContext> {
    bind.to(factory: AppContext.init)
  }

  static func configure(binder: Binder<Singleton>) {
    binder.include(module: ReleaseInfoModule.self)
    binder.include(module: LevelsModule.self)
    binder.include(module: ExercisesModule.self)
    binder.include(module: RepositoryModule.self)
    binder.include(module: LicensesModule.self)
    binder.include(module: UnsplashModule.self)
  }
}

struct ReleaseInfoModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(ReleaseInfo.self)
      .sharedInScope()
      .to {
        let decoder = JSONDecoder()
        let data = try! Data(
          contentsOf: Bundle.module.url(forResource: "release", withExtension: "json")!
        )
        let decoded = try! decoder.decode(ReleaseInfo.self, from: data)
        return decoded
      }
  }
}

struct LevelsModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([Level].self)
      .sharedInScope()
      .to {
        let decoder = JSONDecoder()
        let data = try! Data(
          contentsOf: Bundle.module.url(forResource: "levels", withExtension: "json")!
        )
        let decoded = try! decoder.decode([Level].self, from: data)
        return decoded
      }
  }
}

struct ExercisesModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([Exercise].self)
      .sharedInScope()
      .to {
        let decoder = JSONDecoder()
        let data = try! Data(
          contentsOf: Bundle.module.url(forResource: "exercises", withExtension: "json")!
        )
        let decoded = try! decoder.decode([Exercise].self, from: data)
        return decoded
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

struct LicensesModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([License].self)
      .sharedInScope()
      .to {
        let decoder = JSONDecoder()
        let data = try! Data(
          contentsOf: Bundle.module.url(forResource: "licenses", withExtension: "json")!
        )
        let decoded = try! decoder.decode([License].self, from: data)
        return decoded
      }
  }
}

struct UnsplashModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind([Photo].self)
      .sharedInScope()
      .to {

        let decoder = JSONDecoder()
        let data = try! Data(
          contentsOf: Bundle.module.url(forResource: "unsplash", withExtension: "json")!
        )
        let decoded = try! decoder.decode([Photo].self, from: data)
        return decoded
      }
  }
}
