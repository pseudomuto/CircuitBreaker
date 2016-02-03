//
//  Sync.swift
//  Pods
//
//  Created by David Muto on 2016-02-02.
//
//

class Sync {
  static func lock(thing: AnyObject!, block: () -> Void) {
    objc_sync_enter(thing)
    defer { objc_sync_exit(thing) }
    
    block()
  }
}
