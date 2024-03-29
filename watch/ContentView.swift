//
//  ContentView.swift
//  CilantroWYC-WatchCompanion WatchKit Extension
//
//  Created by Rohan Malik on 9/13/22.
//

import SwiftUI
import UserNotifications
func beginningTimeOfBlock() -> DateComponents {
    let cal = Calendar.current
    if nowIsBeforeBlockBegins(block: 0){
        let comp = DateComponents(calendar: cal, hour: 8, minute: 30, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 1){
        let comp = DateComponents(calendar: cal, hour: 8, minute: 40, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 2){
        let comp = DateComponents(calendar: cal, hour: 9, minute: 45, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 3){
        let comp = DateComponents(calendar: cal, hour: 10, minute: 45, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 4){
        let comp = DateComponents(calendar: cal, hour: 11, minute: 20, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 5){
        let comp = DateComponents(calendar: cal, hour: 12, minute: 25, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 6){
        let comp = DateComponents(calendar: cal, hour: 12, minute: 50, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 7){
        let comp = DateComponents(calendar: cal, hour: 13, minute: 35, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 8){
        let comp = DateComponents(calendar: cal, hour: 14, minute: 40, second:00)
        return comp
    } else if nowIsBeforeBlockBegins(block: 9){
        let comp = DateComponents(calendar: cal, hour: 15, minute: 0, second:00)
        return comp
    } else {
        let comp = DateComponents(calendar: cal, hour: 0, minute: 00, second:00)
        return comp
    }
}
func getTime(dc: DateComponents) -> String {
    
    var hr = String(dc.hour!)
    if hr.count == 1 {
        hr = "0" + hr
    }
    var mn = String(dc.minute!)
    if mn.count == 1 {
        mn = "0" + mn
    }
    var sc = String(dc.second!)
    if sc.count == 1 {
        sc = "0" + sc
    }
    
    if globalOffset != 0 {
        return "00:00:00"
    }
    
    return hr + ":" + mn + ":" + sc
}

func getOrder() -> Text {
    return getColor(Blk: 0) + Text("-") + getColor(Blk: 1) + Text("-") + getColor(Blk: 2) + Text("-") + getColor(Blk: 3) + Text("-") + getColor(Blk: 4)
}

func getColor(Blk: Int) -> Text {
    if globalOffset == 0{
        if nowIsBeforeBlockBegins(block: Blk){
            return Text(blocks[cycleDay]![Blk]).foregroundColor(.red).fontWeight(.light)
        } else {
            return Text(blocks[cycleDay]![Blk]).foregroundColor(.blue).fontWeight(.light)
        }
    } else {
        return Text(blocks[cycleDay]![Blk]).foregroundColor(.white).fontWeight(.light)
    }
}
func getNextClass() -> Text {
    if cycleDay == 0{
        return Text("None").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 0){
        return Text("First: House").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 1){
        return Text("Next: \(classes[cycleDay]![0])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 2){
        return Text("Next: \(classes[cycleDay]![1])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 3){
        return Text("Next: \(getMorningActivity())").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 4){
        return Text("Next: \(classes[cycleDay]![2])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 5){
        if getLunch(day: cycleDay, z: 1) == "Lunch"{
            return Text("Next: Lunch").foregroundColor(.green)
        } else {
            return Text("Next: \(classes[cycleDay]![3])").foregroundColor(.green)
        }
    } else if nowIsBeforeBlockBegins(block: 6){
        if getLunch(day: cycleDay, z: 2) == "Lunch"{
            return Text("Next: Lunch").foregroundColor(.green)
        } else {
            return Text("Next: \(classes[cycleDay]![3])").foregroundColor(.green)
        }
    } else if nowIsBeforeBlockBegins(block: 7){
        return Text("Next: \(classes[cycleDay]![4])").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 8){
        return Text("Next: Office Hours").foregroundColor(.green)
    } else if nowIsBeforeBlockBegins(block: 9){
        return Text("Next: " + sports[cycleDay]).foregroundColor(.green)
    } else {
        return Text("—").foregroundColor(.green)
    }
}
func getClasses() -> String {
    if let classList = classes[cycleDay]?.joined(separator: "\n") {
        return classList
    } else { return "e" }
}
func cycleDayDay() -> Text {
    if cycleDay == 0{
        return Text("No School!")
    }else{
        return Text("Day " + String(cycleDay))
    }
    
}

func getTimeUntilNextClass(dc: DateComponents, now: Date = Date()) -> DateComponents {
    var date = now
    let cal = Calendar.current
    if globalOffset != 0 {
        date = cal.date(byAdding: .day, value: globalOffset, to: date)!
    }
    let hr = dc.hour
    let mn = dc.minute
    let sc = dc.second
    let comp = DateComponents(calendar: cal, hour: hr, minute: mn, second:sc)
    let time = cal.nextDate(after: date, matching: comp, matchingPolicy: .nextTime)!
    let diff = cal.dateComponents([.hour, .minute, .second], from: date, to: time)
    return diff
}

var globalOffset = 0
var showTime = true
var TIME_TRAVEL_SLOWDOWN_FACTOR = 5.0
struct ContentView: View {
    @State var timeUntil = "00:00:00"
    @Environment(\.scenePhase) private var scenePhase
    @State var timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
    @State var opacity = 1.0
    @State var offset = 0
    @State var minOffset = 0.0
    @ObservedObject var CM = Connectivity.shared
    
    func getDate() -> String {
        var date = Date()
        let cal = Calendar.current
        if offset != 0 {
            date = cal.date(byAdding: .day, value: offset, to: date)!
        }
        let month = cal.component(.month, from: date)
        let day = cal.component(.day, from: date)
        let year = cal.component(.year, from: date)
        let weekday = cal.component(.weekday, from: date)
        return "\(cal.shortWeekdaySymbols[weekday-1]), \(cal.shortMonthSymbols[month-1]) \(day), \(year)"
    }
    
    func timeTravelBlockBegin(block: Int) -> Bool{
        let cal = Calendar.current
        let date = cal.date(byAdding: .minute, value: Int(floor(minOffset / TIME_TRAVEL_SLOWDOWN_FACTOR)), to: Date())!
        let hr = cal.component(.hour, from: date)
        let min = cal.component(.minute, from: date)
        if block == 9 { //before sports or go home
            return isAfter(hour1: hr,minute1: min,hour2: 15,minute2: 00)
        } else if block == 8 { //before office hours
            return isAfter(hour1: hr,minute1: min,hour2: 14,minute2: 40)
        } else if block == 7 { //before d block on day 1
            return isAfter(hour1: hr,minute1: min,hour2: 13,minute2: 35)
        } else if block == 6 { //before Z2
            return isAfter(hour1: hr,minute1: min,hour2: 12,minute2: 50)
        } else if block == 5 { //before Z1
            return isAfter(hour1: hr,minute1: min,hour2: 12,minute2: 25)
        } else if block == 4 {// before c block
            return isAfter(hour1: hr,minute1: min,hour2: 11,minute2: 20)
        } else if block == 3 {// before morning activity
            return isAfter(hour1: hr,minute1: min,hour2: 10,minute2: 20)
        } else if block == 2 { //before b block
            return isAfter(hour1: hr,minute1: min,hour2: 9,minute2: 45)
        }else if block == 1 { //before a block on day 1
            return isAfter(hour1: hr,minute1: min,hour2: 8,minute2: 40)
        } else if block == 0 { //before house
            return isAfter(hour1: hr, minute1: min, hour2: 8, minute2: 30)
        }
        return false
    }
    
    func timeTravelNextClass() -> Text {
        if cycleDay == 0{
            return Text("")
        } else if timeTravelBlockBegin(block: 0){
            return (Text("Before School")).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 1){
            return (Text(classes[cycleDay]![0])).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 2){
            return (Text(classes[cycleDay]![1])).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 3){
            return (Text(getMorningActivity())).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 4){
            return (Text(classes[cycleDay]![2])).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 5){
            if getLunch(day: cycleDay, z: 1) == "Lunch"{
                return (Text("Lunch")).foregroundColor(.purple)
            } else {
                return (Text("\(classes[cycleDay]![3])")).foregroundColor(.purple)
            }
        } else if timeTravelBlockBegin(block: 6){
            if getLunch(day: cycleDay, z: 2) == "Lunch"{
                return (Text("Lunch")).foregroundColor(.purple)
            } else {
                return (Text("\(classes[cycleDay]![3])")).foregroundColor(.purple)
            }
        } else if timeTravelBlockBegin(block: 7){
            return (Text(classes[cycleDay]![4])).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 8){
            return (Text("Office Hours")).foregroundColor(.purple)
        } else if timeTravelBlockBegin(block: 9){
            return (Text(sports[cycleDay])).foregroundColor(.purple)
        } else {
            return Text("After School").foregroundColor(.purple)
        }
    }
    
    func getTimeTravelTime() -> String {
        let cal = Calendar.current
        let date = cal.date(byAdding: .minute, value: Int(floor(minOffset / TIME_TRAVEL_SLOWDOWN_FACTOR)), to: Date())!
        let hr = cal.component(.hour, from: date)
        let min = cal.component(.minute, from: date)
        return "\(hr < 10 ? "0" : "")\(hr):\(min < 10 ? "0" : "")\(min)"
    }
    
    // delays the execution of the given code by the given time interval
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    // returns to the current day after time travel
    func returnToCurrent() {
        var delay = 0.1
        var initialOffset = offset
        while initialOffset != 0 {
            if initialOffset < 0 {
                delayWithSeconds(delay) { offset += 1; globalOffset += 1 }
                initialOffset += 1
            } else {
                delayWithSeconds(delay) { offset -= 1; globalOffset -= 1}
                initialOffset -= 1
            }
            delay += 0.15
            delayWithSeconds(delay) { opacity = 1 }
        }
    }
    
    // --- COMPONENTS ---
    
    func timeTravelComponent() -> some View {
        return Group {
            Spacer()
            cycleDayDay().font(.title).fontWeight(.heavy).multilineTextAlignment(.center)
            timeTravelNextClass().fontWeight(.heavy)
            Text("Time: " + getTimeTravelTime()).fontWeight(.semibold)
            Text(getDate())
            Text("e").foregroundColor(.black)
            Spacer()
            Button(action: { opacity = 0; delayWithSeconds(0.3) { opacity = 1 }; delayWithSeconds(0.2) { minOffset = 0 } }) {
                Text("Return to Present").fontWeight(.heavy)
            }
        }
    }
    
    func classTimeComponents() -> some View {
        return Group {
            getNextClass().fontWeight(.heavy)
            Text(timeUntil).fontWeight(.light).foregroundColor(offset == 0 ? .white : .black).onReceive(timer, perform: {_ in timeUntil = getTime(dc: getTimeUntilNextClass(dc: beginningTimeOfBlock()))}).onChange(of: scenePhase, perform: { phase in
                if phase == .active {
                    timeUntil = getTime(dc: getTimeUntilNextClass(dc: beginningTimeOfBlock()))
                    timer = Timer.publish(every: 1, on: .current, in: .common).autoconnect()
                } else { timer.upstream.connect().cancel() }})
        }
    }
    
    func getNavDate() -> DateComponents {
        var date = Date()
        let cal = Calendar.current
        if globalOffset != 0 {
            date = cal.date(byAdding: .day, value: globalOffset, to: date)!
        }
        return DateComponents(calendar: Calendar.current, month: cal.component(.month, from: date), day: cal.component(.day, from: date))
    }
    
    var body: some View {
        VStack{
            if globalOffset == 0 && minOffset != 0 && cycleDay != 0{
                // *** TIME TRAVEL VIEW ***
                timeTravelComponent()
                // *** END TIME TRAVEL VIEW ***
            } else {
                Spacer()
//                Button(action: { showTime.toggle() }) {
//                (cycleDayDay().font(.title).fontWeight(.heavy).multilineTextAlignment(.center)).onTapGesture(count: 3){ showTime.toggle()
//                    print("workedyay")
//                }
//                }.buttonStyle(DefaultButtonStyle())
                cycleDayDay().font(.title).fontWeight(.heavy).multilineTextAlignment(.center)
                if globalOffset == 0 && !schoolDone() && showTime{
                    classTimeComponents()
                } else if globalOffset != 0 {
                    Text(getRelativeDayText()).foregroundColor(.purple).fontWeight(abs(globalOffset) == 1 ? .heavy : .regular)
                }
                
                Text("\(getDate())")
                if isSchoolDay() { getOrder() }
                if globalOffset == 0 { Spacer() }
                if isSchoolDay() { NavigationLink(destination: DayView(dtcp: getNavDate())){ Text(offset == 0 ? "Today" : "View Day").fontWeight(.heavy) } }
                else { Spacer() }
            }
        }.animation(nil, value: opacity).gesture(DragGesture(minimumDistance: 50, coordinateSpace: .global).onEnded({ value in
            let horiz = value.translation.width as CGFloat
            if horiz > 0 {  // right swipe
                opacity = 0
                delayWithSeconds(0.3) { minOffset = 0; offset -= 1; globalOffset -= 1}
            } else {  // left swipe
                opacity = 0
                delayWithSeconds(0.3) { minOffset = 0; offset += 1; globalOffset += 1}
            }
            delayWithSeconds(0.35) { opacity = 1 }
        }).onChanged({value in opacity = max(0, 1.0 - abs(value.translation.width/125))}))
        .opacity(opacity).animation(.easeInOut, value: opacity)
        .gesture(TapGesture(count: 2).onEnded({ returnToCurrent() }))
        .focusable().digitalCrownRotation($minOffset)
        .onChange(of: scenePhase, perform: { phase in if phase == .background { globalOffset = 0; offset = 0; minOffset = 0 } })
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



