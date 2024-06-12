--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_TestWidget_C

local Screen = require('Screen')
local M = UnLua.Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

function M:Construct()
    self.TextBlock_Title:SetText("Test Widget")

    self.Button_No.Button.OnClicked:Add(self, self.OnNoButtonClicked)
    self.Button_Yes.Button.OnClicked:Add(self, self.OnYesButtonClicked)

    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnTimer}, 1, true)
    self:OnTimer()
end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:OnNoButtonClicked()
    Screen.Print(self, "NoButtonClicked")
    self:RemoveFromParent()
end

function M:OnYesButtonClicked()
    Screen.Print(self, "YesButtonClicked")
    self:RemoveFromParent()
end

function M:OnTimer()
    local second = UE.UKismetSystemLibrary.GetGameTimeInSeconds(self)
    self.TextBlock_Message:SetText(string.format("game second: %d s", math.floor(second)))
end

function M:Destruct()
    self.Button_No.Button.OnClicked:Remove(self, self.OnNoButtonClicked)
    self.Button_Yes.Button.OnClicked:Remove(self, self.OnYesButtonClicked)

    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle)
end

return M
