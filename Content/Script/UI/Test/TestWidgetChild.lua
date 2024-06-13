--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_TestWidgetChild_C
local Screen = require('Screen')
local M = UnLua.Class()

function M:Construct()
    Screen.Print(self, "TestWidgetChild Construct")

    self.Button_Remove.OnClicked:Add(self, self.OnRemoveButtonClicked)
end

function M:Setup(parent)
    self.parent = parent
end

function M:OnRemoveButtonClicked()
    self.parent:Remove()
end

function M:Destruct()
    Screen.Print(self, "TestWidgetChild Destruct")
    self.Button_Remove.OnClicked:Remove(self, self.OnRemoveButtonClicked)
    self:Release()
end

return M
