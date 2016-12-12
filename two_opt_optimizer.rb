require_relative 'basic_optimizer'

class TwoOptOptimizer < BasicOptimizer
  def process(path, task)
    best = Solution.new(path, task)
    while true
      current_best = best
      (0..path.size-2).each do |i|
        (i+1..path.size-1).each do |k|
          current = current_best.two_opt_swap(i, k)
          current_best = current if current.length < current_best.length
        end     
      end
      break if current_best.length >= best.length
      best = current_best
    end
    best
  end
end