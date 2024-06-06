function print_array(array)
    local ret = {}
    for i = 1, array:Length() do
        table.insert(ret, array:Get(i))
    end
    print("[" .. table.concat(ret, ",") .. "]")
end

function print_set(set)
    local array = set:ToArray()
    local ret = {}
    for i = 1, array:Length() do
        table.insert(ret, array:Get(i))
    end
    print("(" .. table.concat(ret, ",") .. ")")
end

function print_map(map)
    local ret = {}
    local keys = map:Keys()

    for i = 1, keys:Length() do
        local key = keys:Get(i)
        local val = map:Find(key)
        table.insert(ret, key .. ":" .. tostring(val))
    end

    print("{" .. table.concat(ret, ",") .. "}")
end

