module ControlFlow
  using FactCheck

  facts("Conrol Flow") do
    context("block") do
      @fact begin
        x = 1
        y = 2
        x + y
      end => 3
    end

    context("input to if must be boolean") do
      @fact_throws if 1; println("true"); end
    end

    context("Short circuit evaluation") do
      @fact false || true => true
      @fact false || "right" => "right"
      @fact true || "right" => true

      @fact true && "pizza" => "pizza"
    end

    facts("errors") do
      context("Exception") do
        @fact_throws throw(Exception)
      end

      context("ArgumentError") do
        @fact_throws throw(ArgumentError)
      end

      context("BoundsError") do
        @fact_throws throw(BoundsError)
      end

      context("DivideError") do
        @fact_throws throw(DivideError)
      end

      context("DomainError") do
        @fact_throws throw(DomainError)
      end

      context("EOFError") do
        @fact_throws throw(EOFError)
      end

      context("ErrorException") do
        @fact_throws throw(ErrorException)
      end

      context("InexactError") do
        @fact_throws throw(InexactError)
      end

      context("InterruptException") do
        @fact_throws throw(InterruptException)
      end

      context("KeyError") do
        @fact_throws throw(KeyError)
      end

      context("LoadError") do
        @fact_throws throw(LoadError)
      end

      context("MemoryError") do
        @fact_throws throw(MemoryError)
      end

      context("MethodError") do
        @fact_throws throw(MethodError)
      end

      context("OverflowError") do
        @fact_throws throw(OverflowError)
      end

      context("ParseError") do
        @fact_throws throw(ParseError)
      end

      context("SystemError") do
        @fact_throws throw(SystemError)
      end

      context("TypeError") do
        @fact_throws throw(TypeError)
      end

      context("UndefRefError") do
        @fact_throws throw(UndefRefError)
      end
    end

    facts("Task") do
      # Produces 6 times
      function producer()
        produce("start")

        for n=1:4
          produce(2n)
        end

        produce("stop")
      end

      context("Producer") do
        p = Task(producer)

        @fact consume(p) => "start"
        @fact consume(p) => 1*2
        @fact consume(p) => 2*2
        @fact consume(p) => 3*2
        @fact consume(p) => 4*2
        @fact consume(p) => "stop"
      end

      context("looking via a Task") do
        @fact map(Task(producer)) do p
          p
        end => ["start", 1*2, 2*2, 3*2, 4*2, "stop"]
      end
    end
  end
end
