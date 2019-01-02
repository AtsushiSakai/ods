"
 Dual array deque Julia implementation  

 Ref: Open Data Structure book, chapter 2.5. 
"

include("./2_1_arraystack.jl")

mutable struct DualArrayDeque
    front::ArrayStack
    back::ArrayStack

    DualArrayDeque() = new(ArrayStack(), ArrayStack())
    DualArrayDeque(input::Array) = new(ArrayStack(input[round(Int64,length(input)/2):-1:1]),
                                       ArrayStack(input[round(Int64,length(input)/2)+1:end]))
end

function get(self::DualArrayDeque, i::Int64)

    if i < 0 || i > size(self)
        error("Index overflow")
    end

    fsize = size(self.front)+1

    if i < fsize 
        return get(self.front, fsize - i) 
    else
        return get(self.back, i - fsize +1)
    end

end


function set(self::DualArrayDeque, i::Int64, x)

    if i < 0 || i > size(self)
        error("Index overflow")
    end

    fsize = size(self.front)+1

    if i < fsize 
        return set(self.front, fsize - i, x) 
    else
        return set(self.back, i - fsize +1, x)
    end
end


function size(self::DualArrayDeque)
    return size(self.front)+size(self.back)
end



function add(self::DualArrayDeque, i::Int64, x)

    if i<size(self.front)
        add(self.front, size(self.front)-i, x)
    else
        add(self.back, i-size(self.front), x)
    end

    _balance(self)
end


function remove(self::DualArrayDeque, i)

    x = self.front.a[1]

    fsize = size(self.front)+1

    if i < fsize
        x = remove(self.front, fsize-i)
    else
        x = remove(self.back, i-fsize)
    end

    _balance(self)

    return x
end

function _balance(self)
    n = size(self)
    mid = round(Int64, n/2)
    if 3*size(self.front) < size(self.back) ||
        3*size(self.back) < size(self.front)

        f = ArrayStack()
        for i in 1:mid
            add(f, i, get(self, mid-i+1))
        end
        b = ArrayStack()
        for i in 1:n-mid
            add(b, i, get(self,mid+i)) 
        end
        self.front = f
        self.back = b
    end
end


function Print(self::DualArrayDeque)
    println(self.front,",",self.back)
    for i in 1:size(self)
        print(get(self, i))
    end
    println("")
end


function test()
    println(PROGRAM_FILE," start!!")

    dualarraydeque = DualArrayDeque(["a","b","c","d"])
    Print(dualarraydeque)
    add(dualarraydeque, 3, "x")
    Print(dualarraydeque)
    add(dualarraydeque, 4, "y")
    Print(dualarraydeque)
    remove(dualarraydeque, 1)
    Print(dualarraydeque)
    set(dualarraydeque, 3, "m")
    Print(dualarraydeque)

    println(PROGRAM_FILE," Done!!")
end

test()
