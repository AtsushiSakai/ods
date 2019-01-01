"
 Array stack implementation  

 Ref: Open Data Structure book, chapter 2.2. 
"

using Test

mutable struct ArrayStack
    a::Array
    n::Int64

    ArrayStack() = new([], 0)
end

function get(as::ArrayStack, i::Int64)

    if i < 0 || i > as.n
        error("Index overflow")
    end

    return as.a[i]
end

function set(as::ArrayStack, i, x)

    if i < 0 || i > as.n
        error("Index overflow")
    end

    y = as.a[i]
    as.a[i] = x

    return y
end

function add(as::ArrayStack, i, x)

    if i < 0 || i > as.n +1
        error("Index overflow")
    end

    if as.n == length(as.a)
        _resize(as)
    end

    as.a[i+1:as.n+1] = as.a[i:as.n]
    as.a[i] = x
    as.n += 1
end

function remove(as::ArrayStack, i)

    if i < 0 || i > as.n +1
        error("Index overflow")
    end

    x = as.a[i]
    as.a[i:as.n-1] = as.a[i+1:as.n]
    as.a[as.n] = NaN
    as.n -= 1
    if length(as.a) >= 3*as.n
        _resize(as)
    end

    return x
end


function _resize(as::ArrayStack)
    b = fill(NaN, maximum([1, as.n*2]))
    b[1:as.n] = as.a[1:as.n]
    as.a = b
end


function print(as::ArrayStack)
    println(as.a,",",as.n)
end


function test()
    println(PROGRAM_FILE," start!!")

    arraystack = ArrayStack()

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

    println(PROGRAM_FILE," Done!!")
end

test()
