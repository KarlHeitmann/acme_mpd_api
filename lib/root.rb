require 'sinatra/reloader'
require_relative 'common.rb'

def read_root(mpc)
  lineas = mpc.split("\n")
  puts
  print mpc
  puts mpc.inspect
  puts
  puts lineas.length
  if lineas.length == 1
    volume, repeat, random, single, consume = lineas[0].split("  ").map { |elem| elem.split(":")[1].strip() }
    return {
      status: "stopped",
      artist: "no artist",
      title: "no title",
      current_item_playlist: 0,
      total_items_playlist: 0,
      current_time: "00:00",
      total_time: "00:00",
      percentage: 0,
      volume: volume,
      repeat: repeat,
      random: random,
      single: single,
      consume: consume,
    }
  else
    return parse_status(mpc)
  end
end
