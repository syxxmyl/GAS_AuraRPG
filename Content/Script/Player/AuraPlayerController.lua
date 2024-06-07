--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AuraPlayerController_C

require('Common')
require('Test.Test')

local Screen = require('Screen')
local BindKey = UnLua.Input.BindKey
local BindAction = UnLua.Input.BindAction
local EnhancedBindAction = UnLua.EnhancedInput.BindAction

local M = UnLua.Class()

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_5", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    -- ArrayTest()
    -- SetTest()
    -- MapTest()
    -- CoroutineTest(self)
    UE.UAuraAbilitySystemLibrary.CallLuaByGlobalTable()
    UE.UAuraAbilitySystemLibrary.CallLuaByFLuaTable()
end)

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_6", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    local WidgetClass = self.TestSpawnWidget
    local TestWidget = NewObject(WidgetClass, self, nil)
    TestWidget:AddToViewport()
    -- local Position = UE.UWidgetLayoutLibrary:GetViewportSize(self)
    TestWidget:AdjustPositionInViewport()
end)

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_Move", "Triggered", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    -- print(string.format("EnhancedInput IA_Move ElapsedSeconds=%s.", ElapsedSeconds))
    -- print(string.format("EnhancedInput IA_Move TriggeredSeconds=%s.", TriggeredSeconds))
    -- local msg = string.format("EnhancedInput IA_Move Triggered X=%s, Y=%s.", ActionValue.X, ActionValue.Y)
    -- print(msg)
    -- Screen.Print(msg)
end)

return M
