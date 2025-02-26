# Seed games
Game.available_games.each do |game|
  Game.find_or_create_by!(name: game)
end
