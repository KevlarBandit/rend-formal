require_relative "rend/parser"
require_relative "rend/translator"
require_relative "rend/solver"
require_relative "rend/law"

module Rend
  class << self
    def verify(source:, laws:)
      parser = Rend::Parser.new
      ast = parser.parse(source)

      translator = Rend::Translator.new
      conditions = translator.translate(ast, laws)

      solver = Rend::Solver.new
      results = []

      laws.each_with_index do |law, i|
        smt = conditions[i]
        result = solver.check_sat(smt)
        if result == :unsat
          results << { law: law.name, status: :proved, details: "No counterexample found" }
        elsif result == :sat
          results << { law: law.name, status: :broken, details: "Counterexample found" }
        else
          results << { law: law.name, status: :unknown, details: "Solver inconclusive" }
        end
      end

      all_proved = results.all? { |r| r[:status] == :proved }
      {
        results: results,
        all_proved: all_proved,
        total_laws: results.size,
        proved: results.count { |r| r[:status] == :proved },
        broken: results.count { |r| r[:status] == :broken }
      }
    end

    def prove(source:, property:)
      law = Rend::Law.new("auto", property: property)
      verify(source: source, laws: [law])
    end
  end
end
