"
 Array stack Julia implementation  

 Ref: Open Data Structure book, chapter 2.1. 
"

using Test

mutable struct ArrayStack
    a::Array
    n::Int64

    ArrayStack() = new([], 0)
    ArrayStack(input::Array) = new(input, length(input))
end

function get(self::ArrayStack, i::Int64)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    return self.a[i]
end

function set(self::ArrayStack, i, x)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    y = self.a[i]
    self.a[i] = x

    return y
end

function size(self::ArrayStack)
    return self.n
end

function add(self::ArrayStack, i, x)

    if i < 0 || i > self.n +1
        error("Index overflow")
    end

    if self.n == length(self.a)
        _resize(self)
    end

    if self.n != 0
        self.a[i+1:self.n+1] = self.a[i:self.n]
    end
    self.a[i] = x
    self.n += 1
end

function remove(self::ArrayStack, i)

    if i < 0 || i > self.n +1
        error("Index overflow")
    end

    x = self.a[i]
    self.a[i:self.n-1] = self.a[i+1:self.n]
    # self.a[self.n] = ""
    self.n -= 1
    if length(self.a) >= 3*self.n
        _resize(self)
    end

    return x
end


function _resize(self::ArrayStack)
    b = similar(self.a, maximum([1, self.n*2])) 
    b[1:self.n] = self.a[1:self.n]
    self.a = b
end


function Print(self::ArrayStack)
    println(self.a,",n:",self.n)
end


function test()
    println(PROGRAM_FILE," start!!")

    arraystack = ArrayStack()

    add(arraystack, 1, 2.0)
    Print(arraystack)
    add(arraystack, 2, 4.0)
    Print(arraystack)
    set(arraystack, 2, 1.0)
    Print(arraystack)
    println(get(arraystack, 2))
    remove(arraystack, 1)
    Print(arraystack)

    for i in 1:10
        add(arraystack, 2, i)
    end
    Print(arraystack)
    for i in 1:8
        remove(arraystack, 3)
        Print(arraystack)
    end
    @test arraystack.n == 3

    println(PROGRAM_FILE," Done!!")
end

test()
