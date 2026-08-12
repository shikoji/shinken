@tool
class_name Enemy
extends CharacterBody2D

enum EnemyType {
	SLIME,
	SKELETON
}

@export var ENEMY_TYPE: EnemyType:
	set(value):
		ENEMY_TYPE = value
		setup_enemy()

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export_category("Config")
@export var health: float = 100.0
@export var health_max: float = 100.0
@export var damage: float = 20.0

var ia = null

var init: bool = false
func _ready() -> void:
	setup_enemy()
	init = true

func _physics_process(delta: float) -> void:
	if ia and init:
		ia.update(self, get_tree().get_nodes_in_group("Player")[0], delta)

func setup_enemy() -> void:
	if !is_instance_valid(anim_sprite):
		return
	match ENEMY_TYPE:
		EnemyType.SLIME:
			anim_sprite.sprite_frames = load("res://TRES/Animations/slime_sprites.tres")
			ia = Slime.new()
		
		EnemyType.SKELETON:
			anim_sprite.sprite_frames = load("res://TRES/Animations/skeleton_sprites.tres")
