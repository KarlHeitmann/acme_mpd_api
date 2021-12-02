require 'sinatra'
require 'sinatra/reloader'
require 'byebug'

set :bind, '0.0.0.0'

get '/' do
  mpc = IO.popen(['mpc']).read
  lineas = mpc.split("\n")
  puts
  print mpc
  puts mpc.inspect
  puts
  puts lineas.length
  if lineas.length == 1
    content_type :json
    return {
      status: "stopped",
      artist: "no artist",
      title: "no title",
      current_item_playlist: 0,
      total_items_playlist: 0,
      current_time: "00:00",
      total_time: "00:00",
      percentage: 0,
      volume: "",
      repeat: "",
      random: "",
      single: "",
      consume: "",
    }.to_json
  else
=begin
The Cranberries - Promises
[paused]  #2/4   1:13/5:27 (22%)
volume: n/a   repeat: off   random: off   single: off   consume: off
"The Cranberries - Promises\n[paused]  #2/4   1:13/5:27 (22%)\nvolume: n/a   repeat: off   random: off   single: off   consume: off\n"
=end
    artist, title = lineas[0].split('-')
    # status = lineas[1].split("]")[0].split("[")[1]
    status, current_total_playlist, actual_time_total_time, percentage = lineas[1].split(' ')
    status = status.gsub("[", "").gsub("]", "")
    current_item_playlist, total_items_playlist = current_total_playlist.gsub("#", "").strip().split('/')
    current_time, total_time = actual_time_total_time.strip().split('/')
    percentage = percentage.gsub("(", "").gsub(")", "").gsub("%", "")

    volume, repeat, random, single, consume = lineas[2].split("  ").map { |elem| elem.split(":")[1].strip() }
    content_type :json
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
    }.to_json
  end
end

get '/prev' do
  prev_r = IO.popen(['mpc', 'prev']).read
  puts "::::::::::::::"
  puts prev_r
  puts "::::::::::::::"
  return prev_r
end

get '/next' do
  next_r = IO.popen(['mpc', 'next']).read
  puts "::::::::::::::"
  puts next_r
  puts "::::::::::::::"
  return next_r
end

get '/playlist' do
  playlist = IO.popen(['mpc', 'playlist']).read
  puts "::::::::::::::"
  puts playlist
  puts "::::::::::::::"
  return playlist
end

get '/queued' do
  queued = IO.popen(['mpc', 'queued']).read
  puts "::::::::::::::"
  puts queued
  puts "::::::::::::::"
  return queued
end

get '/ls' do
  ls = IO.popen(['mpc', 'ls']).read
  puts ls
  puts ls.class
  print ls
  content_type :json
  return ls.split("\n").to_json
end

get '/toggle' do
  ls = IO.popen(['mpc', 'toggle']).read
  puts ls
  puts ls.class
  print ls
  return ls
end


get '/help' do
  ls = IO.popen(['mpc', 'help']).read
  puts ls
  puts ls.class
  print ls
  return ls
end


