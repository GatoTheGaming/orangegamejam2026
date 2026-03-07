extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_explode_pressed():
	var explode = AudioStreamPlayer2D.new()
	explode.stream = load("res://assets/audio/sfx/deltarune-explosion.mp3")
	add_child(explode)
	explode.play()
	%boom.visible = true
	%boom.play()
	%Panop.visible = true
	%explodetimer.start()
	


func _on_explodetimer_timeout():
	get_tree().quit()


func _on_start_pressed():
	get_tree().change_scene_to_file("res://maingame.tscn")


func _on_howtoplay_pressed():
	if %controls.visible == true:
		print("true")
		%controls.visible = false
	else:
		print("false")
		%controls.visible = true
