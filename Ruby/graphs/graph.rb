# Graph is a simple graph api, it
# allows initialization from the number
# of vertices or from file
# Edges can be added to an existing graph
#
# It uses the adjacency list representation
#
# Author:: Tristan Claverie
# License:: MIT
class Graph

    # Edge class is the internal edge used by Graph
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Edge
        # Extremities of an edge
        attr_accessor :v, :w

        # Creates a new edge
        def initialize(v, w)
            @v = v
            @w = w
        end

        # Is this edge the same ad the other ?
        def ==(other)
            (other.v == @v and other.w == @w) or (other.v == @w and other.w == @v)
        end

        # Other end of the edge
        def other(v)
            @v == v ? @w : @v
        end

        # String representation of an edge
        def to_s
            @v.to_s << " -> " << @w.to_s
        end
    end

    # Creates an empty graph containg v vertices
    def initialize(v)
        @v = v
        @e = 0
        # For some reason, my version of ruby does not support array instantiation
        # with mutable objects, that is, given this code:
        # @graph = Array.new(2, Array.new)
        # @graph[0] << 0
        # puts @graph.to_s
        # This outputs [[0], [0]]
        @graph = Array.new(v)
        (0...v).each { |i| @graph[i] = [] }
    end

    # Creates an empty graph from file
    def self.init_file(filename)
        g = nil
        File.open(filename) do |file|
            g = Graph.new(file.gets.to_i)
            while (line = file.gets)
                e = line.scan(/\w+/)
                g.add_edge(e[0].to_i, e[1].to_i)
            end
        end
        return g
    end

    # Add the edge (v,w) if not existant
    def add_edge(v, w)
        e = Edge.new(v, w)
        return if @graph[v].find_index(e)
        @graph[v].push(e)
        @graph[w].push(e)
        @e += 1
    end

    # Vertices adjacents to v
    def adj(v)
        @graph[v]
    end

    # Iterate through all edges
    def each
        @graph.each do |v|
            v.each do |e|
                yield e
            end
        end
    end

    # String representing the graph
    def to_s
        s = "V:" << @v.to_s << ",E:" << @e.to_s << "\n"
        self.each do |e|
            s += e.to_s << "\n"
        end
        s
    end

    # Number of edges
    def E
        @e
    end

    # Number of vertices
    def V
        @v
    end

end

# MtxGraph is an implementation of a simple
# graph API using the adjacency matrix representation
#
# Author:: Tristan Claverie
# License:: MIT
class MtxGraph

    # Edge class is the internal edge used by Graph
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Edge
        # Extremities of an edge
        attr_accessor :v, :w

        # Creates a new edge
        def initialize(v, w)
            @v = v
            @w = w
        end

        # Is this edge the same ad the other ?
        def ==(other)
            (other.v == @v and other.w == @w) or (other.v == @w and other.w == @v)
        end

        # Other end of the edge
        def other(v)
            @v == v ? @w : @v
        end

        # String representation of an edge
        def to_s
            @v.to_s << " -> " << @w.to_s
        end
    end

    # Creates an empty graph
    def initialize(v)
        @v = v
        @e = 0
        @graph = Array.new(v)
        (0...v).each { |i| @graph[i] = Array.new(v) }
    end

    # Creates an empty graph from file
    def self.init_file(filename)
        g = nil
        File.open(filename) do |file|
            g = Graph.new(file.gets.to_i)
            while (line = file.gets)
                e = line.scan(/\w+/)
                g.add_edge(e[0].to_i, e[1].to_i)
            end
        end
        return g
    end

    # Add the edge (v,w) if not existant
    def add_edge(v, w)
        return if @graph[v][w] != nil
        e = Edge.new(v, w)
        @graph[v][w] = e
        @graph[w][v] = e
        @e += 1
    end

    # Vertices adjacents to v
    def adj(v)
        adj = []
        @graph[v].each { |e| adj << e if e }
    end

    # Iterate through all edges
    def each
        @graph.each do |v|
            v.each do |e|
                yield e if e
            end
        end
    end

    # String representing the graph
    def to_s
        s = "V:" << @v.to_s << ",E:" << @e.to_s << "\n"
        self.each do |e|
            s += e.to_s << "\n"
        end
        s
    end

    # Number of edges
    def E
        @e
    end

    # Number of vertices
    def V
        @v
    end

end

# Digraph is a directed graph api, it
# allows initialization from the number
# of vertices or from file
# Edges can be added to an existing graph
#
# It uses the adjacency list representation
#
# Author:: Tristan Claverie
# License:: MIT
class Digraph

    # Edge class is the internal edge used by Digraph
    #
    # Author:: Tristan Claverie
    # License:: MIT
    class Edge
        # Extremities of an edge
        attr_accessor :from, :to

        # Creates a new edge
        def initialize(from, to)
            @from = from
            @to = to
        end

        # Is this edge the same as the other ?
        def ==(other)
            @from == other.from and @to = other.to
        end

        # String representation of an edge
        def to_s
            @from.to_s << " -> " << @to.to_s
        end
    end

    # Creates an empty graph containg v vertices
    def initialize(v)
        @v = v
        @e = 0
        # For some reason, my version of ruby does not support array instantiation
        # with mutable objects, that is, given this code:
        # @graph = Array.new(2, Array.new)
        # @graph[0] << 0
        # puts @graph.to_s
        # This outputs [[0], [0]]
        @graph = Array.new(v)
        (0...v).each { |i| @graph[i] = [] }
    end

    # Creates an empty graph from file
    def self.init_file(filename)
        g = nil
        File.open(filename) do |file|
            g = Digraph.new(file.gets.to_i)
            while (line = file.gets)
                e = line.scan(/\w+/)
                g.add_edge(e[0].to_i, e[1].to_i)
            end
        end
        return g
    end

    # Add the edge (from,to) if not existant
    def add_edge(from, to)
        e = Edge.new(from, to)
        return if @graph[from].find_index(e)
        @graph[from].push(e)
        @e += 1
    end

    # Vertices adjacents to v
    def adj(v)
        @graph[v]
    end

    # Iterate through all edges
    def each
        @graph.each do |v|
            v.each do |e|
                yield e
            end
        end
    end

    # String representing the graph
    def to_s
        s = "V:" << @v.to_s << ",E:" << @e.to_s << "\n"
        self.each do |e|
            s += e.to_s << "\n"
        end
        s
    end

    # Number of edges
    def E
        @e
    end

    # Number of vertices
    def V
        @v
    end

end
