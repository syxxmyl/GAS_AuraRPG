--
-- DESCRIPTION
--
-- @COMPANY **
-- @AUTHOR **
-- @DATE ${date} ${time}
--

---@type BP_AuraPlayerController_C

local Screen = require('Screen')
local BindKey = UnLua.Input.BindKey
local BindAction = UnLua.Input.BindAction
local EnhancedBindAction = UnLua.EnhancedInput.BindAction

local M = UnLua.Class()

-- function M:Initialize(Initializer)
-- end

-- function M:UserConstructionScript()
-- end

-- function M:ReceiveBeginPlay()
-- end

-- function M:ReceiveEndPlay()
-- end

-- function M:ReceiveTick(DeltaSeconds)
-- end

-- function M:ReceiveAnyDamage(Damage, DamageType, InstigatedBy, DamageCauser)
-- end

-- function M:ReceiveActorBeginOverlap(OtherActor)
-- end

-- function M:ReceiveActorEndOverlap(OtherActor)
-- end

M["W_Pressed"] = function(self, key)
    -- local msg = string.format("press %s.", key.KeyName)
    -- Screen.Print(msg)
end

M["W_Released"] = function(self, key)
    -- local msg = string.format("release %s.", key.KeyName)
    -- Screen.Print(msg)
end

function M:A_Pressed(key)
    -- local msg = string.format("press %s.", key.KeyName)
    -- print(msg)
    -- Screen.Print(msg)
end

function M:A_Released(key)
    -- local msg = string.format("release %s.", key.KeyName)
    -- print(msg)
    -- Screen.Print(msg)
end

BindKey(M, "D", "Pressed", function(self, key)
    -- Screen.Print("Press D")
end)

BindKey(M, "D", "Pressed", function(self, key)
    -- Screen.Print("Press Ctrl+D")
end, {Ctrl = true})


EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_1", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    local World = self:GetWorld()
    local SpawnClass = self.TestSpawnClass
    local Transform = self:GetTransform()
    local SpawnActor = World:SpawnActor(SpawnClass, Transform, UE.ESpawnActorCollisionHandlingMethod.AdjustIfPossibleButAlwaysSpawn, self, self)
    print(SpawnActor:SayHi("Spawn Success"))
end)

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_2", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
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
