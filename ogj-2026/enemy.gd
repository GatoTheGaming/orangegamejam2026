extends CharacterBody2D


var SPEED = 100.0
var JUMP_VELOCITY = -250.0
var player = ""
var type = "lemon"
var attack = "lemon"
var dir = 1
var attacking = false
var attackfinish = true
var hovering = false
var slamming = false

var maxhealth = 150
var health = maxhealth
var dmg = 20
var temppos = Vector2(0,0)

#func seta(typez,pos,playa):
	#type = typez
	#position = pos
	#player = playa
func _ready():
	add_to_group("enemies")
	attack = type
	%collbox.shape = load("res://assets/collisions/normcollbox.tres")
	if type == "lime":
		%sprite.animation = "placeholder"
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
		collision_mask = 2
		%sprite.animation = "lemon_idle"
		var maxhealth = 100
		var health = maxhealth
		dmg = 20
		%attackcoll.shape = load("res://assets/collisions/lemoncoll.tres")
		%attackcoll.position.x = 98
		%initcoll.shape = load("res://assets/collisions/lemonplayerdetect.tres")
		%initcoll.rotation = PI / 2
	elif type == "grapefruit":
		SPEED = 50
		var maxhealth = 200
		var health = maxhealth
		dmg = 34
		%collbox.shape = load("res://assets/collisions/grapefruitcollbox.tres")
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
		%sprite.flip_h = true if dir == 1 else false
		%sprite.modulate.r = 1
		%sprite.modulate.g = 0.5
		%sprite.modulate.b = 0.5
		%Timer.wait_time = 0.7
		attacking = true
		attackfinish = false
		%Timer.start(0)

func grapefruit():
	if player in %initbox.get_overlapping_bodies() and not attacking and attackfinish:
		%attacktimer.stop()
		dir = 1 if player.position.x > position.x else -1
		attack = "grapefruit"
		%Timer.wait_time = 0.8
		hovering = true
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
	if not is_on_floor() and not type == "lemon" and not hovering:
		velocity += get_gravity() * delta
		
	if type == "lime":
		lime()
	elif type == "lemon":
		lemon()
		if attacking:
			%attackcoll.shape.height = (22 * %attackanim.frame) + 22
			%attackcoll.position.x = 12.25 * %attackanim.frame + 12.5
		else:
			%attackcoll.shape.height = 176.0
			%attackcoll.position.x = 98
	elif type == "grapefruit":
		grapefruit()
	if hovering:
		%collbox.disabled = true
		position.x = lerpf(position.x,player.position.x,0.05)
		position.y = lerpf(position.y,player.position.y - 75,0.05)
	elif slamming:
		%collbox.disabled = false
		position.x = lerpf(position.x,temppos.x,0.05)
		position.y = lerpf(position.y,temppos.y,0.05)
		if position.y < 0:
			position.y = 14
	else:
		%collbox.disabled = false

	move_and_slide()


func _on_timer_timeout():
	if attacking and not attackfinish:
		%sprite.modulate.r = 1
		%sprite.modulate.g = 1
		%sprite.modulate.b = 1
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
			%sprite.animation = "lemon_idle"
			%Timer.stop()
			%attackanim.frame = 0
			%attackanim.visible = true
			%attackanim.play()
			%attackbox.monitoring = true
			%attackbox.rotation = PI if dir == -1 else 0
			%attacktimer.wait_time = 0.6
			%attacktimer.start(0)
		elif attack == "grapefruit":
			hovering = false
			slamming = true
			%Timer.stop()
			temppos = position + Vector2(0,75)
			%attackbox.monitoring = true
			%attacktimer.wait_time = 0.6
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
		%sprite.animation = "lemon_idle"
		%Timer.stop()
		%attackanim.visible = false
		%attackbox.monitoring = false
		%cooldowntimer.wait_time = 0.1
		%cooldowntimer.start(0)
	elif type == "grapefruit":
		slamming = false
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
