require_relative "../lib/rend"

puts "=" * 60
puts "Rend: Ruby Formal Verification Test Suite"
puts "=" * 60

# Test 1: Simple arithmetic law
puts "\n--- Test 1: Addition is commutative ---"
result = Rend.prove(source: "", property: "x + y == y + x")
puts result[:results][0][:status] == :proved ? "✓ PASSED" : "✗ FAILED"

# Test 2: Multiplication identity
puts "\n--- Test 2: Multiplication by 1 ---"
result = Rend.prove(source: "", property: "x * 1 == x")
puts result[:results][0][:status] == :proved ? "✓ PASSED" : "✗ FAILED"

# Test 3: Distributive law
puts "\n--- Test 3: Distributive law ---"
result = Rend.prove(source: "", property: "a * (b + c) == a * b + a * c")
puts result[:results][0][:status] == :proved ? "✓ PASSED" : "✗ FAILED"

# Test 4: Non-negative after addition
puts "\n--- Test 4: Non-negative after addition ---"
result = Rend.prove(source: "", property: "a >= 0 && b >= 0 => a + b >= 0")
puts result[:results][0][:status] == :proved ? "✓ PASSED" : "✗ FAILED"

puts "\n" + "=" * 60
puts "Test suite complete"
puts "=" * 60
