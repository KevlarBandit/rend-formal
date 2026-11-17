module Rend
  class Translator
    def translate(ast, laws)
      functions = extract_functions(ast)
      laws.map { |law| generate_law_smt(law, functions) }
    end

    private

    def extract_functions(ast)
      functions = {}
      statements = ast.statements.body
      statements.each do |stmt|
        if stmt.type == :def_node
          name = stmt.name
          body = stmt.body
          params = stmt.parameters&.elements || []
          param_names = []
          params.each do |p|
            if p.type == :identifier
              param_names << p.name.to_s
            end
          end
          functions[name] = { body: body, params: param_names, node: stmt }
        end
      end
      functions
    end

    def generate_law_smt(law, functions)
      smt = "(set-logic QF_LIA)\n"

      # Extract variable names from the property expression
      vars = extract_variables(law.property)
      vars.each do |var|
        smt += "(declare-const #{var} Int)\n"
      end

      # Parse the property expression and generate proper SMT-LIB
      expr = parse_property(law.property)
      smt += "(assert (not #{expr}))\n"
      smt += "(check-sat)\n"

      smt
    end

    # Simple expression parser for SMT-LIB generation
    # Handles: arithmetic (+, -, *), comparisons (=, <, >, <=, >=, !=),
    #         logical (and, or, not), variables, integers
    # Uses operator precedence parsing
    def parse_property(expr)
      expr = expr.strip

      # Handle parentheses
      if expr.start_with?("(") && expr.end_with?("(")
        return parse_property(expr[1..-2])
      end

      # Try to find lowest-precedence binary operator
      # Order: => (lowest), ||, &&, ==, !=, <, >, <=, >=, +, -, * (highest)
      
      # Implication
      if (match = expr.match(/^(.+?)\s*=>\s*(.+)$/))
        return "(=> #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # OR
      if (match = expr.match(/^(.+?)\s*\|\|\s*(.+)$/))
        return "(or #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # AND
      if (match = expr.match(/^(.+?)\s*&&\s*(.+)$/))
        return "(and #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Equality
      if (match = expr.match(/^(.+?)\s*==\s*(.+)$/))
        return "(= #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Inequality
      if (match = expr.match(/^(.+?)\s*!=\s*(.+)$/))
        return "(!= #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Less than or equal
      if (match = expr.match(/^(.+?)\s*<=\s*(.+)$/))
        return "(<= #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Greater than or equal
      if (match = expr.match(/^(.+?)\s*>=\s*(.+)$/))
        return "(>= #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Less than
      if (match = expr.match(/^(.+?)\s*<\s*(.+)$/))
        return "(< #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Greater than
      if (match = expr.match(/^(.+?)\s*>\s*(.+)$/))
        return "(> #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Addition
      if (match = expr.match(/^(.+?)\s*\+\s*(.+)$/))
        return "(+ #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Subtraction
      if (match = expr.match(/^(.+?)\s*-\s*(.+)$/))
        return "(- #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Multiplication
      if (match = expr.match(/^(.+?)\s*\*\s*(.+)$/))
        return "(* #{parse_property(match[1])} #{parse_property(match[2])})"
      end
      
      # Handle unary minus
      if expr.start_with?("-")
        return "(- 0 #{parse_property(expr[1..-1])})"
      end
      
      # Handle unary not
      if expr.start_with?("!")
        return "(not #{parse_property(expr[1..-1])})"
      end
      
      # Handle integers
      if expr.match(/^\d+$/)
        return expr
      end
      
      # Handle variables (identifiers)
      if expr.match?(/^[a-zA-Z_][a-zA-Z0-9_]*$/)
        return expr
      end
      
      # Unknown expression - return as-is
      expr
    end

    # Extract variable names from a property expression
    def extract_variables(expr)
      vars = []
      expr.scan(/[a-zA-Z_][a-zA-Z0-9_]*/).each do |word|
        # Skip SMT/Ruby keywords
        next if ["and", "or", "not", "true", "false"].include?(word)
        vars << word
      end
      vars.uniq
    end
  end
end
