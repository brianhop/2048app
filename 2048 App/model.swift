//
//  model.swift
//  assign3
//
//  Created by Brian Hopkins  on 10/10/21.
//

import Foundation

class Twos: ObservableObject {
    @Published var board: [[Tile]]  // must be init'd, but contents overwritten
    @Published var score: Int = 0
    @Published var scoreList: [Score] = [Score(score: 400, time: Date()), Score(score: 300, time: Date())]
    var seededGenerator: SeededGenerator
    var isRandom: Bool
    
    init() {
        board = [[Tile(v: 0, i: 1, r: 0, c: 0),Tile(v: 0, i: 2, r: 0, c: 1),Tile(v: 0, i: 3, r: 0, c: 2),Tile(v: 0, i: 4, r: 0, c: 3)],
                 [Tile(v: 0, i: 5, r: 1, c: 0),Tile(v: 0, i: 6, r: 1, c: 1),Tile(v: 0, i: 7, r: 1, c: 2),Tile(v: 0, i: 8, r: 1, c: 3)],
                 [Tile(v: 0, i: 9, r: 2, c: 0),Tile(v: 0, i: 10, r: 2, c: 1),Tile(v: 0, i: 11, r: 2, c: 2),Tile(v: 0, i: 12, r: 2, c: 3)],
                 [Tile(v: 0, i: 13, r: 3, c: 0),Tile(v: 0, i: 14, r: 3, c: 1),Tile(v: 0, i: 15, r: 3, c: 2),Tile(v: 0, i: 16, r: 3, c: 3)]]
        seededGenerator = SeededGenerator(seed: 14)
        isRandom = false
    }
    
    func newgame(rand: Bool) {
        board = [[Tile(v: 0, i: 1, r: 0, c: 0),Tile(v: 0, i: 2, r: 0, c: 1),Tile(v: 0, i: 3, r: 0, c: 2),Tile(v: 0, i: 4, r: 0, c: 3)],
                 [Tile(v: 0, i: 5, r: 1, c: 0),Tile(v: 0, i: 6, r: 1, c: 1),Tile(v: 0, i: 7, r: 1, c: 2),Tile(v: 0, i: 8, r: 1, c: 3)],
                 [Tile(v: 0, i: 9, r: 2, c: 0),Tile(v: 0, i: 10, r: 2, c: 1),Tile(v: 0, i: 11, r: 2, c: 2),Tile(v: 0, i: 12, r: 2, c: 3)],
                 [Tile(v: 0, i: 13, r: 3, c: 0),Tile(v: 0, i: 14, r: 3, c: 1),Tile(v: 0, i: 15, r: 3, c: 2),Tile(v: 0, i: 16, r: 3, c: 3)]]
        score = 0
        isRandom = rand
        if isRandom {
            seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
        } else { //deterministic
            seededGenerator = SeededGenerator(seed: 14)
        }
    }
    
    func getTile(id: Int) -> Tile {
        for row in board {
            for tile in row {
                if tile.id == id {
                    return tile
                }
            }
        }
        return Tile(v: -1, i: -1, r: -1, c: -1) //returned if given id does not exist, but in our implementation, this will never happen
    }
    
    
    func shiftLeft() {  // collapse to the left
        for i in 0..<4 {
            //first shift all numbers to the left
            var x = 0
            var y = 0
            while y < 4 {
                if x == y && board[i][x].val != 0 {
                    x += 1
                    y += 1
                } else {
                    if board[i][y].val != 0 {
                        let temp = board[i][x]
                        let tempRow = board[i][y].lastRow
                        let tempCol = board[i][y].lastCol
                        board[i][x] = board[i][y]
                        board[i][x].lastRow = temp.lastRow
                        board[i][x].lastCol = temp.lastCol
                        board[i][y] = temp
                        board[i][y].lastRow = tempRow
                        board[i][y].lastCol = tempCol
                        x += 1
                    }
                    y += 1
                }
            }
            //now combine numbers where appropriate
            for j in 0..<3 {
                if board[i][j].val != 0 && board[i][j].val == board[i][j+1].val {
                    score += (board[i][j].val * 2)
                    
                    let temp = board[i][j]
                    let tempRow = board[i][j+1].lastRow
                    let tempCol = board[i][j+1].lastCol
                    board[i][j] = board[i][j+1]
                    board[i][j].lastRow = temp.lastRow
                    board[i][j].lastCol = temp.lastCol
                    board[i][j].val = board[i][j].val * 2
                    board[i][j+1] = temp
                    board[i][j+1].lastRow = tempRow
                    board[i][j+1].lastCol = tempCol
                    board[i][j+1].val = 0
                }
            }
            
            //now shift all numbers to the left again to account for any spaces made when combining (but now we can start at column 1)
            x = 1
            y = 1
            while y < 4 {
                if x == y && board[i][x].val != 0 {
                    x += 1
                    y += 1
                } else {
                    if board[i][y].val != 0 {
                        let temp = board[i][x]
                        let tempRow = board[i][y].lastRow
                        let tempCol = board[i][y].lastCol
                        board[i][x] = board[i][y]
                        board[i][x].lastRow = temp.lastRow
                        board[i][x].lastCol = temp.lastCol
                        board[i][y] = temp
                        board[i][y].lastRow = tempRow
                        board[i][y].lastCol = tempCol
                        x += 1
                    }
                    y += 1
                }
            }
        }
    }
    
    func rightRotate() {  // define using only rotate2D
        board = rotate2D(input: board)
    }
    
    func collapse(dir: Direction) -> Bool {  // collapse in direction "dir" using only shiftLeft() and rightRotate()
        var temp: [[Tile]]
        var hasChanged: Bool = false
        if dir == .left {
            temp = board
            shiftLeft()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
        } else if dir == .down {
            rightRotate()
            temp = board
            shiftLeft()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
            rightRotate()
            rightRotate()
            rightRotate()
        } else if dir == .right {
            rightRotate()
            rightRotate()
            temp = board
            shiftLeft()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
            rightRotate()
            rightRotate()
        } else { //up
            rightRotate()
            rightRotate()
            rightRotate()
            temp = board
            shiftLeft()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
            rightRotate()
        }
        
        return hasChanged
    }
    
    func spawn() {
        //traverse the board, marking all open tiles
        var openTiles: [(Int, Int)] = []
        for i in 0..<4 {
            for j in 0..<4 {
                if board[i][j].val == 0 {
                    openTiles.append((i, j))
                }
            }
        }
        let size = openTiles.count
        
        if size > 0 {
            let newNum: Int = (Int.random(in:1...2, using: &seededGenerator)) * 2
            let index = Int.random(in: 0...(size-1), using: &seededGenerator)
            let i = openTiles[index].0
            let j = openTiles[index].1
            
            board[i][j].val = newNum
        }
    }
    
    func isGameOver() -> Bool {
        let tempBoard : [[Tile]] = board //deep copy to set board back to when done
        
        if test_collapse(dir: Direction.left) {
            board = tempBoard
            return false
        } else if test_collapse(dir: Direction.up) {
            board = tempBoard
            return false
        } else if test_collapse(dir: Direction.right) {
            board = tempBoard
            return false
        } else if test_collapse(dir: Direction.down) {
            board = tempBoard
            return false
        } else {
            return true
        }
    }
    
    func test_collapse(dir: Direction) -> Bool {  // collapse in direction "dir" using only shiftLeft() and rightRotate()
        var temp: [[Tile]]
        var hasChanged: Bool = false
        if dir == .left {
            temp = board
            shiftLeftNoScore()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
        } else if dir == .down {
            rightRotate()
            temp = board
            shiftLeftNoScore()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
            rightRotate()
            rightRotate()
            rightRotate()
        } else if dir == .right {
            rightRotate()
            rightRotate()
            temp = board
            shiftLeftNoScore()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
            rightRotate()
            rightRotate()
        } else { //up
            rightRotate()
            rightRotate()
            rightRotate()
            temp = board
            shiftLeftNoScore()
            if temp == board {
                hasChanged = false
            } else {
                hasChanged = true
            }
            rightRotate()
        }
        
        return hasChanged
    }
    
    func shiftLeftNoScore() {  // a version of shift left that doesn't keep score, used in test_colapse
        for i in 0..<4 {
            //first shift all numbers to the left
            var x = 0
            var y = 0
            while y < 4 {
                if x == y && board[i][x].val != 0 {
                    x += 1
                    y += 1
                } else {
                    if board[i][y].val != 0 {
                        let temp = board[i][x]
                        let tempRow = board[i][y].lastRow
                        let tempCol = board[i][y].lastCol
                        board[i][x] = board[i][y]
                        board[i][x].lastRow = temp.lastRow
                        board[i][x].lastCol = temp.lastCol
                        board[i][y] = temp
                        board[i][y].lastRow = tempRow
                        board[i][y].lastCol = tempCol
                        x += 1
                    }
                    y += 1
                }
            }
            //now combine numbers where appropriate
            for j in 0..<3 {
                if board[i][j].val != 0 && board[i][j].val == board[i][j+1].val {
                    let temp = board[i][j]
                    let tempRow = board[i][j+1].lastRow
                    let tempCol = board[i][j+1].lastCol
                    board[i][j] = board[i][j+1]
                    board[i][j].val = board[i][j].val * 2
                    board[i][j].lastRow = temp.lastRow
                    board[i][j].lastCol = temp.lastCol
                    board[i][j+1] = temp
                    board[i][j+1].val = 0
                    board[i][j+1].lastRow = tempRow
                    board[i][j+1].lastCol = tempCol
                }
            }
            
            //now shift all numbers to the left again to account for any spaces made when combining (but now we can start at column 1)
            x = 1
            y = 1
            while y < 4 {
                if x == y && board[i][x].val != 0 {
                    x += 1
                    y += 1
                } else {
                    if board[i][y].val != 0 {
                        let temp = board[i][x]
                        let tempRow = board[i][y].lastRow
                        let tempCol = board[i][y].lastCol
                        board[i][x] = board[i][y]
                        board[i][x].lastRow = temp.lastRow
                        board[i][x].lastCol = temp.lastCol
                        board[i][y] = temp
                        board[i][y].lastRow = tempRow
                        board[i][y].lastCol = tempCol
                        x += 1
                    }
                    y += 1
                }
            }
        }
    }
}




struct Tile: Equatable {
    var val : Int
    var id : Int
    var lastRow : Int
    var lastCol : Int
    init(v: Int, i: Int, r: Int, c: Int) {
        val = v
        id = i
        lastRow = r
        lastCol = c
    }
}

struct Score: Comparable {
    var score : Int
    var time : Date
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
    
    static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.score < rhs.score
    }
}

enum Direction {
   case left
   case right
   case up
   case down
}



// primitive functions
public func rotate2DInts(input: [[Int]]) ->[[Int]] { // rotate a square 2D Int array clockwise
    let length = input.count
    var res: [[Int]] = [[Int]](repeating: [Int](repeating: 0, count: length), count: length)
    
    for i in 0..<length/2 {
        for j in i..<length-1-i {
            res[j][length-1-i] = input[i][j]
            res[length-1-i][length-1-j] = input[j][length-1-i]
            res[length-1-j][i] = input[length-1-i][length-1-j]
            res[i][j] = input[length-1-j][i]
        }
    }
    return res
}
public func rotate2D<T>(input: [[T]]) ->[[T]] { // generic version of the above
    let length = input.count
    var temp: [[T?]] = [[T?]](repeating: [T?](repeating: nil, count: length), count: length)
    var res: [[T]] = []
    
    for i in 0..<length/2 {
        for j in i..<length-1-i {
            temp[j][length-1-i] = input[i][j]
            temp[length-1-i][length-1-j] = input[j][length-1-i]
            temp[length-1-j][i] = input[length-1-i][length-1-j]
            temp[i][j] = input[length-1-j][i]
        }
    }
    
    //now force unwrap every element in res
    for i in 0..<length {
        var t: [T] = []
        for j in 0..<length {
            t.append(temp[i][j]!)
        }
        res.append(t)
    }
    return res
}
