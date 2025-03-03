require "rufus/scheduler"

scheduler = Rufus::Scheduler.new

scheduler.every "10sec" do
  Game.first.regenerate_boosters
end
