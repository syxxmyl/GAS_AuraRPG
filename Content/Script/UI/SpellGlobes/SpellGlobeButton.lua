--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_SpellGlobe_Button_C
local M = UnLua.Class()

function M:Construct()
    self.Selected = false
end

function M:WidgetControllerSet()
    self.SpellMenuWidgetController = self.WidgetController:Cast(UE.USpellMenuWidgetController)

    self.SpellMenuWidgetController.AbilityInfoDelegate:Add(self, self.OnReceiveAbilityInfo)
    self.SpellMenuWidgetController.SpellGlobeReassignedDelegate:Add(self, self.OnReceiveSpellGlobeReassigned)

    self.Button_Ring.OnClicked:Add(self, self.OnButtonRingClicked)
end

function M:Destruct()
    self.Button_Ring.OnClicked:Remove(self, self.OnButtonRingClicked)

    self.SpellMenuWidgetController.AbilityInfoDelegate:Clear()
    self.SpellMenuWidgetController.SpellGlobeReassignedDelegate:Clear()

    self:Release()
end

function M:OnReceiveAbilityInfo(info)
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()

    if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.AbilityTag, self.AbilityTag, true) then
        if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.StatusTag, AuraGameplayTags.Abilities_Status_Locked, true) then
            self:SetGlobeLocked()
        else
            if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.StatusTag, AuraGameplayTags.Abilities_Status_Unlocked, true) or
            UE.UBlueprintGameplayTagLibrary.MatchesTag(info.StatusTag, AuraGameplayTags.Abilities_Status_Equipped, true) then
                self:SetGlobeEquippedOrUnlocked(info.Icon, info.BackgroundMaterial)
            else 
                if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.StatusTag, AuraGameplayTags.Abilities_Status_Eligible, true) then
                    self:SetGlobeEligible(info.Icon)
                end
            end
        end
    end
end

function M:OnReceiveSpellGlobeReassigned(abilitytag)
    if UE.UBlueprintGameplayTagLibrary.MatchesTag(abilitytag, self.AbilityTag, true) then
        self:DeSelect()
        UE.UGameplayStatics.PlaySound2D(self, self.SpellGlobeReAssignedSound)
    end
end

function M:OnButtonRingClicked()
    if self.Selected then
        self:Destruct()
        self.SpellMenuWidgetController:GlobeDeselect()
        UE.UGameplayStatics.PlaySound2D(self, self.SpellGlobeReAssignedSound)
    else
        self.SpellGlobeSelected:Broadcast(self)
        self.SpellMenuWidgetController:SpellGlobeSelected(self.AbilityTag)
    end
end

function M:SetGlobeLocked()
    self.Image_Icon:SetBrushFromTexture(self.LockedTexture)
    self.Image_Background:SetBrushFromMaterial(self.LockedMaterialInstance)
end

function M:SetGlobeEquippedOrUnlocked(texture, materialinstance)
    self.Image_Icon:SetBrushFromTexture(texture)
    self.Image_Background:SetBrushFromMaterial(materialinstance)
end

function M:SetGlobeEligible(texture)
    self.Image_Icon:SetBrushFromTexture(texture)
    self.Image_Background:SetBrushFromMaterial(self.LockedMaterialInstance)
end

function M:Select()
    self.Selected = true
    self.Image_Selection:SetRenderOpacity(1.0)
    self:PlayAnimation(self.SelectAnimation)
    UE.UGameplayStatics.PlaySound2D(self, self.SpellGlobeSelectSound)
end

function M:DeSelect()
    self.Selected = false
    self.Image_Selection:SetRenderOpacity(0)
end

return M
