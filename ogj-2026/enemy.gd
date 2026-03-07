extends CharacterBody2D


var SPEED = 100.0
var JUMP_VELOCITY = -250.0
var player = ""
var type = "lemon"
var attack = "lemon"
var dir = 1
var attacking = false
var attackfinish = true

var maxhealth = 150
var health = maxhealth
var dmg = 20

#func seta(typez,pos,playa):
	#type = typez
	#position = pos
	#player = playa
func _ready():
	add_to_group("enemies")
	attack = type
	if type == "lime":
		var maxhealth = 150
		var health = maxhealth
		dmg = 20
		SPEED = 100
		JUMP_VELOCITY = -250
		%attackcoll.shape = load("res://assets/collisions/limecoll.tres")
		%attackcoll.position.x = 18
		%initcoll.shape = load("res://assets/collisions/limeplayerdetect.tres")
		%initcoll.rotation = 0
	elif type == "lemon":
		var maxhealth = 100
		var health = maxhealth
		dmg = 20
		%attackcoll.shape = load("res://assets/collisions/lemoncoll.tres")
		%attackcoll.position.x = 107
		%initcoll.shape = load("res://assets/collisions/lemonplayerdetect.tres")
		%initcoll.rotation = PI / 2
	elif type == "grapefruit":
		SPEED = 50
		var maxhealth = 200
		var health = maxhealth
		dmg = 34
		%attackcoll.shape = load("res://assets/collisions/grapecoll.tres")
		%attackcoll.position.x = 0
		%initcoll.shape = load("res://assets/collisions/limeplayerdetect.tres")
		%initcoll.rotation = 0
		
		
func lime():
	
	if player in %initbox.get_overlapping_bodies() and not attacking and attackfinish:
		%attacktimer.stop()
		dir = 1 if player.position.x > position.x else -1
		velocity.x = 0
		attack = "lime"
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
			
func lemon():
	if player in %initbox.get_overlapping_bodies() and not attacking and attackfinish:
		%attacktimer.stop()
		dir = 1 if player.position.x > position.x else -1
		attack = "lemon"
		%sprite.flip_h = false if dir == 1 else true
		%sprite.animation = "green"
		%Timer.wait_time = 0.7
		attacking = true
		attackfinish = false
		%Timer.start(0)

func grapefruit():
	if player in %initbox.get_overlapping_bodies() and not attacking and attackfinish:
		%attacktimer.stop()
		dir = 1 if player.position.x > position.x else -1
		velocity.x = 0
		attack = "grapefruit"
		%sprite.animation = "green"
		%Timer.wait_time = 0.6
		attacking = true
		attackfinish = false
		%Timer.start(0)

func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if type == "lime":
		lime()
	elif type == "lemon":
		lemon()

	move_and_slide()


func _on_timer_timeout():
	if attacking and not attackfinish:
		if attack == "lime":
			%Timer.stop()
			%attackbox.monitoring = true
			%sprite.animation = "blue"
			velocity.y = -150
			velocity.x += 200 * dir
			%attackbox.rotation = PI if dir == -1 else 0
			%attacktimer.wait_time = 0.3
			%attacktimer.start(0)
		elif attack == "lemon":
			%sprite.animation = "blue"
			%Timer.stop()
			%attackbox.monitoring = true
			%attackbox.rotation = PI if dir == -1 else 0
			%attacktimer.wait_time = 0.4
			%attacktimer.start(0)
		


func _on_attacktimer_timeout():
	if type == "lime":
		%Timer.stop()
		%sprite.animation = "placeholder"
		velocity.x = 0
		%attackbox.monitoring = false
		%cooldowntimer.wait_time = 0.1
		%cooldowntimer.start(0)
	elif type == "lemon":
		%sprite.animation = "placeholder"
		%Timer.stop()
		%attackbox.monitoring = false
		%cooldowntimer.wait_time = 0.1
		%cooldowntimer.start(0)


func _on_cooldowntimer_timeout():
	attacking = false
	attackfinish = true
	
func damage(dm):
	health -= dm
	if health <= 0:
		get_parent().die()
		queue_free()
	

func _on_attackbox_body_entered(body):
	if body == player:
		player.damage(dmg)
		%attackbox.monitoring = false
