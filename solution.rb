class Solution
  attr_reader :path, :length

  def initialize(path, task)
    @path = path
    @length = task.path_distance(path)
    @task = task
    if @path.size != task.matrix.size
      binding.pry
    end
  end

  def update_length
    @length = @task.path_distance(@path)
  end

  def two_opt_swap(i, k)
    Solution.new(@path[0...i] + @path[i..k].reverse + @path[k+1..-1], @task)
  end

  def has_path_pair?(pair)
    index = @path.index(pair[0])
    unless index
      binding.pry
    end
    another_index = 
    @path[index == @path.size - 1 ? 0 : index + 1] == pair[1] || @path[index - 1] == pair[1]
  end

  def to_s
    "problem: #{@task.name} length: #{@length} path: #{@path.join(', ')}"
  end
end