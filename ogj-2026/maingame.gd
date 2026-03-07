extends Node2D

var level = 1
var map = preload("res://template.tscn")
@onready var enemyp = preload("res://enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	map = load("res://template.tscn")
	%startscreen.visible = true
	%startbutton.visible = true
	add_child(map)

func spawn_enemies():
	if level == 1:
		var enemy = enemyp.instantiate()
		enemy.type = "lemon"
		enemy.position = Vector2(132,160)
		enemy.player = %player
		
		add_child(enemy)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
		%startbutton.visible = false
		%startscreen.visible = false
		spawn_enemies()
