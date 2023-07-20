extends Node2D

@onready var bullet_node = $CanvasLayer/bullet
@onready var round_node = $CanvasLayer/round
@onready var score_node = $CanvasLayer/score

var bullet_count = 3:
	set(value):
		if value>=0:
			bullet_count = value
			bullet_node.text = str(value)
		else:
			_lose()

var Round = 1:
	set(value):
		Round = value
		round_node.text = str(value)

var score = 0:
	set(value):
		score =value
		score_node.text = str(value)

@export var bird_node : PackedScene
var bird

func _ready():
	_default_display()
	_spawn()

func _default_display():
	bullet_node.text = str(bullet_count)
	round_node.text = str(Round)
	score_node.text = str(score)

func _spawn():
	if bird != null:
		await bird.tree_exited
	bird = bird_node.instantiate()
	
	bird.speed = Round * 50
	bird.position = Vector2(160,90)
	bird.next_round.connect(_on_next_round)
	bird.call_deferred("set_name","Bird")
	
	get_tree().current_scene.add_child(bird)

func _on_next_round():
	score += Round * 100
	Round += 1
	bullet_count = 3
	
	_spawn()

func _input(event):
	if event.is_action_pressed("shoot"):
		bullet_count -= 1
		
func _lose():
	if $Timer.is_stopped():
		find_child("dog").dog_laugh()
		find_child("Bird",false,false).input_pickable = false
		$Timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
