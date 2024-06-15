--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type WBP_Overlay_C
local M = UnLua.Class()

--function M:Initialize(Initializer)
--end

--function M:PreConstruct(IsDesignTime)
--end

-- function M:Construct()
-- end

--function M:Tick(MyGeometry, InDeltaTime)
--end

function M:WidgetControllerSet()
    self.BPOverlayWidgetController = self.WidgetController:Cast(UE.UOverlayWidgetController)
    self.PlayerController = self.BPOverlayWidgetController.PlayerController

    self.WBP_HealthManaSpells:SetWidgetController(self.WidgetController)
    self.WBP_XPBar:SetWidgetController(self.WidgetController)
    self.ValueGlobe_Level:SetWidgetController(self.WidgetController)

    self.BPOverlayWidgetController.MessageWidgetRowDelegate:Add(self, self.OnReceiveMessageWidgetRowBroadcast)
    self.BPOverlayWidgetController.OnPlayerLevelChangedDelegate:Add(self, self.OnReceivePlayerLevelChangedBroadcast)
end

function M:Construct()
    self.AttributeMenuButton.Button.OnClicked:Add(self, self.OnAttributeMenuButtonClicked)
    self.SpellMenuButton.Button.OnClicked:Add(self, self.OnSpellMenuButtonClicked)
    self.Button_Quit.Button.OnClicked:Add(self, self.OnQuitButtonClicked)
end

function M:Destruct()
    self.BPOverlayWidgetController.MessageWidgetRowDelegate:Remove(self, self.OnReceiveMessageWidgetRowBroadcast)
    self.BPOverlayWidgetController.OnPlayerLevelChangedDelegate:Remove(self, self.OnReceivePlayerLevelChangedBroadcast)
    self.AttributeMenuButton.Button.OnClicked:Remove(self, self.OnAttributeMenuButtonClicked)
    self.SpellMenuButton.Button.OnClicked:Remove(self, self.OnSpellMenuButtonClicked)
    self.Button_Quit.Button.OnClicked:Remove(self, self.OnQuitButtonClicked)

    self:Release()
end

function M:OnAttributeMenuButtonClicked()
    self.AttributeMenuOpen = true
    self:SetButtonsEnabled(false)

    if UE.UObject.IsValid(self.AttributeMenuWidget) then
        self.AttributeMenuWidget:RemoveFromParent()
    end

    self.AttributeMenuWidget = NewObject(self.AttributeMenuWidgetClass, self.PlayerController, nil)
    self.AttributeMenuWidget:AddToViewport()

    local Position = UE.FVector2D(self.MenuPadding, self.MenuPadding)
    self.AttributeMenuWidget:SetPositionInViewport(Position)
    self.AttributeMenuWidget.AttributeMenuClosed:Add(self, self.OnAttributeMenuClosed)  -- TODO: attributemenu delegate clear
    UE.UWidgetBlueprintLibrary.SetInputMode_UIOnlyEx(self.PlayerController)
end

function M:OnAttributeMenuClosed()
    self.AttributeMenuOpen = false
    self:SetButtonsEnabled(true)

    if not self.AttributeMenuOpen then
        UE.UWidgetBlueprintLibrary.SetInputMode_GameAndUIEx(self.PlayerController, nil, 0, false, false)
    end

end

function M:OnSpellMenuButtonClicked()
    self.SpellMenuOpen = true
    self:SetButtonsEnabled(false)

    if UE.UObject.IsValid(self.SpellMenuWidget) then
        self.SpellMenuWidget:RemoveFromParent()
    end

    self.SpellMenuWidget = NewObject(self.SpellMenuWidgetClass, self.PlayerController, nil)
    self.SpellMenuWidget:AddToViewport()

    local Position = UE.UWidgetLayoutLibrary.GetViewportSize(self)
    Position.X = Position.X / 2 + self.MenuPadding
    Position.Y = self.MenuPadding
    self.SpellMenuWidget:SetPositionInViewport(Position)
    self.SpellMenuWidget.SpellMenuClosed:Add(self, self.OnSpellMenuClosed)  -- TODO: spellmenu delegate clear
    UE.UWidgetBlueprintLibrary.SetInputMode_UIOnlyEx(self.PlayerController)
end

function M:OnSpellMenuClosed()
    self.SpellMenuOpen = false
    self:SetButtonsEnabled(true)

    if not self.SpellMenuOpen then
        UE.UWidgetBlueprintLibrary.SetInputMode_GameAndUIEx(self.PlayerController, nil, 0, false, false)
    end

end

function M:OnQuitButtonClicked()
    self:SetButtonsEnabled(false)

    if UE.UObject.IsValid(self.AreYouSureWidget) then
        self.AreYouSureWidget:RemoveFromParent()
    end

    self.AreYouSureWidget = NewObject(self.AreYouSureWidgetClass, self.PlayerController, nil)    
    self.AreYouSureWidget:AddToViewport()
    local Position = UE.FVector2D(self.AreYouSureWidget:CenteredXPosition(), 100)
    self.AreYouSureWidget:SetPositionInViewport(Position)

    self.AreYouSureWidget.TextBlock_Message:SetText("Exit to Loading Menu? All unsaved progress will be lost.")
    self.AreYouSureWidget.Button_Delete.Text_ButtonTitle:SetText("QUIT")

    self.AreYouSureWidget.DeleteButtonClicked:Add(self, self.OnAreYouSureWidgetDeleteButtonClicked)
    self.AreYouSureWidget.CancelButtonClicked:Add(self, self.OnAreYouSureWidgetCancelButtonClicked)

    UE.UWidgetBlueprintLibrary.SetInputMode_UIOnlyEx(self.PlayerController)
end

function M:OnAreYouSureWidgetDeleteButtonClicked()
    UE.UGameplayStatics.OpenLevel(self, "LoadMenu", true)
end

function M:OnAreYouSureWidgetCancelButtonClicked()
    self:SetButtonsEnabled(true)
    UE.UWidgetBlueprintLibrary.SetInputMode_GameAndUIEx(self.PlayerController, nil, 0, false, false)
end

function M:OnReceiveMessageWidgetRowBroadcast(Row)
    local widget = NewObject(Row.MessageWidget, self.PlayerController, nil)
    widget:AddToViewport()
    local Position = UE.UWidgetLayoutLibrary.GetViewportSize(self)
    Position = Position * 0.5
    widget:SetPositionInViewport(Position, true)
    widget:SetImageAndText(Row.Image, Row.Message)
end

function M:OnReceivePlayerLevelChangedBroadcast(newLevel, bLevelUp)
    if not bLevelUp then
        return
    end

    if UE.UObject.IsValid(self.LevelUpWidget) then
        self.LevelUpWidget:RemoveFromParent()
    end

    self.LevelUpWidget = NewObject(self.LevelUpWidgetClass, self.PlayerController, nil)
    local text = UE.UKismetTextLibrary.Conv_IntToText(newLevel)
    self.LevelUpWidget:SetLevelText(text)
    self.LevelUpWidget:AddToViewport()
end

function M:SetButtonsEnabled(enable)
    self.AttributeMenuButton.Button:SetIsEnabled(enable)
    self.SpellMenuButton.Button:SetIsEnabled(enable)
    self.Button_Quit.Button:SetIsEnabled(enable)
end


return M
