extends Node2D


const CARD_WIDTH = 140
const HAND_Y_POSITION = 890

var player_hand = []
var center_screen_x


func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2


func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_position()
        else:
                animate_card_to_position(card, card.card_starting_position)

func remove_card_from_hand(card):
        if card in player_hand:
                player_hand.erase(card)
                update_hand_position()

func update_hand_position():
	for i in range(player_hand.size()):
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.card_starting_position = new_position
		animate_card_to_position(card, new_position)


func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset
	
	
func animate_card_to_position(card, new_position):
        var tween = get_tree().create_tween()
        tween.tween_property(card, "position", new_position, 0.3)

func get_card_ids() -> Array:
        var ids := []
        for card in player_hand:
                ids.append(card.card_id)
        return ids

func calculate_score() -> int:
        var ScoreManager = preload("res://Scripts/ScoreManager.gd")
        return ScoreManager.calculate_score(get_card_ids())
	
	
	
	
	
	
	
