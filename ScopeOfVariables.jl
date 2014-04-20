module ScopeOfVariables
  using FactCheck

  facts("Scope of Variables") do
    context("7 types of Scope blocks") do
      context("Function bodies") do
        x = 1

        function outer_function(x)
          parent_scope = "parent scope"
          function inner_function(x)
            parent_scope
          end
        end
      end

      context("While loops") do
        i = 1
        while i <= 2
          i += 1
          x = i + 1
        end

        @fact_throws x == 3
      end

      context("For loops") do
      end

      context("Try blocks") do
      end

      context("Catch blocks") do
      end

      context("let blocks") do
      end

      context("Type blocks") do
      end

      context("Begin blocks do not introduce a new scope") do
        begin
          x = 5
        end

        @fact x => 5
      end
    end

    context("A declaration of local x or context x introduces a new variable") do
    end

    context("A declaration global x makes x in the current scope and inner scopes refer to the global variable of that name") do
    end

    context("A functions variables are introduced as new local variables into the function body's scope") do
    end

    context("An assignment x = y introduces a new local variable x only if x is neither declared global nor explicitly introduces as local by any enclosing scope before or after the current line of code") do
    end

    context("Local variable in a function") do
      function foo(n)
        x = 0
        for i = 1:n
          x = x + 1
        end
        x
      end

      @fact foo(10) => 10
    end

    context("An outer assignment of x need not come before an inner usage") do
      function foo(n)
        f = y -> n + x    # x is used in function definition before it's declared
        x = 1
        f(2)
      end

      @fact foo(2) => 3
    end

    context("testing if integers are even or odd") do
      even(n) = n == 0 ? true  :  odd(n-1)
      odd(n)  = n == 0 ? false : even(n-1)

      @fact even(3) => false
      @fact odd(3) => true
    end

    context("let statements allocate new variable bindings every time that they run") do
      var1 = "var1_outer_value"
      var2 = "var2_outer_value"
      var3 = "var3_outer_value"

      let var1 = 1, var2 = "var2", var3 = 3.0, var4 = "var4 declaration"
          @fact var1 => 1
          @fact var2 => "var2"
          @fact var3 => 3.0
      end

      @fact var1 => "var1_outer_value"
      @fact var2 => "var2_outer_value"
      @fact var3 => "var3_outer_value"
      @fact_throws var4 == "var4 declaration"
    end

    context("let() creates a new binding") do
      Fs = cell(2)
      i = 1
      while i <= 2
        Fs[i] = ()->i
        i += 1
      end

      @fact Fs[1]() => 3
      @fact Fs[2]() => 3


      Fs = cell(2)
      i = 1
      while i <= 2
        let i = i
          Fs[i] = ()->i
        end
        i += 1
      end

      @fact Fs[1]() => 1
      @fact Fs[2]() => 2
    end

    context("Creating the same variable locally twice throws an error") do
      begin
        local m = 1
        begin
          let
            local m = 2
            @fact m => 2
          end
        end

        @fact m => 1
      end
    end

    context("For loops freshly allocate iteration variables on each iteration") do
      Fs = cell(2)

      for i=1:2
          Fs[i] = () -> i
      end

      @fact Fs[1]() => 1
      @fact Fs[2]() => 2
    end

    context("for loops reuse variables on each iteration") do
      i = 0
      for i = 1:3
      end

      @fact i => 3
    end

    context("But list comprehensions always allocate their iteration variables") do
      x = 0
      y = [x for x=1:3]

      @fact x => 0
      @fact y => [1, 2, 3]
    end

    context("constant variables are more performant") do
      @fact e => 2.71828182845904523536
      @fact pi => 3.14159265358979323846
    end
  end
end
