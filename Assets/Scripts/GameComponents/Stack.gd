extends Spatial

class_name Stack


var MainCamera : Camera

func get_next_card() -> Card:
	var card : Card = get_child(get_child_count()-1)
	return card

# Called when the node enters the scene tree for the first time.
func _ready():
	MainCamera = get_tree().root.get_node("Game/MainCamera")
	
	global_transform.origin =  MainCamera.global_transform.origin - MainCamera.global_transform.basis.z * get_parent().get_node("Hand").DistanceToCamera

	look_at(MainCamera.global_transform.origin, Vector3.UP)
	rotate_object_local(Vector3.LEFT, PI/2)
	rotate_object_local(Vector3.UP, PI)
	
	translate_object_local(Vector3.RIGHT * 6.5)
	
	subscribe_to_signals()

func _process(delta):
	pass

func subscribe_to_signals():
	for player in get_tree().root.get_node("Game/Players").get_children():
		player.connect("card_played", self, "_card_played")
		
	get_tree().root.get_node("Game/UI/BtnNext").connect("pressed", self, "_card_resolves")
		
func _card_played(card : Card):
	if MTG.Type.Land in card.Type:
		return
	for i in range(0, get_child_count()-1):
		var j = get_child_count() - i -1
		get_child(i)._targetPosition = get_child(i).global_transform.origin + Vector3(0, 0.01, -.5)
		
	card._targetPosition = global_transform.origin

func _card_resolves():
	if(get_child_count() == 0):
		return
	
	var card = get_next_card()
	
	if (MTG.Type.Instant in card.Type || MTG.Type.Sorcery in card.Type):
		card.change_zone(MTG.Zone.Graveyard)
	else:
		card.change_zone(MTG.Zone.Battlefield)
		
	for i in range(0, get_child_count()):
		var j = get_child_count() - i -1
		get_child(i)._targetPosition = get_child(i).global_transform.origin - Vector3(0, 0.01, -.5)
