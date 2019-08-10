extends Hand

class_name OpponentHand

func _ready():
	subscribe_to_signals()
	MainCamera = get_tree().root.get_node("Game/MainCamera")
	
	global_transform.origin = Vector3(0, 1, -6.5)
	
	#update_card_sizes()