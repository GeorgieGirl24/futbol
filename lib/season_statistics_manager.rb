require './lib/game_teams_manager'

class SeasonStatisticsManager < GameTeamsManager
  # attr_reader :game_teams

  def initialize(tracker)
    @tracker = tracker
  end

  # def selected_season_game_teams(season_id)
  #   require "pry"; binding.pry
  #   @manager.game_teams.select do |game_team|
  #     game_team.season_id == season_id
  #   end
  # end
  
  def game_ids_in_season(season_id)
    @tracker.get_game_ids_in_season(season_id)
  end

  def wins_for_coach(season_id, head_coach)
    selected_season_game_teams(season_id).count do |game_team|
      game_team.result == 'WIN' if game_team.head_coach == head_coach
    end
  end

  def games_for_coach(season_id, head_coach)
    selected_season_game_teams(season_id).count do |game_team|
      game_team.head_coach == head_coach
    end
  end

  def average_win_percentage_by_season(season_id, head_coach)
    ((wins_for_coach(season_id, head_coach).to_f / games_for_coach(season_id, head_coach)) * 100).round(2)
  end

  def coaches_hash_w_avg_win_percentage(season_id)
    by_coach_wins = {}
    selected_season_game_teams(season_id).each do |game_team|
      head_coach = game_team.head_coach
      by_coach_wins[head_coach] ||= []
      by_coach_wins[head_coach] = average_win_percentage_by_season(season_id, head_coach)
    end
    by_coach_wins
  end

  def winningest_coach(season_id)
    coaches_hash_w_avg_win_percentage(season_id).max_by do |coach, avg_win_perc|
      avg_win_perc
    end.to_a[0]
  end

  def worst_coach(season_id)
    coaches_hash_w_avg_win_percentage(season_id).min_by do |coach, avg_win_perc|
      avg_win_perc
    end.to_a[0]
  end
end
