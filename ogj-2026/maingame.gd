extends Node2D

var level = 1
var map = preload("res://template.tscn")
@onready var enemyp = preload("res://enemy.tscn")
var num_enemies = 0
var maps = []
var items = [] # max 3
# Called when the node enters the scene tree for the first time.
func _ready():
	map = load("res://template.tscn")
	%startscreen.visible = true
	%startbutton.visible = true
	add_child(map)
func die():
	num_enemies -= 1
	if num_enemies <= 0:
		%player.health = %player.maxhealth
		Ui.shutter()
		get_tree().paused = true
		level += 1
		spawn_enemies()
func spawn_enemies():
	if level == 1:
		%player.position = Vector2(36,157)
		var enemy = enemyp.instantiate()
		enemy.type = "lime"
		enemy.position = Vector2(132,160)
		enemy.player = %player
		add_child(enemy)
		enemy = enemyp.instantiate()
		enemy.type = "lime"
		enemy.position = Vector2(327,136)
		enemy.player = %player
		add_child(enemy)
		num_enemies = 2
	elif level == 2:
		%map.queue_free()
		
		var mapp = load("res://template.tscn").instantiate()
		maps.append(mapp)
		mapp.position = Vector2(0,0)
		mapp.z_index = -1
		add_child(mapp)
		%player.position = Vector2(36,157)
		var enemy = enemyp.instantiate()
		enemy.type = "lemon"
		enemy.position = Vector2(313,135)
		enemy.player = %player
		add_child(enemy)
		enemy = enemyp.instantiate()
		enemy.type = "lemon"
		enemy.position = Vector2(76,87)
		enemy.player = %player
		add_child(enemy)
		enemy = enemyp.instantiate()
		enemy.type = "lime"
		enemy.position = Vector2(193,135)
		enemy.player = %player
		add_child(enemy)
		enemy = enemyp.instantiate()
		enemy.type = "lime"
		enemy.position = Vector2(192,88)
		enemy.player = %player
		add_child(enemy)
		
		num_enemies = 4
	elif level == 3:
		for mapz in maps:
			mapz.queue_free()
		maps = []
		var mapp = load("res://level3.tscn").instantiate()
		maps.append(mapp)
		mapp.position = Vector2(0,0)
		mapp.z_index = -1
		add_child(mapp)
		var enemy = enemyp.instantiate()
		enemy.type = "grapefruit"
		enemy.position = Vector2(313,135)
		enemy.player = %player
		add_child(enemy)
	elif level == 4:
		for mapz in maps:
			mapz.queue_free()
		maps = []
		var mapp = load("res://level3.tscn").instantiate()
		maps.append(mapp)
		mapp.position = Vector2(0,0)
		mapp.z_index = -1
		add_child(mapp)
		var enemy = enemyp.instantiate()
		enemy.type = "lemon"
		enemy.position = Vector2(313,135)
		enemy.player = %player
		add_child(enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_texture_button_pressed():
		%startbutton.visible = false
		%startscreen.visible = false
		spawn_enemies()
