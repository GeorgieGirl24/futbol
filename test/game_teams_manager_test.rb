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

  def test_it_can_return_list_of_season_game_ids
    season_id = '20122013'
    expected = ['2012030221', '2012030222', '2012030223', '2012030224', '2012030225', '2012030311', '2012030312']
    assert_equal expected, @game_teams_manager.list_of_season_game_ids(season_id)
  end

  def test_it_can_find_season_id
    game_id = '2012030221'
    assert_equal '20122013', @game_teams_manager.find_season_id(game_id)
  end

  def test_return_games_played_by_team
    assert_equal 7, @game_teams_manager.games_played('6').count
  end

  def test_all_teams_for_game_id_list
    team_id = '3'
    assert_equal 12, @game_teams_manager.all_teams_for_game_id_list(team_id).count
    refute_equal 15, @game_teams_manager.all_teams_for_game_id_list(team_id).count
  end

  def test_total_wins_team_all_seasons
    team_id = '6'
    assert_equal 6.0, @game_teams_manager.total_wins_team_all_seasons(team_id)
  end

  def test_list_seasons_played_by_team
    team_id = '5'
    assert_equal 2, @game_teams_manager.list_seasons_played_by_team(team_id).count
    refute_equal 3, @game_teams_manager.list_seasons_played_by_team(team_id).count
  end

  def test_game_ids_played_by_team
    team_id = '5'
    expected = ['2012030311', '2012030312', '2015030143']
    unexpected = ['2012030311', '2012030312', '2015030143', '2012030313']
    assert_equal expected, @game_teams_manager.game_ids_played_by_team(team_id)
    refute_equal unexpected, @game_teams_manager.game_ids_played_by_team(team_id)
  end

  def test_it_can_group_game_teams_played_by_opponents
    team_id = '6'
    assert_equal 7, @game_teams_manager.game_teams_played_by_opponent(team_id).count
    refute_equal 9, @game_teams_manager.game_teams_played_by_opponent(team_id).count
  end

  def games_played_by_team_by_season
    team_id = '6'
    season = '20122013'
    assert_equal 9, @game_teams_manager.games_played_by_team_by_season(season, team_id)
    refute_equal 12, @game_teams_manager.games_played_by_team_by_season(season, team_id)
  end

  def test_it_can_calculate_total_wins_by_team
    season = '20122013'
    team_id = '3'
    assert_equal 0, @game_teams_manager.total_wins_team(season, team_id)
  end

  def test_it_can_make_games_w_opponent_hash
    team_id = '6'
    assert_equal 2, @game_teams_manager.games_w_opponent_hash(team_id).count
    refute_equal 3, @game_teams_manager.games_w_opponent_hash(team_id).count
  end

  def test_avg_win_pct_per_season
    season = '20122013'
    team_id = '6'
    assert_equal 0.8571, @game_teams_manager.avg_win_pct_per_season(season, team_id)
    refute_equal 0.6774, @game_teams_manager.avg_win_pct_per_season(season, team_id)
  end

  def test_it_can_make_season_win_percentage_hash
    team_id = '6'
    expected = { '20122013' => 0.8571 }
    unexpected = { '20152016' => 0.8581 }
    assert_equal expected, @game_teams_manager.season_win_pct_hash(team_id)
    refute_equal unexpected, @game_teams_manager.season_win_pct_hash(team_id)
  end

  def test_it_can_make_an_opponent_hash
    team_id = '6'
    expected = {
      '3' => 1.0,
      '5' => 1.0
    }
    assert_equal expected, @game_teams_manager.opponent_hash(team_id)
  end

  def test_it_can_find_best_season_for_team
    team_id = '6'
    assert_equal '20122013', @game_teams_manager.get_best_season(team_id)
  end

  def test_it_can_find_worst_season_for_team
    team_id = '6'
    assert_equal '20122013', @game_teams_manager.get_worst_season(team_id)
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

  def test_it_can_find_average_win_percentage_for_team
    team_id = '6'
    assert_equal 0.86, @game_teams_manager.get_average_win_pct(team_id)
  end
end
