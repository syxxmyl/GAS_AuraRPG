--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_GlobeProgressBar_C
local M = UnLua.Class()

function M:Construct()
    self.GhostPercentTarget = 0
    self.GlobeInitialized = false
    self.Text_Value:SetVisibility(2)
end

function M:Tick(MyGeometry, InDeltaTime)
    self:InterpGhostGlobe(InDeltaTime)

    if self.ProgressBar_Globe:IsHovered() then
        self.Text_Value:SetVisibility(0)
    else
        self.Text_Value:SetVisibility(2)
    end    
end

function M:InterpGhostGlobe(delta)
    local percent = UE.UKismetMathLibrary.FInterpTo(self.ProgressBar_Ghost.Percent, self.GhostPercentTarget, delta, self.GhostInterpSpeed)
    self.ProgressBar_Ghost:SetPercent(percent)
end

function M:SetProgressBarPercent(percent)
    if self.GlobeInitialized then
        self.ProgressBar_Globe:SetPercent(percent)
        self:GhostPercentSet(percent)
    else
        if percent > 0.0 then
            self.GlobeInitialized = true
            self.ProgressBar_Globe:SetPercent(percent)
            self.ProgressBar_Ghost:SetPercent(percent)
            self.GhostPercentTarget = percent
        end
    end
end

function M:SetGhostProgressBarPercent(percent)
    self.ProgressBar_Ghost:SetPercent(percent)
end

function task(widget, percent)
    UE.UKismetSystemLibrary.Delay(widget, 1)
    widget.GhostPercentTarget = percent
end

function M:GhostPercentSet(percent)
    coroutine.resume(coroutine.create(task), self, percent)
end

return M
