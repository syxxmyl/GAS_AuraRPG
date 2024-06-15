--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_LevelUpMessage_C
local M = UnLua.Class()

function M:Construct()
    UE.UGameplayStatics.PlaySound2D(self, self.LevelUpSound)
    self:PlayAnimation(self.MessageAnimation)
    self.DestroyTimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnDestroyTimer}, 5, false)
end

function M:SetLevelText(text)
    self.LevelText = text
    if self.Text_Level then
        self.Text_Level:SetText(text)
    else
        UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.SetLevelTextTimerHandle)
        self.SetLevelTextTimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnSetLevelTextTimer}, 0.1, false)
    end
end

function M:OnDestroyTimer()
    self:RemoveFromParent()
end

function M:OnSetLevelTextTimer()
    self:SetLevelText(self.LevelText)
end

function M:Destruct()
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.DestroyTimerHandle)
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.SetLevelTextTimerHandle)

    self:Release()
end

return M
