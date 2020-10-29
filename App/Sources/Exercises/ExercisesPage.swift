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

import CoreLocation
import Kite
import UIKit

protocol ExercisesPageDelegate {
  func show(page: PageId.Challenge)
}

class ExercisesPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var delegate: ExercisesPageDelegate?

  private let level: Level
  private let exercises: [Exercise]
  private let repository: Repository

  init(level: Level, exercises: [Exercise], repository: Repository) {
    self.level = level
    self.exercises = exercises
    self.repository = repository
    super.init(nibName: nil, bundle: nil)
    modalPresentationStyle = .fullScreen
  }

  private var tableView: UITableView!
  private var tableHeight: NSLayoutConstraint!

  override func loadView() {
    let view = Kite.views.background()

    let scrollv = UIScrollView(frame: .zero)
    scrollv.pin(to: view)

    let contentv = UIView(frame: .zero)
    contentv.directionalLayoutMargins = Kite.margins.directional
    contentv.pin(to: scrollv)

    let title = Kite.largeTitle(text: "Level \(level.id)")
    tableView = UITableView(frame: .zero, style: .plain)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
    tableView.isScrollEnabled = false
    contentv.addSubviews(title, tableView)

    let layout = contentv.layoutMarginsGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      title.topAnchor.constraint(equalTo: layout.topAnchor),
      title.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      title.trailingAnchor.constraint(equalTo: layout.trailingAnchor),

      tableView.topAnchor.constraint(
        equalTo: title.lastBaselineAnchor,
        constant: Kite.space.medium
      ),
      tableView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
    ])

    tableHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    tableHeight.isActive = true

    self.view = view
  }

  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewDidLayoutSubviews() {
    super.updateViewConstraints()
    tableHeight.constant = tableView.contentSize.height
  }
}

extension ExercisesPage: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return exercises.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let exercise = exercises[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: ExerciseRow.reuseId) as? ExerciseRow
      ?? ExerciseRow(frame: .zero)
    cell.accessoryType = .disclosureIndicator
    let completed = !repository.fetchRecords(for: exercise).isEmpty
    cell.bind(to: exercise, completed: completed)
    return cell
  }
}

extension ExercisesPage: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let exercise = exercises[indexPath.row]
    delegate?.show(page: .details(exercise: exercise))
    tableView.deselectRow(at: indexPath, animated: false)
  }

  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(style: .normal, title: "challenge.exercises.complete".l) {
      action,
      view,
      fn in
      let exercise = self.exercises[indexPath.row]
      // todo: allow selecting active wing
      let wing = Current.repository.fetchWings()[0]
      var record = Record(exerciseId: exercise.id, wing: wing)
      if let placemark = Current.location.placemark {
        record.placemark = placemark
      }
      if let conditions = Current.weather.conditions {
        record.conditions = conditions
      }

      let result = self.repository.save(record: record)
      switch result {
      case .ok(_):
        fn(true)
        tableView.reloadRows(at: [indexPath], with: .top)
      case .err(let err):
        fn(false)
        print(err)
      }
    }

    action.backgroundColor = Kite.color.accent
    return UISwipeActionsConfiguration(actions: [action])
  }
}

class ExerciseRow: UITableViewCell {
  static let reuseId = "\(ExerciseRow.self)"

  func bind(to exercise: Exercise, completed: Bool = false) {
    backgroundColor = Kite.color.background

    let name = Kite.title(text: exercise.name)
    let goal = Kite.label(text: exercise.goal)
    let check = Kite.views.image(symbol: "checkmark")
    contentView.addSubviews(name, goal, check)

    check.isHidden = !completed

    let layout = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: layout.topAnchor, constant: Kite.space.xsmall),
      name.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      goal.topAnchor.constraint(equalTo: name.lastBaselineAnchor, constant: Kite.space.xsmall),
      goal.leadingAnchor.constraint(equalTo: name.leadingAnchor),
      goal.bottomAnchor.constraint(equalTo: layout.bottomAnchor, constant: -Kite.space.xsmall),
      check.trailingAnchor.constraint(equalTo: layout.trailingAnchor, constant: -Kite.space.small),
      check.centerYAnchor.constraint(equalTo: layout.centerYAnchor),
    ])
  }
}
