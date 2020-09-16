require './test/test_helper'
require './lib/team_manager'
require './lib/team'
require 'mocha/minitest'

class TeamTest < Minitest::Test
  def setup
    data = {
            'team_id'      => '6',
            'franchiseId'  => '6',
            'teamName'     => 'FC Dallas',
            'abbreviation' => 'DAL',
            'Stadium'      => 'Toyota Stadium',
            'link'         => '/api/v1/teams/6'
            }
    manager = mock('TeamsManager')
    @team = Team.new(data, manager)
  end

  def test_it_has_attributes
    assert_equal 'FC Dallas', @team.team_name
  end
end
