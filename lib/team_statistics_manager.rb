require './lib/game_teams_manager'

class TeamStatisticsManager < GameTeamsManager
  def initialize(tracker)
    @tracker = tracker
  end
end
