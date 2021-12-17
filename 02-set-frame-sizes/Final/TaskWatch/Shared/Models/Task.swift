/// Copyright (c) 2021 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import CoreData


class TaskEntity: NSManagedObject {
  
  @NSManaged public var id: UUID
  @NSManaged public var title: String
  @NSManaged public var duration: Double
  @NSManaged public var timestamp: Date
  @NSManaged public var isFavorite: Bool
  
  override func awakeFromInsert() {
    super.awakeFromInsert()
    setPrimitiveValue(Date(), forKey: "timestamp")
    setPrimitiveValue(UUID(), forKey: "id")
    setPrimitiveValue(false, forKey: "isFavorite")
  }
  
}


struct Task: Identifiable {
  
  var id: UUID
  var title: String
  var duration: TimeInterval
  var timestamp: Date
  var isFavorite: Bool
  
  init(id: UUID,
       title: String,
       duration: TimeInterval = 0.0,
       timestamp: Date,
       isFavorite: Bool) {
    self.id = id
    self.title = title
    self.duration = duration
    self.timestamp = timestamp
    self.isFavorite = isFavorite
  }
}

extension Task {
  init(taskEntity: TaskEntity) {
    self.id = taskEntity.id
    self.title = taskEntity.title
    self.duration = taskEntity.duration
    self.timestamp = taskEntity.timestamp
    self.isFavorite = taskEntity.isFavorite
  }
  
}

