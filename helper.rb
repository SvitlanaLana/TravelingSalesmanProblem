require 'csv'
require_relative 'tasks'
require_relative 'basic_optimizer'

class Helper
  class << self
    def read_tsp_file(path)
      indicator = false
      array = []
      dimension = 0
      begin
        file = File.new(path, "r")
        file.readlines.each do |line|
          dimension = line.split(' ')[-1].to_i if line.include?('DIMENSION')
          indicator = false if line.include?('EOF')
          array << line if indicator
          indicator = true if line.include?('NODE_COORD_SECTION') || line.include?('DISPLAY_DATA_SECTION')
        end
        file.close
        if path.include?('att48') && false
          get_matrix_att(dimension, array)
        else
          get_matrix(dimension, array)
        end
      rescue => err
        puts "Exception: #{err}"
      end
    end

    def read_atsp_file(directory)
      matrix = []
      file = File.new(directory, 'r')
      file.readlines.each do |line|
        matrix << line.split(' ').map(&:to_i)
      end
      matrix
    end

    def get_matrix(n, array)
      prepared_array  = array.map { |line| line.split(' ').map(&:to_i) }
      matrix = Array.new(n) { Array.new(n) }
      prepared_array.each_with_index do |row_i, i|
        prepared_array.each_with_index do |row_j, j|
          d = ((row_i[1] - row_j[1])**2 + (row_i[2] - row_j[2])**2) **0.5
          matrix[i][j] = d.ceil
        end
      end
      matrix
    end

    def get_matrix_att(n, array)
      prepared_array  = array.map { |line| line.split(' ').map(&:to_i) }
      matrix = Array.new(n) { Array.new(n) }
      prepared_array.each_with_index do |row_i, i|
        prepared_array.each_with_index do |row_j, j|
          d = ((row_i[1] - row_j[1])**2 + (row_i[2] - row_j[2])**2) **0.5 / 10.0
          matrix[i][j] = d.ceil
        end
      end
      matrix
    end

    def save_overall_report(solutions, path, options = {})
      CSV.open(path, 'w') do |csv|
        csv << [options[:title] || 'No Title']
        csv << ['problem', 'try', 'result', 'path']
        Tasks::ALL_TASKS.each_with_index do |problem, i|
          solutions[i].each_with_index do |solution, try|
            csv << [problem, try, solution.length, solution.path.join(' ')]
          end
        end
      end
    end

    def min_overall_report(solutions, path, options)
      solutions.each do |problem|
        best = problem.min { |a, b| a.length <=> b.length }
        puts best
        puts '============================'
      end
    end
  end
end