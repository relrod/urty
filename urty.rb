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
end.parse!  

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

pp options