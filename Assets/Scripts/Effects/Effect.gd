extends Node

class_name Effect

var _card : Card
var _effect_func : String

func _init(card : Card, effect_func : String):
	_effect_func = effect_func
	_card = card
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func activate():
	_card.call(_effect_func)
	pass