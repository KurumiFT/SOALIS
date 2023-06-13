-- Implementation of famous Signal, but for needs SOALIS :)
-- (It's just a wrapper for bindable event)

local Trove = require(script.Parent.Trove)

local Event = {}
Event.__type = 'Event'
Event.__index = Event

function Event.new()
   local self = { trove = Trove.new() }
   self.trove['event'] = Instance.new('BindableEvent')

   return setmetatable(self, Event)
end

function Event:Connect(handler: (...any) -> nil)
    if not self.trove['event'] then
        error("You cannot make connection to destroyed event!", 2)
    end

    local connection = self.trove['event'].Event:Connect(function(proceed : boolean, ... : any) -- Put into wrapper
        if proceed then
            handler(...)
        end
    end)

    self.trove:put(connection)
end

function Event:Wait()
    if not self.trove['event'] then
        error("You cannot wait destroyed event!", 2)
    end

    local result = table.pack(self.trove['event'].Event:Wait())

    if result[1] == false then
        error("Event was destroyed while waiting!", 2)
    end 

    return unpack(result, 2)
end

function Event:Destroy()
    if not self.trove['event'] then error('Event already destroyed!', 2) end

    self.trove['event']:Fire(false)
    self.trove:Destroy()
end

function Event:Fire(... : any)
    if not self.trove['event'] then error('You try to fire destroyed event!', 2) end
    
    self.trove['event']:Fire(true, ...)
end

return Event