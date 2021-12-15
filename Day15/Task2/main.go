package main

import (
	"fmt"
	"github.com/fzipp/astar"
	"math"
	"os"
	"strconv"
	"strings"
)

const caveSize = 500

type point struct {
	x int
	y int
}

var possibleMoves = []point{
	{x: -1, y: 0},
	{x: 1, y: 0},
	{x: 0, y: -1},
	{x: 0, y: 1},
}

type cave [caveSize][caveSize]int

func (c *cave) get(x int, y int) (int, bool) {
	if x >= caveSize || x < 0 || y >= caveSize || y < 0 {
		return 0, false
	}
	return c[x][y], true
}

func (c *cave) set(x int, y int, n int) {
	if x >= caveSize || x < 0 || y >= caveSize || y < 0 {
		return
	}
	c[x][y] = n
}

func (c *cave) Neighbours(n astar.Node) (neighbors []astar.Node) {
	s := n.(point)
	for _, move := range possibleMoves {
		_, ok := c.get(s.x+move.x, s.y+move.y)
		if !ok {
			continue
		}
		neighbors = append(neighbors, point{x: s.x + move.x, y: s.y + move.y})
	}
	return
}

func (c *cave) DirectCost(_ astar.Node, b astar.Node) float64 {
	toSpot := b.(point)
	r, _ := c.get(toSpot.x, toSpot.y)
	return float64(r)
}

func (c *cave) EstimatedCost(a astar.Node, b astar.Node) float64 {
	x1 := a.(point).x
	x2 := b.(point).x
	y1 := a.(point).y
	y2 := b.(point).y
	return math.Abs(float64(x2-x1)) + math.Abs(float64(y2-y1))
}

func grow(seed [100][100]int) cave {
	var result cave
	w := caveSize / 5
	h := caveSize / 5
	for rX := 0; rX < 5; rX++ {
		for rY := 0; rY < 5; rY++ {
			for x := 0; x < w; x++ {
				for y := 0; y < h; y++ {
					v := seed[x][y]

					var back int
					var ok bool
					if rX > 0 {
						back, ok = result.get(w*(rX-1)+x, w*rY+y)
					} else if rY > 0 {
						back, ok = result.get(w*rX+x, w*(rY-1)+y)
					}

					if ok {
						v = back + 1
						if v == 10 {
							v = 1
						}
					}
					result.set(w*rX+x, h*rY+y, v)
				}
			}
		}
	}
	return result
}

func main() {
	bytes, _ := os.ReadFile("..\\input.txt")
	var parsed [100][100]int
	lines := strings.Split(string(bytes), "\n")
	for i, line := range lines {
		if line != "" {
			for j, num := range strings.Split(line, "") {
				atoi, err := strconv.Atoi(num)
				if err != nil {
					break
				}
				parsed[i][j] = atoi
			}
		}
	}
	c := grow(parsed)
	path := astar.FindPath(&c, point{x: 0, y: 0}, point{x: caveSize - 1, y: caveSize - 1}, c.DirectCost, c.EstimatedCost)
	fmt.Printf("Result: %d\n", int(path.Cost(c.DirectCost)))
}
