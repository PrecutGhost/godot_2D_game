extends RigidBody2D

func _ready() -> void:
	# 获取动画列表,并返回名称
	var mod_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	# 随机选择一个列表索引整数
	$AnimatedSprite2D.play(mod_types[randi() % mod_types.size()])
	
# 让敌人在离开屏幕时删除自己
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
