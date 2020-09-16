require './test/test_helper'
require './lib/game_teams_season'
require './lib/game_teams_manager'
require './lib/stat_tracker'
require 'pry';
require 'mocha/minitest'

class GameTeamsSeasonTest < Minitest::Test
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
    @game_team_season = GameTeamsSeason.new(game_teams_path, stat_tracker)
  end

  def test_selected_season_game_teams
    season_id = '20152016'
    assert_equal 2, @game_team_season.selected_season_game_teams(season_id).count
  end

  def test_it_can_list_teams_in_season
    season_id = '20152016'
    assert_equal 2, @game_team_season.list_teams_in_season(season_id).count
    refute_equal 4, @game_team_season.list_teams_in_season(season_id).count
  end

  def test_it_can_list_game_teams_season_team
    season_id = '20122013'
    team_id = '6'
    assert_equal 7, @game_team_season.list_game_teams_season_team(season_id, team_id).count
    refute_equal 10, @game_team_season.list_game_teams_season_team(season_id, team_id).count
  end

  def test_it_can_list_coaches_in_season
    season_id = '20122013'
    expected = ["John Tortorella", "Claude Julien", "Dan Bylsma"]
    assert_equal expected, @game_team_season.list_coaches_in_season(season_id)
  end

  def test_it_can_list_game_teams_for_coach
    season_id = '20122013'
    head_coach = 'Claude Julien'
    assert_equal 7, @game_team_season.game_teams_for_coach(season_id, head_coach).count
  end

  def test_games_for_coach
    season_id = '20152016'
    head_coach = 'Mike Sullivan'
    assert_equal 1, @game_team_season.games_for_coach(season_id, head_coach)
    refute_equal 2, @game_team_season.games_for_coach(season_id, head_coach)
  end

  def test_wins_for_coach
    season_id = '20122013'
    head_coach = 'Claude Julien'
    assert_equal 6.0, @game_team_season.wins_for_coach(season_id, head_coach)
  end

  def test_shots_by_team
    season_id = '20122013'
    team_num = '3'
    assert_equal 38, @game_team_season.shots_by_team(season_id, team_num)
  end

  def test_goals_by_team
    season_id = '20122013'
    team_num = '3'
    assert_equal 8, @game_team_season.goals_by_team(season_id, team_num)
  end

  def test_tackles_by_team
    season_id = '20122013'
    team_num = '3'
    assert_equal 179, @game_team_season.tackles_by_team(season_id, team_num)
  end

  def test_coaches_hash_w_avg_win_percentage
    season_id = '20152016'
    expected = {'Mike Sullivan' => 1.0, 'Alain Vigneault' => 0.0}
    assert_equal expected, @game_team_season.coaches_hash_avg_win_pct(season_id)
  end

  def test_teams_hash_w_ratio_shots_goals
    season_id = '20122013'
    expected = {
      '3' => 0.2105,
      '6' => 0.3333,
      '5' => 0.0769
    }
    assert_equal expected, @game_team_season.teams_hash_shots_goals(season_id)
  end

  def test_teams_hash_w_tackles
    season_id = '20122013'
    expected = {
                  '3' => 179,
                  '6' => 212,
                  '5' => 71
    }
    assert_equal expected, @game_team_season.teams_hash_w_tackles(season_id)
  end

  def test_it_can_find_winningest_coach
    season_id = '20152016'
    assert_equal 'Mike Sullivan', @game_team_season.winningest_coach(season_id)
  end

  def test_it_can_find_worst_coach
    season_id = '20122013'
    assert_equal 'John Tortorella', @game_team_season.worst_coach(season_id)
  end

  def test_most_accurate_team
    season_id = '20122013'
    assert_equal '6', @game_team_season.most_accurate_team(season_id)
  end

  def test_least_accurate_team
    season_id = '20122013'
    assert_equal '5', @game_team_season.least_accurate_team(season_id)
  end

  def test_most_tackles
    season_id = '20122013'
    assert_equal '6', @game_team_season.most_tackles(season_id)
  end

  def test_fewest_tackles
    season_id = '20122013'
    assert_equal '5', @game_team_season.fewest_tackles(season_id)
  end
end
