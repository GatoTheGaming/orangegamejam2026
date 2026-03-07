extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const RELEASE_DROP_MODIFIER = 0.7
var attacking = false

var maxhealth = 100
var health = maxhealth
var dmg = 50

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += (get_gravity() * delta * 0.8)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= RELEASE_DROP_MODIFIER

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
		
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		%weaponarea.monitoring = true
		%weapontext.visible = true
		if get_global_mouse_position().x > position.x:
			%weapontext.position.x = 16
			%weapontext.flip_h = false
			%weaponarea.rotation = 0.0
			%sprite.flip_h = false
		else:
			%weapontext.flip_h = true
			%sprite.flip_h = true
			%weapontext.position.x = -16
			%weaponarea.rotation = 180.0
		%weapontext.play("swordph")
	elif not attacking:
		%weaponarea.monitoring = false
		%weapontext.visible = false
		if get_global_mouse_position().x > position.x:
			%sprite.flip_h = false
		else:
			%sprite.flip_h = true
	move_and_slide()

func damage(dm):
	health -= dm
	if health <= 0:
		get_tree().change_scene_to_file("res://titlescreen.tscn")

func _on_weapontext_animation_finished():
	attacking = false


func _on_weaponarea_body_entered(body):
	if body.is_in_group("enemies"):
		body.damage(dmg)
		%weaponarea.monitoring = false
