extends CharacterBody2D

const SPEED = 300.0
const MOVE_DISTANCE = 50.0 # Change direction after moving this distance

var direction: Vector2 = Vector2.ZERO
var start_position: Vector2

@onready var add_area: Area2D = $AddArea

var player: Node2D = null
var is_following = false

func _ready():
	randomize()
	_change_direction()
	start_position = global_position
	add_area.body_entered.connect(_on_add_area_body_entered)  # ✅ Correct Godot 4 syntax

func _physics_process(delta: float) -> void:
	if is_following and player:
		# Follow player
		var dir_to_player = (player.global_position - global_position)
		if dir_to_player.length() > 30: # stop close to player
			velocity = dir_to_player.normalized() * SPEED
		else:
			velocity = Vector2.ZERO
	else:
		# Random wandering
		velocity = direction * SPEED

		var distance_traveled = global_position.distance_to(start_position)
		if distance_traveled >= MOVE_DISTANCE:
			_change_direction()
			start_position = global_position

	move_and_slide()

func _change_direction():
	var angle = randf() * TAU  # TAU = 2 * PI
	direction = Vector2(cos(angle), sin(angle)).normalized()

func _on_add_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player = body
		is_following = true
