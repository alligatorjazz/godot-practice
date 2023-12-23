extends Area2D
signal hit
@export var speed = 400
var screen_size: Vector2
var upside_down = false
var facing_back = true
# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	# $ is shorthand for get_node(). So in the code below, $AnimatedSprite2D.play() is the same as get_node("AnimatedSprite2D").play().
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	# controls movement animation (horizontal / vertical)
	if abs(velocity.x) > abs(velocity.y):
		$AnimatedSprite2D.animation = "walk"
	else:
		$AnimatedSprite2D.animation = "up"

	# controls sprite orientation (flipped / unflipped)
	if velocity.y > 0:
		$AnimatedSprite2D.flip_v = true
		upside_down = true;
	elif velocity.y < 0:
		$AnimatedSprite2D.flip_v = false
		upside_down = false;
	else:
		$AnimatedSprite2D.flip_v = upside_down;

	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		facing_back = false;
	elif velocity.y < 0:
		$AnimatedSprite2D.flip_h = true
		facing_back = true;
	else:
		$AnimatedSprite2D.flip_h = facing_back;

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos: Vector2):
	position = pos
	show()
	$CollisionShape2D.disabled = false
