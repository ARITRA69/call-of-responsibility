extends CharacterBody2D

const SPEED = 300.0
const MOVE_DISTANCE = 50.0

var direction: Vector2 = Vector2.ZERO
var start_position: Vector2

@onready var add_area: Area2D = $AddArea

signal died

var player: Node2D = null
var player_id: int = -1
var is_following = false

func _ready():
	randomize()
	_change_direction()
	start_position = global_position
	add_area.body_entered.connect(_on_add_area_body_entered)

func _physics_process(delta: float) -> void:
	if is_following and player:
		var dir_to_player = (player.global_position - global_position)
		if dir_to_player.length() > 30:
			velocity = dir_to_player.normalized() * SPEED
		else:
			velocity = Vector2.ZERO
	else:
		velocity = direction * SPEED
		var distance_traveled = global_position.distance_to(start_position)
		if distance_traveled >= MOVE_DISTANCE:
			_change_direction()
			start_position = global_position

	move_and_slide()

func _change_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()

func _on_add_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if GlobalStateManager.npcs_per_player.has(body.name.to_int()) and \
		GlobalStateManager.npcs_per_player[body.name.to_int()].size() >= GlobalStateManager.MAX_NPC_PER_PLAYER:
			return
		player = body
		player_id = body.name.to_int()
		is_following = true
		GlobalStateManager.register_npc(self, player_id)

func die():
	GlobalStateManager.unregister_npc(self)
	emit_signal("died")
	queue_free()
