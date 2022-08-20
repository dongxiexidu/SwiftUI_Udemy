//
//  TimerBootCamp.swift
//  SwiftfulThinkingContinuedLearning
//
//  Created by Junyeong Park on 2022/08/20.
//

import SwiftUI

struct TimerBootCamp: View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var count: Int = 1
    @State private var finishedText: String? = nil
    @State private var timeRemaining = ""
    let futureData: Date = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    
    func updateTimeRemaining() {
        let remaining = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureData)
        let minute = remaining.minute ?? 0
        let second = remaining.second ?? 0
        timeRemaining = "\(minute) minutes \(second) seconds"
    }
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.purple, .indigo]), center: .center, startRadius: 5, endRadius: 500).ignoresSafeArea()
            VStack {
                Text("Time Remaining")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Text(timeRemaining)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                
                TabView(selection: $count) {
                    Rectangle()
                        .foregroundColor(.red)
                        .tag(1)
                    Rectangle()
                        .foregroundColor(.orange)
                        .tag(2)
                    Rectangle()
                        .foregroundColor(.yellow)
                        .tag(3)
                    Rectangle()
                        .foregroundColor(.green)
                        .tag(4)
                    Rectangle()
                        .foregroundColor(.blue)
                        .tag(5)
                }
                .frame(height: 200)
                .tabViewStyle(.page)
            }
            HStack(spacing: 15) {
                Circle()
                    .offset(y: count == 1 ? -20 : 0)
                Circle()
                    .offset(y: count == 2 ? -20 : 0)
                Circle()
                    .offset(y: count == 3 ? -20 : 0)
                Circle()
                    .offset(y: count == 4 ? -20 : 0)
                Circle()
                    .offset(y: count == 5 ? -20 : 0)
            }
            .frame(width: 200)
            .foregroundColor(.white)
        }
        .onAppear {
            updateTimeRemaining()
        }
        .onReceive(timer) { value in
            withAnimation(.default) {
                count = count == 5 ? 1 : count + 1
            }
            updateTimeRemaining()
        }
    }
}

struct TimerBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        TimerBootCamp()
    }
}
