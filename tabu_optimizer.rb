require_relative 'basic_optimizer'

class TabuOptimizer < BasicOptimizer
  def initialize(options = {})
    super
    @tabu_size = options[:tabu_size] || 15
    @tabu_list = []
    @max_candidates = options[:max_candidates] || 50
  end

  def process(path, task)
    current = Solution.new(path, task)
    best = current
    @max_iterations.times do |iter|
      candidates = Array.new(@max_candidates) do |i|
        generate_candidate(current, task)
      end
      best_candidate_result = candidates.min { |x, y| x.first.length <=> y.first.length }

      best_candidate = best_candidate_result[0]
      best_candidate_edges = best_candidate_result[1]
      if best_candidate.length < current.length
        current = best_candidate
        best = best_candidate if best_candidate.length < best.length
        @tabu_list += best_candidate_edges
        @tabu_list.shift([0, @tabu_list.size - @tabu_size].max)
      end
    end
    best
  end

  private

  def generate_candidate(best, task)
    cities = task.matrix
    perm, edges = stochastic_two_opt(best)
    return perm, edges
  end

  def tabu?(permutation)
    @tabu_list.any? { |pair| permutation.has_path_pair?(pair) }
  end

  def stochastic_two_opt(parent)
    path = parent.path
    perm = Array.new(path)
    indexes = (0...path.size).to_a
    c1 = indexes[rand(indexes.size)]

    indexes.delete_if { |i| in_tabu?(path[i], path[c1]) }

    c2 = indexes[rand(indexes.size)]
    c1, c2 = c2, c1 if c2 < c1

    edges = [[path[c1-1], path[c1]], [path[c2-1], path[c2]]]

    perm = parent.two_opt_swap(c1, c2)
    return perm, [[path[c1], path[c2]]]
  end

  def in_tabu?(c1, c2)
    @tabu_list.any? { |pair| pair[0] == c1 && pair[1] == c2 || pair[1] == c1 && pair[0] == c2 }
  end



  def old_stochastic_two_opt(parent)
    path = parent.path
    perm = Array.new(path)
    indexes = (0...path.size).to_a
    c1 = indexes[rand(indexes.size)]
    i = indexes.index(c1)
    indexes.delete_at(i)
    indexes.delete_at(i - 1)
    indexes.delete_at(i == indexes.size ? 0 : i)
    c2 = indexes[rand(indexes.size)]
    c1, c2 = c2, c1 if c2 < c1

    edges = [[path[c1-1], path[c1]], [path[c2-1], path[c2]]]

    perm = parent.two_opt_swap(c1, c2)
    return perm, [[path[c1-1], path[c1]], [path[c2-1], path[c2]]]
  end
end