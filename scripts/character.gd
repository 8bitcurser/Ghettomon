extends Node2D

class_name Character

@export var is_player: bool
@export var current_hp: int = 25
@export var max_hp: int = 25
@export var combat_actions: Array
@export var opponent: Node
@export var visual: Texture2D
@export var flip_visual:  bool


@onready var health_bar = $HealthBar
@onready var health_text = $HealthBar/Label
@onready var sprite = $Sprite

@onready var root = get_node('/root/BattleScene')

func _update_health_bar():
	health_bar.value = current_hp
	health_text.text = str(current_hp, '/', max_hp)

func take_damage(damage):
	current_hp -= damage
	_update_health_bar()
	
	if current_hp <= 0:
		root.char_died(self)
		queue_free()

func heal(amount):
	current_hp += amount
	if current_hp >= max_hp:
		current_hp = max_hp
	_update_health_bar()

func _on_character_begin_turn(character):
	if character == self and is_player == false:
		_decide_combat_action()


func cast_combat_action(action):
	if action.damage_amount > 0:
		opponent.take_damage(action.damage_amount)
	elif action.heal > 0:
		heal(action.heal)
	else:
		pass
	get_node('/root/BattleScene').end_current_turn()

func _decide_combat_action():
	var health_percent = float(current_hp) / float(max_hp)
	for action in combat_actions:
		var caction = action as CombatAction
		if caction.heal > 0:
			if randf() > health_percent:
				cast_combat_action(caction)
				return
			else:
				continue
		else:
			cast_combat_action(caction)
			return

func _ready():
	sprite.flip_h = flip_visual
	sprite.texture = visual
	root.character_begin_turn.connect(
		_on_character_begin_turn)
	health_bar.max_value = max_hp
	
