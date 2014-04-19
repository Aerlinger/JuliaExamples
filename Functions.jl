module Functions
  using FactCheck

  facts("functions") do
    function f(x, y)
      x + y
    end

    context("a simple function") do
      @fact f(4,5) => 9
    end

    context("apply") do
      @fact apply(f, 2, 3) => 5
    end

    context("operators are functions") do
      @fact +(1, 2, 3) => 6
    end

    context("anonymous function") do
      @fact (x -> x^2 + 2x - 1)(2) => 7
    end

    context("map") do
      @fact map(round, [1.2, 3.5, 1.7]) => [1.0, 4.0, 2.0]
    end

    context("multiple return values") do
      function flip(a, b)
        (-a, -b)
      end

      @fact flip(1,5) => (-1, -5)
    end

    context("varargs without ...") do
      function rev(a, b, x...)
        (a, b, x)
      end

      @fact rev(1, 2, 3, 4, 5) => (1, 2, (3, 4, 5))
    end

    context("optional arguments") do
      function opt(a, b, f="optional", x...)
        (a, b, f, (x))
      end

      @fact opt(1, 2, "HELLO", 4, 5) => (1, 2, "HELLO", (4, 5))
    end

    context("Evaluation of scope") do
      function f(x, a=b, b=1)
        [x, a, b]
      end

      @fact f(1, 2) => [1, 2, 1]
      @fact_throws f(1)
    end

    context("Block evaluation") do

      @fact map([45, -2, 0, 17]) do x
            if x < 0 && iseven(x)
                return 0
            elseif x == 0
                return 1
            else
                return x
            end
        end => [45, 0, 1, 17]

    end
  end
end
