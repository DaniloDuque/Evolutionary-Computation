function sign(x::Number)::Number return real(x) < 0 ? -1 : 1 end

function sum(u::Number, v::Number)::Number return real(u + v) end

function subs(u::Number, v::Number)::Number return real(u - v) end

function prod(u::Number, v::Number)::Number return real(u * v) end

function div(u::Number, v::Number)::Number return v == 0 ? Inf * sign(u) : real(u / v) end 

function lg(u::Number, v::Number) return real(log(Complex(u), v)) end

function pow(u::Number, v::Number) return real(Complex(u) ^ float(v))end
