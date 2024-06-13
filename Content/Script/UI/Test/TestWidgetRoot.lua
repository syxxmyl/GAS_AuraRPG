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

function M:Construct()
    Screen.Print(self, "TestWidgetRoot Construct")
    self.TextBlock_Title:SetText("Test Widget")
    self.Widgets = {}

    self.Button_Add.Button.OnClicked:Add(self, self.OnAddButtonClicked)
    self.Button_RemoveAll.Button.OnClicked:Add(self, self.OnRemoveAllButtonClicked)
    self.Button_Close.Button.OnClicked:Add(self, self.OnCloseButtonClicked)

    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnTimer}, 1, true)
    self:OnTimer()
end

function M:OnAddButtonClicked()
    Screen.Print(self, "TestWidgetRoot OnAddButtonClicked")
    local widget = NewObject(self.AddWidgetClass, self)
    table.insert(self.Widgets, widget)
    self.ItemVerticalBox:AddChildToVerticalBox(widget)
end

function M:OnRemoveAllButtonClicked()
    Screen.Print(self, "TestWidgetRoot OnRemoveAllButtonClicked")
    for i,v in ipairs(self.Widgets) do
        if v:IsValid() then
            v:RemoveFromParent()
        end
    end
    self.Widgets = {}
end

function M:OnCloseButtonClicked()
    Screen.Print(self, "TestWidgetRoot OnCloseButtonClicked")
    self:RemoveFromParent()
end

function M:OnTimer()
    local second = UE.UKismetSystemLibrary.GetGameTimeInSeconds(self)
    self.TextBlock_Message:SetText(string.format("game second: %d s", math.floor(second)))
end

function M:Destruct()
    self.Button_Add.Button.OnClicked:Remove(self, self.OnAddButtonClicked)
    self.Button_RemoveAll.Button.OnClicked:Remove(self, self.OnRemoveAllButtonClicked)
    self.Button_Close.Button.OnClicked:Remove(self, self.OnCloseButtonClicked)

    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.TimerHandle)

    Screen.Print(self, "TestWidgetRoot Destruct")
    self:Release()
end

function M:CenteredXPosition()
    local viewport = UE.UWidgetLayoutLibrary.GetViewportSize(self)
    return viewport.X / 2 - self.SizeBox_Root.WidthOverride / 2
end

function M:CenteredYPosition()
    local viewport = UE.UWidgetLayoutLibrary.GetViewportSize(self)
    return viewport.Y / 2 - self.SizeBox_Root.HeightOverride / 2
end

function M:AdjustPositionInViewport()
    self:SetPositionInViewport(UE.FVector2D(self:CenteredXPosition(), self:CenteredYPosition()), true)
end

return M
