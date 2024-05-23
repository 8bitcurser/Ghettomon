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
		root.character_died(self)
		queue_free()

func heal(amount):
	current_hp += amount
	if current_hp >= max_hp:
		current_hp = max_hp
	_update_health_bar()

func _on_character_begin_turn(character):
	if character == self:
		pass

func _ready():
	sprite.flip_h = flip_visual
	sprite.texture = visual
	root.character_begin_turn.connect(
		_on_character_begin_turn)
	health_bar.max_value = max_hp
	
