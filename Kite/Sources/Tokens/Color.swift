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

extension Kite {
  public enum color {
    public static let accent = KiteAsset.accent.color

    public static let primary = KiteAsset.primary.color
    public static let secondary = KiteAsset.secondary.color

    public static let background = KiteAsset.background.color

    public static let active = KiteAsset.controlActive.color
    public static let inactive = KiteAsset.controlInactive.color

    public static let ok = KiteAsset.resultOk.color
    public static let error = KiteAsset.resultError.color
  }
}
