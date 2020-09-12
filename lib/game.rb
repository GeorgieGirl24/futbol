class Game
  def initialize(data, manager)
    @game_id = data["game_id"]
    @season = data["season"]
    @type = data["type"]
    @date_time = data["date_time"]
    @away_team_id = data["away_team_id"]
    @home_team_id = data["home_team_id"]
    @away_goals = data["away_goals"]
    @home_goals = data["home_goals"]
    @venue = data["venue"]
    @venue_link = data["venue_link"]
  end
end