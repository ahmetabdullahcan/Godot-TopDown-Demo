extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
const max_speed = 40
const accel = 150
const friction = 600
var input = Vector2.ZERO

func _ready() -> void:
	animation_tree.active = true
	var defaultFacing : Vector2 = Vector2(0, 1)
	animation_tree.set("parameters/Idle/blend_position", defaultFacing)

func get_cardinal_direction(vec: Vector2) -> Vector2:
	if vec == Vector2.ZERO:
		return Vector2.ZERO
	if abs(vec.x) > abs(vec.y):
		return Vector2(sign(vec.x), 0)
	else:
		return Vector2(0, sign(vec.y))

func get_input():
	input.x = int(Input.is_action_pressed("MOVE_RIGHT")) - int(Input.is_action_pressed("MOVE_LEFT"))
	input.y = int(Input.is_action_pressed("MOVE_DOWN")) - int(Input.is_action_pressed("MOVE_UP"))
	
	return (input.normalized())

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if (velocity.length() > (friction * delta)):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta)
		velocity = velocity.limit_length(max_speed)
	if velocity == Vector2.ZERO or (abs(velocity.x) <= 3.5 and abs(velocity.y) <= 3.5):
		update_animation(Vector2.ZERO)
	else:
		update_animation(velocity)
	move_and_slide()

func update_animation(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/conditions/is_moving", true)
		animation_tree.set("parameters/conditions/is_idle", false)
		animation_tree.set("parameters/Movement/blend_position", direction)
		animation_tree.set("parameters/Idle/blend_position", direction)
	else:
		animation_tree.set("parameters/conditions/is_moving", false)
		animation_tree.set("parameters/conditions/is_idle", true)

func _physics_process(delta: float) -> void:
	player_movement(delta)
