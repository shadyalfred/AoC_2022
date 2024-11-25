package main

import "core:os"
import "core:strings"
import "core:fmt"
import "core:unicode"
import "core:strconv"
import "core:container/queue"

Crate :: rune

Queue :: queue.Queue

Instruction :: struct {
	count: u8,
	from: u8,
	to: u8,
}

print_stacks :: proc(stacks: ^[9]Queue(Crate)) {
	for &stack in stacks {
		fmt.printf("[ ")
		for i in 0..<queue.len(stack) {
			fmt.printf("%c ", queue.get(&stack, i))
		}
		fmt.printfln("]")
	}
}

parse :: proc(input: string) -> (^[9]Queue(Crate), []Instruction) {
	input := input
	stacks := parse_stacks(&input)
	instructions := parse_instructions(input[1:])
	return stacks, instructions
}

parse_stacks :: proc(input: ^string) -> ^[9]Queue(Crate) {
	stacks := new([9]Queue(Crate))
	outer: for line in strings.split_lines_iterator(input) {
		if line == "\n" {
			break
		}

		for i, j := 0, 1; j < len(line); i, j = i + 1, j + 4 {
			char := rune(line[j])
			if unicode.is_digit(char) {
				break outer
			}

			if char != ' ' {
				queue.push_front(&stacks[i], auto_cast char)
			}
		}
	}

	return stacks
}

parse_instructions :: proc(input: string) -> []Instruction {
	input := input
	instructions := make([dynamic]Instruction, 0, 512)
	for line in strings.split_lines_iterator(&input) {
		splits := strings.split_n(line, " ", 6)
		instruction := Instruction{
			count = auto_cast strconv.atoi(splits[1]),
			from  = auto_cast strconv.atoi(splits[3]) - 1,
			to    = auto_cast strconv.atoi(splits[5]) - 1,
		}
		append(&instructions, instruction)
	}
	return instructions[:]
}

peek_top_crates :: proc(stacks: ^[9]Queue(Crate)) -> string {
	sb := strings.builder_make_len_cap(0, 9)
	for &stack in stacks {
		if queue.len(stack) == 0 {
			continue
		}
		strings.write_rune(&sb, queue.peek_back(&stack)^)
	}
	return strings.to_string(sb)
}

part_one :: proc(stacks: ^[9]Queue(Crate), instructions: []Instruction) -> string {
	for instruction in instructions {
		for i in 0..<instruction.count {
			queue.push_back(
				&stacks[instruction.to],
				queue.pop_back(&stacks[instruction.from])
			)
		}
	}
	return peek_top_crates(stacks)
}

part_two :: proc(stacks: ^[9]Queue(Crate), instructions: []Instruction) -> string {
	q := Queue(Crate){}
	queue.init(&q, 256)
	for instruction in instructions {
		for i in 0..<instruction.count {
			queue.push_back(&q, queue.pop_back(&stacks[instruction.from]))
		}
		for queue.len(q) > 0 {
			queue.push_back(
				&stacks[instruction.to],
				queue.pop_back(&q)
			)
		}
	}
	return peek_top_crates(stacks)
}

main :: proc() {
	file_content, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		panic("failed to read file `input.txt`")
	}

	input := string(file_content)

	stacks, instructions := parse(input)
	defer free(stacks)
	defer delete(instructions)

	// Can’t run both parts together because the function modifies the stacks array and queues
	fmt.printfln("part one: %s", part_one(stacks, instructions))
	// fmt.printfln("part two: %s", part_two(stacks, instructions))
}
