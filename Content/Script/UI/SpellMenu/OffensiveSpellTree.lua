--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_OffensiveSpellTree_C
local M = UnLua.Class()

function M:Construct()
    self:SetAttributeTags()

    self.Globe_FireBolt.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.Globe_FireBlast.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.Globe_Electrocute.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.Globe_ArcaneShards.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)  
    self.WBP_SpellGlobe_Button_3.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_4.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_6.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_7.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
end

function M:WidgetControllerSet()
    self.SpellMenuWidgetController = self.WidgetController:Cast(UE.USpellMenuWidgetController)
    self:SetGlobeWidgetController()
end

function M:Destruct()
    self.Globe_FireBolt.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.Globe_FireBlast.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.Globe_Electrocute.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.Globe_ArcaneShards.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_3.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_4.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_6.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.WBP_SpellGlobe_Button_7.SpellGlobeSelected:Remove(self, self.OnReceiveSpellGlobeSelected)

    self.OnOffensiveSpellGlobeSelected:Clear()

    self:Release()
end

function M:SetAttributeTags()
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()
    self.Globe_FireBolt.AbilityTag = AuraGameplayTags.Abilities_Fire_FireBolt
    self.Globe_FireBlast.AbilityTag = AuraGameplayTags.Abilities_Fire_FireBlast
    self.Globe_Electrocute.AbilityTag = AuraGameplayTags.Abilities_Lightning_Electrocute
    self.Globe_ArcaneShards.AbilityTag = AuraGameplayTags.Abilities_Arcane_ArcaneShards
end

function M:SetGlobeWidgetController()
    self.Globe_FireBolt:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_FireBlast:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_Electrocute:SetWidgetController(self.SpellMenuWidgetController)
    self.Globe_ArcaneShards:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_SpellGlobe_Button:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_SpellGlobe_Button_3:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_SpellGlobe_Button_4:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_SpellGlobe_Button_6:SetWidgetController(self.SpellMenuWidgetController)
    self.WBP_SpellGlobe_Button_7:SetWidgetController(self.SpellMenuWidgetController)
end

function M:OnReceiveSpellGlobeSelected(button)
    self:DeSelectAll()
    button:Select()
    self.OnOffensiveSpellGlobeSelected:Broadcast()
end

function M:DeSelectAll()
    self.Globe_FireBolt:DeSelect()
    self.Globe_FireBlast:DeSelect()
    self.Globe_Electrocute:DeSelect()
    self.Globe_ArcaneShards:DeSelect()
    self.WBP_SpellGlobe_Button:DeSelect()
    self.WBP_SpellGlobe_Button_3:DeSelect()
    self.WBP_SpellGlobe_Button_4:DeSelect()
    self.WBP_SpellGlobe_Button_6:DeSelect()
    self.WBP_SpellGlobe_Button_7:DeSelect()
end

return M
