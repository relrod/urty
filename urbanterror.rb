#!/usr/bin/env ruby

require 'socket'
require 'pp'

class UrbanTerror
  def initialize(server, port=nil, rcon=nil)
    @server = server
    @port = port.nil? ? 27960 : port
    @rcon = rcon.nil? ? '' : rcon
    @socket = UDPSocket.open
  end

  def sendCommand(command)
    magic = "\377\377\377\377"
    @socket.send("#{magic}#{command}\n", 0, @server, @port)
    @socket.recv(2048)
  end

  def get(command)
    sendCommand("get#{command}")
  end

  def getparts(command)
    get(command).split("\n")
  end
  
  def rcon(command)
    sendCommand("rcon #{@rcon} #{command}")
  end

  # settings() returns a hash of settings => values.
  # We /were/ going to accept an optional setting arg, but it would be
  # doing the same thing and just selecting one from the Hash, so
  # why not just let the user do server.settings['map'] or whatever.
  def settings
    result = get("status").split("\n")[1].split("\\").reject{ |s| s.empty? }
    Hash[*result]
  end
  
  # players() returns a list of hashes. Each hash contains
  # name, score, ping.
  def players
    result = get("status").split("\n")[2..-1]
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

# TODO: Eventually this will be in UrbanTerror (the class)
def gearCalc
  # We basically have to determine what the JS in
  # http://www.urbanterror.info/docs/texts/123/#2.2
  # is doing.
end