--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_HealthGlobe_C
local M = UnLua.Class("UI.ProgressBar.GlobeProgressBar")

function M:Construct()
    self.Health = 0
    self.MaxHealth = 0
end

function M:WidgetControllerSet()
    self.OverlayWidgetController = self.WidgetController:Cast(UE.UOverlayWidgetController)
    self.OverlayWidgetController.OnHealthChanged:Add(self, self.OnReceiveHealthChanged)
    self.OverlayWidgetController.OnMaxHealthChanged:Add(self, self.OnReceiveMaxHealthChanged)
end

function M:Destruct()
    self.OverlayWidgetController.OnHealthChanged:Remove(self, self.OnReceiveHealthChanged)
    self.OverlayWidgetController.OnMaxHealthChanged:Remove(self, self.OnReceiveMaxHealthChanged)

    self:Release()
end

function M:Tick(MyGeometry, InDeltaTime)
    self.Super.Tick(self, MyGeometry, InDeltaTime)
end

function M:OnReceiveHealthChanged(health)
    self.Health = health
    self.SetProgressBarPercent(self, UE.UKismetMathLibrary.SafeDivide(self.Health, self.MaxHealth))
    self:UpdateTextValue()
end

function M:OnReceiveMaxHealthChanged(maxhealth)
    self.MaxHealth = maxhealth
    self.SetProgressBarPercent(self, UE.UKismetMathLibrary.SafeDivide(self.Health, self.MaxHealth))
    self:UpdateTextValue()
end

function M:UpdateTextValue()
    local text = UE.UKismetTextLibrary.Conv_DoubleToText(self.Health) .. "/" .. UE.UKismetTextLibrary.Conv_DoubleToText(self.MaxHealth)
    self.Text_Value:SetText(UE.UKismetTextLibrary.Conv_StringToText(text))
end

return M
