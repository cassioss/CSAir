require 'csair/version'
require 'launchy'
require_relative '../lib/cli/cmd_interface'
require_relative '../lib/graph/graph'

module CSAir
end

basic_url = 'http://www.gcmap.com/mapui?P='
new_graph = Graph.new
new_graph.create_graph_from_json
basic_url << new_graph.get_url_addition
Launchy.open(basic_url)
