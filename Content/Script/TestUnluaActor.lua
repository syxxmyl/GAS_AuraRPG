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
    Screen.Print(msg)
end

function M:ReceiveBeginPlay()
    local msg = [[
        Test Unlua Actor BeginPlay!
    ]]

    print(msg)
    Screen.Print(msg)
end

function M:ReceiveTick(DeltaSeconds)
    local msg = [[
        Test Unlua Actor ReceiveTick!
    ]]
    print(msg)
    Screen.Print(msg)
end

return M
