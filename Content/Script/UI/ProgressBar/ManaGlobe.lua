--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_ManaGlobe_C
local M = UnLua.Class("UI.ProgressBar.GlobeProgressBar")

function M:Construct()
    self.Mana = 0
    self.MaxMana = 0
end

function M:WidgetControllerSet()
    self.OverlayWidgetController = self.WidgetController:Cast(UE.UOverlayWidgetController)
    self.OverlayWidgetController.OnManaChanged:Add(self, self.OnReceiveManaChanged)
    self.OverlayWidgetController.OnMaxManaChanged:Add(self, self.OnReceiveMaxManaChanged)
end

function M:Destruct()
    self.OverlayWidgetController.OnManaChanged:Remove(self, self.OnReceiveManaChanged)
    self.OverlayWidgetController.OnMaxManaChanged:Remove(self, self.OnReceiveMaxManaChanged)

    self:Release()
end

function M:Tick(MyGeometry, InDeltaTime)
    self.Super.Tick(self, MyGeometry, InDeltaTime)
end

function M:OnReceiveManaChanged(Mana)
    self.Mana = Mana
    self.SetProgressBarPercent(self, UE.UKismetMathLibrary.SafeDivide(self.Mana, self.MaxMana))
    self:UpdateTextValue()
end

function M:OnReceiveMaxManaChanged(maxMana)
    self.MaxMana = maxMana
    self.SetProgressBarPercent(self, UE.UKismetMathLibrary.SafeDivide(self.Mana, self.MaxMana))
    self:UpdateTextValue()
end

function M:UpdateTextValue()
    local text = UE.UKismetTextLibrary.Conv_DoubleToText(self.Mana) .. "/" .. UE.UKismetTextLibrary.Conv_DoubleToText(self.MaxMana)
    self.Text_Value:SetText(UE.UKismetTextLibrary.Conv_StringToText(text))
end

return M
