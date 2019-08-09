extends MeshInstance

class_name Card

signal any_enter_deck
signal any_enter_hand
signal any_enter_stack
signal any_enter_battlefield
signal any_enter_graveyard
signal any_enter_exile
signal any_enter_reveal

export var HIGHLIGHT_SPEED = 3
export var HIGHLIGHT_ZOOM : float = 1.75

export var MOVE_SPEED = 1

var Name : String
var CMC : String setget set_cmc
var ImageName : String
var CardText : String
var Effect : String
var SuperType = [] setget set_super_type
var Type = [] setget set_type
var SubType = [] setget set_sub_type
var PreviousZone = MTG.Zone.Deck
var Zone = MTG.Zone.Hand
var Tapped = false
var Controller
var Game

var _highlighted = false
var _lerpCounter = 0
var _transform = false
var _changingZones = false
var _mainCamera : Camera
var _meshSize : Vector2
var _targetRotation
var _targetPosition : Vector3 setget set_target_position

"""
	Setters
"""

func set_cmc(cmc : String):
	pass

func set_super_type(super_types):
	if(typeof(super_types) == TYPE_ARRAY):
		SuperType = super_types
	else:
		SuperType.push_back(super_types)

func set_type(type):
	if(typeof(type) == TYPE_ARRAY):
		Type = type
	else:
		Type.push_back(type)
		
func set_sub_type(sub_type):
	if(typeof(sub_type) == TYPE_ARRAY):
		SubType = sub_type
	else:
		SubType.push_back(sub_type)

func set_target_position(targetPosition : Vector3):
	_targetPosition = targetPosition
	_transform = true
	_lerpCounter = 0


"""
	Public functions
"""
func tap():
	if !Tapped:
		rotate_object_local(Vector3.UP, PI/2)
	
func untap():
	pass
	
func sacrifice():
	pass

func change_zone(zone):
	if _changingZones: #this would happen if the player played a card and the clicked next before the card finished moving
		change_zone_finished()
	else:
		_changingZones = true
		
	PreviousZone = Zone
		
	if(zone == Zone):
		return
	
	if(zone == MTG.Zone.Hand):
		pass
		
	if(zone == MTG.Zone.Stack):
		if MTG.Type.Land in Type:
			zone = MTG.Zone.Battlefield
		else:
			Zone = MTG.Zone.Stack
			var old_position = global_transform
			get_parent().remove_child(self)
			Controller.Stack.add_child(self)
			global_transform = old_position
			Controller.card_played(self)
		
	if(zone == MTG.Zone.Battlefield):
		Zone = MTG.Zone.Battlefield
		var old_position = global_transform
		get_parent().remove_child(self)
		if(MTG.Type.Land in Type):
			Controller.Battlefield.RowTwo.add_child(self)
		else:
			Controller.Battlefield.RowOne.add_child(self)
		global_transform = old_position
		if MTG.Type.Land in Type:
			Controller.card_played(self)
		Controller.card_resolved(self)
		_targetRotation = null

func change_zone_finished():
	
	if Zone == MTG.Zone.Deck:
		emit_signal("any_enter_deck", self)
		
	elif Zone == MTG.Zone.Hand:
		emit_signal("any_enter_hand", self)
	
	elif Zone == MTG.Zone.Stack:
		emit_signal("any_enter_stack", self)
		
	elif Zone == MTG.Zone.Battlefield:
		emit_signal("any_enter_battlefield", self)
		
	elif Zone == MTG.Zone.Graveyard:
		emit_signal("any_enter_graveyard", self)
		
	elif Zone == MTG.Zone.Exile:
		emit_signal("any_enter_exile", self)
		
	elif Zone == MTG.Zone.Reveal:
		emit_signal("any_enter_reveal", self)

func connect_to_signals():
	get_node("StaticBody").connect("mouse_entered", self, "_mouse_entered")
	get_node("StaticBody").connect("mouse_exited", self, "_mouse_exited")
	
	for card in Game.get_all_cards():
		card.connect("any_enter_deck", self, "on_any_enter_deck")
		card.connect("any_enter_hand", self, "on_any_enter_hand")
		card.connect("any_enter_stack", self, "on_any_enter_stack")
		card.connect("any_enter_battlefield", self, "on_any_enter_battlefield")
		card.connect("any_enter_graveyard", self, "on_any_enter_graveyard")
		card.connect("any_enter_exile", self, "on_any_enter_exile")
		card.connect("any_enter_reveal", self, "on_any_enter_reveal")

"""
	Card scripting callbacks
"""
func on_activated(effect):
	pass

func on_any_enter_deck(card : Card):
	if(card == self):
		on_enter_deck()

func on_enter_deck():
	print(Name + " entered the deck")

func on_any_enter_hand(card : Card):
	if(card == self):
		on_enter_hand()

func on_enter_hand():
	print(Name + " entered the hand")

func on_any_enter_stack(card : Card):
	if(card == self):
		on_enter_stack()

func on_enter_stack():
	print(Name + " entered the stack")

func on_any_enter_battlefield(card : Card):
	if(card == self):
		on_enter_battlefield()

func on_enter_battlefield():
	print(Name + " entered the battlefield")

func on_any_enter_graveyard(card : Card):
	if(card == self):
		on_enter_graveyard()

func on_enter_graveyard():
	print(Name + " entered the graveyard")

func on_any_enter_exile(card : Card):
	if(card == self):
		on_enter_exile()

func on_enter_exile():
	print(Name + " entered the exile")

func on_any_enter_reveal(card : Card):
	if(card == self):
		on_enter_reveal()

func on_enter_reveal():
	print(Name + " entered the reveal zone")

func on_upkeep():
	pass
	
func on_controller_upkeep():
	pass
	
func on_opponent_upkeep():
	pass

"""
	Callbacks functions
"""
func _ready():
	
	Controller = get_parent().get_parent()
	Game = get_tree().root.get_node("Game")
	
	_mainCamera = get_tree().root.get_node("Game/MainCamera")
	_meshSize = mesh.size
	
	var material = SpatialMaterial.new()
	material.albedo_texture = load("res://Cards/Images/" + Name.substr(0, 1) + "/" + ImageName)
	material.flags_unshaded = true
	material.flags_transparent = true
	set_surface_material(0, material)
	
	connect_to_signals()
	
func _process(delta):
	
	if(_lerpCounter > 1):
		return
	
	if Zone == MTG.Zone.Hand:
		
		if(Input.is_action_just_released("drag") && (_targetPosition - global_transform.origin).length() > 2):
			change_zone(MTG.Zone.Stack)
			
		if !Input.is_action_pressed("drag") && _transform:
			if(_highlighted):
				scale = lerp(scale, Vector3(HIGHLIGHT_ZOOM, 1, HIGHLIGHT_ZOOM), _lerpCounter)
				global_transform.origin = lerp(global_transform.origin, (_targetPosition - 1 * global_transform.basis.z) + Vector3(0,0,0.01), _lerpCounter)
			else:
				scale = lerp(scale, Vector3.ONE, _lerpCounter)
				global_transform.origin = lerp(global_transform.origin, _targetPosition, _lerpCounter)
	
			_lerpCounter += delta * HIGHLIGHT_SPEED
	
	if Zone == MTG.Zone.Stack && _transform:
		global_transform.origin = lerp(global_transform.origin, _targetPosition, _lerpCounter)
		
		_lerpCounter += delta * MOVE_SPEED
	
	if Zone == MTG.Zone.Battlefield && _transform:
		global_transform.origin = lerp(global_transform.origin, _targetPosition, _lerpCounter)

		if(_targetRotation == null):
			var lookDir = Controller.Battlefield.global_transform.origin - global_transform.origin 
			_targetRotation = global_transform.looking_at(-lookDir,Vector3.UP)
			
		var thisRotation = Quat(global_transform.basis).slerp(_targetRotation.basis, _lerpCounter)
		
		global_transform = Transform(thisRotation,global_transform.origin)
		
		_lerpCounter += delta * MOVE_SPEED
	
	if(_lerpCounter > 1):
		if _transform && _changingZones:
			change_zone_finished()
			_changingZones = false
		_transform = false
		_lerpCounter = 1

func _input(event):
	if event is InputEventMouseMotion && _highlighted && Input.is_action_pressed("drag"):
		global_translate(Vector3(event.relative.x, 0, event.relative.y) * 0.01)

func _mouse_entered():
	_highlighted = true
	_lerpCounter = 0
	_transform = true
	
	#translate up slightly so that this card is drawn on top when in hand
	if (Zone == MTG.Zone.Hand):
		translate_object_local(Vector3.UP * 0.01)
		
	if (Zone == MTG.Zone.Battlefield):		
		var cardinfopanel : Node2D = get_tree().root.get_node("Game/CardInfoPanel")
		
		var pos = _mainCamera.unproject_position(global_transform.origin)
		if(pos.x < get_viewport().size.x/2):
			pos.x += 60
		else:
			pos.x -= 585
		pos.y -= 170
		
		cardinfopanel.position = pos
		
		cardinfopanel.get_node("Panel/CardImage").texture = load("res://Cards/Images/" + Name.substr(0, 1) + "/" + ImageName)
		cardinfopanel.get_node("Panel/CardName").text = Name
		cardinfopanel.get_node("Panel/CardText").text = CardText
		cardinfopanel.show()
	
func _mouse_exited():
	_highlighted = false
	_lerpCounter = 0
	_transform = true
	
	if (Zone == MTG.Zone.Battlefield):
		get_tree().root.get_node("Game/CardInfoPanel").hide()

