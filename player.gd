extends CharacterBody3D

# players speed (m/s)
@export var speed = 14
# air accel (also m/s)
@export var fall_accel = 75

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	# store direction
	var direction = Vector3.ZERO
	
	# check for movement in x direction 
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
	# check for movement in z direction 
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# this affects the rotation of the player, so we rotate them back
		$Pivot.basis = Basis.looking_at(direction)
		
	# ground velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed 
	
	# air velocity
	if not is_on_floor():	# detect if we arent on the floor
		target_velocity.y = target_velocity.y - (fall_accel * delta)
		
	# actually move character
	velocity = target_velocity
	move_and_slide()
