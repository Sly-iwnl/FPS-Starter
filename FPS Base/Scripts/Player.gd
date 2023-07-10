extends CharacterBody3D

const WALKSPEED = 5.0
const SPRINTSPEED = 10.0
const JUMP_VELOCITY = 4.5

var speed = 5.0
var gravity = 9.8
var mouse_sensitivity = 0.002

var is_player = true

@onready var camera = $Head/Camera
@onready var head = $Head
@onready var graphics = $GFX

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if is_player == true:
		graphics.hide()
	else:
		graphics.show()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, -1.2, 1.2)

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		elif Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_pressed("Sprint"):
		speed = SPRINTSPEED
	else:
		speed = WALKSPEED
	
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
