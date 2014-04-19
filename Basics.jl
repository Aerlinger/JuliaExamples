module TestBasicAssertions

using FactCheck

facts("Variables") do

  context("type") do
    @fact typeof(1) => Int64
  end

  context("has internal variable WORD_SIZE") do
    @fact WORD_SIZE => 64
  end

  context("Getting type of a large integer") do
    @fact typeof(300000000000000) => Int64
  end

  context("HEX digits") do
    @fact 0x01 => 0x1
  end

  context("Sets type for 32 bit HEX") do
    @fact typeof(0x1234567) => Uint32
  end

  context("Sets type for 64 bit HEX") do
    @fact typeof(0x123456789abcdef) => Uint64
  end

  context("typemax") do
    x = 9223372036854775807
    @fact typemax(Int64) => x

    x = x + 1
    @fact x => -9223372036854775808
  end

  context("typemin") do
    @fact typemin(Int64) => -9223372036854775808
  end

  context("different representations for Float64 types") do
    @fact 1.0 => 1.0
    @fact 1. => 1.0
    @fact .5 => .5
    @fact 1e10 => 10000000000
    @fact 2.5e-4 => .00025
  end

  context("different representations for Float32 types") do
    @fact float32(1.5) => 1.5
  end

  context("HEX floats") do
    @fact 0x1.8p3 => 12.0
  end

  context("sizeof") do
    @fact sizeof(Char) => 4
    @fact sizeof(Uint8) => 1
    @fact sizeof(Bool) => 1
    @fact sizeof(Uint16) => 2
  end

  context("bits") do
    @fact bits(0.0) => "0000000000000000000000000000000000000000000000000000000000000000"
  end

  context("bits") do
    @fact bits(-0.0) => "1000000000000000000000000000000000000000000000000000000000000000"
  end

  context("typemin and typemax") do
    @fact typemin(Float16) => -Inf16
  end

  context("test for infinity") do
    @fact isinf(typemin(Float16)) => true
  end

  context("test for NaN") do
    @fact isnan(0 * Inf) => true
  end

  context("Machine epsilon") do
    @fact eps(Float32) => 1.1920929f-7
  end

  context("Machine epsilon") do
    @fact eps() => 2.220446049250313e-16
  end

  context("The distance between floating points is not constant") do
    @fact eps(0.0) => 5.0e-324
  end

  context("One of type float") do
    @fact zero(Float32) => 0.0f0
  end
end

end
