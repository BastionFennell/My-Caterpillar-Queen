extends Position2D
 
const MIN_DIST = 20
 
onready var joint1 = get_node("Joint 1")
onready var joint2 = get_node("Joint 1/Joint 2")
onready var hand = get_node("Joint 1/Joint 2/Hand")
 
var len_upper = 0
var len_middle = 0
var len_lower = 0
 
export var flipped = false
 
var goal_pos = Vector2()
var int_pos = Vector2()
var start_pos = Vector2()
var step_height = 50
var step_rate = 0.1
var step_time = 0.0
 
func _ready():
	len_upper = joint1.position.x
	len_middle = joint2.position.x
	len_lower = hand.position.x
 
	if !flipped:
		$Sprite.flip_h = true
		joint1.get_node("Sprite").flip_v = true
		joint2.get_node("Sprite").flip_v = true

func step(g_pos):
	if goal_pos == g_pos:
		return
 
	goal_pos = g_pos
	var hand_pos = hand.global_position
 
	var midY = (goal_pos.y + hand_pos.y) / 2.0
	var midX = goal_pos.x

	if get_parent().global_position.x < global_position.x:
		midX += step_height
	else:
		midX -= step_height

	start_pos = hand_pos
	int_pos = Vector2(midX, midY)
	step_time = 0.0
 
func _process(delta):
	var len_total = len_upper + len_middle + len_lower
	var offset = goal_pos - global_position
	var dis_to_tar = offset.length()

	step_time += delta

	if abs(offset.y) < 40:
		if goal_pos.y < global_position.y:
			step(Vector2(get_parent().global_position.x, global_position.y - len_total * 0.8))
		else:
			step(Vector2(get_parent().global_position.x, global_position.y + len_total * 0.8))

	if dis_to_tar > len_total * 0.8:
		if goal_pos.y < global_position.y:
			step(Vector2(get_parent().global_position.x, global_position.y - 40))
		else:
			step(Vector2(get_parent().global_position.x, global_position.y + 40))

	var target_pos = Vector2()
	var t = step_time / step_rate

	if t < 0.5:
		target_pos = start_pos.linear_interpolate(int_pos, t / 0.5)
	elif t < 1.0:
		target_pos = int_pos.linear_interpolate(goal_pos, (t - 0.5) / 0.5)
	else:
		target_pos = goal_pos


	update_ik(target_pos)

func update_ik(target_pos):
	var offset = target_pos - global_position
	var dis_to_tar = offset.length()
	if dis_to_tar < MIN_DIST:
		offset = (offset / dis_to_tar) * MIN_DIST
		dis_to_tar = MIN_DIST
 
	var base_r = offset.angle()
	var len_total = len_upper + len_middle + len_lower
	var len_dummy_side = (len_upper + len_middle) * clamp(dis_to_tar / len_total, 0.0, 1.0)
 
	var base_angles = SSS_calc(len_dummy_side, len_lower, dis_to_tar)
	var next_angles = SSS_calc(len_upper, len_middle, len_dummy_side)
 
	global_rotation = base_angles.B + next_angles.B + base_r
	joint1.rotation = next_angles.C
	joint2.rotation = base_angles.C + next_angles.A
 
func SSS_calc(side_a, side_b, side_c):
	if side_c >= side_a + side_b:
		return {"A": 0, "B": 0, "C": 0}
	var angle_a = law_of_cos(side_b, side_c, side_a)
	var angle_b = law_of_cos(side_c, side_a, side_b) + PI
	var angle_c = PI - angle_a - angle_b
 
	if flipped:
		angle_a = -angle_a
		angle_b = -angle_b
		angle_c = -angle_c
 
	return {"A": angle_a, "B": angle_b, "C": angle_c}
 
func law_of_cos(a, b, c):
	if 2 * a * b == 0:
		return 0
	return acos( (a * a + b * b - c * c) / ( 2 * a * b) )
