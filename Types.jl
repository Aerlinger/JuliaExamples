module Types
  using FactCheck

  ###############################
  # Simple bit types
  ###############################
  bitstype 16 WtfLol16 <: FloatingPoint
  bitstype 32 Omfg{T}


  ###############################
  # Basic types
  ###############################

  type Foo
    bar
    baz::Int
    qux::Float64
   end

  type NoFields
  end


  ###############################
  # Immutable types
  ###############################
  immutable PseudoComplex
    real::Float64
    imag::Float64
  end


  ###############################
  # Parametric types
  ###############################
  abstract Pointy{T}
  abstract RPointy{T<:Real}

  type Point{T} <: Pointy{T}
    x::T
    y::T
  end

  type DiagPoint{T} <: Pointy{T}
    x::T
  end

  type RPoint{T<:Real} <: Pointy{T}
    x::T
    y::T
  end



  # Actual Julia implementation of the Rational type (renamed to prevent override)
  immutable RealRational{T<:Integer} <: Real
    num::T
    den::T
  end


  facts("Types") do
    context("Description") do
      "
        - No concept of compile-time type
        - No division between object and non-object values
        - Only variables, not values have type.
      "
    end

    context("Type Assertion (::) operator") do
      context("Throws an error when type assertion is invalid") do
        @fact_throws (1+2)::FloatingPoint
      end

      context("Sum") do
        @fact (1+2)::Int => 3
      end

      context("Function return value has a type") do
        function foo()
          x::Int8 = 1000
          x
        end

        @fact foo() => -24
        @fact typeof(foo()) => Int8
      end
    end

    context("Inheritance for number types") do
      #abstract Number
      #abstract Real     <: Number
      #abstract FloatingPoint <: Real
      #abstract Integer  <: Real
      #abstract Signed   <: Integer
      #abstract Unsigned <: Integer

      @fact Integer <: Number => true
      @fact Integer <: FloatingPoint => false

      @fact Array{Float64,1} <: Array{Float64} <: Array => true
    end

    context("Custom types can be declared for bit types") do
      @fact WtfLol16 <: FloatingPoint => true
    end

    context("Composite types (similar to structs in C)") do
      foo = Foo("Hello, world.", 23, 1.5)

      context("Has a type of Foo") do
        @fact typeof(foo) => Foo
      end

      context("Has correct attributes") do
        @fact foo.bar => "Hello, world."
        @fact foo.baz => 23
        @fact foo.qux => 1.5
      end

      context("Can change value of an attribute") do
        foo.qux = 33
        @fact foo.qux => 33
      end

      context("Throws an error when converting to an invalid type") do
        @fact_throws foo.qux = "asdf"
      end

      context("Doesn't throw an error when converting a non-declared type") do
        foo.bar = 2.5
        @fact foo.bar => 2.5
      end
    end

    context("A type with no fields") do
      is(NoFields(), NoFields())
    end

    context("Immutable Composite types") do
      pc = PseudoComplex(1.0, -1.0)

      @fact pc.real => 1.0
      @fact pc.imag => -1.0
      @fact_throws pc.real += 1
    end

    context("Declared Types") do
      explanation = "A data type can be abstract or concrete"

      @fact typeof(Real) => DataType
      @fact typeof(Int) => DataType
      @fact typeof(typeof(1)) => DataType
      @fact typeof(Point{Float64}) => DataType
    end

    context("Tuples and their types") do
      @fact typeof((1, "foo", 2.5)) => (Int64, ASCIIString, Float64)
    end

    context("Tuples are their own types") do
      @fact typeof(()) => ()
    end

    context("Type assertion on Tuples") do
      @fact (1,"foo",2.5) :: (Int64, String, Any) => (1,"foo",2.5)
    end

    context("Throws an error when coercing to an invalid type") do
      @fact_throws (1, "foo", 2.5) :: (Int64, String, 3)
    end

    context("Tuple comparison for subtypes") do
      @fact (Int, String) <: (Real, Any) => true
      @fact (Int, String) <: (Real, Real) => false
      @fact (Int,String) <: (Real,) => false
    end

    context("Type Unions") do
      IntOrString = Union(Int, String)

      @fact 1 :: IntOrString => 1
      @fact "Hello!" :: IntOrString => "Hello!"
      @fact_throws 1.0 :: IntOrString

      @fact Union() => None
    end

    context("parametric types") do
      p = Point{Float64}(5.0, 1.3)

      @fact p.x => 5.0
      @fact p.y => 1.3
    end

    context("parametric type inheritance") do
      @fact (Point{Float64} <: Point) => true
      @fact (Point{String} <: Point) => true

      @fact Float64 <: Number => true
      @fact (Point{Float64} <: Point{Number}) => false
    end

    context("Parameteric abstract types declare a collection of abstract types") do
      @fact Pointy{Int64} <: Pointy => true
      @fact Pointy{1} <: Pointy => true
    end

    context("Declaring an abstract type") do
      @fact Point{Float64} <: Pointy{Float64} => true
      @fact Point{Real} <: Pointy{Real} => true
    end

    context("Inheritance is invariant") do
      @fact Point{Float64} <: Pointy{Real} => false
    end

    # For each type, T, the 'singleton type' Type{T} is an abstract type whose only instance is the object T
    context("isa(A, Type{B}) is only true if A and B are the same object and that object is a type") do
      @fact isa(Type{Float64}, Type) => true
      @fact isa(Real, Type{Float64}) => false
      @fact isa(Real, Type{Real}) => true
      @fact isa(Float64, Type{Real}) => false
    end

    context("Without a parameter Type is simple an avstract type which has all type objects as its instances") do
      @fact isa(Type{Float64}, Type) => true
      @fact isa(Float64, Type) => true
      @fact isa(Real, Type) => true
    end

    context("Any object that is not a type is not an instance of Type") do
      @fact isa(1, Type) => false
      @fact isa("foo", Type) => false
    end

    context("Aliases") do
      @fact Uint => Uint64
    end

    context("Types are themselves objects") do
      @fact typeof(Rational) => DataType
      @fact typeof(Union(Real, Rational, Float64)) => DataType
      @fact typeof(None) => UnionType
    end

    context("Using 'super' to reference supertype") do
      @fact super(Float64) => FloatingPoint
      @fact super(super(Float64)) => Real
      @fact super(Real) => Number
      @fact super(Number) => Any
      @fact super(String) => Any
      @fact super(Any) => Any
    end

    context("Calling super on a non-type raises an error") do
      @fact_throws super(Union(Float64,Int64))
      @fact_throws super(None)
      @fact_throws super((Float64, Int64))
      @fact_throws super(())
    end
  end
end
