--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_PassiveSpellTree_C
local M = UnLua.Class()

function M:Construct()
    self:SetGlobeAbilityTags()

    self.Button_HaloOfProtection.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.Button_LifeSiphon.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
    self.Button_ManaSiphon.SpellGlobeSelected:Add(self, self.OnReceiveSpellGlobeSelected)
end

function M:WidgetControllerSet()
    self.SpellMenuWidgetController = self.WidgetController:Cast(UE.USpellMenuWidgetController)
    self:SetGlobeWidgetController()
end

function M:Destruct()
    self.Button_HaloOfProtection.Button_Ring.OnClicked:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.Button_LifeSiphon.Button_Ring.OnClicked:Remove(self, self.OnReceiveSpellGlobeSelected)
    self.Button_ManaSiphon.Button_Ring.OnClicked:Remove(self, self.OnReceiveSpellGlobeSelected)

    self.OnPassiveSpellGlobeSelected:Clear()

    self:Release()
end

function M:SetGlobeAbilityTags()
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()
    self.Button_HaloOfProtection.AbilityTag = AuraGameplayTags.Abilities_Passive_HaloOfProtection
    self.Button_LifeSiphon.AbilityTag = AuraGameplayTags.Abilities_Passive_LifeSiphon
    self.Button_ManaSiphon.AbilityTag = AuraGameplayTags.Abilities_Passive_ManaSiphon
end

function M:SetGlobeWidgetController()
    self.Button_HaloOfProtection:SetWidgetController(self.SpellMenuWidgetController)
    self.Button_LifeSiphon:SetWidgetController(self.SpellMenuWidgetController)
    self.Button_ManaSiphon:SetWidgetController(self.SpellMenuWidgetController)
end

function M:OnReceiveSpellGlobeSelected(button)
    self:DeSelectAll()
    button:Select()
    self.OnPassiveSpellGlobeSelected:Broadcast()
end

function M:DeSelectAll()
    self.Button_HaloOfProtection:DeSelect()
    self.Button_LifeSiphon:DeSelect()
    self.Button_ManaSiphon:DeSelect()
end

return M
