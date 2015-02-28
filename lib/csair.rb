require 'csair/version'
require_relative '../lib/cli/cmd_interface'

module CSAir
  cli = CmdInterface.new
  cli.basic_for_loop
end