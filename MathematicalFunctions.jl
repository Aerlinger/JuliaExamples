module MathematicalFunctions
  using FactCheck

  facts("Mathematical Functions") do
    context("isequal considers NaNs to be equal") do
      @fact isequal(NaN, NaN) => true
    end

    context("comparisons can be chained") do
      @fact (1 < 2 <= 2 < 3 == 3 > 2 >= 1 == 1 < 3 != 5) => true
    end

    context("Division with remainder") do
      @fact divrem(23, 7) => (3, 2)
    end

    context("hypotenuse") do
      @fact hypot(3,4) => 5
    end


  end
end
