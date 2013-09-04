# EXTRA CREDIT:
#
# Create a program that will play the Greed Game.
# Rules for the game are in GREED_RULES.TXT.
#
# You already have a DiceSet class and score function you can use.
# Write a player class and a Game class to complete the project.  This
# is a free form assignment, so approach it however you desire.
require File.expand_path(File.dirname(__FILE__) + '/neo')
require 'about_dice_project.rb' 
require 'about_scoring_project.rb'

class GreedGame 
	attr_reader :number_of_players, :players

	def initialize(number_of_players)
		fail "Invalid number of players" if number_of_players < 2 
		@players = Array.new(number_of_players)
		@players.each_with_index { |player, index| @players[index] =  0 }
		@number_of_players = number_of_players
		@dice =  DiceSet.new
	end

#Counts the number of non scoring dice 
#Uses an array of "roll values" as an argument
	def count_non_scoring_dice(values)
		rolls_array = values
		rolls = values.size
		rolls -= (values.count(1) + values.count(5))
		triple_found = false
		[2,3,4,6].each do |number| 
			if values.count(number) >= 3 
				triple_found = true
				rolls -= 3 
				break
			end
		end
		return rolls
	end


	#Calculates the number of dice available after a roll by 
	#taking the number of non-scoring-dice as an argument
	def calc_available_dice_for_reroll(non_scoring_dice)
		case non_scoring_dice
		when 0
			return 5
		when 5
			return 0
		else
			return non_scoring_dice
		end
	end

	def can_player_roll_again?(dice_available_for_reroll,score)
		return true if dice_available_for_reroll > 0 and score !=0
		return false
	end


	def turn(current_points)
		in_turn = true
		available_dice = 5
		total_turn_score = 0
		while (in_turn)
			roll_values = roll(available_dice)
			non_scoring_dice = count_non_scoring_dice(roll_values) 
			score = score(roll_values)
			available_dice = calc_available_dice_for_reroll(non_scoring_dice)
			if can_player_roll_again?(available_dice,score)
				total_turn_score += score
				puts "Roll: #{roll_values}" 
				puts "You scored #{score}"
				puts "Your total score this turn is #{total_turn_score}"

				if current_points+total_turn_score >=3000 
					in_turn = false
					next
				end

				puts "You can roll again with #{available_dice} dice"
				puts "Would you like to roll the non-scoring dice (Yes/No)?"			
				valid = false
				while (!valid)
					answer = get_answer
					valid = valid_answer?(answer)
				end
				
				if answer.upcase == "YES" 
					next
				else
					in_turn = false
				end
			else
				puts "Roll: #{roll_values}"
				puts "You scored #{score}"
				puts "You can't roll again."
				puts "You lost your points for the turn"
				total_turn_score = 0
				in_turn = false
			end
		end
		if current_points == 0 
			if total_turn_score<300 
				return 0
			end
		end

		return current_points + total_turn_score
	end

	def roll(number_of_dice)
		@dice.roll(number_of_dice)
		@dice.values
	end

	def get_answer
		print "Type answer:"
		gets.chomp
	end

#Evaluates if a string is a valid answer for the game prompts
	def valid_answer?(answer)
		if ["YES", "NO"].include?(answer.upcase)
			return true
		else
			return false
		end
	end

	def play_greed 
		game_on  = true 
		winner = 0
		while (game_on)
			@players.each_with_index do |player, index|
				puts "Player #{index+1}'s' turn"
				puts "Player #{index+1}',  are you ready to roll (Yes/No)?"
				ready = false
				answer = ""
				
				while (answer.upcase != "YES") 
					answer = ""
					while (!valid_answer?(answer))
						answer = get_answer
					end
					#ready = valid_answer?(answer)
				end

				@players[index] = turn(player) 
				if @players[index] >= 3000
					game_on = false
					winner = index + 1
					break
				end
				#puts "Player #{index+1} Total Score: #{@players[index]}"
				puts "******  SCOREBOARD  ******"
				@players.each_with_index {|a, b| puts "Player #{b+1} Total Score: #{@players[b]}" }
				puts "**************************"
			end
		end
		puts @players
		puts "The Winner is Player #{winner}"
		puts "Game Over"
	end
end

class GreedGameProject < Neo::Koan
	def test_greed_assisngs_correct_number_of_players
		test_game = GreedGame.new(5)
		assert_raise(StandardError) do
			test_game2 = GreedGame.new(1)
		end
		
		assert_equal 5, test_game.number_of_players
		assert_equal [0,0,0,0,0], test_game.players
		#assert_equal "Invalid number of players", test_game2 = GreedGame.new(1)
	end

	def test_count_non_scoring_dice
		test_game = GreedGame.new(5)
		assert_equal 5, test_game.count_non_scoring_dice([2,3,4,6,4])
		assert_equal 0, test_game.count_non_scoring_dice([1,1,1,1,1])
		assert_equal 0, test_game.count_non_scoring_dice([1,5,1,5,1])
		assert_equal 2, test_game.count_non_scoring_dice([3,2,3,2,3])
		assert_equal 1, test_game.count_non_scoring_dice([3,1,3,2,3])
		assert_equal 4, test_game.count_non_scoring_dice([2,3,5,6,4])
		assert_equal 3, test_game.count_non_scoring_dice([1,3,3,5,4])
		assert_equal 2, test_game.count_non_scoring_dice([6,6,2,6,6])
	end

	def test_roll
		test_game = GreedGame.new(2)
		assert_equal Array, test_game.roll(5).class
		assert_equal 5, test_game.roll(5).size
	end

	def test_valid_answer?
		test_game = GreedGame.new(2)
		assert_equal true, test_game.valid_answer?("yes")
		assert_equal true, test_game.valid_answer?("no")
		assert_equal false, test_game.valid_answer?("0")
	end

	def test_reroll_dice_available
		test_game = GreedGame.new(2)
		assert_equal 1, test_game.calc_available_dice_for_reroll(1)
		assert_equal 2, test_game.calc_available_dice_for_reroll(2)
		assert_equal 3, test_game.calc_available_dice_for_reroll(3)
		assert_equal 4, test_game.calc_available_dice_for_reroll(4)
		assert_equal 0, test_game.calc_available_dice_for_reroll(5)
		assert_equal 5, test_game.calc_available_dice_for_reroll(0)
	end

	def test_can_player_roll_again?
		test_game = GreedGame.new(2)
		assert_equal false, test_game.can_player_roll_again?(0,100) 
		assert_equal true, test_game.can_player_roll_again?(5,100)
		assert_equal false, test_game.can_player_roll_again?(1,0)
		assert_equal false, test_game.can_player_roll_again?(0,0) 
	end

	# def test_get_answer
	# 	test_game = GreedGame.new(2)
	# 	puts "User Input Test"
	# 	assert_equal String,  test_game.get_answer.class
	# end



	end



game = GreedGame.new(2)
game.play_greed



 