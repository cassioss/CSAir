require 'csair/version'
require_relative '../lib/cli/cmd_interface'
require 'json'

# Module that initiates the Command Line Interface (CLI) as a for loop.
#
# @author Cassio dos Santos Sousa
# @version 1.0
#
module CSAir
  cli = CmdInterface.new
  cli.basic_for_loop

  temp_hash = {
      :key_a => 10,
      :key_b => 20,
  }

  my_path = File.dirname(__FILE__)
  path_to_json = File.join(my_path, '..', 'resources', 'new_map_data.json')
  File.open(path_to_json, 'w') do |f|
    f.write(temp_hash.to_json)
  end

end