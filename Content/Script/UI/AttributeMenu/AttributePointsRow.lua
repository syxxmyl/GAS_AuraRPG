--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_AttributePointsRow_C
local M = UnLua.Class()

function M:WidgetControllerSet()
    self.AttributeMenuWidgetController = self.WidgetController:Cast(UE.UAttributeMenuWidgetController)
    self.AttributeMenuWidgetController.OnAttributePointsChangedDelegate:Add(self, self.OnAttributePointsChanged)
end

function M:Destruct()
    self.AttributeMenuWidgetController.OnAttributePointsChangedDelegate:Remove(self, self.OnAttributePointsChanged)
end

function M:OnAttributePointsChanged(value)
    self.WBP_FramedValue.TextBlock_Value:SetText(UE.UKismetTextLibrary.Conv_IntToText(value))
end

return M
