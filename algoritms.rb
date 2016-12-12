require 'pry'
require_relative 'two_opt_optimizer'
require_relative 'tabu_optimizer'
require_relative 'helper'

puts 'LocalSearch'
local_search_results = TwoOptOptimizer.new.start_tasks
Helper.min_overall_report(local_search_results, '2opt.csv', title: '2opt')
puts 'TabuOptimizer'
options = {tabu_size: 40, max_candidates: 60}
tabu_search_results = TabuOptimizer.new(options).start_tasks
opt = TabuOptimizer.new(options)
#tabu_search_results = Tasks::TSP_TASKS[3...4].map { |t| opt.start_task(t, 'tsp') }
#binding.pry
Helper.min_overall_report(tabu_search_results, 'tabu.csv', title: 'tabu')

=begin
Tasks::TSP_TASKS.each do |name|
  t = Tasks.new(name, 'tsp')
  puts name
  BasicOptimizer.approximations[name].each do |h|
    s = Solution.new(h['path'], t)
    puts s
    puts '====================='
  end
end

=end
