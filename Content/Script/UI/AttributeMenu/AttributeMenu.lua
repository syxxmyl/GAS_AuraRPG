--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_AttributeMenu_C
local M = UnLua.Class()

function M:Construct()
    self.CloseButton.Button.OnClicked:Add(self, self.OnCloseButtonClicked)
    self:SetAttributeTags()
    self.AttributeMenuWidgetController = UE.UAuraAbilitySystemLibrary.GetAttributeMenuWidgetController(self)
    self:SetWidgetController(self.AttributeMenuWidgetController)
    self.Row_AttributePoint:SetWidgetController(self.AttributeMenuWidgetController)
    
    self.AttributeMenuWidgetController.OnAttributePointsChangedDelegate:Add(self, self.OnAttributePointsChanged);
    self.AttributeMenuWidgetController:BroadcastInitialValues()
end

function M:Destruct()
    self.AttributeMenuWidgetController.OnAttributePointsChangedDelegate:Remove(self, self.OnAttributePointsChanged)
    self.CloseButton.Button.OnClicked:Remove(self, self.OnCloseButtonClicked)
    self.AttributeMenuClosed:Broadcast()
    self.AttributeMenuClosed:Clear()
    
    self:Release()
end

function M:OnCloseButtonClicked()
    self:RemoveFromParent()
end

function M:SetAttributeTags()
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()
    self.Row_Strength.AttributeTag = AuraGameplayTags.Attributes_Primary_Strength
    self.Row_Intelligence.AttributeTag = AuraGameplayTags.Attributes_Primary_Intelligence
    self.Row_Resilience.AttributeTag = AuraGameplayTags.Attributes_Primary_Resilience
    self.Row_Vigor.AttributeTag = AuraGameplayTags.Attributes_Primary_Vigor

    self.Row_Armor.AttributeTag = AuraGameplayTags.Attributes_Secondary_Armor
    self.Row_ArmorPenetration.AttributeTag = AuraGameplayTags.Attributes_Secondary_ArmorPenetration
    self.Row_BlockChance.AttributeTag = AuraGameplayTags.Attributes_Secondary_BlockChance
    self.Row_CriticalHitChance.AttributeTag = AuraGameplayTags.Attributes_Secondary_CriticalHitChance
    self.Row_CriticalHitDamage.AttributeTag = AuraGameplayTags.Attributes_Secondary_CriticalHitDamage
    self.Row_CriticalHitResistance.AttributeTag = AuraGameplayTags.Attributes_Secondary_CriticalHitResistance
    self.Row_HealthRegeneration.AttributeTag = AuraGameplayTags.Attributes_Secondary_HealthRegeneration
    self.Row_ManaRegeneration.AttributeTag = AuraGameplayTags.Attributes_Secondary_ManaRegeneration

    self.Row_MaxHealth.AttributeTag = AuraGameplayTags.Attributes_Secondary_MaxHealth
    self.Row_MaxMana.AttributeTag = AuraGameplayTags.Attributes_Secondary_MaxMana
    
    self.Row_FireResistance.AttributeTag = AuraGameplayTags.Attributes_Resistance_Fire
    self.Row_LightningResistance.AttributeTag = AuraGameplayTags.Attributes_Resistance_Lightning
    self.Row_ArcaneResistance.AttributeTag = AuraGameplayTags.Attributes_Resistance_Arcane
    self.Row_PhysicalResistance.AttributeTag = AuraGameplayTags.Attributes_Resistance_Physical
end

function M:OnAttributePointsChanged(points)
    self:SetAttributeButtonEnabled(points)
end

function M:SetAttributeButtonEnabled(points)
    local enable = false
    if points > 0 then
        enable = true
    end

    self.Row_Strength:SetButtonEnabled(enable)
    self.Row_Intelligence:SetButtonEnabled(enable)
    self.Row_Resilience:SetButtonEnabled(enable)
    self.Row_Vigor:SetButtonEnabled(enable)
end

return M
