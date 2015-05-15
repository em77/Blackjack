def greeting
	puts "\nWelcome to Double-Deck Blackjack!"
	puts "Minimum bet: $5\n\n"
	sleep 1
	puts "We are just beginning a new deck."
	sleep 1
	@cards.delete_at(0)
	puts "One card burned...\n"
	sleep 1
end

def ace_check(hand, card, total)
	location_p = hand.index {|c| c[:points] == 11}
	if ((total + card[:points]) > 21) && (card[:points] == 11)
		card[:points] = 1
	end
	while ((total + card[:points]) > 21) && (location_p != nil)
		hand[location_p][:points] = 1
		location_p = hand.index {|c| c[:points] == 11}
		total = hand.reduce(0) {|total,c| total + c[:points]}
	end
end

#Boolean that returns true if first two cards are aces
def double_ace_check?(hand)
	hand[0][:name].include?("A") && hand[1][:name].include?("A")
end

def double_ace_actions(hand)
	if (hand[0][:points] == 11) && (hand[1][:points] == 11)
		hand[0][:points] = 1
	end
end

def play(hand)
	catch :done do
		while @player_total <= 20
			if (@decision == "h") || (@decision == "sp")
				sleep 1
				puts "\nDealer upcard: #{@upcard[:name]}\n"
				sleep 1

				if @split_status == true
					print 'Hand #'
					print "#{@split_hand_counter}\n"
				end

				@player_total = hand.reduce(0) {|total,c| total + c[:points]}

				card_names_p = (hand.map{|c| c[:name]})
				location_p = hand.index {|c| c[:points] == 11} #related to finding aces
				if (location_p != nil)
					puts "\nPlayer hand: #{card_names_p.join(', ')}"
					puts "Player total: Soft #{@player_total}"
					sleep 1
				else
					puts "\nPlayer hand: #{card_names_p.join(', ')}"
					puts "Player total: #{@player_total}"
					sleep 1
				end
				if hand.count == 2 && (hand[0][:points] != hand[1][:points]) && (@split_status == false) && (double_ace_check?(hand) == false)
					print "\nType \"h\" to hit, \"d\" to double down, \"s\" to stand and \"sur\" to surrender: "
					@decision = gets.chomp
					until ["h", "d", "s", "sur"].include? @decision
						print "\nThat is not a valid choice. Enter \"h,\" \"d,\" \"s\" or \"sur\": "
						@decision = gets.chomp
					end
				elsif (hand.count == 2 && (hand[0][:points] != hand[1][:points]) && (@split_status == true)) || (hand.count == 2 && (@split_counter == 4) && (@split_status == true)) && (double_ace_check?(hand) == false)

					print "\nType \"h\" to hit, \"d\" to double down or \"s\" to stand: "
					@decision = gets.chomp
					until ["h", "d", "s"].include? @decision
						print "\nThat is not a valid choice. Enter \"h,\" \"d\" or \"s\": "
						@decision = gets.chomp
					end
				elsif ((hand[0][:points] == hand[1][:points]) || (double_ace_check?(hand))) && (hand.count == 2) && (@split_status == false)
					print "\nType \"h\" to hit, \"d\" to double down, \"s\" to stand, \"sp\" to split and \"sur\" to surrender: "
					@decision = gets.chomp
					until ["h", "d", "s", "sur", "sp"].include? @decision
						print "\nThat is not a valid choice. Enter \"h,\" \"d,\" \"s,\" \"sp\" or \"sur\": "
						@decision = gets.chomp
					end
				elsif ((hand[0][:points] == hand[1][:points]) || (double_ace_check?(hand))) && (hand.count == 2) && (@split_status == true) && (@split_counter <= 3)
					print "\nType \"h\" to hit, \"d\" to double down, \"s\" to stand and \"sp\" to split: "
					@decision = gets.chomp
					until ["h", "d", "s", "sur", "sp"].include? @decision
						print "\nThat is not a valid choice. Enter \"h,\" \"d,\" \"s\" or \"sp\": "
						@decision = gets.chomp
					end
				else
					print "\nType \"h\" to hit and \"s\" to stand: "
					@decision = gets.chomp
					until ["h", "s"].include? @decision
						print "\nThat is not a valid choice. Enter \"h\" or \"s\": "
						@decision = gets.chomp
					end
				end

				split_bet_total = (@split_bet1 + @split_bet2 + @split_bet3 + @split_bet4)

#Checking if player has enough money to double or split
				if ((@decision == "sp") || (@decision == "d")) && (@bankroll < ((@base_bet*2) + split_bet_total))
					puts "\nYou don't have enough money to double or split."
					print "\nPlease enter \"h,\" \"s\" or \"sur\": "
					@decision = gets.chomp
					until ["h", "s", "sur"].include? @decision
						print "\nThat is not a valid choice. Enter \"h,\" \"s\" or \"sur\": "
						@decision = gets.chomp
					end
				end

#Gives hand new card if decision is to hit or double
				if (@decision == "h") || ((@decision == "d") && (hand.count == 2))
					@playercard = @cards.delete_at(0)
					@player_total = hand.reduce(0) {|total,c| total + c[:points]}
					ace_check(@player_hand, @playercard, @player_total)
					hand << @playercard

					if @decision == "d"
						@current_bet = @base_bet*2
					end
				end

#This part does the splitting of hands
				if @decision == "sp"
					if (hand[0][:name].include?("A")) && (hand.count == 2)
						hand[0][:points] = 11
					end
					if @split_counter == 0
						@split_hand1 << hand.delete_at(0) << @cards.delete_at(0)
						@split_hand2 << hand.delete_at(0) << @cards.delete_at(0)
						@split_counter = 2
						@split_status = true
						throw :done
					elsif @split_counter == 2
						@split_hand3 << hand.delete_at(0) << @cards.delete_at(0)
						hand << @cards.delete_at(0)
						@split_counter = 3
					elsif @split_counter == 3
						@split_hand4 << hand.delete_at(0) << @cards.delete_at(0)
						hand << @cards.delete_at(0)
						@split_counter = 4
					end
				end

				@player_total = hand.reduce(0) {|total,c| total + c[:points]}

#This part keeps track of bet amounts for each hand when splitting is involved in play
				if @split_status == true
					if @split_hand_counter == 1
						if ["d"].include? @decision
							@split_bet1 = @current_bet
						elsif (@player_total <= 20) || (@decision == "s")
							@split_bet1 = @base_bet
						end
					elsif @split_hand_counter == 2
						if ["d"].include? @decision
							@split_bet2 = @current_bet
						elsif (@player_total <= 20) || (@decision == "s")
							@split_bet2 = @base_bet
						end
					elsif @split_hand_counter == 3
						if ["d"].include? @decision
							@split_bet3 = @current_bet
						elsif (@player_total <= 20) || (@decision == "s")
							@split_bet3 = @base_bet
						end
					elsif @split_hand_counter == 4
						if ["d"].include? @decision
							@split_bet4 = @current_bet
						elsif (@player_total <= 20) || (@decision == "s")
							@split_bet4 = @base_bet
						end
					end
				end

				@player_total = hand.reduce(0) {|total,c| total + c[:points]}
			else
				throw :done
			end
		end
	end
end

def result(c_bet = @current_bet, hand = @player_hand)

	@player_total = hand.reduce(0) {|total,c| total + c[:points]}

	if (@decision == "sur")
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nYou surrendered and #{@base_bet/2} was returned to your @bankroll."
		puts "The holecard was #{@holecard[:name]}"
		@bankroll = @bankroll - (@base_bet/2)
	elsif @player_total > 21
		sleep 1
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nPlayer busted with #{@player_total}"
		puts "The holecard was #{@holecard[:name]}"
		puts "You lost $#{c_bet.dec_drop}"
		@bankroll = @bankroll - c_bet
	elsif @dealer_total > 21
		sleep 1
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nDealer busted with #{@dealer_total}"
		puts "The holecard was #{@holecard[:name]}"
		puts "You won $#{c_bet.dec_drop}!"
		@bankroll = @bankroll + c_bet
	elsif @dealer_total > @player_total
		sleep 1
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nDealer won with #{@dealer_total}"
		puts "The holecard was #{@holecard[:name]}"
		puts "You lost $#{c_bet.dec_drop}"
		@bankroll = @bankroll - c_bet
	elsif @dealer_total == @player_total
		sleep 1
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nIt's a push!"
		puts "The holecard was #{@holecard[:name]}"
	else
		sleep 1
		card_names_p = (hand.map{|c| c[:name]})
		card_names_d = (@dealer_hand.map{|c| c[:name]})
		puts "\nPlayer hand: #{card_names_p.join(', ')}"
		puts "Player total: #{@player_total}\n"
		sleep 1
		puts "\nDealer hand: #{card_names_d.join(', ')}"
		puts "Dealer total: #{@dealer_total}\n"
		sleep 1
		puts "\nYou won $#{c_bet.dec_drop}!"
		puts "The holecard was #{@holecard[:name]}"
		@bankroll = @bankroll + c_bet
	end
end

def dealer_play
	while @dealer_total <= 16
		@dealercard = @cards.delete_at(0)
		ace_check(@dealer_hand, @dealercard, @dealer_total)
		@dealer_hand << @dealercard
		@dealer_total = @dealer_hand.reduce(0) {|total,c| total + c[:points]}
	end
end

# Replenishes deck and shuffles cards if 15 or less cards are left
def card_shuffle
	if @cards.count <= 15
		@deck.each_index { |index| @cards[index] = @deck[index].dup }
		@deck.each_index { |index| @cards << deck[index].dup }
		@cards.shuffle!
		sleep 2
		puts "\nCards are being shuffled...\n"
		@cards.delete_at(0)
		puts "One card burned...\n"
		sleep 1
	end
end

def split_actions(hand)
	if hand[0][:name].include?("A")
		@decision = "s"
	end

	double_ace_actions(hand)

	@playercard = {}
	@dealercard = {}
	@dealer_total = @dealer_hand.reduce(0) {|total,c| total + c[:points]}
	@player_total = hand.reduce(0) {|total,c| total + c[:points]}
end