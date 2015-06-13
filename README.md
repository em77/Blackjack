# Multi-Deck Blackjack in Ruby
# https://github.com/em77

This is a Multi-Deck Blackjack command-line based game written in Ruby. In terms of card handling and viewing, dealer actions, player actions, rules, shuffling, deck penetration, vulnerability to card counting and terminology, I have attempted to mirror a real blackjack game as realistically as possible. It may not look very pretty, but it should work as it's intended. I've recently re-designed the whole program along object-oriented and Model-View-Controller (MVC) design. I plan to tweak the coding design and implementation a bit more soon, possibly add more features and hope to deploy it graphically in a web environment.

Enjoy playing!

##Specific Rules & Conditions
1. The game can be played with 2, 4, 6, or 8 decks, as these are the most likely shoe options that would be available in a variety of real casinos.
2. Dealer must draw on all 16's and stand on all 17's.
3. Late surrender is available, meaning the player can "surrender" their first two cards and get half their bet back but only after the dealer has checked for a blackjack. This is only available on the first two cards and as such is not available after splitting.
4. On any hand (Including hands generated from splitting), the player may choose to "double" their bet on their first two cards and then receive only one additional card.
5. The player may split up to three times (To a total of four hands) on each round.
6. The cut card is placed at the 15 card mark in the deck. When there are 15 or less cards left, the deck is replenished and shuffled.

##Glossary
**Stand** - To stop taking new cards on a hand.  
**Hit** - To request another card on a hand.  
**Double Down** - To double one's bet and receive one final card on a hand.  
**Surrender** - To "give up" the hand and receive half the bet back on a hand.  
**Split** - Two-card hands where both cards have the same point value may be split to make additional hands, receiving one new card on each hand and playing all hands against the single dealer's hand. In order to do this, the player must have enough money to put down the same amount as their original bet again for each additional hand.  
**Push** - A tie between the player's hand and the dealer's hand. No money is lost or won.  
**Blackjack** - When the initial two cards on a hand total 21. A player is paid 3:2 on a blackjack win as opposed to the 1:1 payout on a normal win. If the player and dealer both have blackjack, it is a push.  
**Cut card** - The point at which the deck is replenished and shuffled.  
**Penetration** - The depth of the cut card in the deck.  
**Burn** - A card is "burned" when it is discarded without being dealt out or played. Typically one card is burned after each shuffle and is not generally visible to the players, so that is what happens in this game as well.