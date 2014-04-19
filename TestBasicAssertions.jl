module TestBasicAssertions

using FactCheck

facts("Variables") do
  context("creating a variable") do
    ix = 1.0
    @fact ix => 1.0
  end

  context("UTF encoding") do
    UniversalDeclarationOfHumanRightsStart = "人人生而自由，在尊严和权力上一律平等。"

    @fact UniversalDeclarationOfHumanRightsStart => "人人生而自由，在尊严和权力上一律平等。"
  end

  context("UTF encoded variable names") do
    δ = 0.00001

    @fact δ => 0.00001
  end

  context("Can't set predefined names") do
    @fact_throws else = false
  end

  context("Conventions") do
    @fact "Names of variables are in lower case."
    @fact "Word separation can be indicated by underscores"
    @fact "Names of Types begin with a capital letter and word separation is shown with CamelCase instead of underscores"
    @fact "Names of functions and macros are lowercase without underscores"
    @fact "Functions that modify their inputs end in `!`. (Mutating or in-place functions)"
  end

  exitstatus()
end

end
