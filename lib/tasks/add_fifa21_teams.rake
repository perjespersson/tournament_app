desc "Add fifa teams that have at least 4.5 stars from Fifa 21"
task :add_fifa21_teams, [] => [:environment] do

  teams = [
            ["Liverpool",5],
            ["Manchester City",5],
            ["Real Madrid CF",5],
            ["FC Bayern München",5],
            ["Paris Saint-Germain",5],
            ["Juventus",5],
            ["Atletico de Madrid",5],
            ["FC Barcelona",5],
            ["Tottenham Hotspur",4.5],
            ["Manchester United",4.5],
            ["Inter",4.5],
            ["Chelsea",4.5],
            ["Borussia Dortmund",4.5],
            ["Sevilla FC",4.5],
            ["Arsenal",4.5],
            ["Napoli",4.5],
            ["Lazio",4.5],
            ["Villarreal CF",4.5],
            ["Leicester City",4.5],
            ["RB Leipzig",4.5],
            ["Atalanta",4.5],
            ["Real Sociedad",4.5],
            ["Everton",4.5],
            ["Milan",4.5],
            ["Athletic Club de Bilbao",4.5],
            ["Borussia Mönchengladbach",4.5],
            ["Bayer 04 Leverkusen",4.5],
            ["Wolverhampton Wanderers",4.5],
            ["SL Benfica",4.5],
            ["Frankrike",5],
            ["Tyskland",5],
            ["Spanien",5],
            ["Argentina",5],
            ["England",5],
            ["Belgien",5],
            ["Portugal",5],
            ["Italien",4.5],
            ["Nederländerna",4.5],
            ["Brasilien",4.5],
            ["Uruguay",4.5]
          ]

  career = "fifa21"

  for i in 0..teams.length()
    new_team = FifaTeam.find_by name: teams[i][0]
    if new_team.nil?
      new_team = FifaTeam.new
      new_team.name = teams[i][0]
      new_team.stars = teams[i][1].to_s
      new_team.career = "fifa21"
      new_team.img = "teams/" + teams[i][0].gsub(/\s+/, "").downcase.tr("äåöü", "aaou") + ".png"
      new_team.save
    end
  end
end

