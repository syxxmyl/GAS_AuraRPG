--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_TestUnluaActor_C

local Screen = require('Screen')

local M = UnLua.Class()

function M:Initialize(Initializer)
    local msg = [[
        Test Unlua Actor Initialize!
    ]]

    print(msg)
    Screen.Print(self, msg)
end

function M:ReceiveBeginPlay()
    -- local msg = self:SayHi("tom")
    -- print(msg)
    -- Screen.Print(self, msg)
end

function M:ReceiveTick(DeltaSeconds)
    -- local msg = [[
    --     Test Unlua Actor ReceiveTick!
    -- ]]
    -- print(msg)
    -- Screen.Print(self, msg)
end

function M:SayHi(name)
    local msg = self.Overridden.SayHi(self, name)
    return msg .. "\n\n" .. [[
        Text from Unlua
    ]]
end

return M
