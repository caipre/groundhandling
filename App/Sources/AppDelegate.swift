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
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(
    _: UIApplication,
    didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let factoryc = try! ComponentFactory.of(AppContextComponent.self)
    AppContext.shared = factoryc.build(())

    let factorys = try! ComponentFactory.of(AppServicesComponent.self)
    AppServices.shared = factorys.build(())
    (AppServices.shared.location as! LocationServiceImpl).start()
    (AppServices.shared.location as! LocationServiceImpl).recv(msg: .requestAuth)
    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func applicationWillTerminate(_ application: UIApplication) {
    (AppContext.shared.repository as! FileSystemRepository).flush()
  }
}
