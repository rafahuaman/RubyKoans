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
	attr_reader :number_of_players
	def initialize(number_of_players)
		puts "Invalid number of players" if number_of_players < 2 
		@players = Array.new(number_of_players)
		@number_of_players = number_of_players
	end

	def count_non_scoring_dice(values_array)

	end


	def play_greed 
		#number_of_players = prompt
	end
end

class GreedGameProject < Neo::Koan
	def test_greed_assisngs_correct_number_of_players
		test_game = GreedGame.new(5)
		test_game2 = GreedGame.new(1)

		assert_equal 5, test_game.number_of_players
		assert_equal "Invalid", test_game2 = GreedGame.new(1)
	end

	def test_count_non_scoring_dice
		test_game = GreedGame.new(5)
		assert_equal 5, count_non_scoring_dice([2,3,4,6,4])
		assert_equal 0, count_non_scoring_dice([1,1,1,1,1])
		assert_equal 0, count_non_scoring_dice([1,5,1,5,1])
		assert_equal 2, count_non_scoring_dice([3,2,3,2,3])
		assert_equal 1, count_non_scoring_dice([3,1,3,2,3])
		assert_equal 4, count_non_scoring_dice([2,3,5,6,4])
		assert_equal 3, count_non_scoring_dice([1,3,3,5,4])

	end
end



#game = GreedGame.new()
#game.play_greed


