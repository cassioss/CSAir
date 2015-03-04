require 'csair/version'
require_relative '../lib/cli/cmd_interface'

# Module that initiates the Command Line Interface (CLI) as a for loop.
#
# Author:: Cassio dos Santos Sousa
# Version:: 1.0
#
module CSAir
  cli = CmdInterface.new
  cli.basic_for_loop
end