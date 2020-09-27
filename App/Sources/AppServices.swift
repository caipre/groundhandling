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

struct AppServices {
  static var shared: AppServices!

  let location: LocationService
}

struct AppServicesComponent: Cleanse.RootComponent {
  typealias Root = AppServices

  static func configureRoot(binder bind: ReceiptBinder<AppServices>) -> BindingReceipt<AppServices>
  {
    bind.to(factory: AppServices.init)
  }

  static func configure(binder: Binder<Singleton>) {
    binder.include(module: LocationServiceModule.self)
  }
}

struct LocationServiceModule: Cleanse.Module {
  static func configure(binder: Binder<Singleton>) {
    binder.bind(LocationService.self)
      .sharedInScope()
      .to(factory: LocationServiceImpl.init)
  }
}
