require 'csv'
require_relative './game_team'
require_relative './averageable'

class GameTeamsManager
  include Averageable
  def initialize(game_teams_path, tracker)
    @game_teams = []
    @tracker = tracker
    create_games(game_teams_path)
  end

  def create_games(game_teams_path)
    game_teams_data = CSV.parse(File.read(game_teams_path), headers: true)
    @game_teams = game_teams_data.map do |data|
      GameTeam.new(data, self)
    end
  end

  def selected_season_game_teams(season_id)
    @game_teams.select do |game_team|
      find_season_id(game_team.game_id) == season_id
    end
  end

  def find_season_id(game_id)
    @tracker.find_season_id(game_id)
  end

  def games_played(team_id)
    @game_teams.select do |game_team|
      game_team.team_id == team_id
    end
  end

  # Team
  def all_teams_for_game_id_list(team_id)
    @game_teams.select do |game_team|
      game_ids_played_by_team(team_id).include?(game_team.game_id)
    end
  end

  def total_wins_team_all_seasons(team_id)
    @game_teams.count do |game_team|
      game_team.result == 'WIN' if game_team.team_id == team_id
    end.to_f
  end

  def list_seasons_played_by_team(team_id)
    games_played(team_id).group_by do |game_team|
      find_season_id(game_team.game_id)
    end
  end

  def game_ids_played_by_team(team_id)
    games_played(team_id).map do |game_team|
      game_team.game_id
    end
  end

  def game_teams_played_by_opponent(team_id)
    all_teams_for_game_id_list(team_id).select do |game_team|
      game_team.team_id != team_id
    end
  end

  def games_played_by_team_by_season(season, team_id)
    games_played(team_id).select do |game_team|
      find_season_id(game_team.game_id) == season
    end
  end

  def total_wins_team(season, team_id)
    games_played_by_team_by_season(season, team_id).count do |game_team|
      game_team.result == 'WIN'
    end.to_f
  end

  def games_w_opponent_hash(team_id)
    game_teams_played_by_opponent(team_id).group_by do |game_team|
      game_team.team_id
    end
  end

  def season_win_pct_hash(team_id)
    season_hash = {}
    list_seasons_played_by_team(team_id).each do |season, game_team|
      season_hash[season] ||= []
      season_hash[season] = average_with_count(total_wins_team(season, team_id), games_played_by_team_by_season(season, team_id))
    end
    season_hash
  end

  def opponent_hash(team_id)
    woohoo = {}
    games_w_opponent_hash(team_id).map do |opp_team_id, game_team_obj|
      tie_loss = game_team_obj.count do |game_team|
        game_team.result == 'LOSS' || game_team.result == 'TIE'
      end.to_f
      woohoo[opp_team_id] = average_with_count(tie_loss, game_team_obj, 2)
    end
    woohoo
  end

  def get_best_season(team_id)
    season_win_pct_hash(team_id).max_by { |season, win_pct| win_pct }.to_a[0]
  end

  def get_worst_season(team_id)
    season_win_pct_hash(team_id).min_by { |season, win_pct| win_pct }.to_a[0]
  end

  def get_most_goals_scored_for_team(team_id)
    games_played(team_id).max_by { |game_team| game_team.goals }.goals
  end

  def get_fewest_goals_scored_for_team(team_id)
    games_played(team_id).min_by { |game_team| game_team.goals }.goals
  end

  def get_favorite_opponent(team_id)
    opponent_hash(team_id).max_by { |opp_team_id, tie_loss| tie_loss }.to_a[0]
  end

  def get_rival(team_id)
    opponent_hash(team_id).min_by { |opp_team_id, tie_loss| tie_loss }.to_a[0]
  end

  def get_average_win_pct(team_id)
    average_with_count(total_wins_team_all_seasons(team_id), games_played(team_id), 2)
  end
end
