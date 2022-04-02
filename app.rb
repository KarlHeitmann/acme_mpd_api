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
  # mpc = IO.popen(['mpc']).read
  mpc_p = IO.popen(['mpc'])
  puts mpc_p.class
  puts mpc_p
  mpc = mpc_p.read
  puts ":::::::::::::::"
  puts "::: WAITING :::"
  Process.wait(mpc_p.pid)

  data_mpc = read_root mpc
  content_type :json
  puts data_mpc
  return data_mpc.to_json
end

get '/prev' do
  prev_r_p = IO.popen(['mpc', 'prev'])
  prev_r = prev_r_p.read
  Process.wait(prev_r_p.pid)
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
  next_r_p = IO.popen(['mpc', 'next'])
  next_r = next_r_p.read
  Process.wait(next_r_p.pid)
  puts "::::::::::::::"
  puts next_r
  puts "::::::::::::::"
  parsed_next = parse_next(next_r)
  content_type :json
  return parsed_next.to_json
end

get '/play' do
  index = params[:index]
  index_r_p = IO.popen(['mpc', 'play', index])
  index_r = index_r_p.read
  Process.wait(index_r_p.pid)
  content_type :json
  return {status: "OK"}.to_json
end

get '/del' do
  index = params[:index]
  index_r_p = IO.popen(['mpc', 'del', index])
  index_r = index_r_p.read
  Process.wait(index_r_p.pid)
  content_type :json
  return {status: "OK"}.to_json
end

get '/playlist' do
  playlist_p = IO.popen(['mpc', 'playlist'])
  playlist = playlist_p.read
  Process.wait(playlist_p.pid)
  puts "::::::::::::::"
  puts playlist
  puts "::::::::::::::"
  data_playlist = read_playlist(playlist)
  content_type :json
  return data_playlist.to_json
end

get '/queued' do
  queued_p = IO.popen(['mpc', 'queued'])
  queued = queued_p.read
  Process.wait(queued_p.pid)
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
    ls_p = IO.popen(['mpc', 'ls'])
    ls = ls_p.read
    Process.wait(ls_p.pid)
  else
    ls_p = IO.popen(['mpc', "ls", folder])
    ls = ls_p.read
    Process.wait(ls_p.pid)
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
  ls_p = IO.popen(['mpc', 'toggle'])
  ls = ls_p.read
  Process.wait(ls_p.pid)
  puts ls
  puts ls.class
  print ls
  parsed_toggle = parse_toggle(ls)
  content_type :json
  return parsed_toggle.to_json
end

get '/add' do
  file = params[:file]
  res_p = IO.popen(['mpc', 'add', file])
  res = res_p.read
  Process.wait(res_p.pid)
  puts res
  puts res.class
  print res
  parsed_res = parse_add(res)
  content_type :json
  return parsed_res.to_json
end


get '/help' do
  ls_p = IO.popen(['mpc', 'help'])
  ls = ls_p.read
  Process.wait(ls_p.pid)
  puts ls
  puts ls.class
  print ls
  return ls
end

get '/qqq' do
  IO.popen(['sudo', 'shutdown', 'now'])
end


