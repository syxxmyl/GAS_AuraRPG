--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_AreYouSure_C
local M = UnLua.Class()

function M:Construct()
    self.Button_Cancel.Button.OnClicked:Add(self, self.OnCancelButtonClicked)
    self.Button_Delete.Button.OnClicked:Add(self, self.OnDeleteButtonClicked)
end

function M:Destruct()    
    self.Button_Cancel.Button.OnClicked:Remove(self, self.OnCancelButtonClicked)
    self.Button_Delete.Button.OnClicked:Remove(self, self.OnDeleteButtonClicked)

    self.CancelButtonClicked:Clear()
    self.DeleteButtonClicked:Clear()

    self:Release()
end

function M:OnCancelButtonClicked()
    self.CancelButtonClicked:Broadcast()
    self:RemoveFromParent()
end

function M:OnDeleteButtonClicked()
    self.DeleteButtonClicked:Broadcast()
    self:RemoveFromParent()
end

function M:CenteredXPosition()
    local Position = UE.UWidgetLayoutLibrary.GetViewportSize(self)
    return Position.X / 2 - self.SizeBox_Root.WidthOverride / 2
end

return M
