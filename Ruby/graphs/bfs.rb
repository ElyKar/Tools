# Use breadth-first search to perform graph traversal from a given source
# One initialized, query it for getting data from the graph suh has paths
#
# Author:: Tristan Claverie
# License:: MIT
class BreadthFirstSearch

    # Perform bfs on the graph from given source
    def initialize(graph, s)
        @visited = Array.new(graph.V, false)
        @path = Array.new(graph.V)
        @dist = Array.new(graph.V, Float::INFINITY)
        @s = s
        bfs(graph, s)
    end

    # Source for BFS
    def S
        @s
    end

    # Has the source a path to v ?
    def has_path?(v)
        @visited[v]
    end

    # Number of edges to go through to get to v
    def dist_to(v)
        @dist[v]
    end

    # Path from the source to v, the path is rendered
    # as an array containing the source and the destination
    # Example:
    # Graph is 0 -- 1 -- 2 -- 3 -- 4
    # BFS is called with source = 0
    # path_to(4) returns [0,1,2,3,4]
    def path_to(v)
        return nil if not @visited[v]
        path = [v]
        while @path[v]
            path << @path[v]
            v = @path[v]
        end
        return path.reverse
    end

    private

    # Inner function performing the actual bfs
    def bfs(graph, s)
        queue = [s]
        @visited[s] = true
        @dist[s] = 0
        w = nil
        while not queue.empty?
            w = queue.delete_at(0)
            graph.adj(v).each do |edge|
                w = edge.other(v)
                if not @visited[edge.other(v)]
                    @path[w] = v
                    @dist[w] = @dist[v] + 1
                    @visited[w] = true
                    queue << edge.other(v)
                end
            end
        end
    end

end
