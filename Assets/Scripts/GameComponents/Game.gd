extends Spatial

class_name Game

var ActivePlayer : Player
var CurrentTurn = 1
var CurrentPhase = MTG.Phase.Untap

func _ready():
	pass # Replace with function body.

func get_all_cards():
	return get_node("Players/Player/Hand").get_children()