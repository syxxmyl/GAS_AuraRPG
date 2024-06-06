--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AuraPlayerController_C

require('Common')

local Screen = require('Screen')
local BindKey = UnLua.Input.BindKey
local BindAction = UnLua.Input.BindAction
local EnhancedBindAction = UnLua.EnhancedInput.BindAction

local M = UnLua.Class()

local function ArrayTest()
    local array = UE.TArray(0)
    print_array(array)

    array:Add(3)
    array:Add(2)
    print_array(array)

    local length = array:Length()
    print(string.format("array length = %d", length))

    local index = array:AddUnique(1)
    print(string.format("array add unique 1 then return index = %d", index))
    print_array(array)

    array:Remove(2)
    print_array(array)

    array:RemoveItem(1)
    print_array(array)

    array:Insert(4,2)
    print_array(array)

    for i = 1,5 do
        array:Insert(i, array:Num())
    end
    print_array(array)

    array:Shuffle()
    print_array(array)

    array:Clear()
    print_array(array)
end

local function SetTest()
    local set = UE.TSet(0)
    print_set(set)

    set:Add(1)
    set:Add(2)
    print_set(set)

    for i = 1,5 do
        set:Add(i)
    end
    print_set(set)

    local length = set:Length()
    print(string.format("set length = %d", length))

    if set:Contains(6) == true then
        print("set contain 6")
    else
        print("set doesn't contain 6")
    end
    
    set:Clear()
    print_set(set)
end

local function MapTest()
    local map = UE.TMap(0, "")
    print_map(map)

    map:Add(1, "zhangsan")
    map:Add(2, "lisi")
    print_map(map)

    local ret = map:Find(2)
    print(ret)

    map:Remove(2)
    print_map(map)

    map:Add(3, "wangwu")
    map:Add(4, "zhangsan")
    print_map(map)
end

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_5", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    -- ArrayTest()
    -- SetTest()
    MapTest()
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
