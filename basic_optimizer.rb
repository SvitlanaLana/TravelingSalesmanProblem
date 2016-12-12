require_relative 'solution'
require_relative 'tasks'
require 'benchmark'
require 'json'

class BasicOptimizer
  def initialize(options = {})
    @max_iterations = options[:max_iterations] || 200
    @matrix = []
  end

  def start_task(task_name, type)
    task = Tasks.new(task_name, type)
    @matrix = task.matrix
    initial_path(task_name)[0..-1].map do |hash|
      r = nil
      puts Benchmark.measure { r = process(hash["path"], task) }
      r
    end
  end

  def start_tasks
    i = 0
    proc = Proc.new do |tasks, type|
      tasks.map do |name| 
        r = start_task(name, type)
        puts "Task #{i} is finished"
        i += 1
        r
      end
    end
    proc.call(Tasks::TSP_TASKS, 'tsp') +
    proc.call(Tasks::ATSP_TASKS, 'atsp')
  end

  def initial_path(key)
    self.class.approximations[key]
  end

  class << self
    def approximations
      @approximations ||= parse_json
    end

    private

    def parse_json
      file = File.read('./Data/approximations.json')
      content = JSON.parse(file)
      content['problems']
    end
  end
end