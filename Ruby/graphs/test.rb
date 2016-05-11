require_relative 'graph'
require_relative 'dfs'

G = Graph.new(6)
G.add_edge(0,1)
G.add_edge(1,2)
G.add_edge(2,3)
G.add_edge(3,4)
puts G

D = NRDepthFirstSearch.new(G, 0)
puts D.has_path?(0)
puts D.has_path?(1)
puts D.has_path?(2)
puts D.has_path?(3)
puts D.has_path?(4)
puts D.has_path?(5)

puts D.path_to(0).to_s
puts D.path_to(1).to_s
puts D.path_to(2).to_s
puts D.path_to(3).to_s
puts D.path_to(4).to_s
puts D.path_to(5).to_s

