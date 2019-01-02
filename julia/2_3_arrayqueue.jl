"
 Array queue Julia implementation  

 Ref: Open Data Structure book, chapter 2.3. 
"

using Test

mutable struct ArrayQueue
    a::Array
    j::Int64
    n::Int64

    ArrayQueue() = new([], 0, 0)
end

function get(self::ArrayQueue, i::Int64)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    return self.a[i]
end

function add(self::ArrayQueue, x)

    if self.n+1 > length(self.a)
        _resize(self)
    end

    self.a[((self.j+self.n)%length(self.a))+1] = x
    self.n += 1
    return true
end

function remove(self::ArrayQueue)

    if self.n == 0
        error("Index Error")
    end

    x = self.a[self.j+1]
    self.j = (self.j + 1) % length(self.a)

    self.n -= 1
    if length(self.a) >= 3*self.n
        _resize(self)
    end

    return x
end

function _resize(self::ArrayQueue)
    b = fill(NaN, maximum([1, self.n*2]))
    for k in 1:self.n
        b[k] = self.a[((self.j+k-1) % length(self.a))+1]
    end
    self.a = b
    self.j = 0
end

function print(self::ArrayQueue)
    println(self.a,",j:",self.j,",n:",self.n,)
end


function test()
    println(PROGRAM_FILE," start!!")

    arrayqueue = ArrayQueue()

    for i in 1:5
        add(arrayqueue, i)
        print(arrayqueue)
    end
    @test get(arrayqueue,3) == 3.0
    for i in 1:5
        y = remove(arrayqueue)
        println(y)
        print(arrayqueue)
    end

    println(PROGRAM_FILE," Done!!")
end

test()
