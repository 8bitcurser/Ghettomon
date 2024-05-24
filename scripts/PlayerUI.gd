extends VBoxContainer

@onready var battle_scene = $".."

func _ready():
	battle_scene.character_begin_turn.connect(_on_char_begin_turn)
	battle_scene.character_end_turn.connect(_on_char_end_turn)
	
func _on_char_begin_turn(character):
	visible = character.is_player
	if visible:
		_display_combat_actions(character.combat_actions)

func _on_char_end_turn(character):
	visible = false

func _display_combat_actions(combat_actions):
	for button in get_children():
		remove_child(button)
		button.queue_free()

	for action in combat_actions:
		var button = Button.new()
		button.text = action.display_name
		#button.visible = true
		button.pressed.connect(_on_combat_action_pressed.bind(action))
		add_child(button)

func _on_combat_action_pressed(action):
	var current_character = battle_scene.current_char
	current_character.cast_combat_action(action)
