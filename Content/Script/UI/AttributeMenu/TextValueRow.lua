--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_TextValueRow_C
local M = UnLua.Class()

function M:Construct()
    self.AttributeMenuWidgetController = UE.UAuraAbilitySystemLibrary.GetAttributeMenuWidgetController(self)
    self.AttributeMenuWidgetController.AttributeInfoDelegate:Add(self, self.OnReceiveAttributeInfo)
end

function M:Destruct()
    self.AttributeMenuWidgetController.AttributeInfoDelegate:Remove(self, self.OnReceiveAttributeInfo)

    self:Release()
end

function M:OnReceiveAttributeInfo(info)
    if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.AttributeTag, self.AttributeTag, true) then
        self:SetLableText(info.AttributeName)
        self:SetNumericalValueFloat(info.AttributeValue)
    end
end

function M:SetLableText(text)
    self.TextBlock_Label:SetText(text)
end

function M:SetNumericalValueFloat(value)
    self.WBP_FramedValue.TextBlock_Value:SetText(UE.UKismetTextLibrary.Conv_DoubleToText(value, 0, false, true, 1, 324, 0, 2))
end

return M
