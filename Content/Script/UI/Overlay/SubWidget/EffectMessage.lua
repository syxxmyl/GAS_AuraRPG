--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_EffectMessage_C
local M = UnLua.Class()

function M:SetImageAndText(image, text)
    if self.Text_Message then
        self.Text_Message:SetText(text)
    end

    if image:IsValid() then
        local brush = UE.FSlateBrush(image)
        brush.ImageSize = self.ImageSize
        if self.Image_Icon then
            self.Image_Icon:SetBrush(brush)
        end
    end

    self:PlayAnimation(self.MessageAnimation)
    self.DestroyTimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnDestroyTimer}, 1.25, false)
end

function M:OnDestroyTimer()
    self:RemoveFromParent()
end

function M:Destruct()
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.DestroyTimerHandle)

    self:Release()
end

return M
