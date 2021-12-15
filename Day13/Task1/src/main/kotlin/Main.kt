fun main() {
    val paper = Paper.parse("..\\input.txt", 1400)
    println("First fold count: ${paper.fold().first().countActive()}")
}
