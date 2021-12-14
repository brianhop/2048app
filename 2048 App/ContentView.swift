//
//  ContentView.swift
//  assign3
//
//  Created by Brian Hopkins  on 10/10/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var twos: Twos = Twos()
    @State var startPoint: CGPoint = .zero
    @State var isDragging: Bool = true
    @State var showAlert: Bool = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        let scoresList = twos.scoreList
        let views : [TileView] = [TileView(id: 1),
                                  TileView(id: 2),
                                  TileView(id: 3),
                                  TileView(id: 4),
                                  TileView(id: 5),
                                  TileView(id: 6),
                                  TileView(id: 7),
                                  TileView(id: 8),
                                  TileView(id: 9),
                                  TileView(id: 10),
                                  TileView(id: 11),
                                  TileView(id: 12),
                                  TileView(id: 13),
                                  TileView(id: 14),
                                  TileView(id: 15),
                                  TileView(id: 16)]
        if (verticalSizeClass == .regular) {
            TabView {
                VStack {
                    Text("Score: \(twos.score)")
                        .padding()
                        .font(.title)
                        .animation(nil)
                    ZStack {
                        VStack {
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                        }
                        ForEach(0..<views.count, id: \.self) { i in
                            if !skipAnimation(id: i+1) {
                                views[i].environmentObject(twos).offset(x: getXOffSet(id: i+1), y: getYOffSet(id: i+1)).animation(.spring())
                            }
                        }
                    }.frame(width: 304, height: 304, alignment: .center)
                        .gesture(DragGesture(minimumDistance: 10.0, coordinateSpace: .global)
                                    .onChanged { v in
                                        if isDragging {
                                            startPoint = v.location
                                            isDragging.toggle()
                                        }
                                    }
                                    .onEnded {v in
                                        let x = abs(v.location.x - startPoint.x)
                                        let y = abs(v.location.y - startPoint.y)
                                        if startPoint.y > v.location.y && y > x {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.up) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        } else if startPoint.x > v.location.x && x > y {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.left) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        } else if startPoint.x < v.location.x && x > y {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.right) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        } else {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.down) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        }
                                        isDragging.toggle()
                        }).alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Game Over"),
                                message: Text("Final Score: \(twos.score)"),
                                dismissButton: .default(Text("Start New Game"), action: {
                                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                                        return lhs > rhs
                                    }
                                    twos.newgame(rand: twos.isRandom)
                                    twos.spawn()
                                    twos.spawn()
                                })
                            )
                        }
                    ButtonUp().environmentObject(twos)
                    HStack {
                        ButtonLeft().environmentObject(twos)
                        ButtonRight().environmentObject(twos)
                    }
                    ButtonDown().environmentObject(twos)
                    ButtonNewGame().environmentObject(twos)
                    SegmentedPicker().environmentObject(twos)
                }.tabItem {
                    Label("Board", systemImage: "gamecontroller")
                }
                VStack {
                    Text("Highest Scores")
                        .font(.largeTitle)
                        .bold()
                    List(0..<scoresList.count, id:\.self) { i in
                        Text("\(i+1))\t\t\(scoresList[i].score)\t\t\(scoresList[i].time)")
                    }
                }.tabItem {
                    Label("Scores", systemImage: "list.dash")
                }
                VStack {
                    aboutTab()
                }.tabItem {
                    Label("About", systemImage: "info.circle")
                }
            }
        } else {
            TabView {
                HStack {
                    Text("Score: \(twos.score)")
                        .padding()
                        .font(.title)
                        .animation(nil)
                    ZStack {
                        VStack {
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                            HStack {
                                gridBackground()
                                gridBackground()
                                gridBackground()
                                gridBackground()
                            }.frame(width: 304, height: 70, alignment: .center)
                        }
                        ForEach(0..<views.count, id: \.self) { i in
                            if !skipAnimation(id: i+1) {
                                views[i].environmentObject(twos).offset(x: getXOffSet(id: i+1), y: getYOffSet(id: i+1)).animation(.spring())
                            }
                        }
                    }.frame(width: 304, height: 304, alignment: .center)
                        .gesture(DragGesture(minimumDistance: 10.0, coordinateSpace: .global)
                                    .onChanged { v in
                                        if isDragging {
                                            startPoint = v.location
                                            isDragging.toggle()
                                        }
                                    }
                                    .onEnded {v in
                                        let x = abs(v.location.x - startPoint.x)
                                        let y = abs(v.location.y - startPoint.y)
                                        if startPoint.y > v.location.y && y > x {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.up) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        } else if startPoint.x > v.location.x && x > y {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.left) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        } else if startPoint.x < v.location.x && x > y {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.right) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        } else {
                                            withAnimation {
                                                if twos.collapse(dir: Direction.down) {
                                                    twos.spawn()
                                                    if twos.isGameOver() {
                                                        showAlert = true
                                                    }
                                                }
                                            }
                                        }
                                        isDragging.toggle()
                        }).alert(isPresented: $showAlert) {
                            Alert(
                                title: Text("Game Over"),
                                message: Text("Final Score: \(twos.score)"),
                                dismissButton: .default(Text("Start New Game"), action: {
                                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                                        return lhs > rhs
                                    }
                                    twos.newgame(rand: twos.isRandom)
                                    twos.spawn()
                                    twos.spawn()
                                })
                            )
                        }
                    VStack {
                        ButtonUp().environmentObject(twos)
                        HStack {
                            ButtonLeft().environmentObject(twos)
                            ButtonRight().environmentObject(twos)
                        }
                        ButtonDown().environmentObject(twos)
                        ButtonNewGame().environmentObject(twos)
                        SegmentedPicker().environmentObject(twos)
                    }
                }.tabItem {
                    Label("Board", systemImage: "gamecontroller")
                }
                VStack {
                    Text("Highest Scores")
                        .font(.largeTitle)
                        .bold()
                    List(0..<scoresList.count, id:\.self) { i in
                        Text("\(i+1))\t\t\(scoresList[i].score)\t\t\(scoresList[i].time)")
                    }
                }.tabItem {
                    Label("Scores", systemImage: "list.dash")
                }
                VStack {
                    aboutTab()
                }.tabItem {
                    Label("About", systemImage: "info.circle")
                }
            }
        }
    }
    
    func getXOffSet(id: Int) -> CGFloat {
        return CGFloat(twos.getTile(id: id).lastCol) * 78.0
    }
    func getYOffSet(id: Int) -> CGFloat {
        return CGFloat(twos.getTile(id: id).lastRow) * 78.0
    }
    func skipAnimation(id: Int) -> Bool {
        let v = twos.getTile(id: id).val
        if v == 0 {
            return true
        } else {
            return false
        }
    }
}


struct ButtonUp : View {
    @EnvironmentObject var twos: Twos
    @State private var showAlert = false
    
    var body: some View {
        Button("Up") {
            withAnimation {
                if twos.collapse(dir: Direction.up) {
                    twos.spawn()
                    if twos.isGameOver() {
                        showAlert = true
                    }
                }
            }
        }
        .font(.title)
        .frame(width: 100, height: 50, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(lineWidth: 3.5).foregroundColor(Color.blue))
        .padding(2)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Final Score: \(twos.score)"),
                dismissButton: .default(Text("Start New Game"), action: {
                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                        return lhs > rhs
                    }
                    twos.newgame(rand: twos.isRandom)
                    twos.spawn()
                    twos.spawn()
                })
            )
        }
    }
}

struct ButtonLeft : View {
    @EnvironmentObject var twos: Twos
    @State private var showAlert = false
    
    var body: some View {
        Button("Left") {
            withAnimation {
                if twos.collapse(dir: Direction.left) {
                    twos.spawn()
                    if twos.isGameOver() {
                        showAlert = true
                    }
                }
            }
        }
        .font(.title)
        .frame(width: 100, height: 50, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(lineWidth: 3.5).foregroundColor(Color.blue))
        .padding(2)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Final Score: \(twos.score)"),
                dismissButton: .default(Text("Start New Game"), action: {
                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                        return lhs > rhs
                    }
                    twos.newgame(rand: twos.isRandom)
                    twos.spawn()
                    twos.spawn()
                })
            )
        }
    }
}

struct ButtonRight : View {
    @EnvironmentObject var twos: Twos
    @State private var showAlert = false
    
    var body: some View {
        Button("Right") {
            withAnimation {
                if twos.collapse(dir: Direction.right) {
                    twos.spawn()
                    if twos.isGameOver() {
                        showAlert = true
                    }
                }
            }
        }
        .font(.title)
        .frame(width: 100, height: 50, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(lineWidth: 3.5).foregroundColor(Color.blue))
        .padding(2)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Final Score: \(twos.score)"),
                dismissButton: .default(Text("Start New Game"), action: {
                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                        return lhs > rhs
                    }
                    twos.newgame(rand: twos.isRandom)
                    twos.spawn()
                    twos.spawn()
                })
            )
        }
    }
}

struct ButtonDown : View {
    @EnvironmentObject var twos: Twos
    @State private var showAlert = false
    
    var body: some View {
        Button("Down") {
            withAnimation {
                if twos.collapse(dir: Direction.down) {
                    twos.spawn()
                    if twos.isGameOver() {
                        showAlert = true
                    }
                }
            }
        }
        .font(.title)
        .frame(width: 100, height: 50, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(lineWidth: 3.5).foregroundColor(Color.blue))
        .padding(2)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Final Score: \(twos.score)"),
                dismissButton: .default(Text("Start New Game"), action: {
                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                        return lhs > rhs
                    }
                    twos.newgame(rand: twos.isRandom)
                    twos.spawn()
                    twos.spawn()
                })
            )
        }
    }
}

struct ButtonNewGame : View {
    @EnvironmentObject var twos: Twos
    @State private var showAlert = false
    
    var body: some View {
        Button("New Game") {
            showAlert = true
        }
        .font(.title)
        .frame(width: 200, height: 50, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 20.0).stroke(lineWidth: 3.5).foregroundColor(Color.blue))
        .padding(2)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Game Over"),
                message: Text("Final Score: \(twos.score)"),
                dismissButton: .default(Text("Start New Game"), action: {
                    twos.scoreList.append(Score(score: twos.score, time: Date()))
                    twos.scoreList.sort { (lhs: Score, rhs: Score) -> Bool in
                        return lhs > rhs
                    }
                    twos.newgame(rand: twos.isRandom)
                    twos.spawn()
                    twos.spawn()
                })
            )
        }
    }

    func f() {
        twos.newgame(rand: twos.isRandom)
        twos.spawn()
        twos.spawn()
    }
}

struct SegmentedPicker : View {
    @EnvironmentObject var twos: Twos
    
    var body: some View {
        Picker("Randomized or Deterministic", selection: $twos.isRandom, content: {
            Text("Random").tag(true)
            Text("Determ").tag(false)
        }).pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

struct gridBackground : View {
    var body: some View {
        Text("")
            .frame(width: 70, height: 70, alignment: .center)
            .background(Color.gray)
            .cornerRadius(15.0)
    }
}

struct TileView : View {
    @EnvironmentObject var twos : Twos
    let id : Int
    
    init(id: Int) {
        self.id = id
    }

    var body : some View {
        let tile = twos.getTile(id: id)
        let num = tile.val
        
        if num != 0 {
            let colorNum: Int = ((Int(log2(Double(num))) - 1) % 7)
            if colorNum == 0 {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.green)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            } else if colorNum == 1 {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            } else if colorNum == 2 {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.purple)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            } else if colorNum == 3 {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.pink)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            } else if colorNum == 4 {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.red)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            } else if colorNum == 5 {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.orange)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            } else {
                Text("\(num)")
                    .font(.title)
                    .bold()
                    .frame(width: 70, height: 70, alignment: .center)
                    .background(Color.yellow)
                    .cornerRadius(15.0)
                    .position(x: 35.0, y: 35.0)
            }
        }
    }
}

struct aboutTab : View {
    @State var size = 100.0
    @State var growOrShrink = true
    @State var t: Int = 10
    @State var isEnabled = false
    @State var s: String = "Tap Me"
    @State var a: Animation? = nil
    @State var c: Color = .black
    var body: some View {
        let timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()

        Button(action: {
            if !isEnabled {
                isEnabled = true
            } else {
                isEnabled = false
                size = 100.0
                c = .black
                s = "Tap Me"
                a = .linear
            }
        }) {
            Text(s)
                .font(.title)
                .foregroundColor(c)
                .frame(width: size, height: size)
                .background(Color.red)
                .clipShape(Circle())
                .onReceive(timer) { _ in
                    if isEnabled {
                        if t > 0 {
                            t -= 1
                            s = "\(t)"
                            f()
                        } else {
                            size = 3000.0
                            a = Animation.easeIn(duration: 0.5).delay(1.25)
                        }
                    }
                }
                .animation(a, value: size)
        }.buttonStyle(PlainButtonStyle())
    }
    func f() {
        if t > 0 {
            a = Animation.easeInOut(duration: 1)
            if growOrShrink {
                size = 400.0 - Double((27*t))
                c = .white
            } else {
                size = 100.0
                c = .black
            }
            growOrShrink.toggle()
        } else if t == 0 {
            s = ""
            size = 30
            a = Animation.easeInOut(duration: 2.0)
        }
    }
}
