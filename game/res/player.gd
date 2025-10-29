extends CharacterBody3D

# players speed
@export var def_speed = 4.0
@export var speed = def_speed
# air accel
@export var def_faccel = 45.0
@export var fall_accel = def_faccel
# vertical impulse
@export var def_jumpulse = 10.0
@export var jump_impulse = def_jumpulse
# player scale
@export var def_pscale = 1.0
@export var pl_scale = def_pscale

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
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse
	
	# jump longer if holding space
	if Input.is_action_pressed("jump"):
		fall_accel = def_faccel - 20
	else:
		fall_accel = lerp(fall_accel, def_faccel, 0.10)
		
	# crouching
	if Input.is_action_pressed("crouch"):
		scale.y = def_pscale / 2
		speed = def_speed / 1.5
	else: 
		scale.y = def_pscale
		speed = def_speed
	
	# air velocity
	if not is_on_floor():	# detect if we arent on the floor
		target_velocity.y = target_velocity.y - (fall_accel * delta)
		
	# actually move character
	velocity = target_velocity
	move_and_slide()
	# camera
	$CameraController.position = lerp($CameraController.position, position, 0.3)
