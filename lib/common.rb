require 'sinatra/reloader'

def parse_status(mpc_data)
  puts "!!!!!!!!!!!!!!!!!!!!"
  puts "!!!!!!!!!!!!!!!!!!!!"
  puts "!!!!!!!!!!!!!!!!!!!!"
  puts "!!!!!!!!!!!!!!!!!!!!"
  puts "!!!!!!!!!!!!!!!!!!!!"
  puts "!!!!!!!!!!!!!!!!!!!!"
  puts "!!!!!!!!!!!!!!!!!!!!"
=begin
The Cranberries - Promises
[paused]  #2/4   1:13/5:27 (22%)
volume: n/a   repeat: off   random: off   single: off   consume: off
"The Cranberries - Promises\n[paused]  #2/4   1:13/5:27 (22%)\nvolume: n/a   repeat: off   random: off   single: off   consume: off\n"
=end
  lineas = mpc_data.split("\n")
  artist, title = lineas[0].split('-')
  # status = lineas[1].split("]")[0].split("[")[1]
  status, current_total_playlist, actual_time_total_time, percentage = lineas[1].split(' ')
  status = status.gsub("[", "").gsub("]", "")
  current_item_playlist, total_items_playlist = current_total_playlist.gsub("#", "").strip().split('/')
  current_time, total_time = actual_time_total_time.strip().split('/')
  percentage = percentage.gsub("(", "").gsub(")", "").gsub("%", "")

  volume, repeat, random, single, consume = lineas[2].split("  ").map { |elem| elem.split(":")[1].strip() }
  return {
    status: status,
    artist: artist,
    title: title,
    current_item_playlist: current_item_playlist,
    total_items_playlist: total_items_playlist,
    current_time: current_time,
    total_time: total_time,
    percentage: percentage,
    volume: volume,
    repeat: repeat,
    random: random,
    single: single,
    consume: consume,
  }
end
