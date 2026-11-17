require "open3"

module Rend
  class Solver
    Z3_PATH = ENV["Z3_PATH"] || "z3"

    def check_sat(smt)
      stdout, stderr, status = Open3.capture3(Z3_PATH, "-in", "-smt2", stdin_data: smt)
      if stdout.include?("unsat")
        return :unsat
      elsif stdout.include?("sat")
        return :sat
      elsif stdout.include?("unknown")
        return :unknown
      else
        raise SolverError, "Unexpected Z3 output: #{stdout[0..200]}"
      end
    rescue Errno::ENOENT
      raise SolverError, "Z3 not found at '#{Z3_PATH}'. Install z3 or set Z3_PATH."
    end

    class SolverError < StandardError; end
  end
end
