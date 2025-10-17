extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@export var speed = 35

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
	var input_vec = Input.get_vector("MOVE_LEFT", "MOVE_RIGHT", "MOVE_UP", "MOVE_DOWN").normalized()
	var cardinal_dir = get_cardinal_direction(input_vec)
	
	velocity = input_vec * speed
	move_and_slide()

	# Gerçek hareketi kontrol et (çarpışmadan dolayı duruyorsa algıla)
	if velocity.length() < 1.0:
		update_animation(Vector2.ZERO)
	else:
		update_animation(cardinal_dir)
