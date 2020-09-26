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

import UIKit

public extension Kite {
  enum margins {
    public static var directional: NSDirectionalEdgeInsets {
      NSDirectionalEdgeInsets(
        top: space.medium,
        leading: space.medium,
        bottom: space.medium,
        trailing: space.medium
      )
    }

    public static func of(space: CGFloat) -> NSDirectionalEdgeInsets {
      return NSDirectionalEdgeInsets(
        top: space,
        leading: space,
        bottom: space,
        trailing: space
      )
    }
  }

  enum space {
    public static let xsmall: CGFloat = 4
    public static let small: CGFloat = 16
    public static let medium: CGFloat = 24
    public static let large: CGFloat = 48
    public static let xlarge: CGFloat = 64
  }
}
