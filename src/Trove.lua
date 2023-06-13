-- Aka Maid implementation, but for for the needs of SOALIS

-- FIXME: Add check for same elements in Trove.troved (As Instances)

local Trove = {}
Trove.__type = 'Trove'
Trove.__newindex = function(self, index, value)
    if self.troved[index] then
        self:pop(self.troved[index])
    end

    self.troved[index] = value
end

Trove.__index = function(self, index)
    if Trove[index] then
        return Trove[index]
    end

    return self.troved[index]
end

type TroveInstance = Instance | {any} | RBXScriptConnection

function Trove:pop(trove_instance : TroveInstance)
    if typeof(trove_instance) == "Instance" then
        trove_instance:Destroy()
    elseif typeof(trove_instance) == "RBXScriptConnection" then
        trove_instance:Disconnect()
    elseif typeof(trove_instance) == "table" then
        if trove_instance['Destroy'] then
            trove_instance:Destroy()
        else
            error(("Table: \"%s\" haven't \"Destroy\" method!"):format(trove_instance), 2)
        end        
    else
        error("Unsupported type for Trove Instance!", 2)
    end
end

function Trove:put(trove_instance : TroveInstance)
    table.insert(self.troved, trove_instance)

    return trove_instance
end

function Trove:Destroy()
    for _, instance in ipairs(self.troved) do -- Iter by indexes
        self:pop(instance)
    end

    for _, instance in pairs(self.troved) do -- Iter by keys
        self:pop(instance)
    end

    self.troved = {}
end

function Trove.new(trove_instance : TroveInstance | nil)
    local self = setmetatable({
        troved = {}
    }, Trove)

    if trove_instance then
        self:put(trove_instance)
    end

    return self
end

return Trove