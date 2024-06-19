--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_SpellGlobe_C
local M = UnLua.Class()

function M:Construct()
    self:ClearGlobe()
    self:SetDefaultState()
end

function M:WidgetControllerSet()
    self.OverlayWidgetController = self.WidgetController:Cast(UE.UOverlayWidgetController)
    self.OverlayWidgetController.AbilityInfoDelegate:Add(self, self.OnReceiveAbilityInfo)
end

function M:Destruct()
    self.OverlayWidgetController.AbilityInfoDelegate:Remove(self, self.OnReceiveAbilityInfo)

    if UE.UObject.IsValid(self.WaitCooldownChangeTask) then
        self.WaitCooldownChangeTask.CooldownStart:Remove(self, self.OnCooldownStart)
    end

    self.Release()
end

function M:OnReceiveAbilityInfo(info)
    local AuraGameplayTags = UE.FAuraGameplayTags:Get()

    if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.InputTag, self.InputTag, true) then
        if UE.UBlueprintGameplayTagLibrary.MatchesTag(info.AbilityTag, AuraGameplayTags.Abilities_None, false) then
            self:ClearGlobe()
            self.CooldownTag = nil
            self:StopCooldownTimer()
            if UE.UObject.IsValid(self.WaitCooldownChangeTask) then
                self.WaitCooldownChangeTask.CooldownStart:Remove(self, self.OnCooldownStart)
                self.WaitCooldownChangeTask:EndTask()
            end
        else
            self.CooldownTag = info.CooldownTag
            self:SetIconAndBackground(info.Icon, info.BackgroundMaterial)
            coroutine.resume(coroutine.create(BindCooldownTask), self)
        end
    end
end

function BindCooldownTask(widget)
    widget.WaitCooldownChangeTask = UE.UWaitCooldownChange.WaitForCooldownChange(widget.OverlayWidgetController.AbilitySystemComponent, widget.CooldownTag)
    widget.WaitCooldownChangeTask.CooldownStart:Add(widget, widget.OnCooldownStart)
end

function M:OnCooldownStart(time)
    self.TimeRemaining = time
    self:SetCooldownState()
    self.CooldownTimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnUpdateCooldownTimer}, self.TimeFrequency, true)
end

function M:OnUpdateCooldownTimer()
    local value = UE.UKismetMathLibrary.FClamp(self.TimeRemaining - self.TimeFrequency, 0, self.TimeRemaining)
    self.TimeRemaining = value
    self.Text_Cooldown:SetText(UE.UKismetTextLibrary.Conv_DoubleToText(value, 0, false, true, 1, 324, 1, 1))
    if self.TimeRemaining <= 0 then
        self:StopCooldownTimer()
    end
end

function M:ClearGlobe()
    self.Image_SpellIcon:SetOpacity(0)
    self.Image_Background:SetOpacity(0)
end

function M:SetIconAndBackground(icon, background)
    self.Image_SpellIcon:SetOpacity(1)
    self.Image_Background:SetOpacity(1)
    self.Image_SpellIcon:SetBrushFromTexture(icon)
    self.Image_Background:SetBrushFromMaterial(background)
end

function M:SetCooldownState()
    self:SetBackgroundTint(0.05)
    self.Text_Cooldown:SetRenderOpacity(1)
end

function M:SetDefaultState()
    self:SetBackgroundTint(1)
    self.Text_Cooldown:SetRenderOpacity(0)
end

function M:StopCooldownTimer()
    UE.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.CooldownTimerHandle)
    self:SetDefaultState()
end

return M
