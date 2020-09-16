require './test/test_helper'
require './lib/season_statistics_manager'
require './lib/game_teams_manager'
require './lib/stat_tracker'
require "mocha/minitest"

class SeasonStatisticsManagerTest < Minitest::Test
  def setup
    stat_tracker = mock('stat_tracker')
    # stat_tracker.stubs(:class).returns(StatTracker)
    whatever = GameTeamsManager.new('./data/dummy_game_teams.csv', stat_tracker)
    @season_stat = SeasonStatisticsManager.new(stat_tracker)
  end

  def test_it_exists
    assert_instance_of SeasonStatisticsManager, @season_stat
  end

  # def test_it_can_get_games_ids_in_season
  #   season_id = '20122013'
  #   @season_stat.stubs(:get_game_ids_in_season).returns(['0212030221'])
  #   assert_equal ['0212030221'], @season_stat.game_ids_in_season(season_id)
  # end

  def test_selected_season_game_teams
    season_id = '20152016'
    assert_equal 2, @season_stat.selected_season_game_teams(season_id).count
  end

  def test_wins_for_coach
    season_id = '20152016'
    head_coach = 'Mike Sullivan'
    assert_equal 1, @season_stat.wins_for_coach(season_id, head_coach)
  end

  def test_games_for_coach
    season_id = '20152016'
    head_coach = 'Mike Sullivan'
    assert_equal 1, @season_stat.games_for_coach(season_id, head_coach)
  end

  def test_average_win_percentage_by_season
    season_id = '20152016'
    head_coach = 'Mike Sullivan'
    assert_equal 100.0, @season_stat.average_win_percentage_by_season(season_id, head_coach)
  end

  def test_coaches_hash_w_avg_win_percentage
    season_id = '20152016'
    expected = {'Mike Sullivan' => 100.0, 'Alain Vigneault' => 0.0}
    assert_equal expected, @season_stat.coaches_hash_w_avg_win_percentage(season_id)
  end

  def test_it_can_find_winningest_coach
    season_id = '20152016'
    assert_equal 'Mike Sullivan', @season_stat.winningest_coach(season_id)
  end

  def test_it_can_find_worst_coach
    season_id = '20122013'
    assert_equal 'John Tortorella', @season_stat.worst_coach(season_id)
  end
end
