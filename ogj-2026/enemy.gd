extends CharacterBody2D


var SPEED = 100.0
var JUMP_VELOCITY = -250.0
var player = ""
var type = "lemon"
var attack = "lemon"
var dir = 1
var attacking = false
var attackfinish = true

var health = 100
var dmg = 20

#func seta(typez,pos,playa):
	#type = typez
	#position = pos
	#player = playa
func _ready():
	add_to_group("enemies")
	attack = type
	if type == "lemon":
		health = 100
		dmg = 20
		SPEED = 100
		JUMP_VELOCITY = -250
func lemon():
	
	if player in %initbox.get_overlapping_bodies() and not attacking and attackfinish:
		%attacktimer.stop()
		print("yeah")
		print(Time)
		dir = 1 if player.position.x > position.x else -1
		velocity.x = 0
		attack = "lemon"
		%sprite.animation = "green"
		%Timer.wait_time = 0.6
		attacking = true
		attackfinish = false
		%Timer.start(0)
	elif not attacking and attackfinish:
		if player.position.x > position.x:
			velocity.x = SPEED
			%sprite.flip_h = -1
			
		else:
			velocity.x = SPEED * -1
			%sprite.flip_h = 1
		if player.position.y < position.y - 10 and is_on_floor():
			velocity.y = JUMP_VELOCITY
func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if type == "lemon":
		lemon()

	move_and_slide()


func _on_timer_timeout():
	if attacking and not attackfinish:
		if attack == "lemon":
			%Timer.stop()
			%attackbox.monitoring = true
			%sprite.animation = "blue"
			velocity.y = -150
			velocity.x += 200 * dir
			%attacktimer.wait_time = 0.3
			%attacktimer.start(0)
		


func _on_attacktimer_timeout():
	print("2")
	#print("done")
	%Timer.stop()
	%sprite.animation = "placeholder"
	velocity.x = 0
	%attackbox.monitoring = false
	%cooldowntimer.wait_time = 0.1 if type == "lemon" else %cooldowntimer.wait_time
	%cooldowntimer.start(0)


func _on_cooldowntimer_timeout():
	print("3")
	attacking = false
	attackfinish = true
	

func _on_attackbox_body_entered(body):
	if body == player:
		player.damage(dmg)
		%attackbox.monitoring = false
