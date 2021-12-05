require 'sinatra'
require 'sinatra/reloader'
require 'byebug'
require_relative 'lib/root'

set :bind, '0.0.0.0'

get '/' do
  mpc = IO.popen(['mpc']).read
  data_mpc = read_root mpc
  content_type :json
  return data_mpc.to_json
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


