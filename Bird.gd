extends KinematicBody2D


var gravity = 98
var speed = 100
var velocity = Vector2.ZERO

func _physics_process(delta):

	if Input.is_action_pressed("space"):
		velocity.y -= 5

	velocity.y += gravity * delta
	
	if is_on_floor():
		velocity.y = 0 
	
	move_and_slide(velocity * speed * delta, Vector2.UP)
