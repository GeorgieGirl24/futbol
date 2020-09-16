require "./test/test_helper"
require './lib/stat_tracker'
require './lib/game_teams_manager'
require './lib/game_team'
require './lib/core_statistics'
require 'pry';
require 'mocha/minitest'

class CoreStatisticsTest < Minitest::Test
  def setup
    game_path = './data/dummy_game.csv'
    team_path = './data/dummy_teams.csv'
    game_teams_path = './data/dummy_game_teams.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }
    # stat_tracker = StatTracker.from_csv(locations)
    @core_statistics = CoreStatistics.new#(game_teams_path, stat_tracker)
  end

  def test_it_exists
    # core_statistics = CoreStatistics.new
    assert_instance_of CoreStatistics, @core_statistics
  end

  def test_it_can_find_the_winningest_coach
    season_id = '20152016'
    assert_equal 'Mike Sullivan', @core_statistics.winningest_coach(season_id)
  end
end
