package main

import "core:fmt"
import "core:strconv"
import "core:os"

part_one :: proc(input: string) -> int {
	calories := 0
	max_calories := min(int)
	l := 0
	for c, r in input {
		if c == '\n' {
			if l == r { // empty line check
				max_calories = max(calories, max_calories)
				calories = 0
			} else {
				input := input
				calories = calories + strconv.atoi(input[l:r])
			}
			l = r + 1
		}
	}
	// check the last line and group
	calories = calories + strconv.atoi(input[l:])
	max_calories = max(calories, max_calories)

	return max_calories
}

part_two :: proc(input: string) -> int {
	reorder_arr :: proc(arr: []int, new_value: int) {
		outer: for i in 0..<len(arr) {
			if new_value > arr[i] {
				for j := len(arr) - 1; j > i; j = j - 1 {
					arr[j] = arr[j - 1]
				}
				arr[i] = new_value
				break outer
			}
		}
	}

	calories := 0
	top_calories := [3]int{min(int), min(int), min(int)}
	l := 0
	for c, r in input {
		if c == '\n' {
			if l == r { // empty line check
				reorder_arr(top_calories[:], calories)
				calories = 0
			} else {
				input := input
				calories = calories + strconv.atoi(input[l:r])
			}

			l = r + 1
		}
	}
	// check the last line and group
	calories = calories + strconv.atoi(input[l:])
	reorder_arr(top_calories[:], calories)

	return top_calories[0] + top_calories[1] + top_calories[2]
}

main :: proc() {
	file_content, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		panic("`input.txt` file was not found")
	}
	input := string(file_content)

	fmt.printfln("Part one: %i", part_one(input))
	fmt.printfln("Part two: %i", part_two(input))
}
