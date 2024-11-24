package main

import "core:os"
import "core:strings"
import "core:fmt"
import "core:strconv"

Range :: struct {
	start: u8,
	end: u8,
}

extract_range :: proc(r: string, range: ^Range) {
	// start-end
	splits := strings.split_n(r, "-", 2)
	start, end := strconv.atoi(splits[0]), strconv.atoi(splits[1])
	range.start = auto_cast start
	range.end   = auto_cast end
}

parse :: proc(input: string, pairs: ^[dynamic][2]Range) {
	input := input
	for line in strings.split_lines_iterator(&input) {
		// le-ft,ri-ght
		splits := strings.split_n(line, ",", 2)
		parsed_ranges := [2]Range{}
		extract_range(splits[0], &parsed_ranges[0])
		extract_range(splits[1], &parsed_ranges[1])
		append(pairs, parsed_ranges)
	}
}

does_contain :: proc(range_1, range_2: Range) -> bool {
	return range_1.start <= range_2.start && range_1.end >= range_2.end
}

part_one :: proc(pairs: [][2]Range) -> uint {
	count: uint = 0
	for pair in pairs {
		range_1, range_2 := pair[0], pair[1]
		if does_contain(range_1, range_2) || does_contain(range_2, range_1) {
			count = count + 1
		}
	}
	return count
}

does_overlap :: proc(range_1, range_2: Range) -> bool {
	return range_1.start <= range_2.start && range_1.end >= range_2.start ||
		range_1.start >= range_2.start && range_1.end <= range_2.end
}

part_two :: proc(pairs: [][2]Range) -> uint {
	count: uint = 0
	for pair in pairs {
		range_1, range_2 := pair[0], pair[1]
		if does_overlap(range_1, range_2) || does_overlap(range_2, range_1) {
			count = count + 1
		}
	}
	return count
}

main :: proc() {
	file_content, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		panic("failed to read file `input.txt`")
	}

	input := string(file_content)

	pairs := make([dynamic][2]Range, 0, 1000)
	defer delete(pairs)
	parse(input, &pairs)

	fmt.printfln("part one: %i", part_one(pairs[:]))
	fmt.printfln("part two: %i", part_two(pairs[:]))
}
