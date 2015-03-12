require 'csair/version'
require_relative 'cli/cmd_interface'
require_relative 'csair_lib/writer'
require 'json'

# Module that initiates the Command Line Interface (CLI) as a for loop.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
module CSAir
  cli = CmdInterface.new
  cli.basic_for_loop

  write = Writer.new

end