require_relative './game_teams_manager'
class CoreStatistics < GameTeamsManager
  def initialize
  end

  def winningest_coach(season_id)
    coaches_hash_w_avg_win_percentage(season_id).max_by do |coach, avg_win_perc|
      avg_win_perc
    end.to_a[0]
  end
end
