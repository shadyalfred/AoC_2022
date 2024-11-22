package main

import "core:fmt"
import "core:strings"
import "core:os"

Move :: enum {
	Rock = 1,
	Paper,
	Scissors,
}

CharToMove := map[u8]Move {
	'A' = Move.Rock,
	'X' = Move.Rock,

	'B' = Move.Paper,
	'Y' = Move.Paper,

	'C' = Move.Scissors,
	'Z' = Move.Scissors,
}

MoveToWin := map[Move]Move {
	Move.Rock = Move.Paper,
	Move.Paper = Move.Scissors,
	Move.Scissors = Move.Rock
}

MoveToLose := map[Move]Move {
	Move.Rock = Move.Scissors,
	Move.Paper = Move.Rock,
	Move.Scissors = Move.Paper,
}

GameOutcome :: enum {
	Loss = 0,
	Draw = 3,
	Win = 6,
}

play :: proc(my_move, his_move: Move) -> GameOutcome {
	if my_move == his_move {
		return .Draw
	}

	switch my_move {
	case .Rock:
		if his_move == .Scissors {
			return .Win
		} else {
			return .Loss
		}
	case .Paper:
		if his_move == .Rock {
			return .Win
		} else {
			return .Loss
		}
	case .Scissors:
		if his_move == .Paper {
			return .Win
		} else {
			return .Loss
		}
	}

	panic("failed to determine outcome of game")
}

part_one :: proc(input: string) -> int {
	input := input
	score := 0
	for game in strings.split_lines_iterator(&input) {
		his_move, my_move := CharToMove[game[0]], CharToMove[game[len(game) - 1]]
		game_outcome := play(my_move, his_move)
		score = score + int(my_move) + int(game_outcome)
	}
	return score
}

part_two :: proc(input: string) -> int {
	input := input
	score := 0
	for game in strings.split_lines_iterator(&input) {
		my_move: Move
		needed_outcome: GameOutcome

		his_move, needed_outcome_symbol := CharToMove[game[0]], game[len(game) - 1]

		switch needed_outcome_symbol {
		case 'X':
			needed_outcome = GameOutcome.Loss
			my_move = MoveToLose[his_move]
		case 'Y':
			needed_outcome = GameOutcome.Draw
			my_move = his_move
		case:
			needed_outcome = GameOutcome.Win
			my_move = MoveToWin[his_move]
		}

		score = score + int(my_move) + int(needed_outcome)
	}
	return score
}

main :: proc() {
	file_content, ok := os.read_entire_file_from_filename("input.txt")
	if !ok {
		panic("failed to read `input.txt`")
	}

	input := string(file_content)

	fmt.printfln("part one: %i", part_one(input))
	fmt.printfln("part two: %i", part_two(input))
}
