extends Spatial

class_name Hand

var MainCamera : Camera
var DistanceToCamera = 7

func Put(card : Card):
	pass


func _ready():
	MainCamera = get_tree().root.get_node("Game/MainCamera")
	
	global_transform.origin =  MainCamera.global_transform.origin - MainCamera.global_transform.basis.z * DistanceToCamera

	look_at(MainCamera.global_transform.origin, Vector3.UP)
	rotate_object_local(Vector3.LEFT, PI/2)
	rotate_object_local(Vector3.UP, PI)
	
	translate_object_local(Vector3.BACK * 4.8)
	
	subscribe_to_signals()
	
	update_card_sizes()
	
func subscribe_to_signals():
	for player in get_tree().root.get_node("Game/Players").get_children():
		player.connect("card_played", self, "_card_played")

func update_card_sizes():	
	var num_children = 0
	
	for child in get_children():
		if child.visible:
			num_children += 1
	
	if num_children == 0:
		return
	
	var distance_between_cards = 0.05
	var card_size = get_child(0).mesh.size
	var horiz_size = (card_size.x * num_children) + (num_children-1)*distance_between_cards
	
	var i = 0
	for child in get_children():
		if (!child.visible):
			continue
			
		child.transform.origin = Vector3(0,0,0)
		child.translate_object_local(
			Vector3(
				-(horiz_size/2 - card_size.x/2) + i * (card_size.x + distance_between_cards) ,
				 0,
				 0))
		
		
		child._targetPosition = get_child(i).global_transform.origin
		
		i += 1
		
func _card_played(card : Card):
	update_card_sizes()