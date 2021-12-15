import java.io.File

class Paper(val points: Array<BooleanArray>, private val folds: List<String>) {

    private fun foldX(maxX: Int, paper: Paper) {
        for (y in paper.points.indices) {
            for (x in paper.points[y].indices) {
                if (x <= maxX) {
                    continue
                }
                if (paper.points[y][x]) {
                    paper.points[y][maxX - (x - maxX)] = true
                    paper.points[y][x] = false
                }
            }
        }
    }

    private fun foldY(maxY: Int, paper: Paper) {
        for (y in paper.points.indices) {
            for (x in paper.points[y].indices) {
                if (y <= maxY) {
                    continue
                }
                if (paper.points[y][x]) {
                    paper.points[maxY - (y - maxY)][x] = true
                    paper.points[y][x] = false
                }
            }
        }
    }

    fun fold() = sequence {
        val newPaper = Paper(points.copyOf(), folds.subList(1, folds.size))
        for (f in folds) {
            val (axis, amount) = f.split("=")
            when (axis) {
                "x" -> foldX(amount.toInt(), newPaper)
                "y" -> foldY(amount.toInt(), newPaper)
            }
            yield(newPaper)
        }
    }

    fun countActive() = points.fold(0) { acc, li -> acc + li.filter { it }.size }

    companion object {
        fun parse(file: String, size: Int): Paper {
            val folds = mutableListOf<String>()
            val points = Array(size) { BooleanArray(size) { false } }
            File(file).forEachLine { li ->
                if (li.startsWith("fold along ")) {
                    folds.add(li.replace("fold along ", ""))
                } else if (li.isNotEmpty()) {
                    val parts = li.split(",")
                    points[parts[1].toInt()][parts[0].toInt()] = true
                }
            }
            return Paper(points, folds)
        }
    }
}


