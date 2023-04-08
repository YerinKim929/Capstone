//
//  Extension.swift
//  CapstoneProject
//
//  Created by Yerin Kim on 2023/04/08.
//

import Foundation

extension Comparable {
  func clamped(to limits: ClosedRange<Self>) -> Self {
    min(max(self, limits.lowerBound), limits.upperBound)
  }
}
