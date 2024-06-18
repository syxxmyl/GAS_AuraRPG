--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_EquippedSpellRow_C
local M = UnLua.Class()

function M:Construct()
    self:SetGlobeInputTag()
    self:SetGlobeAbilityType()
end

function M:WidgetControllerSet()
    self.SpellMenuWidgetController = self.WidgetController:Cast(UE.USpellMenuWidgetController)
    self:SetGlobeWidgetController()
end

function M:Destruct()
    self:Release()
end

function M:SetGlobeWidgetController()
    self.Globe_1:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_2:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_3:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_4:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_LMB:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_RMB:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_Passive_1:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_Passive_2:SetWidgetController(self.SpellMenuWidgetController)
end

function M:SetGlobeInputTag()
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()
    self.Globe_1.InputTag = AuraGameplayTags.InputTag_1
    self.Globe_2.InputTag = AuraGameplayTags.InputTag_2
    self.Globe_3.InputTag = AuraGameplayTags.InputTag_3
    self.Globe_4.InputTag = AuraGameplayTags.InputTag_4
    self.Globe_LMB.InputTag = AuraGameplayTags.InputTag_LMB
    self.Globe_RMB.InputTag = AuraGameplayTags.InputTag_RMB
    self.Globe_Passive_1.InputTag = AuraGameplayTags.InputTag_Passive_1
    self.Globe_Passive_2.InputTag = AuraGameplayTags.InputTag_Passive_2
end

function M:SetGlobeAbilityType()
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()

    self.Globe_1.AbilityType = AuraGameplayTags.Abilities_Type_Offensive
    self.Globe_2.AbilityType = AuraGameplayTags.Abilities_Type_Offensive
    self.Globe_3.AbilityType = AuraGameplayTags.Abilities_Type_Offensive
    self.Globe_4.AbilityType = AuraGameplayTags.Abilities_Type_Offensive
    self.Globe_LMB.AbilityType = AuraGameplayTags.Abilities_Type_Offensive
    self.Globe_RMB.AbilityType = AuraGameplayTags.Abilities_Type_Offensive
    self.Globe_Passive_1.AbilityType = AuraGameplayTags.Abilities_Type_Passive
    self.Globe_Passive_2.AbilityType = AuraGameplayTags.Abilities_Type_Passive
end

return M
