extends Node2D

# GameManager controls the flow of rounds and keeps track of
# all active players. Each round the lowest scoring player is
# eliminated until only one winner remains.

# Reference to the Player class for convenience
const Player = preload("res://Scripts/Player.gd")

# Array of Player objects taking part in the game
var players: Array = []

# Current round index
var round: int = 0

# Reference to the Shop node handling purchases
var shop: Node

func _ready() -> void:
    # Called when the node enters the scene tree.
    # Here we create our players and immediately start the first round
    init_players()
    shop = get_node("../Shop")
    next_round()

func init_players() -> void:
    # In a real project players could come from a lobby or saved data.
    # For this prototype we create a fixed list of three participants
    players = [
        Player.new("Player1", 3),
        Player.new("Player2", 3),
        Player.new("Player3", 3),
    ]

func next_round():
    round += 1
    print("\n--- Round %d ---" % round)
    # Each player attempts to buy one card from the shop
    for p in players:
        shop.buy_card(p)
    tally_scores()

func tally_scores():
    # Calculate scores for each player based on their hands
    for p in players:
        p.calculate_score()
        print("%s score: %d" % [p.name, p.score])

    # Sort players ascending by score so the lowest is first
    players.sort_custom(_sort_by_score)

    if players.size() > 1:
        # Remove the player with the least points
        var removed = players.pop_front()
        print("%s removed" % removed.name)

        # Continue to the next round while more than one player remains
        if players.size() > 1:
            next_round()
        else:
            print("%s wins!" % players[0].name)
    else:
        print("Game over")

func _sort_by_score(a, b):
    # Helper for sorting players by score in ascending order
    return a.score < b.score
