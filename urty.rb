#!/usr/bin/env ruby
require 'urbanterror'
require 'optparse'

options = Hash.new
OptionParser.new do |opts|
  opts.banner = "Example Usage: urty --rcon PassW0rd --map ut4_riyadh --gravity 500"
  opts.on('-r', '--rcon-password', "RCON Password") { |r| options[:rcon] = r }
  opts.on('-g', '--gear', "Gear Selection (see -L for list)") { |r| options[:gear] = r }
  opts.on('-L', '--gear-list', "Gear List") { |r| options[:gearlist] = r }
  opts.on('-G', '--gravity', "Gravity Level") { |r| options[:gravity] = r }
  opts.on('-h', '--hostname', "Server Hostname or IP") { |r| options[:hostname] = r }
  opts.on('-p', '--port', "Server Port") { |r| options[:port] = r }
  opts.on('-m', '--map', "Full Map Name (including 'ut4_')") { |r| options[:map] = r }
end.parse!  
  
