#!/usr/bin/env ruby
require 'urbanterror'
require 'optparse'

options = Hash.new
OptionParser.new do |opts|
  opts.banner = "Example Usage: urty --rcon PassW0rd --map ut4_riyadh --gravity 500"
  opts.on('-r', '--rcon-password PASSWORD', "RCON Password") { |r| options[:rcon] = r }
  opts.on('-g', '--gear GEAR', "Gear Selection (see -L for list)") { |r| options[:gear] = r }
  opts.on('-L', '--gear-list', "Gear List") { |r| options[:gearlist] = r }
  opts.on('-G', '--gravity GRAVITY', "Gravity Level") { |r| options[:gravity] = r }
  opts.on('-h', '--hostname HOSTNAME', "Server Hostname or IP") { |r| options[:hostname] = r }
  opts.on('-p', '--port PORT', "Server Port") { |r| options[:port] = r }
  opts.on('-m', '--map MAP', "Full Map Name (including 'ut4_')") { |r| options[:map] = r }
  opts.on('-S', '--status', "Print the current status of the server.") { |r| options[:status] = r }
end.parse!  

# Handle simple sanity checks first. If we're just printing stuff,
# no use in creating an instance of UrbanTerror() for example.
if not options.has_key? :hostname or not options.has_key? :rcon
  puts "--hostname and --rcon-password are required for the time being."
  puts "In a later release, these options will be able to have defaults assigned"
  puts "through the use of a local configuration file."
  exit
end

if options.has_key? :gearlist
  puts "GEAR LIST: grenades, pistols, snipers, autos, spas, negev, all, none"
  puts "none = knife only."
  puts "comma-separate a list (no spaces)."
  exit
end

# Alright, everything else is actually dealing with UrT.
port = !options[:port].nil? ? options[:port] : 27960
server = UrbanTerror.new(options[:hostname], port, options[:rcon])

if options.has_key? :status
  pp server.settings
  exit
end

if options.has_key? :map
  server.rcon "map #{options[:map]}"
  puts "Map is now #{options[:map]}"
end

if options.has_key? :gear
  gear = options[:gear].split(',')
  gear_i = UrbanTerror.gearCalc gear
  server.rcon "set g_gear #{gear_i}"
  puts "Gear is now set to #{gear_i}"
end

pp options