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
  public enum views {
    public static func background() -> UIView {
      let view = UIView(frame: .zero)
      view.backgroundColor = Kite.color.background
      return view
    }

    public static func image(named name: String) -> UIImageView {
      let view = UIImageView(image: UIImage(named: name)!)
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      view.contentMode = .center
      return view
    }

    public static func image(symbol name: String) -> UIImageView {
      let view = UIImageView(image: UIImage(systemName: name)!)
      view.translatesAutoresizingMaskIntoConstraints = false
      view.tintColor = Kite.color.secondary
      view.clipsToBounds = true
      view.contentMode = .center
      return view
    }

    public static func button(title: String, target: Any?, selector: Selector) -> UIButton {
      let view = UIButton(frame: .zero)
      view.setTitle(title, for: .normal)
      view.addTarget(target, action: selector, for: .touchUpInside)
      view.translatesAutoresizingMaskIntoConstraints = false
      view.setTitleColor(Kite.color.secondary, for: .normal)
      return view
    }

    public static func button(symbol name: String, target: Any?, selector: Selector) -> UIButton {
      let view = UIButton(frame: .zero)
      view.setImage(UIImage(systemName: name), for: .normal)
      view.addTarget(target, action: selector, for: .touchUpInside)
      view.translatesAutoresizingMaskIntoConstraints = false
      view.tintColor = Kite.color.secondary
      view.clipsToBounds = true
      view.contentMode = .center
      return view
    }

    public static func table() -> UITableView {
      let view = UITableView(frame: .zero, style: .plain)
      view.backgroundColor = Kite.color.background
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
    }

    public static func placeholder(name: String) -> UIView {
      let view = UIView(frame: .zero).rounded()
      view.translatesAutoresizingMaskIntoConstraints = false
      let name = Kite.caption(text: name)
      view.backgroundColor = Kite.color.inactive
      name.center(in: view)
      return view
    }
  }
}
