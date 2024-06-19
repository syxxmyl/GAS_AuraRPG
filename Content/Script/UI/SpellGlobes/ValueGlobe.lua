--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_ValueGlobe_C
local M = UnLua.Class()

function M:WidgetControllerSet()
    self.OverlayWidgetController = self.WidgetController:Cast(UE.UOverlayWidgetController)
    self.OverlayWidgetController.OnPlayerLevelChangedDelegate:Add(self, self.OnReceivePlayerLevelChange)
end

function M:Destruct()
    self.OverlayWidgetController.OnPlayerLevelChangedDelegate:Remove(self, self.OnReceivePlayerLevelChange)

    self:Release()
end

function M:OnReceivePlayerLevelChange(newlevel, levelup)
    self.Text_Value:SetText(UE.UKismetTextLibrary.Conv_IntToText(newlevel))
end

return M
