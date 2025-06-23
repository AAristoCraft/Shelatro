extends Node2D


const CARD_SCENE_PATH = "res://Scenes/Card.tscn"

var player_deck = ["42_years", "42_years", "Ushanka_hat", "42_years"]


func _ready() -> void:
	print($Area2D.collision_mask)


func draw_card():
        var drawn_id = player_deck[0]
        player_deck.erase(drawn_id)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
	
	print("draw card")
	var card_scene = preload(CARD_SCENE_PATH)

        var new_card = card_scene.instantiate()
        new_card.card_id = drawn_id
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card)
