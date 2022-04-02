require 'sinatra/reloader'
def read_playlist(mpc_data)
  temas = mpc_data.split("\n").map do |tema|
    partes = tema.split('/')
    filename = partes[-1]
    folders = partes[0...-1]
=begin
    artist_and_song = filename.split('.')[0...-1].join
    folders = partes[0...-1]
    artist = artist_and_song.split(' - ')[0...-1].join
    song = artist_and_song.split(' - ')[-1]
=end
    artist, song = filename.split(' - ')

    {
      artist: artist.strip,
      song: song.strip,
      filename: filename,
      folders: folders,
      raw: tema,
    }
  end
end
