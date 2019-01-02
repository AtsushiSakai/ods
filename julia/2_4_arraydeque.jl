"
 Array deque Julia implementation  

 Ref: Open Data Structure book, chapter 2.4. 
"

using Test

const NAN = ""

mutable struct ArrayDeque
    a::Array
    j::Int64
    n::Int64

    ArrayDeque() = new([], 1, 0)
    ArrayDeque(input::Array) = new(input, 1, length(input))
end

function get(self::ArrayDeque, i::Int64)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    return self.a[i]
end

function set(self::ArrayDeque, i::Int64, x)

    if i < 0 || i > self.n
        error("Index overflow")
    end

    y = self.a[abs((i + self.j) % length(self.a))]
    self.a[abs((i + self.j) % length(self.a))] = x

    return self.a[i]
end


function add(self::ArrayDeque, i::Int64, x)

    if i < 1 || i > self.n
        error("Index overflow")
    end

    if self.n == length(self.a)
        _resize(self)
    end

    if i-1 < self.n/2.0
        for k in 0:self.n-i
            self.a[calc_rolling_ind(self, self.n-k)] = self.a[calc_rolling_ind(self, self.n-k-1)]
        end
    else
        for k in self.n-1:-1:i-2
            self.a[calc_rolling_ind(self, self.j+k)] = self.a[calc_rolling_ind(self, self.j+k-1)]
        end
    end
    self.a[calc_rolling_ind(self, self.j+i-2)] = x
    self.n += 1
end

function calc_rolling_ind(self, i)
    return abs(i%length(self.a))+1
end

function remove(self::ArrayDeque, i)

    if i < 0 || i > self.n
        error("Index Error")
    end

    x = self.a[calc_rolling_ind(self, self.j+i-2)]
    if i < self.n/2
        for k in i-2:-1:0
            self.a[calc_rolling_ind(self, self.j+k)] = self.a[calc_rolling_ind(self, self.j+k-1)]
        end
        self.a[calc_rolling_ind(self, self.j-1)] = ""
        self.j = calc_rolling_ind(self, self.j)
    else
        for k in i-2:self.n-2 
            self.a[calc_rolling_ind(self, self.j+k)] = self.a[calc_rolling_ind(self, self.j+k+1)]
        end
    end

    self.n -= 1
    if length(self.a) >= 3*self.n
        _resize(self)
    end

    return x
end

function _resize(self::ArrayDeque)
    b = fill(NAN, maximum([1, self.n*2]))
    if length(self.a)>=1
        for k in 0:self.n-1
            b[k+1] = self.a[abs((self.j+k-1) % length(self.a))+1]
        end
    end
    self.a = b
    self.j = 1
end

function print(self::ArrayDeque)
    println(self.a,",j:",self.j,",n:",self.n,)
end


function test()
    println(PROGRAM_FILE," start!!")

    arraydeque = ArrayDeque(["a","b","c","d","e","f","g","h"])
    remove(arraydeque,3)
    print(arraydeque)
    add(arraydeque,5,"x")
    print(arraydeque)
    add(arraydeque,4,"y")
    print(arraydeque)
    add(arraydeque,5,"z")
    print(arraydeque)

    println(PROGRAM_FILE," Done!!")
end

test()
