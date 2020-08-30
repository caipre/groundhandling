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
  enum views {
    static func background() -> UIView {
      let view = UIView(frame: .zero)
      view.backgroundColor = Kite.color.background
      return view
    }

    static func image(named name: String) -> UIImageView {
      let view = UIImageView(image: UIImage(named: name)!)
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      view.contentMode = .center
      return view
    }

    static func placeholder(name: String) -> UIView {
      let view = UIView(frame: .zero).rounded()
      view.translatesAutoresizingMaskIntoConstraints = false
      let name = Kite.caption(text: name)
      view.backgroundColor = Kite.color.inactive
      name.center(in: view)
      return view
    }
  }
}
