extends CharacterBody3D

# players speed
var def_speed = 6.0
var speed = def_speed
# air accel
var def_faccel = 45.0
var fall_accel = def_faccel
# player scale
var def_pscale = 1.0
var pl_scale = def_pscale

var target_velocity = Vector3.ZERO

func _physics_process(delta):

	# camera rotation
	if Input.is_action_pressed("keylook_left"):
		$CameraController.rotate_y(deg_to_rad(2))
	if Input.is_action_pressed("keylook_right"):
		$CameraController.rotate_y(deg_to_rad(-2))
	if Input.is_action_pressed("keylook_up"):
		$CameraController.rotate_x(deg_to_rad(2))
	if Input.is_action_pressed("keylook_down"):
		$CameraController.rotate_x(deg_to_rad(-2))
	#	print($CameraController.rotation_degrees)
	if $CameraController.rotation_degrees.x >= 90:
		$CameraController.rotate_x(deg_to_rad(-2))
	if $CameraController.rotation_degrees.x <= -65:
		$CameraController.rotate_x(deg_to_rad(2))

	# store direction
	var direction = (transform_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
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
