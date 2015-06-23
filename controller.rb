# Multi-Deck Blackjack in Ruby
# https://github.com/em77

require_relative 'model'
require_relative 'view'

class Game
	attr_accessor :player, :shoe, :continue, :deck_num

	def initialize(bankroll)
		deck_choices = [2,4,6,8]
		@deck_num = deck_num_prompter(deck_choices)
		@shoe = Shoe.new(deck_num)
		@continue = "y"
		@player = Player.new(((Prompt::name_prompt).capitalize!), bankroll)
	end

	def deck_num_prompter(deck_choices)
		decision_made = 0
		until deck_choices.include? decision_made
			decision_made = Prompt::deck_num_prompt(deck_choices)
		end
		decision_made
	end

	def start
		Message::greeting(deck_num)
		do_game
		Message::broke_message(player.bankroll) if player.broke?
		Message::exit_message
	end

	def do_game
		while (continue == "y") && !(player.broke?)
			player.hands.clear
			round = Round.new(deck_num, shoe, player)
			round.do_round
			self.continue = Prompt::play_again_prompt
			if shoe.current_cards.count <= 15
				shoe.shuffle_up(deck_num)
				Message::shuffle_message
			end
		end
	end
end

class Round
	attr_accessor :shoe, :player_hand, :dealer_hand, :decision, :player, :shoe, :play

	def initialize(deck_num, shoe, player)
		@decision = "h"
		@shoe = shoe
		@player = player
		@play = Play.new(self)
		@player_hand = Hand.new {player}
		@dealer_hand = Hand.new
		2.times {shoe.deal_card(player_hand)}
		2.times {shoe.deal_card(dealer_hand)}
	end

	def there_is_blackjack?
		if (dealer_hand.total == 21) && (player_hand.total == 21)
			self.player.bankroll += player_hand.bet
			Display::display_final(player_hand, dealer_hand, player.name) {Results::tie}
			return true
		elsif dealer_hand.total == 21
			Display::display_final(player_hand, dealer_hand, player.name) {Results::dealer_has_blackjack(player.name, player_hand.bet)}
			return true
		elsif player_hand.total == 21
			player.add_to_bankroll(player_hand, player_hand.bet * 2.5)
			self.player_hand.bet *= 1.5
			Display::display_final(player_hand, dealer_hand, player.name) {Results::player_has_blackjack(player.name, player_hand.bet)}
			return true
		end
		false
	end

	def dealer_play
		while dealer_hand.total <= 16
			shoe.deal_card(dealer_hand)
		end
	end

	def results
		player.hands.each_with_index do |hand, index|
			if decision == "sur"
				player.add_to_bankroll(hand, hand.bet)
				Display::display_final(hand, dealer_hand, player.name, index) {Results::surrender(player.name, hand.bet)}
			elsif hand.busted? || ((hand.total < dealer_hand.total) && !dealer_hand.busted?)
				Display::display_final(hand, dealer_hand, player.name, index) {Results::dealer_won(player.name, hand.bet)}
			elsif (hand.total > dealer_hand.total) || (dealer_hand.busted?)
				self.player.bankroll += (hand.bet * 2)
				Display::display_final(hand, dealer_hand, player.name, index) {Results::player_won(player.name, hand.bet)}
			elsif hand.total == dealer_hand.total
				self.player.bankroll += hand.bet
				Display::display_final(hand, dealer_hand, player.name, index) {Results::tie}
			end
		end
	end

	# Returns index of first hand that has not been played
	def index_has_not_been_played(hands)
		hands.index {|hand| hand.has_been_played == false}
	end

	def bet_prompter(player, hand)
		while (hand.bet < 5) || (hand.bet % 0.5 != 0) || (hand.bet >= player.bankroll)
			Prompt::bet_prompt(player, hand)
		end
		player.withdraw_from_bankroll(player_hand, player_hand.bet)
	end

	def play_loop
		while index_has_not_been_played(player.hands)
			player.hands.each do |hand|
				play.do_play(hand, player.hands.index(hand)) if hand.has_been_played == false
			end
		end
	end

	def do_round
		bet_prompter(player, player_hand)
		if !there_is_blackjack?
			play_loop
			dealer_play
			results
		end
	end
end

class Play
	attr_accessor :round, :choices

	def initialize(round)
		@round = round
		@choices = []
	end

	def do_play(current_player_hand, hand_index)
		while !current_player_hand.has_been_played && (current_player_hand.total <= 20)
			play(current_player_hand, hand_index)
		end
	end

	def play(current_player_hand, hand_index)
			Display::display_upcard(round.dealer_hand)
			Display::display_hand(current_player_hand, round.player.name) {Display::display_hand_number(hand_index)}
			get_choices(current_player_hand)
			get_decision(current_player_hand)
			make_decision(current_player_hand)
	end

	def get_decision(current_player_hand)
		Display::blackjack_moves
		decision_made = nil
		until choices.include? decision_made
			decision_made = Prompt::decision_prompt(choices)
		end
		self.round.decision = decision_made
	end

	def make_decision(current_player_hand)
		case round.decision
		when "h"
			round.shoe.deal_card(current_player_hand)
			current_player_hand.has_been_played = true if current_player_hand.total >= 21
		when "s"
			current_player_hand.has_been_played = true
		when "d"
			doubler_splitter_decision_maker(choices, round.decision, current_player_hand) {double_down(current_player_hand)}
			current_player_hand.has_been_played = true if choices.include? "d"
		when "sur"
			surrender(current_player_hand)
			current_player_hand.has_been_played = true
		when "sp"
			doubler_splitter_decision_maker(choices, round.decision, current_player_hand) {do_split(current_player_hand)}
		end
	end

	def doubler_splitter_decision_maker(available_choices, choice, current_player_hand)
		if round.player.enough_in_bankroll?(current_player_hand.bet, round.decision)
			round.player.withdraw_from_bankroll(current_player_hand, current_player_hand.bet)
			yield
		else
			Message::not_enough_money
			choices_fixer(choice)
			get_decision(current_player_hand)
			make_decision(current_player_hand)
		end
	end

	def double_down(current_player_hand)
		current_player_hand.bet *= 2
		round.shoe.deal_card(current_player_hand)
	end

	def surrender(current_player_hand)
		current_player_hand.bet /= 2
	end

	def split_hand(shoe, player, original_hand, new_hand)
		new_hand.cards << original_hand.cards.delete_at(0)
		shoe.deal_card(original_hand)
		shoe.deal_card(new_hand)
		new_hand.bet = original_hand.bet
	end

	def do_split(current_player_hand)
		# if round.player.hands.count == 4
		# 	Message::maximum_split
		# 	choices_fixer("sp")
		# 	return
		# else
			new_hand = Hand.new {round.player}
			split_hand(round.shoe, round.player, current_player_hand, new_hand)
		# end
	end

	def choices_fixer(remove_choice)
		choices.delete(remove_choice)
	end

	def get_choices(current_player_hand)
		if first_two_not_splittable?(current_player_hand)
			self.choices = ["h", "d", "s", "sur"]
		elsif not_first_two_not_splittable_or_final_split_opportunity?(current_player_hand)
			self.choices = ["h", "d", "s"]
		elsif first_two_splittable?(current_player_hand)
			self.choices = ["h", "d", "s", "sp", "sur"]
		elsif not_first_two_and_splittable?(current_player_hand)
			self.choices = ["h", "d", "s", "sp"]
		else
			self.choices = ["h", "s"]
		end
	end

	def first_two_not_splittable?(hand)
		hand.cards.count == 2 && (hand.cards[0][:points] != hand.cards[1][:points]) && (!round.player.there_are_split_hands?)
	end

	def not_first_two_not_splittable_or_final_split_opportunity?(hand)
		((hand.cards.count == 2) && (round.player.there_are_split_hands?)) && ((hand.cards[0][:points] != hand.cards[1][:points]) || (round.player.hands.count == 4))
	end

	def first_two_splittable?(hand)
		((hand.cards[0][:points] == hand.cards[1][:points])) && (hand.cards.count == 2) && (!round.player.there_are_split_hands?)
	end

	def not_first_two_and_splittable?(hand)
		((hand.cards[0][:points] == hand.cards[1][:points])) && (hand.cards.count == 2) && (round.player.there_are_split_hands?) && (round.player.hands.count <= 3)
	end
end

########## Game starter ##########
game = Game.new(100).start
##################################