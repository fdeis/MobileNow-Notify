//
//  json.swift
//  MobileNow Notifier
//
//  Created by Federico Deis on 2/13/23.
//

import Foundation

struct Response: Decodable {
  let steps: [Steps]
}

struct Steps: Decodable {
  let Path: String
  let Label: String
}
