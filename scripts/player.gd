extends CharacterBody2D


const SPEED = 500.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	
	#if !is_multiplayer_authority(): return
	
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * SPEED
	
	if Input.is_action_just_pressed("attack"):
		animation_player.play("Punch")
	
	move_and_slide()
