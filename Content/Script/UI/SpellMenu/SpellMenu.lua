--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_SpellMenu_C
local M = UnLua.Class()

function M:Construct()
    self:SetSpellButtonEnabled(false, false)
    
    self.CloseButton.Button.OnClicked:Add(self, self.OnCloseButtonClicked)
    self.WBP_OffensiveSpellTree.OnOffensiveSpellGlobeSelected:Add(self, self.OnOffensiveSpellGlobeSelected)
    self.WBP_PassiveSpellTree.OnPassiveSpellGlobeSelected:Add(self, self.OnPassiveSpellGlobeSelected)
    self.Button_SpendPoint.Button.OnClicked:Add(self, self.OnSpendPointButtonClicked)
    self.Button_Equip.Button.OnClicked:Add(self, self.OnEquipButtonClicked)

    self:SetSpellMenuWidgetController()
end

function M:SetSpellMenuWidgetController()
    self.SpellMenuWidgetController = UE.UAuraAbilitySystemLibrary.GetSpellMenuWidgetController(self)
    self:SetWidgetController(self.SpellMenuWidgetController)

    self.SpellMenuWidgetController.WaitForEquipDelegate:Add(self, self.OnReceiveWaitForEquip)
    self.SpellMenuWidgetController.StopWaitingForEquipDelegate:Add(self, self.OnReceiveStopWaitingForEquip)
    self.SpellMenuWidgetController.SpellGlobeSelectedDelegate:Add(self, self.OnReceiveSpellGlobeSelected)
    self.SpellMenuWidgetController.SpellPointsChanged:Add(self, self.OnReceiveSpellPointsChanged)

    self.WBP_EquippedSpellRow:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_OffensiveSpellTree:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_PassiveSpellTree:SetWidgetController(self.SpellMenuWidgetController)

    self.SpellMenuWidgetController:BroadcastInitialValues()
end

function M:Destruct()
    self.CloseButton.Button.OnClicked:Remove(self, self.OnCloseButtonClicked)
    self.WBP_OffensiveSpellTree.OnOffensiveSpellGlobeSelected:Remove(self, self.OnOffensiveSpellGlobeSelected)
    self.WBP_PassiveSpellTree.OnPassiveSpellGlobeSelected:Remove(self, self.OnPassiveSpellGlobeSelected)
    self.Button_SpendPoint.Button.OnClicked:Remove(self, self.OnSpendPointButtonClicked)
    self.Button_Equip.Button.OnClicked:Remove(self, self.OnEquipButtonClicked)

    self.SpellMenuWidgetController.WaitForEquipDelegate:Remove(self, self.OnReceiveWaitForEquip)
    self.SpellMenuWidgetController.StopWaitingForEquipDelegate:Remove(self, self.OnReceiveStopWaitingForEquip)
    self.SpellMenuWidgetController.SpellGlobeSelectedDelegate:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.SpellMenuWidgetController.SpellPointsChanged:Remove(self, self.OnReceiveSpellPointsChanged)

    self.SpellMenuClosed:Broadcast()
    self.SpellMenuClosed:Clear()

    self.Release()
end

function M:OnCloseButtonClicked()
    self:RemoveFromParent()
end

function M:OnOffensiveSpellGlobeSelected()
    self.WBP_PassiveSpellTree:DeSelectAll()
end

function M:OnPassiveSpellGlobeSelected()
    self.WBP_OffensiveSpellTree:DeSelectAll()
end

function M:OnSpendPointButtonClicked()
    self.SpellMenuWidgetController:SpendPointButtonPressed()
end

function M:OnEquipButtonClicked()
    self.SpellMenuWidgetController:EquipButtonPressed()
end

function M:OnReceiveWaitForEquip(type)
    self:SetSpellButtonEnabled(false, false)

    if UE.UBlueprintGameplayTagLibrary.MatchesTag(type, UE.FAuraGameplayTags:Get().Abilities_Type_Offensive, true) then
        self.WBP_EquippedSpellRow:PlayAnimation(self.WBP_EquippedSpellRow.OffensiveSelectionAnimation)
    else
        self.WBP_EquippedSpellRow:PlayAnimation(self.WBP_EquippedSpellRow.PassiveSelectionAnimation)
    end
end

function M:OnReceiveStopWaitingForEquip(type)
    self.WBP_EquippedSpellRow:StopAllAnimations()
    if UE.UBlueprintGameplayTagLibrary.MatchesTag(type, UE.FAuraGameplayTags:Get().Abilities_Type_Offensive, true) then
        self.WBP_EquippedSpellRow:PlayAnimation(self.WBP_EquippedSpellRow.HideOffensiveBox)
    else
        self.WBP_EquippedSpellRow:PlayAnimation(self.WBP_EquippedSpellRow.HidePassiveBox)
    end
end

function M:OnReceiveSpellGlobeSelected(spendpoint, equip, currentlevel, nextlevel)
    self:SetSpellButtonEnabled(spendpoint, equip)
    self.RichText_CurrentLevel:SetText(UE.UKismetTextLibrary.Conv_StringToText(currentlevel))
    self.RichText_NextLevel:SetText(UE.UKismetTextLibrary.Conv_StringToText(nextlevel))
end

function M:OnReceiveSpellPointsChanged(points)
    self:SetSpellPointsText(points)
end

function M:SetSpellButtonEnabled(spendpoint, equip)
    self.Button_SpendPoint:SetIsEnabled(spendpoint)
    self.Button_Equip:SetIsEnabled(equip)
end

function M:SetSpellPointsText(points)
    self.FramedValue_SpellPoints.TextBlock_Value:SetText(UE.UKismetTextLibrary.Conv_IntToText(points))
end

return M
