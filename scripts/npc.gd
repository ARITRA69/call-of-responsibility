extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MOVE_DISTANCE = 50.0 # change direction after moving this distance

var direction := 0
var start_position: Vector2

func _ready():
	randomize()
	_change_direction()
	start_position = global_position

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Move in the current direction
	velocity.x = direction * SPEED
	move_and_slide()

	# Check distance traveled
	var distance_traveled = global_position.distance_to(start_position)
	if distance_traveled >= MOVE_DISTANCE:
		_change_direction()
		start_position = global_position

func _change_direction():
	# Randomly choose -1 (left), 0 (stop), or 1 (right)
	var choices = [-1, 1] # remove 0 if you always want movement
	direction = choices[randi() % choices.size()]
