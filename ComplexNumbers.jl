module ComplexNumbers
  using FactCheck

  facts("Complex Numbers") do
    context("Complex Numbers") do
      @fact 2(1 - 1im) => 2 - 2im
    end

    context("abs(1 + 2im)") do
      @fact abs(1 + 2im) => 2.23606797749979
    end

    context("real(1 + 2im)") do
      @fact real(1 + 2im) => 1
    end

    context("complex()") do
      @fact complex(3,4) => 3 + 4im
      @fact abs(complex(3,4)) => 5
    end
  end
end
