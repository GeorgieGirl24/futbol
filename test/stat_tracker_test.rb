require 'minitest/autorun'
require 'minitest/pride'
require './lib/stat_tracker'
require './lib/game_manager'
require './lib/game_teams_manager'
require './lib/team_manager'
require 'pry';

class StatTrackerTest < Minitest::Test
  def setup
    game_path = './data/dummy_game.csv'
    team_path = './data/dummy_teams.csv'
    game_teams_path = './data/dummy_game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_can_find_highest_total_score
    assert_equal 6, @stat_tracker.highest_total_score
  end

  def test_it_can_find_the_lowest_total_score
    assert_equal 3, @stat_tracker.lowest_total_score
  end

  def test_it_can_find_percentage_home_wins
    assert_equal 37.5, @stat_tracker.percentage_home_wins
  end

  def test_it_can_find_percentage_visitor_wins
    assert_equal 50.0, @stat_tracker.percentage_visitor_wins
  end

  def test_it_can_return_a_count_teams
    assert_equal 3, @stat_tracker.count_of_teams
  end

  def test_it_can_find_a_name
    team_number = '5'
    assert_equal 'Sporting Kansas City', @stat_tracker.find_team_name(team_number)
  end

  def test_average_number_of_goals_scored_by_team
    assert_equal 1.5, @stat_tracker.average_number_of_goals_scored_by_team('3')
  end

  def test_average_number_of_goals_scored_by_team_by_type
    assert_equal 1.67, @stat_tracker.average_number_of_goals_scored_by_team_by_type('3', 'away')
    assert_equal 1.33, @stat_tracker.average_number_of_goals_scored_by_team_by_type('3', 'home')
  end

  def test_find_best_offense
    assert_equal 'FC Dallas', @stat_tracker.best_offense
  end

  def test_find_worst_offense
    assert_equal 'Sporting Kansas City', @stat_tracker.worst_offense
  end

  def test_it_can_find_highest_scoring_visitor
    assert_equal 'Sporting Kansas City', @stat_tracker.highest_scoring_visitor
  end

  def test_it_can_find_lowest_scoring_visitor
    assert_equal 'Houston Dynamo', @stat_tracker.lowest_scoring_visitor
  end

  def test_it_can_find_highest_scoring_home
    assert_equal 'FC Dallas', @stat_tracker.highest_scoring_home_team
  end

  def test_it_can_lowest_scoring_home
    assert_equal 'Sporting Kansas City', @stat_tracker.lowest_scoring_home_team
  end

  def test_it_can_find_season_id
    game_id = '2012030221'
    assert_equal '20122013', @stat_tracker.find_season_id(game_id)
  end
end
