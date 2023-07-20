extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var sprite = $AnimatedSprite2D
var speed: float = 100

signal next_round

func _ready():
	input_pickable = true
	velocity = _random_up_direction() * speed

func _random_up_direction():
	var x = deg_to_rad(randf_range(0,180))
	return Vector2(cos(x),sin(x)).normalized()

func _physics_process(delta):
	var col = move_and_collide(velocity * delta)
	
	if col:
		velocity = velocity.bounce(col.get_normal())
	
	_check_direction()

func _check_direction():
	if velocity.x <0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("shoot"):
		_death()

func _death():
	velocity = Vector2.ZERO
	animation_player.play("death")
	await get_tree().create_timer(1).timeout
	velocity = Vector2.DOWN * 75


func _on_screen_exited():
	next_round.emit()
	queue_free()
