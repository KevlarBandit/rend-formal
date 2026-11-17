Gem::Specification.new do |spec|
  spec.name = "rend"
  spec.version = "0.1.0"
  spec.authors = ["KevlarBandit"]
  spec.email = ["dev@rend-lang.org"]
  spec.summary = "Formal verification for Ruby programs using SMT solving"
  spec.description = "Translates Ruby programs to SMT verification conditions and proves properties with Z3. Defines a 'provable subset' of Ruby for static verification of invariants and laws."
  spec.homepage = "https://github.com/rend-lang/rend"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.2.0"
  spec.files = Dir["lib/**/*.rb", "README.md"]
  spec.require_paths = ["lib"]

  spec.add_dependency "prism", ">= 0.33.0"
end
