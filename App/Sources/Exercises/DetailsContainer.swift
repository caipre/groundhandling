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

class DetailsContainer: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var pagesvc: UIPageViewController = {
    let vc = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )
    vc.dataSource = self
    vc.setViewControllers(
      [controllers.first!],
      direction: .forward,
      animated: false,
      completion: nil
    )
    addChild(vc)
    return vc
  }()
  lazy var controllers: [UIViewController] =
    [
      DetailsPage(exercise: exercise),
      HistoryPage(exercise: exercise, records: records),
    ]
  var idx = 0

  private let exercise: Exercise
  private let records: [Record]

  init(exercise: Exercise, records: [Record]) {
    self.exercise = exercise
    self.records = records
    super.init(nibName: nil, bundle: nil)

    let appearance = UIPageControl.appearance()
    appearance.pageIndicatorTintColor = Kite.color.inactive
    appearance.currentPageIndicatorTintColor = Kite.color.active
  }

  override func loadView() {
    let view = Kite.views.background()
    view.directionalLayoutMargins = Kite.margins.directional

    let title = Kite.largeTitle(text: exercise.name)
    let levelv = Kite.label(text: "Level \(exercise.levelId)")
    let pagesv = pagesvc.view!
    pagesv.translatesAutoresizingMaskIntoConstraints = false
    view.addSubviews(pagesv, title, levelv)

    let layout = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      levelv.lastBaselineAnchor.constraint(equalTo: title.topAnchor, constant: Kite.space.xsmall),
      levelv.leadingAnchor.constraint(equalTo: layout.leadingAnchor),

      title.topAnchor.constraint(equalTo: layout.topAnchor),
      title.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      title.trailingAnchor.constraint(equalTo: layout.trailingAnchor),

      pagesv.topAnchor.constraint(equalTo: title.lastBaselineAnchor),
      pagesv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      pagesv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      pagesv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    self.view = view
  }
}

extension DetailsContainer: UIPageViewControllerDataSource {
  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerBefore viewController: UIViewController
  ) -> UIViewController? {
    let first = controllers.first!
    if viewController == first {
      return nil
    } else {
      idx = 0
      return first
    }
  }

  func pageViewController(
    _ pageViewController: UIPageViewController,
    viewControllerAfter viewController: UIViewController
  ) -> UIViewController? {
    let last = controllers.last!
    if viewController == last {
      return nil
    } else {
      idx = 1
      return last
    }
  }

  func presentationCount(for pageViewController: UIPageViewController) -> Int {
    2
  }

  func presentationIndex(for pageViewController: UIPageViewController) -> Int {
    return idx
  }
}
