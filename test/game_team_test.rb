require './test/test_helper'
require './lib/game_team'
require 'mocha/minitest'

class GameTeamTest < Minitest::Test
  def setup
    data = {
            'game_id'                 => '2012030221',
            'team_id'                 => '3',
            'HoA'                     => 'away',
            'result'                  => 'LOSS',
            'settled_in'              => 'OT',
            'head_coach'              => 'John Tortorella',
            'goals'                   => '2',
            'shots'                   => '8',
            'tackles'                 => '44',
            'pim'                     => '8',
            'powerPlayOpportunities'  => '3',
            'powerPlayGoals'          => '0',
            'faceOffWinPercentage'    => '44.8',
            'giveaways'               => '17',
            'takeaways'               => '7'
            }
    manager = mock('game_manager')
    @game_team = GameTeam.new(data, manager)
  end

  def test_it_has_attributes
    assert_equal '3', @game_team.team_id
    assert_equal 'LOSS', @game_team.result
  end
end
