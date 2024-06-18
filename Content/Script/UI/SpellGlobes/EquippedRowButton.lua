--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_EquippedRow_Button_C
local M = UnLua.Class()

function M:Construct()
    self:ClearGlobe()
end

function M:WidgetControllerSet()
    self.SpellMenuWidgetController = self.WidgetController:Cast(UE.USpellMenuWidgetController)
    
    self.SpellMenuWidgetController.AbilityInfoDelegate:Add(self, self.OnReceiveAbilityInfo)
    self.Button_Ring.OnClicked:Add(self, self.OnButtonClicked)
end

function M:Destruct()
    self.Button_Ring.OnClicked:Remove(self, self.OnButtonClicked)
    self.SpellMenuWidgetController.AbilityInfoDelegate:Remove(self, self.OnReceiveAbilityInfo)

    self:Release()
end

function M:OnReceiveAbilityInfo(info)
    if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.InputTag, self.InputTag, false) then
        if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.AbilityTag, UE.FAuraGameplayTags:Get().Abilities_None, true) then
            self:ClearGlobe()
        else
            self:SetGlobeImage(info.Icon, info.BackgroundMaterial)
        end
    end
end

function M:OnButtonClicked()
    self.SpellMenuWidgetController:SpellRowGlobePressed(self.InputTag, self.AbilityType)
end

function M:ClearGlobe()
    self.Image_Icon:SetOpacity(0)
    self.Image_Background:SetOpacity(0)
end

function M:SetGlobeImage(icon, background)
    self.Image_Icon:SetOpacity(1)
    self.Image_Background:SetOpacity(1)
    self.Image_Icon:SetBrushFromTexture(icon)
    self.Image_Background:SetBrushFromMaterial(background)
end

return M
