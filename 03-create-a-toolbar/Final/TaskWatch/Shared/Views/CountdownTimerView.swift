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

import SwiftUI
import CoreData

struct CountdownTimerView: View {
  
  let formatter: DateComponentsFormatter = {
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .pad
    formatter.allowedUnits = [.minute, .second]
    return formatter
  }()
  
  var task: Task
  @ObservedObject var timer: TimerWrapper
  @State var addingNewTask = false
  @EnvironmentObject var persistenceController: PersistenceController
  
  var body: some View {
    VStack {
      Text(String(formatter.string(from: timer.timeRemaining)!))
        .font(.system(size: 72).monospacedDigit())
      
      HStack {
        if timer.runningState == .stopped {
          Button("Start") {
            start()
          }
          .buttonStyle(CircleButtonStyle(bgColor: Color.green))
        } else if timer.runningState == .paused {
          Button("Resume") {
            start()
          }
          .buttonStyle(CircleButtonStyle(bgColor: Color.green))
        } else if timer.runningState == .running {
          Button("Pause") {
            pause()
          }
          .buttonStyle(CircleButtonStyle(bgColor: Color.yellow))
        }
        
        Spacer()
        
        Button("Cancel") {
          stop()
        }
        .buttonStyle(CircleButtonStyle(bgColor: Color.gray))
      }.padding()
        .navigationTitle(task.title)
        .toolbar {
          ToolbarItem {
            Button(action: {
              persistenceController.favorite(task: task)
            }) {
              Label(task.isFavorite ? "Unfavorite" : "Favorite", systemImage: task.isFavorite ? "heart.fill" : "heart")
                .foregroundColor(.pink)
            }
          }
        }
      Spacer()
     
    }
    
  }
}

extension CountdownTimerView {
  
  func start() {
    timer.start()
  }
  
  func pause() {
    timer.pause()
  }
  
  func stop() {
    timer.cancel()
  }
  
}

struct CountdownTimerView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      CountdownTimerView(task: Task(id: UUID(),
                                    title: "my title",
                                    timestamp: Date(),
                                    isFavorite: true),
                         timer: TimerWrapper()
      ).previewDevice("iPhone 11")
    }
  }
}
