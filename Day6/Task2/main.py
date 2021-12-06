def read_seed() -> list[int]:
    first = open('..\\input.txt', 'r').readlines()[0]
    split = first.split(",")
    return list[int](map(lambda x: int(x), split))


def init_group(fish_seed: list[int]) -> dict[int, int]:
    group = dict()
    for x in range(9):
        group[x] = 0
    for s in fish_seed:
        group[s] += 1
    return group


def sum_groups(fish_groups: dict[int, int]) -> int:
    count = 0
    for g in fish_groups.values():
        count += g
    return count


def tick(x: int, fish_groups: dict[int, int]):
    prev = fish_groups.copy()

    roll_key = (x + 7) % 9
    current_key = x % 9
    fish_groups[roll_key] += fish_groups[current_key]
    print("Tick: " + str(x) + " r: " + str(roll_key) + " c: " + str(current_key))
    print("Groups: " + str(prev) + " -> " + str(fish_groups))
    print()


def main():
    fish_groups = init_group(read_seed())
    for x in range(256):
        tick(x, fish_groups)
    print("Fish count: " + str(sum_groups(fish_groups)))


main()
