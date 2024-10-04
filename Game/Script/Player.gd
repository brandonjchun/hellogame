extends CharacterBody3D

@onready var root_node = $Visual/RootNode
@onready var animation_tree = $Visual/AnimationTree

const SPEED = 12
const JUMP_VELOCITY = 22

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func process(delta):
	animation_tree.set("parameters/StateMachine/GroundMovement/blend_position", abs(velocity.x))
	animation_tree.set("parameters/StateMachine/Airborne/blend_position", velocity.y)
	
	if is_on_floor():
		animation_tree.changeStateToNormal()
	else:
		animation_tree.changeStateToAirborne()


func _physics_process(delta):
#region Rotate the player to the moving direciton

	if velocity.x != 0:
		var faceRight = velocity.x > 0
		if faceRight:
			root_node.rotation = Vector3(0, 0, 0)
		else:
			root_node.rotation = Vector3(0, PI, 0)
#endregion
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta * 8

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("MoveDown") and not is_on_floor():
		velocity.y -= gravity * delta * 50
		
	# Handle inputs
	var horizontalInput = Input.get_axis("MoveLeft", "MoveRight")
	
	if horizontalInput:
		velocity.x = horizontalInput * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, .6)

	move_and_slide()
