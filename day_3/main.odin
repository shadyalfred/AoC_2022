package main

import "core:os"
import "core:strings"
import "core:fmt"

char_set :: map[u8]bool

get_priority :: proc(item: u8) -> uint {
	// is lowercase in ascii
	if item >= 97 && item <= 122 {
		return auto_cast item - 96
	} else {
		return auto_cast item - 38
	}
}

part_one :: proc(input: string) -> uint {
	input := input

	left_items, right_items := make(char_set, 32), make(char_set, 32)
	defer delete(left_items)
	defer delete(right_items)

	score: uint = 0
	for line in strings.split_lines_iterator(&input) {
		clear(&left_items)
		clear(&right_items)

		for l, r := 0, len(line) - 1; l < r; l, r = l + 1, r - 1 {
			left_char, right_char := line[l], line[r]

			left_items[left_char], right_items[right_char] = true, true

			if left_items[right_char] {
				score = score + get_priority(right_char)
				break
			}

			if right_items[left_char] {
				score = score + get_priority(left_char)
				break
			}
		}
	}

	return score
}

part_two :: proc(input: string) -> uint {
	input := input

	first_line_items, second_line_items := make(char_set, 64), make(char_set, 64)
	defer delete(first_line_items)
	defer delete(second_line_items)

	score: uint = 0
	i := 0
	for line in strings.split_lines_iterator(&input) {
		i = i + 1

		if i == 1 {
			for ii := 0; ii < len(line); ii = ii + 1 {
				first_line_items[line[ii]] = true
			}
		} else if i == 2 {
			for ii := 0; ii < len(line); ii = ii + 1 {
				second_line_items[line[ii]] = true
			}
		} else {
			for ii := 0; ii < len(line); ii = ii + 1 {
				char := line[ii]
				if first_line_items[char] && second_line_items[char] {
					score = score + get_priority(char)
					break
				}
			}
			clear(&first_line_items)
			clear(&second_line_items)
			i = 0
		}
	}

	return score
}

main :: proc() {
	file_content, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		panic("failed to read file `input.txt`")
	}

	input := string(file_content)

	fmt.printfln("part one: %i", part_one(input))
	fmt.printfln("part two: %i", part_two(input))
}
