static def readInput() {
    def input = new ArrayList<String>()
    new File("..\\..\\input.txt").withReader('UTF-8') { reader ->
        String line
        while ((line = reader.readLine()) != null) {
            input.add(line)
        }
    }
    return input;
}

static def parseMap(List<String> input) {
    def edges = new HashMap<String, List<String>>()
    for (line in input) {
        def s = line.split('-')
        edges.putIfAbsent(s[0], new ArrayList<String>())
        edges.putIfAbsent(s[1], new ArrayList<String>())
        edges[s[0]].add(s[1])
        edges[s[1]].add(s[0])
    }
    return edges
}

static boolean isLowerCase(String s) {
    for (int i = 0; i < s.length(); i++) {
        if (!Character.isLowerCase(s.charAt(i))) {
            return false;
        }
    }
    return true;
}

static def maxVisited(List<String> prev) {
    return prev.countBy { it }.values().max()
}

static def search(Map<String, List<String>> edges, String curr, List<String> prev) {
    if (isLowerCase(curr)) {
        prev += [curr]
    }
    if (curr == "end") {
        return 1
    }
    def total = 0
    for (neighbor in edges[curr]) {
        if (!prev.contains(neighbor) || (maxVisited(prev) == 1 && neighbor != "start")) {
            total += search(edges, neighbor, prev)
        }
    }
    return total
}

def input = readInput()
def map = parseMap(input)
print("Result: " + search(map, "start", []))
