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

class ExercisesPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let level: Level
  private let exercises: [Exercise]

  init(level: Level, exercises: [Exercise]) {
    self.level = level
    self.exercises = exercises
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

    let readable = contentv.readableContentGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      title.topAnchor.constraint(equalTo: readable.topAnchor),
      title.leadingAnchor.constraint(equalTo: readable.leadingAnchor),

      tableView.topAnchor.constraint(equalTo: title.lastBaselineAnchor, constant: Kite.space.medium),
      tableView.leadingAnchor.constraint(equalTo: readable.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: readable.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: contentv.bottomAnchor),
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
    let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseRow.reuseId) as? ExerciseRow ?? ExerciseRow(frame: .zero)
    cell.accessoryType = .disclosureIndicator
    cell.bind(to: exercise)
    return cell
  }
}

extension ExercisesPage: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let exercise = exercises[indexPath.row]
    let vc = ExerciseContainer(level: level, exercise: exercise)
    show(vc, sender: self)
  }
}

class ExerciseRow: UITableViewCell {
  static let reuseId = "\(ExerciseRow.self)"

  private var name: UILabel!
  private var goal: UILabel!

  func bind(to exercise: Exercise) {
    name = Kite.title(text: exercise.name)
    goal = Kite.subhead(text: exercise.goal)
    backgroundColor = Kite.color.background
    contentView.addSubviews(name, goal)
    NSLayoutConstraint.activate([
      name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Kite.space.small),
      name.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Kite.space.medium),
      goal.topAnchor.constraint(equalTo: name.lastBaselineAnchor),
      goal.leadingAnchor.constraint(equalTo: name.leadingAnchor),
      goal.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Kite.space.small),
    ])
  }
}
