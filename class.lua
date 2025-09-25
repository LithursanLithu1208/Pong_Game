

local function include_helper(to, from, seen)
    if from == nil then
        return to
    elseif type(from) ~= 'table' then
        return from
    end

    seen = seen or {}
    if seen[from] then
        return seen[from]
    end
    seen[from] = to

    for k, v in pairs(from) do
        if type(k) == 'string' and k:sub(1,2) == '__' then
            to[k] = v
        elseif to[k] == nil then
            if type(v) == 'table' then
                to[k] = include_helper({}, v, seen)
            else
                to[k] = v
            end
        end
    end
    return to
end

local function Class(base)
    local c = {}
    if type(base) == 'table' then
        include_helper(c, base)
        c._base = base
    end
    c.__index = c
    setmetatable(c, {
        __call = function(class_tbl, ...)
            local obj = {}
            setmetatable(obj, c)
            if class_tbl.init then
                class_tbl.init(obj, ...)
            end
            return obj
        end
    })
    return c
end

return Class
