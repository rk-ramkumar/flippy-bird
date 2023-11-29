extends ViewportContainer

var pipeScene = preload("res://Pipe.tscn")
var pipeSpawnTimer = 2  
var pipeSpeed = 200 
var screen_size 
var score = 0    

func spawn_pipe(direction):
	var directions = {
		"up": Vector2(screen_size.x, -screen_size.y / 1.5),
		"down": Vector2(screen_size.x, screen_size.y / 2.5),
	}

	var new_pipe = pipeScene.instance()
	new_pipe.position = directions[direction]
	new_pipe.scale.y = randi() % 2  + 1
	print(new_pipe.position,new_pipe.scale)

	new_pipe.connect("body_entered", self, "_on_Pipe_body_entered")
	$Pipes.add_child(new_pipe)
	new_pipe.add_to_group("pipes")

func remove_pipes(pipe):
	var node_position = pipe.global_position
	if node_position.x < -600:
		pipe.queue_free()

func update_speed():
	if score > 1000:
		pipeSpeed = 500

func _process(delta):	
		for pipe in $Pipes.get_children():
			remove_pipes(pipe)
			pipe.position.x -= pipeSpeed * delta
		pipeSpawnTimer -= delta
		if pipeSpawnTimer <= 0:
			spawn_pipe("up")
			spawn_pipe("down")
			pipeSpawnTimer = 2 
		update_score(1)
		$Score.text = str(score)
		update_speed()

func update_score(new_score):
	score += new_score
func _ready():
	randomize()
	screen_size = get_viewport().size	
	$Bird.position = Vector2(100, 100) 
	$GameOverScreen/ColorRect.rect_min_size = screen_size
	$GameOverScreen.hide()
	$Score.text = str(score)
	get_tree().connect("screen_resized", self, "_on_screen_resized") 
	spawn_pipe("up")
	spawn_pipe("down")

func _on_screen_resized():
	screen_size = get_viewport().size
	$GameOverScreen/ColorRect.rect_min_size = screen_size
	$Area2D/CollisionShape2D.position.y = screen_size.y - 500
	$GameOverScreen/Retry.rect_position = screen_size / 2 
 

func game_over():
	get_tree().paused = true
	$GameOverScreen.show()

func _on_Area2D_body_entered(body):
	game_over()


func _on_GameOverScreen_restart():
	get_tree().call_group("pipes", "queue_free")
	score = 0
	pipeSpeed = 200
	_ready()


func _on_Pipe_body_entered(body):
	game_over()
