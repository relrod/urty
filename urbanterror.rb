#!/usr/bin/env ruby

require 'socket'
require 'pp'

class UrbanTerror
  def initialize(server, port=27960)
    @server = server
    @port = port
    @socket = UDPSocket.open
  end
  
  def sendCommand(command)
    magic = "\377\377\377\377"
    @socket.send("#{magic}#{command}\n", 0, @server, @port)
    @socket.recv(2048)
  end
  
  # settings() returns a hash of settings => values.
  # We /were/ going to accept an optional setting arg, but it would be
  # doing the same thing and just selecting one from the Hash, so
  # why not just let the user do server.settings['map'] or whatever.
  def settings
    result = sendCommand("getstatus").split("\n")[1].split("\\").reject{ |s| s.empty? }
    settings = Hash.new
    while result.size > 0 # .each won't work here.
      key = result.shift
      value = result.shift
      settings[key] = value
    end
    settings
  end
  
  # players() returns a list of hashes. Each hash contains
  # name, score, ping.
  def players
    result = sendCommand("getstatus").split("\n")[2..-1]
    players = []
    result.each do |player|
      player = player.split(" ", 3)
      p = Hash.new
      p['name'] = player[2][1..-2]
      p['ping'] = player[1].to_i
      p['score'] = player[0].to_i
      players << p
    end
    players
  end
end

server = UrbanTerror.new(ARGV[0])
pp server.players