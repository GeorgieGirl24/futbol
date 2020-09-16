require './test/test_helper'
require './lib/game_teams_league'
require './lib/game_teams_manager'
require './lib/stat_tracker'
require 'pry';
require 'mocha/minitest'

class GameTeamsLeagueTest < Minitest::Test
  def setup
    game_path = './data/dummy_game.csv'
    team_path = './data/dummy_teams.csv'
    game_teams_path = './data/dummy_game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    stat_tracker = StatTracker.from_csv(locations)
    @game_teams_league = GameTeamsLeague.new(game_teams_path, stat_tracker)
  end

  def test_return_games_played_by_team
    assert_equal 7, @game_teams_league.games_played('6').count
  end

  def test_return_games_played_by_type
    assert_equal 3, @game_teams_league.games_played_by_type('3', 'away').count
    assert_equal 3, @game_teams_league.games_played_by_type('3', 'home').count
  end

  def test_it_can_return_teams_list

  end

  def test_it_can_return_total_goals

  end

  def test_average_number_of_goals_scored_by_team
    assert_equal 1.5, @game_teams_league.average_number_of_goals_scored_by_team('3')
  end

  def test_return_total_goals_by_type
    assert_equal 5, @game_teams_league.total_goals_by_type('3', 'away')
    assert_equal 4, @game_teams_league.total_goals_by_type('3', 'home')
  end

  def test_average_number_of_goals_scored_by_team_by_type
    assert_equal 1.67, @game_teams_league.avg_goals_team_type('3', 'away')
    assert_equal 1.33, @game_teams_league.avg_goals_team_type('3', 'home')
  end

  def test_it_can_return_all_goal_all_teams_hash

  end

  def test_it_can_return_avg_goals_team_type_hash

  end

  def test_find_best_offense
    assert_equal '6', @game_teams_league.best_offense
  end

  def test_find_worst_offense
    assert_equal '5', @game_teams_league.worst_offense
  end

  def test_it_can_find_highest_scoring_visitor
    assert_equal '5', @game_teams_league.highest_scoring_visitor
  end

  def test_it_can_find_lowest_scoring_visitor
    assert_equal '3', @game_teams_league.lowest_scoring_visitor
  end

  def test_it_can_find_highest_scoring_home
    assert_equal '6', @game_teams_league.highest_scoring_home
  end

  def test_it_can_return_lowest_scoring_home
    assert_equal '3', @game_teams_league.lowest_scoring_home
  end
end
