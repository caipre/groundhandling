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

class DetailsPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let exercise: Exercise

  init(exercise: Exercise) {
    self.exercise = exercise
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    let view = Kite.views.background()

    let scrollv = UIScrollView(frame: .zero)
    scrollv.pin(to: view)

    let contentv = UIView(frame: .zero)
    contentv.directionalLayoutMargins = Kite.margins.directional
    contentv.pin(to: scrollv)

    let image = Kite.views.image(named: exercise.id).rounded()
    image.contentMode = .scaleAspectFill
    let desc = Kite.body(text: exercise.desc)
    let goal = Kite.body(text: exercise.goal)
    let attrs = NSMutableAttributedString(
      string: "Objective: ",
      attributes: [.font: Kite.font(style: .body).bold]
    )
    attrs.append(
      NSAttributedString(string: exercise.goal, attributes: [.font: Kite.font(style: .body)])
    )
    goal.attributedText = attrs
    goal.textColor = Kite.color.primary
    contentv.addSubviews(image, desc, goal)

    let layout = contentv.layoutMarginsGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      image.topAnchor.constraint(equalTo: layout.topAnchor),
      image.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      image.heightAnchor.constraint(equalTo: image.widthAnchor),
      image.widthAnchor.constraint(equalTo: layout.widthAnchor, multiplier: 0.85),

      desc.topAnchor.constraint(equalTo: image.bottomAnchor, constant: Kite.space.medium),
      desc.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      desc.trailingAnchor.constraint(equalTo: layout.trailingAnchor),

      goal.topAnchor.constraint(equalTo: desc.lastBaselineAnchor, constant: Kite.space.medium),
      goal.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      goal.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      goal.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
    ])

    self.view = view
  }
}
