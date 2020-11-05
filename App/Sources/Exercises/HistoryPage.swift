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
import MapKit
import UIKit

class HistoryPage: UIViewController {
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let exercise: Exercise
  private let records: [Record]

  init(exercise: Exercise, records: [Record]) {
    self.exercise = exercise
    self.records = records.sorted(by: { (a, b) in a.date > b.date })
    super.init(nibName: nil, bundle: nil)
  }

  private var emptyLabel: UILabel!
  private var tableView: UITableView!
  private var tableHeight: NSLayoutConstraint!

  override func loadView() {
    let view = Kite.views.background()

    let scrollv = UIScrollView(frame: .zero)
    scrollv.pin(to: view)

    let contentv = UIView(frame: .zero)
    contentv.directionalLayoutMargins = Kite.margins.directional
    contentv.pin(to: scrollv)

    emptyLabel = Kite.label(text: "challenge.history.empty".l)

    tableView = Kite.views.table()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 80
    tableView.allowsSelection = false
    contentv.addSubviews(emptyLabel, tableView)

    let layout = contentv.layoutMarginsGuide

    NSLayoutConstraint.activate([
      contentv.widthAnchor.constraint(equalTo: scrollv.widthAnchor),

      emptyLabel.topAnchor.constraint(equalTo: layout.topAnchor),
      emptyLabel.centerXAnchor.constraint(equalTo: contentv.centerXAnchor),
      emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

      tableView.topAnchor.constraint(equalTo: layout.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor),
    ])

    tableHeight = tableView.heightAnchor.constraint(equalToConstant: 0)
    tableHeight.isActive = true

    self.view = view
  }

  override func viewDidLoad() {
    emptyLabel.isHidden = records.count > 0
    tableView.isHidden = records.count == 0

    tableView.dataSource = self
    //    tableView.delegate = self
  }

  override func viewDidLayoutSubviews() {
    super.updateViewConstraints()
    tableHeight.constant = tableView.contentSize.height
  }
}

extension HistoryPage: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return records.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let record = records[indexPath.row]
    let cell =
      tableView.dequeueReusableCell(withIdentifier: RecordRow.reuseId) as? RecordRow
      ?? RecordRow(frame: .zero)
    cell.bind(to: record)
    return cell
  }
}

class RecordRow: UITableViewCell {
  static let reuseId = "\(RecordRow.self)"

  // todo: perhaps better to just link out to a map app
  //  let map: MKMapView = MKMapView(frame: .zero)

  func bind(to record: Record) {
    backgroundColor = Kite.color.background

    let dateText = DateFormatter.localizedString(
      from: record.date,
      dateStyle: .long,
      timeStyle: .none
    )
    let date = Kite.headline(text: dateText)
    contentView.addSubviews(date)

    var locationText = "challenge.history.location.empty".l
    if let locality = record.placemark?.locality,
      let administrativeArea = record.placemark?.administrativeArea
    {
      locationText = "\(locality), \(administrativeArea)"
    }
    let location = Kite.label(text: locationText)
    contentView.addSubviews(location)

    let windLabel = Kite.label(text: "challenge.history.wind".l)
    windLabel.font = windLabel.font.bold
    let windSpeedText =
      record.conditions?.windSpeed.description
      ?? "challenge.history.wind.empty".l
    let windSpeed = Kite.label(text: windSpeedText)
    let windAngleText =
      record.conditions?.windAngle.description
      ?? "challenge.history.wind.empty".l
    let windAngle = Kite.label(text: windAngleText)
    contentView.addSubviews(windLabel, windSpeed, windAngle)

    let wingLabel = Kite.label(text: "challenge.history.wing".l)
    wingLabel.font = wingLabel.font.bold
    let wing = Kite.label(text: "\(record.wing.name)")
    contentView.addSubviews(wingLabel, wing)

    let layout = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      date.topAnchor.constraint(equalTo: layout.topAnchor),
      date.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      date.trailingAnchor.constraint(equalTo: layout.centerXAnchor),

      location.topAnchor.constraint(equalTo: date.bottomAnchor),
      location.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      location.bottomAnchor.constraint(equalTo: layout.bottomAnchor),

      wingLabel.topAnchor.constraint(equalTo: layout.topAnchor),
      wingLabel.leadingAnchor.constraint(
        equalTo: layout.centerXAnchor,
        constant: Kite.space.xsmall
      ),

      wing.topAnchor.constraint(equalTo: wingLabel.topAnchor),
      wing.leadingAnchor.constraint(
        equalTo: wingLabel.trailingAnchor,
        constant: Kite.space.xsmall
      ),

      windLabel.topAnchor.constraint(equalTo: location.topAnchor),
      windLabel.leadingAnchor.constraint(equalTo: wingLabel.leadingAnchor),

      windSpeed.topAnchor.constraint(equalTo: windLabel.topAnchor),
      windSpeed.leadingAnchor.constraint(
        equalTo: windLabel.trailingAnchor,
        constant: Kite.space.xsmall
      ),

      windAngle.topAnchor.constraint(equalTo: windLabel.topAnchor),
      windAngle.leadingAnchor.constraint(
        equalTo: windSpeed.trailingAnchor,
        constant: Kite.space.xsmall
      ),
    ])
  }
}
