extends Node2D

# Simple deck that spawns card scenes and hands them to the player hand.
# Cards are removed from the internal list as they are drawn.


const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var player_deck = ["Ag_42", "Ag_42", "Ag_42", "Ag_42", "Ag_42", "Ag_42"]


func _ready() -> void:
	print($Area2D.collision_mask)


func draw_card() -> Node:
        # Remove the top card from the deck and create its scene.
	var drag_drawn = player_deck[0]
	player_deck.erase(drag_drawn)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	print("draw card")
	var card_scene = preload(CARD_SCENE_PATH)

	var new_card = card_scene.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
        $"../PlayerHand".add_card_to_hand(new_card)
        return new_card
