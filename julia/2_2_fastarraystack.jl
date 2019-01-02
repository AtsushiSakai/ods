"
 Fast Array stack Julia implementation  

 Ref: Open Data Structure book, chapter 2.2. 
"

using Test

mutable struct FastArrayStack
    a::Array
    n::Int64

    FastArrayStack() = new([], 0)
end

function get(self::FastArrayStack, i::Int64)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    return self.a[i]
end

function set(self::FastArrayStack, i, x)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    y = self.a[i]
    self.a[i] = x

    return y
end

function add(self::FastArrayStack, i, x)

    if i < 0 || i > self.n +1
        error("Index overflow")
    end

    if self.n == length(self.a)
        _resize(self)
    end

    self.a[i+1:self.n+1] = self.a[i:self.n]
    self.a[i] = x
    self.n += 1
end

function remove(self::FastArrayStack, i)

    if i < 0 || i > self.n +1
        error("Index overflow")
    end

    x = self.a[i]
    self.a[i:self.n-1] = self.a[i+1:self.n]
    self.a[self.n] = NaN
    self.n -= 1
    if length(self.a) >= 3*self.n
        _resize(self)
    end

    return x
end


function _resize(self::FastArrayStack)
    b = fill(NaN, maximum([1, self.n*2]))
    b[1:self.n] = self.a[1:self.n]
    self.a = b
end


function print(self::FastArrayStack)
    println(self.a,",n:",self.n)
end


function test()
    println(PROGRAM_FILE," start!!")

    arraystack = FastArrayStack()

    add(arraystack, 1, 2.0)
    print(arraystack)
    add(arraystack, 2, 4.0)
    print(arraystack)
    set(arraystack, 2, 1.0)
    print(arraystack)
    println(get(arraystack, 2))
    remove(arraystack, 1)
    print(arraystack)

    for i in 1:10
        add(arraystack, 2, i)
    end
    print(arraystack)
    for i in 1:8
        remove(arraystack, 3)
        print(arraystack)
    end
    @test arraystack.n == 3

    println(PROGRAM_FILE," Done!!")
end

test()
