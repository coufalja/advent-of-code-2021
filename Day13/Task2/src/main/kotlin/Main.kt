fun main() {
    val paper = Paper.parse("..\\input.txt", 1400)
    println("The code:")
    val last = paper.fold().last()
    for (y in last.points.indices) {
        if (y >= 6) break
        for (x in last.points[y].indices) {
            if (x >= 40) break
            when {
                last.points[y][x] -> print("#")
                else -> print(" ")
            }
        }
        println()
    }
}
