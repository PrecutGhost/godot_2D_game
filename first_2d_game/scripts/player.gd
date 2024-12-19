extends Area2D

# 声明变量
@export var speed = 400 # 玩家移动速度;同时设置该数值在检查器中可调整
var screen_size # 游戏窗口大小尺寸
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO #玩家的移动矢量
	# 检查输入
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	
	# 是否移动并调用动画
	if velocity.length() >0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	# 设置不同的玩家动画
	if velocity.x != 0:
		animated_sprite.play("walk")
		animated_sprite.flip_v = false
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.play("up")
		animated_sprite.flip_v = velocity.y > 0
	
	# 更新玩家位置
	position += velocity * delta
	position = position.clamp(Vector2.ZERO , screen_size)
	
signal hit

func _on_body_entered(body: Node2D) -> void:
	hide() # 发生碰撞后玩家隐藏
	hit.emit()
	$CollisionShape2D.set_deferred("disabled" , true) # 解除碰撞体
	
# 调用播放器确认何时开始游戏
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
