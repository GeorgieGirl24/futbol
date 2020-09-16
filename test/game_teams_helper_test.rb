require "./test/test_helper"
require './lib/game_teams_manager'
require './lib/game_teams_helper'
require 'pry';
require 'mocha/minitest'

class GameTeamsHelperTest < Minitest::Test
  def setup
    manager = mock('manager')
    manager.stubs(:class).returns(GameTeamsManager)
    @game_team_helper = GameTeamsHelper.new(manager)
  end
end
