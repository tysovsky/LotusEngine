extends Node

class_name Player

signal card_played
signal card_resolved

var Id : int
var Username : String
var Deck : Deck
var Hand : Hand
var Graveyard : Graveyard
var Stack : Stack
var Battlefield : Battlefield

# Called when the node enters the scene tree for the first time.
func _ready():
	Deck = get_node("Deck")
	Hand = get_node("Hand")
	Graveyard = get_node("Graveyard")
	Stack = get_node("Stack")
	Battlefield = get_node("Battlefield")
	

func card_played(card : Card):
	emit_signal("card_played", card)
	
func card_resolved(card : Card):
	emit_signal("card_resolved", card)