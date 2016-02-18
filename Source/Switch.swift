//
//  Switch.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

public protocol Switch {
  func reset(fromState: State)
  func trip(fromState: State)
  func attempt(fromState: State)
}
