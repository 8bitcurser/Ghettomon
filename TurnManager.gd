extends Node2D

@export var player: Node
@export var enemy: Node
@export var next_turn_delay: float = 1.0

var current_char: Character
var game_over: bool = false

signal character_begin_turn(character)
signal character_end_turn(character)

func _ready():
	begin_next_turn()

func end_current_turn():
	emit_signal('character_end_turn', current_char)
	await get_tree().create_timer(next_turn_delay).timeout
	if not game_over:
		begin_next_turn()

func char_died(character):
	game_over = true
	if character.is_player == true:
		print('Game over')
	else:
		print("You win!")

func begin_next_turn():
	if current_char == player:
		current_char = enemy
	elif current_char == enemy:
		current_char = player
	else:
		current_char = player
	emit_signal('character_begin_turn', current_char)
