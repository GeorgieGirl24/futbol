require_relative './averageable'
require_relative './game_team'
require_relative './game_teams_manager'

class GameTeamsSeason < GameTeamsManager
  include Averageable

  def selected_season_game_teams(season_id)
    game_ids = list_of_season_game_ids(season_id)
    @game_teams.select do |game_team|
      game_ids.include?(game_team.game_id)
    end
  end

  def list_teams_in_season(season_id)
    selected_season_game_teams(season_id).map do |game_team|
      game_team.team_id
    end.uniq
  end

  def list_coaches_in_season(season_id)
    selected_season_game_teams(season_id).map do |game_team|
      game_team.head_coach
    end.uniq
  end

  def list_game_teams_season_team(season_id, team_id)
    selected_season_game_teams(season_id).select do |game_team|
      game_team.team_id == team_id
    end
  end

  def game_teams_for_coach(season_id, head_coach)
    selected_season_game_teams(season_id).select do |game_team|
      game_team.head_coach == head_coach
    end
  end

  def wins_for_coach(season_id, head_coach)
    game_teams_for_coach(season_id, head_coach).count do |game_team|
      game_team.result == 'WIN'
    end.to_f
  end

  def shots_by_team(season_id, team_id)
    list_game_teams_season_team(season_id, team_id).sum do |game_team|
      game_team.shots
    end
  end

  def goals_by_team(season_id, team_id)
    list_game_teams_season_team(season_id, team_id).sum do |game_team|
      game_team.goals
    end.to_f
  end

  def tackles_by_team(season_id, team_id)
    list_game_teams_season_team(season_id, team_id).sum do |game_team|
      game_team.tackles
    end
  end

  def avg_wins_pct_for_coach(season_id, head_coach)
    games = game_teams_for_coach(season_id, head_coach)
    average_with_count(wins_for_coach(season_id, head_coach), games)
  end

  def avg_ratio_goals_shots(season_id, team_id)
    # goals =
    # shots =
    average(goals_by_team(season_id, team_id), shots_by_team(season_id, team_id))
  end

  def coaches_hash_avg_win_pct(season_id)
    by_coach_wins = {}
    list_coaches_in_season(season_id).each do |head_coach|
      by_coach_wins[head_coach] ||= 0
      by_coach_wins[head_coach] = avg_wins_pct_for_coach(season_id, head_coach)
    end
    by_coach_wins
  end

  def teams_hash_shots_goals(season_id)
    by_team_goals_ratio = {}
    list_teams_in_season(season_id).each do |team_id|
      by_team_goals_ratio[team_id] ||= 0
      by_team_goals_ratio[team_id] = avg_ratio_goals_shots(season_id, team_id)
    end
    by_team_goals_ratio
  end

  def teams_hash_w_tackles(season_id)
    tackles_by_team = {}
    list_teams_in_season(season_id).each do |team_id|
      tackles_by_team[team_id] ||= 0
      tackles_by_team[team_id] = tackles_by_team(season_id, team_id)
    end
    tackles_by_team
  end

  def winningest_coach(season_id)
    coaches_hash_avg_win_pct(season_id).max_by do |_coach, avg_win|
      avg_win
    end.to_a[0]
  end

  def worst_coach(season_id)
    coaches_hash_avg_win_pct(season_id).min_by do |_coach, avg_win|
      avg_win
    end.to_a[0]
  end

  def most_accurate_team(season_id)
    teams_hash_shots_goals(season_id).max_by do |_team, goals_ratio|
      goals_ratio
    end.to_a[0]
  end

  def least_accurate_team(season_id)
    teams_hash_shots_goals(season_id).min_by do |_team, goals_ratio|
      goals_ratio
    end.to_a[0]
  end

  def most_tackles(season_id)
    teams_hash_w_tackles(season_id).max_by do |_team, tackles|
      tackles
    end.to_a[0]
  end

  def fewest_tackles(season_id)
    teams_hash_w_tackles(season_id).min_by do |_team, tackles|
      tackles
    end.to_a[0]
  end
end
