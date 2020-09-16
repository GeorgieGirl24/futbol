require "./test/test_helper"
require './lib/stat_tracker'
require './lib/team_manager'
require './lib/team'
require 'pry';
require 'mocha/minitest'

class TeamManagerTest < Minitest::Test
  def setup
    stat_tracker = mock('stat_tracker')
    stat_tracker.stubs(:class).returns(StatTracker)
    @team_manager = TeamsManager.new('./data/dummy_teams.csv', stat_tracker)
  end

  def test_it_can_count_teams
    assert_equal 3, @team_manager.count_of_teams
  end

  def test_it_can_find_a_name
    team_number = '3'
    assert_equal 'Houston Dynamo', @team_manager.find_team_name(team_number)
  end

  def test_finding_a_team
    team_id = '5'
    assert_equal '17', @team_manager.find_a_team(team_id).franchise_id
    assert_equal 'SKC', @team_manager.find_a_team(team_id).abbreviation
  end

  def test_it_can_get_team_info
    team_id = '5'
    expected = {
                'team_id' => '5',
                'franchise_id' => '17',
                'team_name' => 'Sporting Kansas City',
                'abbreviation' => 'SKC',
                'link' => '/api/v1/teams/5'
    }
    assert_equal expected, @team_manager.team_info(team_id)
  end
end
