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

    emptyLabel = Kite.subhead(text: "challenge.history.empty".l)

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

    let text: String
    if let locality = record.placemark?.locality,
      let administrativeArea = record.placemark?.administrativeArea
    {
      text = "\(locality), \(administrativeArea)"
    } else {
      text = "challenge.history.location.empty".l
    }
    let location = Kite.headline(text: text)
    let date = Kite.subhead(
      text: DateFormatter.localizedString(from: record.date, dateStyle: .long, timeStyle: .none)
    )
    let windLabel = Kite.caption(text: "challenge.history.wind".l)
    let wind = Kite.subhead(text: "\(record.conditions?.windSpeed)")
    let wingLabel = Kite.caption(text: "challenge.history.wing".l)
    let wing = Kite.subhead(text: "\(record.wing.brand) \(record.wing.name)")

    //    map.translatesAutoresizingMaskIntoConstraints = false
    //    map.rounded()
    //    if let coordinate = record.placemark?.location?.coordinate {
    //      map.setCenter(coordinate, animated: false)
    //      let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
    //      map.setRegion(map.regionThatFits(region), animated: false)
    //    } else {
    //      map.isHidden = true
    //    }

    //    let comments = Kite.body(text: record.comment ?? "")
    //    comments.isHidden = comments.text.isEmpty

    contentView.addSubviews(location, date, windLabel, wind, wingLabel, wing)  //, map, comments)
    let layout = contentView.layoutMarginsGuide
    NSLayoutConstraint.activate([
      location.topAnchor.constraint(equalTo: layout.topAnchor),
      location.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      location.trailingAnchor.constraint(
        equalTo: layout.centerXAnchor,
        constant: Kite.space.medium
      ),

      date.topAnchor.constraint(equalTo: location.bottomAnchor),
      date.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      date.trailingAnchor.constraint(equalTo: layout.centerXAnchor),

      windLabel.bottomAnchor.constraint(equalTo: wind.topAnchor, constant: -Kite.space.xsmall),
      windLabel.leadingAnchor.constraint(
        equalTo: location.trailingAnchor,
        constant: Kite.space.small
      ),
      //      windLabel.trailingAnchor.constraint(equalTo: wingLabel.leadingAnchor, constant: Kite.space.xsmall),

      wingLabel.bottomAnchor.constraint(equalTo: wing.topAnchor, constant: -Kite.space.xsmall),
      wingLabel.leadingAnchor.constraint(
        equalTo: windLabel.trailingAnchor,
        constant: Kite.space.small
      ),
      //      wingLabel.trailingAnchor.constraint(equalTo: layout.trailingAnchor),

      wind.leadingAnchor.constraint(equalTo: windLabel.leadingAnchor),
      wind.lastBaselineAnchor.constraint(equalTo: date.lastBaselineAnchor),

      wing.leadingAnchor.constraint(equalTo: wingLabel.leadingAnchor),
      wing.lastBaselineAnchor.constraint(equalTo: date.lastBaselineAnchor),

      date.bottomAnchor.constraint(equalTo: layout.bottomAnchor),

      //      map.topAnchor.constraint(equalTo: date.bottomAnchor, constant: Kite.space.xsmall),
      //      map.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      //      map.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
      //
      //      comments.topAnchor.constraint(equalTo: map.bottomAnchor, constant: Kite.space.xsmall),
      //      comments.leadingAnchor.constraint(equalTo: layout.leadingAnchor),
      //      comments.trailingAnchor.constraint(equalTo: layout.trailingAnchor),
    ])

    //    map.heightAnchor.constraint(equalToConstant: 200).isActive = !map.isHidden
    //    comments.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = !comments.isHidden
    //    map.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = comments.isHidden
    //    comments.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = map.isHidden
  }
}
