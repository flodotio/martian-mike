extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var speed = 125
@export var jump_force = 200

var active = true

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -500, 500)
	
	var direction = 0
	
	if active:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
		direction = Input.get_axis("move_left", "move_right")
		
	velocity.x = direction* speed
	
	update_animations(direction)
	move_and_slide()
	
func jump(force):
	velocity.y = -force
	AudioPlayer.play_sfx("jump")

func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
			
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
