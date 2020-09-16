require "./test/test_helper"
require './lib/stat_tracker'
require './lib/game_teams_manager'
require './lib/game_team'
require 'pry';
require 'mocha/minitest'

class GameTeamsManagerTest < Minitest::Test
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
    @game_teams_manager = GameTeamsManager.new(game_teams_path, stat_tracker)
  end

  def test_it_exists
    assert_instance_of GameTeamsManager, @game_teams_manager
  end

  def test_return_games_played_by_team
    assert_equal 7, @game_teams_manager.games_played('6').count
  end

  def test_selected_season_game_teams
    season_id = '20152016'
    assert_equal 2, @game_teams_manager.selected_season_game_teams(season_id).count
  end

  def test_it_can_find_best_season_for_team
    team_id = '6'
    assert_equal '20122013', @game_teams_manager.get_best_season(team_id)
  end

  def test_it_can_find_worst_season_for_team
    team_id = '6'
    assert_equal '20122013', @game_teams_manager.get_worst_season(team_id)
  end

  def test_it_can_find_average_win_percentage_for_team
    team_id = '6'
    assert_equal 0.86, @game_teams_manager.get_average_win_pct(team_id)
  end

  def test_it_can_get_most_goals_scored_for_team
    team_id = '6'
    assert_equal 4, @game_teams_manager.get_most_goals_scored_for_team(team_id)
  end

  def test_it_can_get_fewest_goals_scored_for_team
    team_id = '6'
    assert_equal 1, @game_teams_manager.get_fewest_goals_scored_for_team(team_id)
  end

  def test_it_can_get_favorite_opponent
    team_id = '6'
    assert_equal '3', @game_teams_manager.get_favorite_opponent(team_id)
  end

  def test_it_can_get_rival
    team_id = '6'
    assert_equal '3', @game_teams_manager.get_rival(team_id)
  end
end
