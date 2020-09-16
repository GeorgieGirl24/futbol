require 'csv'
require_relative './game_team'
require_relative './game_teams_season'
require_relative './averageable'

class GameTeamsManager
  include Averageable
  attr_reader :game_teams, :tracker
  def initialize(game_teams_path, tracker)
    @game_teams = []
    @tracker = tracker
    create_games(game_teams_path)
    create_helper
  end

  def create_games(game_teams_path)
    game_teams_data = CSV.parse(File.read(game_teams_path), headers: true)
    @game_teams = game_teams_data.map do |data|
      GameTeam.new(data, self)
    end
  end

  def create_helper
    GameTeamsSeason.new(self)
  end

  def selected_season_game_teams(season_id)
    @game_teams.select do |game_team|
      find_season_id(game_team.game_id) == season_id
    end
  end

  #Team

  def find_season_id(game_id)
    @tracker.find_season_id(game_id)
  end

  # Copy 2 of games_played
  def games_played(team_id)
    @game_teams.select do |game_team|
      game_team.team_id == team_id
    end
  end

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

# League
  def games_played(team_id)
    @game_teams.select do |game_team|
      game_team.team_id == team_id
    end
  end

  def games_played_by_type(team_id, home_away)
    @game_teams.select do |game_team|
      game_team.team_id == team_id && game_team.home_away == home_away
    end
  end

  def teams_list
    @game_teams.map do |game_team|
      game_team.team_id
    end.uniq
  end

  def total_goals(team_id)
    games_played(team_id).sum do |game|
      game.goals
    end.to_f
  end

  def average_number_of_goals_scored_by_team(team_id)
    average_with_count(total_goals(team_id), games_played(team_id), 2)
  end

  def total_goals_by_type(team_id, home_away)
    games_played_by_type(team_id, home_away).sum do |game|
      game.goals
    end.to_f
  end

  def avg_goals_team_type(team_id, home_away)
    average_with_count(total_goals_by_type(team_id, home_away), games_played_by_type(team_id, home_away), 2)
  end

  def avg_goals_all_teams_hash
    hash = {}
    teams_list.each do |team_id|
      hash[team_id] ||= 0
      hash[team_id] = average_number_of_goals_scored_by_team(team_id)
    end
    hash
  end

  def avg_goals_team_type_hash(home_away)
    hash = {}
    teams_list.each do |team_id|
      hash[team_id] ||= 0
      hash[team_id] = avg_goals_team_type(team_id, home_away)
    end
    hash
  end

  def best_offense
    avg_goals_all_teams_hash.max_by { |team_id, avg_goals| avg_goals }.to_a[0]
  end

  def worst_offense
    avg_goals_all_teams_hash.min_by { |team_id, avg_goals| avg_goals }.to_a[0]
  end

  def highest_scoring_visitor
    avg_goals_team_type_hash('away').max_by{ |team_id, avg_goals| avg_goals }.to_a[0]
  end

  def lowest_scoring_visitor
    avg_goals_team_type_hash('away').min_by{ |team_id, avg_goals| avg_goals }.to_a[0]
  end

  def highest_scoring_home
    avg_goals_team_type_hash('home').max_by{ |team_id, avg_goals| avg_goals }.to_a[0]
  end

  def lowest_scoring_home
    avg_goals_team_type_hash('away').min_by{ |team_id, avg_goals| avg_goals }.to_a[0]
  end
end
