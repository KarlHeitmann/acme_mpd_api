require 'sinatra'
require 'sinatra/reloader'
require 'byebug'
require_relative 'lib/root'
require_relative 'lib/toggle'
require_relative 'lib/playlist'
require_relative 'lib/add'
require_relative 'lib/prev'
require_relative 'lib/next'

set :bind, '0.0.0.0'

get '/' do
  mpc = IO.popen(['mpc']).read
  data_mpc = read_root mpc
  content_type :json
  puts data_mpc
  return data_mpc.to_json
end

get '/prev' do
  prev_r = IO.popen(['mpc', 'prev']).read
  puts "::::::::::::::"
  puts prev_r
  puts "::::::::::::::"
  parsed_prev = parse_prev(prev_r)
  puts "11111111111111111111111111111111111111111"
  puts parsed_prev
  puts "00000000000000000000000000000000000000000"
  content_type :json
  return parsed_prev.to_json
end

get '/next' do
  next_r = IO.popen(['mpc', 'next']).read
  puts "::::::::::::::"
  puts next_r
  puts "::::::::::::::"
  parsed_next = parse_next(next_r)
  content_type :json
  return parsed_next.to_json
end

get '/play' do
  index = params[:index]
  index_r = IO.popen(['mpc', 'play', index]).read
  content_type :json
  return {status: "OK"}.to_json
end

get '/del' do
  index = params[:index]
  index_r = IO.popen(['mpc', 'del', index]).read
  content_type :json
  return {status: "OK"}.to_json
end

get '/playlist' do
  playlist = IO.popen(['mpc', 'playlist']).read
  puts "::::::::::::::"
  puts playlist
  puts "::::::::::::::"
  data_playlist = read_playlist(playlist)
  content_type :json
  return data_playlist.to_json
end

get '/queued' do
  queued = IO.popen(['mpc', 'queued']).read
  puts "::::::::::::::"
  puts queued
  puts "::::::::::::::"
  return queued
end

get '/ls' do
  folder = params[:folder]
  puts ":::::::::::::::::::"
  puts ":::::::::::::::::::"
  puts ":::::::::::::::::::"
  puts folder.class
  puts folder
  puts ":::::::::::::::::::"
  # ls = IO.popen(['mpc', folder.nil? ? 'ls' : "ls #{folder}"]).read
  if folder.nil?
    ls = IO.popen(['mpc', 'ls']).read
  else
    ls = IO.popen(['mpc', "ls", folder]).read
  end
  puts ls
  puts ls.class
  print ls
  res = ls.split("\n").to_json
  puts "=============="
  puts "=============="
  puts res
  content_type :json
  return ls.split("\n").to_json
end

get '/toggle' do
  ls = IO.popen(['mpc', 'toggle']).read
  puts ls
  puts ls.class
  print ls
  parsed_toggle = parse_toggle(ls)
  content_type :json
  return parsed_toggle.to_json
end

get '/add' do
  file = params[:file]
  res = IO.popen(['mpc', 'add', file]).read
  puts res
  puts res.class
  print res
  parsed_res = parse_add(res)
  content_type :json
  return parsed_res.to_json
end


get '/help' do
  ls = IO.popen(['mpc', 'help']).read
  puts ls
  puts ls.class
  print ls
  return ls
end


