class Fish:
    timer = 0

    def __init__(self, timer: int):
        self.timer = timer

    def tick(self) -> bool:
        self.timer -= 1
        if self.timer == -1:
            self.timer = 6
            return True
        return False


def read_seed() -> list:
    first = open('..\\input.txt', 'r').readlines()[0]
    split = first.split(",")
    return list(map(lambda x: int(x), split))


def tick(fish: list[Fish]):
    new = list[Fish]()
    for f in fish:
        if f.tick():
            new.append(Fish(8))
    fish += new


def main():
    fish = list[Fish](map(lambda t: Fish(t), read_seed()))
    for x in range(80):
        print("Tick: " + str(x))
        tick(fish)
    print("Fish count: " + str(len(fish)))


main()
