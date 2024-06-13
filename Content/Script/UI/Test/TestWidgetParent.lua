--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_TestWidgetParent_C
local Screen = require('Screen')
local M = UnLua.Class()

function M:Construct()
    Screen.Print(self, "TestWidgetParent Construct")
    self.WBP_TestWidgetChild:Setup(self)
end

function M:Remove()
    self:RemoveFromParent()
end

function M:Destruct()
    Screen.Print(self, "TestWidgetParent Destruct")
    self:Release()
end

return M
