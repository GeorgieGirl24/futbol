require_relative './averageable'
require_relative './game_team'
require_relative './game_teams_manager'

class GameTeamsSeason < GameTeamsManager
  include Averageable
  def initialize(game_teams_path, tracker)
    super(game_teams_path, tracker)
  end

  def create_games(game_teams_path)
    super(game_teams_path)
  end

  def find_season_id(game_id)
    super
  end

  def selected_season_game_teams(season_id)
    super
  end

  def list_teams_in_season(season_id)
    selected_season_game_teams(season_id).map do |game_team|
      game_team.team_id
    end.uniq
  end

  def list_game_teams_season_team(season_id, team_id)
    selected_season_game_teams(season_id).select do |game_team|
      game_team.team_id == team_id
    end
  end

  def wins_for_coach(season_id, head_coach)
    selected_season_game_teams(season_id).count do |game_team|
      game_team.result == 'WIN' if game_team.head_coach == head_coach
    end.to_f
  end

  def games_for_coach(season_id, head_coach)
    selected_season_game_teams(season_id).count do |game_team|
      game_team.head_coach == head_coach
    end
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

  def coaches_hash_avg_win_pct(season_id)
    by_coach_wins = {}
    selected_season_game_teams(season_id).each do |game_team|
      head_coach = game_team.head_coach
      by_coach_wins[head_coach] ||= []
      by_coach_wins[head_coach] = average(wins_for_coach(season_id, head_coach), games_for_coach(season_id, head_coach), 2)
    end
    by_coach_wins
  end

  def teams_hash_shots_goals(season_id)
    by_team_goals_ratio = {}
    list_teams_in_season(season_id).each do |team_id|
      by_team_goals_ratio[team_id] ||= []
      by_team_goals_ratio[team_id] = average(goals_by_team(season_id, team_id), shots_by_team(season_id, team_id))
    end
    by_team_goals_ratio
  end

  def teams_hash_w_tackles(season_id)
    tackles_by_team = {}
    list_teams_in_season(season_id).each do |team_id|
      tackles_by_team[team_id] ||= []
      tackles_by_team[team_id] = tackles_by_team(season_id, team_id)
    end
    tackles_by_team
  end

  def winningest_coach(season_id)
    coaches_hash_avg_win_pct(season_id).max_by { |coach, avg_win| avg_win }.to_a[0]
  end

  def worst_coach(season_id)
    coaches_hash_avg_win_pct(season_id).min_by { |coach, avg_win| avg_win }.to_a[0]
  end

  def most_accurate_team(season_id)
    teams_hash_shots_goals(season_id).max_by { |team, goals_ratio| goals_ratio }.to_a[0]
  end

  def least_accurate_team(season_id)
    teams_hash_shots_goals(season_id).min_by { |team, goals_ratio| goals_ratio }.to_a[0]
  end

  def most_tackles(season_id)
    teams_hash_w_tackles(season_id).max_by { |team, tackles| tackles }.to_a[0]
  end

  def fewest_tackles(season_id)
    teams_hash_w_tackles(season_id).min_by { |team, tackles| tackles }.to_a[0]
  end
end
