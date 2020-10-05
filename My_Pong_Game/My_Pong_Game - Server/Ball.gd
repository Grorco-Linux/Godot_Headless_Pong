extends KinematicBody2D

puppet var puppet_position = Vector2()
var velocity = Vector2(1,0)
var moving = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Tell the clients where the ball is
	rset('puppet_position', self.position)
	movement(delta)


func movement(delta):
	# This changes the velocity if the ball hits a wall, or paddle
	if self.position.y > 0 + 10 and self.position.y < 600 - 10:
		pass
	else:
		velocity = velocity.bounce(Vector2(0,1))
	
	# When the ball should be moving, move it in a straight line until it collides
	if moving:
		var collision = move_and_collide(velocity*delta*500)
		if collision:
			velocity = velocity.bounce(Vector2(1,0))
	

func reset():
	# Center the ball
	self.position.x = 512
	self.position.y = 300
	# Get new random seed
	randomize()
	# Set a random velocity
	velocity = velocity.rotated(deg2rad(rand_range(0, 360)))

