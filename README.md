# Shelatro Game Project

Shelatro is an experimental card/roguelike strategy game inspired by the "Bunker" gameplay concept. The repository contains a minimal Godot project with basic card interaction. This document summarizes the current design ideas.

## Game Overview
* The game is designed for three or more players.
* Each round one player is eliminated. The total number of rounds is `players - 1`.
* Between rounds players can buy cards in a shop using in-game currency.
* Currency is rewarded for victories and certain card effects.
* The last remaining player wins.

## Card Mechanics
Cards have various categories and editions. Some examples from the draft design:

* **Sh (Shelter/Bunker)** – one common card for all players at the start.
* **Ap (Apocalypse)** – one common card defining world conditions.
* **Ge (Gender)** – personal card, cannot be changed without a special ability.
* **Ag (Age)** – personal card, cannot be changed without a special ability.
* **He (Health)** – can be positive or negative. Up to two per player.
* **Ph (Phobia)** – negative traits.
* **Pr (Profession)** – starting profession.
* **Mi (Miscellaneous Info)** – traits that can be positive or negative.
* **Ho (Hobby)** – up to three per player.
* **Ph (Physique)** – body build; positive or negative.
* **Ch (Character)** – positive or negative character traits.
* **Ba (Backpack)** – can be traded or sold at any time.
* **Li (Large inventory)** – up to two. Can be traded or sold at any time.
* **Sa (Special abilities)** – can be used or sold at any time.

Cards may exist in several editions (standard, foil, polychrome, negative) which affect scoring.

## Round Flow
1. Deal basic cards to all players.
2. Shop phase.
3. Score counting. Players with the lowest score are nominated for elimination, and the remaining players vote to remove one of them.
4. If more than one player remains, return to the shop phase.

## Score Calculation
`ScoreManager.gd` contains helper functions for computing a player's score based on card IDs. Each card in `CardsDataBase.gd` now includes a numeric value in its data array. `calculate_score(["42_years", "Ushanka_hat"])` for example returns `2`.

## Blinds
Each round can have a random blind (round modifier) such as:
* Ignore health cards.
* Double the effects of hobby cards.
* Halve the score of the player with the most cards.
* Remove a random card from the player with the highest score.

## Roadmap
The current project only demonstrates card dragging and basic deck handling. Upcoming steps:

1. Expand the `CardsDataBase.gd` to contain full information about all card categories.
2. Implement a `GameManager` script to handle rounds and player elimination. A new `ScoreManager` already provides basic score calculation for a list of card IDs.
3. Add a simple shop interface for buying and selling cards.
4. Implement blind modifiers and support for card editions.

