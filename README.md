# Rend: Formal Verification for Ruby Programs

Translates Ruby programs to SMT verification conditions and proves properties with Z3.

## Architecture

Rend bridges the gap between Ruby and formal verification:

1. **Parse**: Ruby source → Prism AST
2. **Translate**: AST → SMT-LIB verification conditions
3. **Prove**: SMT-LIB → Z3 solver → sat/unsat
4. **Report**: Verification results

## Key Design Decisions

- **SMT solving over term rewriting**: Uses real mathematical logic (Z3) instead of toy arithmetic evaluation
- **"Provable subset" over "arbitrary Ruby"**: Focuses on programs that can be formally verified, rather than claiming to handle all Ruby
- **Verification over proof assistance**: Proves specific programs are correct, rather than helping write mathematical proofs

## Usage

```ruby
require "rend"

# Prove a property
result = Rend.prove(
  source: "",
  property: "x + y == y + x"
)
puts result[:all_proved]  # true

# Verify multiple laws
laws = [
  Rend::Law.new("commutative", property: "x + y == y + x"),
  Rend::Law.new("associative", property: "(x + y) + z == x + (y + z)"),
  Rend::Law.new("distributive", property: "a * (b + c) == a * b + a * c")
]

result = Rend.verify(source: "", laws: laws)
puts result[:all_proved]  # true
```

## Supported Features

### Expressions
- Arithmetic: `+`, `-`, `*`
- Comparisons: `==`, `!=`, `<`, `>`, `<=`, `>=`
- Logical: `&&`, `||`, `!`
- Implication: `=>`
- Variables and integers

### SMT Logic
- QF_LIA (Quantifier-Free Linear Integer Arithmetic)
- Universal quantification via variable declaration

## Example Verification

```ruby
# Prove that adding non-negative numbers results in non-negative
Rend.prove(
  source: "",
  property: "a >= 0 && b >= 0 => a + b >= 0"
)
# => {:all_proved => true, ...}

# Prove distributive law
Rend.prove(
  source: "",
  property: "a * (b + c) == a * b + a * c"
)
# => {:all_proved => true, ...}
```

## Comparison to Original rend

| Aspect | Original rend | This implementation |
|--------|---------------|---------------------|
| Proof engine | Toy term rewriter | Z3 SMT solver |
| Logic | Trivial arithmetic | QF_LIA (linear integer arithmetic) |
| Expressiveness | `2 + 2 = 4` | Universal properties, distributivity, etc. |
| Formal basis | None | SMT-LIB standard |
| Scope | "Arbitrary Ruby" (claim) | Provable subset (honest) |

## Running Tests

```bash
# Install dependencies
gem install prism

# Install Z3 (or set Z3_PATH)
# Download from https://github.com/Z3Prover/z3/releases

# Run tests
export Z3_PATH=/path/to/z3
ruby test/verify_test.rb
```

## Limitations

- Only supports integer arithmetic (QF_LIA)
- No support for real numbers (QF_NRA)
- No support for arrays, strings, or complex data structures
- No support for function definitions and calls (future work)
- No support for quantifiers (forall/exists) in properties

## Future Work

- Add support for more SMT logics (QF_NRA, arrays)
- Add support for function verification
- Add counterexample generation
- Add support for more Ruby features (loops, conditionals)
