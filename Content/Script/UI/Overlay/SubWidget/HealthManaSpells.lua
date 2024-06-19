--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_HealthManaSpells_C
local M = UnLua.Class()

function M:Construct()
    self:SetSpellGlobeInputTags()
end

function M:WidgetControllerSet()
    self.WBP_HealthGlobe:SetWidgetController(self.WidgetController)
    self.WBP_ManaGlobe:SetWidgetController(self.WidgetController)

    self:SetGlobeWidgetControllers()
end

function M:SetSpellGlobeInputTags()
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()
    self.SpellGlobe_1.InputTag = AuraGameplayTags.InputTag_1
    self.SpellGlobe_2.InputTag = AuraGameplayTags.InputTag_2
    self.SpellGlobe_3.InputTag = AuraGameplayTags.InputTag_3
    self.SpellGlobe_4.InputTag = AuraGameplayTags.InputTag_4
    self.SpellGlobe_LMB.InputTag = AuraGameplayTags.InputTag_LMB
    self.SpellGlobe_RMB.InputTag = AuraGameplayTags.InputTag_RMB
    self.SpellGlobe_Passive_1.InputTag = AuraGameplayTags.InputTag_Passive_1
    self.SpellGlobe_Passive_2.InputTag = AuraGameplayTags.InputTag_Passive_2
end

function M:SetGlobeWidgetControllers()
    self.SpellGlobe_1:SetWidgetController(self.WidgetController)
    self.SpellGlobe_2:SetWidgetController(self.WidgetController)
    self.SpellGlobe_3:SetWidgetController(self.WidgetController)
    self.SpellGlobe_4:SetWidgetController(self.WidgetController)
    self.SpellGlobe_LMB:SetWidgetController(self.WidgetController)
    self.SpellGlobe_RMB:SetWidgetController(self.WidgetController)
    self.SpellGlobe_Passive_1:SetWidgetController(self.WidgetController)
    self.SpellGlobe_Passive_2:SetWidgetController(self.WidgetController)
end

return M
