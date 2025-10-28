extends CharacterBody3D

# players speed
@export var def_speed = 4
@export var speed = def_speed
# air accel
@export var fall_accel = 50
# vertical impulse
@export var jump_impulse = 14
# player scale
@export var pl_scale = 1


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
	
	# jumping
	if is_on_floor() and Input.is_action_pressed("jump"):
		target_velocity.y = jump_impulse
		
	# crouching
	if Input.is_action_pressed("crouch"):
		scale.y = pl_scale * 0.6
		speed = def_speed / 2
	
	# crouch jump height
	if Input.is_action_pressed("crouch") and Input.is_action_pressed("jump"):
		scale.y = pl_scale * 0.8
	
	# set scale to normal when not crouching
	if not Input.is_action_pressed("crouch"):
		scale.y = pl_scale
		speed = def_speed
	
	# air velocity
	if not is_on_floor():	# detect if we arent on the floor
		target_velocity.y = target_velocity.y - (fall_accel * delta)
		
	# actually move character
	velocity = target_velocity
	move_and_slide()
