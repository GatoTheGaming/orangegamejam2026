extends Control

var shuttering = false
# Called when the node enters the scene tree for the first time.
func _ready():
	%shutter.position.y = -218
	%black.modulate.a = 0
func playg(anim):
	%health.play(anim)
func shutter():
	%shutter.visible = true
	shuttering = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shuttering == true:
		%black.modulate.a = lerpf(%black.modulate.a, 1, 0.025)
		%shutter.position.y = lerpf(%shutter.position.y, 326, 0.025)
	else:
		%black.modulate.a = lerpf(%black.modulate.a, 0, 0.025)
		%shutter.position.y = lerpf(%shutter.position.y, -218, 0.025)
	if Input.is_action_just_pressed("dash"):
		get_tree().paused = false
		shuttering = false


func _on_startbutt_pressed():
	get_tree().paused = false
	shuttering = false
