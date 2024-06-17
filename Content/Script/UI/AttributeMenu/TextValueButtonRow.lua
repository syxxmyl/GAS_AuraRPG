--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_TextValueButtonRow_C
local M = UnLua.Class("UI.AttributeMenu.TextValueRow")

function M:Construct()
    self.AttributeMenuWidgetController = UE.UAuraAbilitySystemLibrary.GetAttributeMenuWidgetController(self)
    self.AttributeMenuWidgetController.AttributeInfoDelegate:Add(self, self.OnReceiveAttributeInfo)
    self.WBP_Button.Button.OnClicked:Add(self, self.OnUseAttributePoint)
end

function M:Destruct()
    self.AttributeMenuWidgetController.AttributeInfoDelegate:Remove(self, self.OnReceiveAttributeInfo)
    self.WBP_Button.Button.OnClicked:Remove(self, self.OnUseAttributePoint)

    self:Release()
end

function M:OnReceiveAttributeInfo(info)
    if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.AttributeTag, self.AttributeTag, true) then
        self.Super.SetLableText(self, info.AttributeName)
        self.Super.SetNumericalValueFloat(self, info.AttributeValue)
    end
end

function M:OnUseAttributePoint()
    self.AttributeMenuWidgetController:UpgradeAttribute(self.AttributeTag)
end

function M:SetButtonEnabled(enable)
    self.WBP_Button.Button:SetIsEnabled(enable)
end

return M
