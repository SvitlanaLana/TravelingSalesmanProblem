require_relative 'helper'

class Tasks
  TSP_TASKS = ['berlin52','eil76','eil101','att48', 'eil51'].freeze
  ATSP_TASKS = ['br17', 'ft53', 'ftv35','ftv44','ftv33',
                        'ftv55','p43','ftv47','ftv64','swiss42','ry48p','bays29'].freeze
  ALL_TASKS = TSP_TASKS + ATSP_TASKS
  
  attr_reader :matrix, :name

  def initialize(name_file, type_file)
    @name = name_file
    if type_file == 'tsp'
      @matrix = Helper.read_tsp_file("./Data/#{name_file}.tsp")
    else
      @matrix = Helper.read_atsp_file("./Data/#{name_file}_fixed.atsp")
    end
  end

  def path_distance(path)
    distance = 0
    (path.size - 1).times do |i|
      distance += @matrix[path[i]][path[i + 1]]
    end
    distance + @matrix[path[-1]][path[0]]
  end
end