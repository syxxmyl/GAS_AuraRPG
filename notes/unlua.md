# 安装

https://github.com/Tencent/UnLua clone一份项目，把Plugins目录下的内容复制一份粘到项目根目录下

右击`.uproject`选择`Generate Visual Studio project files`

打开项目



# vscode的智能提示

## 生成智能提示信息

UnLua工具栏点击后选择`Generate IntelliSense`

## 在VSCode里的workspace里加上刚才生成的智能提示信息

```json
{
	"folders": [
		{
			"path": "Content/Script"
		},
		{
			"path": "Plugins/UnLua/Intermediate/IntelliSense"
		}
	],
	"settings": {}
}
```



# 测试使用

## 01_HelloWorld

### 创建`BP_TestUnluaActor`

继承自AActor

在菜单栏的UnLua里点击`Bind`

在`Interfaces`->`GetModuleName`里的`ReturnNode`的`ReturnValue`填上这个脚本模块的名字，这里填个`TestUnluaActor`

Compile之后Save



### 生成TestUnluaActor的Lua模板代码

在菜单栏的UnLua里点击`Create Lua Template`



### 仿照案例加个`Screen.lua`

调用`UKismetSystemLibrary`的`PrintString`方法

```lua
local M = {}

local PrintString = UE.UKismetSystemLibrary.PrintString

function M.Print(text, color, duration)
    color = color or UE.FLinearColor(1,1,1,1)
    duration = duration or 10
    PrintString(nil, text, true, false, color, duration)
end

return M
```



### 在`TestUnluaActor.lua`里写点逻辑

```lua
---@type BP_TestUnluaActor_C

local Screen = require('Screen')

local M = UnLua.Class()

function M:Initialize(Initializer)
    local msg = [[
        Test Unlua Actor Initialize!
    ]]

    print(msg)
    Screen.Print(msg)
end

function M:ReceiveBeginPlay()
    local msg = [[
        Test Unlua Actor BeginPlay!
    ]]

    print(msg)
    Screen.Print(msg)
end

function M:ReceiveTick(DeltaSeconds)
    local msg = [[
        Test Unlua Actor ReceiveTick!
    ]]
    print(msg)
    Screen.Print(msg)
end

return M
```



### 创建`TestUnluaMap.umap`

用来测试，拖个`BP_TestUnluaActor`到Level里



## 02_OverrideBlueprintEvents

覆盖蓝图事件

```lua
覆盖蓝图事件时，只需要在返回的table中声明 Receive{EventName}

例如：
    function M:ReceiveBeginPlay()
    end

除了蓝图事件可以覆盖，也可以直接声明 {FunctionName} 来覆盖Function。
如果需要调用被覆盖的蓝图Function，可以通过 self.Overridden.{FunctionName}(self, ...) 来访问
        
例如：
    function M:SayHi(name)
        self.Overridden.SayHi(self, name)
    end
        
注意：这里不可以写成 self.Overridden:SayHi(name)
```



### 在`BP_TestUnluaActor`里处理

蓝图里加个Function命名为SayHi，函数的作用是返回一个字符串

### 在`TestUnluaActor.lua`里处理

在lua里直接声明`SayHi`来覆盖一下SayHi这个定义在蓝图里的Function，并在lua里调用被覆盖的SayHi

然后在`ReceiveBeginPlay`覆盖蓝图事件的时候调用一下SayHi

```lua
function M:ReceiveBeginPlay()
    local msg = self:SayHi("tom")
    print(msg)
    Screen.Print(msg)
end

function M:SayHi(name)
    local msg = self.Overridden.SayHi(self, name)
    return msg .. "\n\n" .. [[
        Text from Unlua
    ]]
end
```



## 03_BindInputs

绑定输入映射

```lua
需要监听按键或Action时，只需要在返回的table中声明 {KeyName}_Pressed / {KeyName}_Released

例如：
    function M:SpaceBar_Pressed()
    end

使用UnLua.Input.BindXXX接口可以实现更细节的输入绑定控制
更多请参考：
    UnLua\Plugins\UnLua\Content\Script\UnLua\Input.lua
```



### 看下`Input.lua`

```lua
--- 为当前模块绑定按键输入响应
---@param Module table @需要绑定的lua模块
---@param KeyName string @绑定的按键名称，参考EKeys下的命名
---@param KeyEvent string @绑定的事件名称，参考EInputEvent下的命名，不需要 “IE_” 前缀
---@param Handler fun(Key:FKey) @事件响应回调函数
---@param Args table @[opt]扩展参数 使用 Ctrl/Shift/Alt/Cmd = true 来控制组合键
function M.BindKey(Module, KeyName, KeyEvent, Handler, Args)
	--
end

--- 为当前模块绑定操作输入响应
---@param Module table @需要绑定的lua模块
---@param ActionName string @绑定的操作名称，对应 “项目设置->输入” 中设置的命名
---@param KeyEvent string @绑定的事件名称，参考EInputEvent下的命名，不需要 “IE_” 前缀
---@param Handler fun(Key:FKey) @事件响应回调函数
---@param Args table @[opt]扩展参数
function M.BindAction(Module, ActionName, KeyEvent, Handler, Args)
    --
end

--- 为当前模块绑定轴输入响应
---@param Module table @需要绑定的lua模块
---@param AxisName string @绑定的轴名称，对应 “项目设置->输入” 中设置的命名
---@param Handler fun(AxisValue:number) @事件响应回调函数
---@param Args table @[opt]扩展参数
function M.BindAxis(Module, AxisName, Handler, Args)
    --
end
```



调用的分别是`UnLuaManager.h`里的

```cpp
UFUNCTION(BlueprintImplementableEvent)
void InputAction(FKey Key);

UFUNCTION(BlueprintImplementableEvent)
void InputAxis(float AxisValue);
```

要注意绑定函数的参数类型



### 给`AuraPlayerController`绑定lua脚本

因为输入是放在AuraPlayerController里做的

```lua
local Screen = require('Screen')
local BindKey = UnLua.Input.BindKey

M["W_Pressed"] = function(self, key)
    local msg = string.format("press %s.", key.KeyName)
    Screen.Print(msg)
end

M["W_Released"] = function(self, key)
    local msg = string.format("release %s.", key.KeyName)
    Screen.Print(msg)
end

function M:A_Pressed(key)
    local msg = string.format("press %s.", key.KeyName)
    print(msg)
    Screen.Print(msg)
end

function M:A_Released(key)
    local msg = string.format("release %s.", key.KeyName)
    print(msg)
    Screen.Print(msg)
end

BindKey(M, "D", "Pressed", function(self, key)
    Screen.Print("Press D")
end)

BindKey(M, "D", "Pressed", function(self, key)
    Screen.Print("Press Ctrl+D")
end, {Ctrl = true})
```



### 关于EnhancedInput增强输入相关的内容

`Content\Script\UnLua\EnhancedInput.lua`



#### 写增强输入遇到的问题

没注意绑定函数的入参是什么，统一复制粘贴的FKey.KeyName，结果报错了

后来去`Source\UnLua\Public\UnLuaManager.h`里看了下

```cpp
UFUNCTION(BlueprintImplementableEvent)
void EnhancedInputActionDigital(bool ActionValue, float ElapsedSeconds, float TriggeredSeconds);

UFUNCTION(BlueprintImplementableEvent)
void EnhancedInputActionAxis1D(float ActionValue, float ElapsedSeconds, float TriggeredSeconds);

UFUNCTION(BlueprintImplementableEvent)
void EnhancedInputActionAxis2D(const FVector2D& ActionValue, float ElapsedSeconds, float TriggeredSeconds);

UFUNCTION(BlueprintImplementableEvent)
void EnhancedInputActionAxis3D(const FVector& ActionValue, float ElapsedSeconds, float TriggeredSeconds);
```



#### 照葫芦画瓢一下在`AuraPlayerController.lua`里绑定一下看看效果

```lua
EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_1", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    print(string.format("EnhancedInput IA_1 ElapsedSeconds=%s.", ElapsedSeconds))
    print(string.format("EnhancedInput IA_1 TriggeredSeconds=%s.", TriggeredSeconds))
    local msg = string.format("EnhancedInput IA_1 Started Value=%s.", ActionValue)
    print(msg)
    Screen.Print(msg)
end)

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_Move", "Triggered", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    print(string.format("EnhancedInput IA_Move ElapsedSeconds=%s.", ElapsedSeconds))
    print(string.format("EnhancedInput IA_Move TriggeredSeconds=%s.", TriggeredSeconds))
    local msg = string.format("EnhancedInput IA_Move Triggered X=%s, Y=%s.", ActionValue.X, ActionValue.Y)
    print(msg)
    Screen.Print(msg)
end)
```





## 04_DynamicBinding

除了实现 UnLuaInterface 的静态绑定方式外，还可以在运行时动态绑定对象到Lua

### 对于 Actor 类，可以使用 SpawnActor 接口

```lua
World:SpawnActor(SpawnClass, Transform, AlwaysSpawn, self, self, "Tutorials.GravitySphereActor")
```

`UnLua\Source\UnLua\Private\BaseLib\LuaLib_World.cpp`里看一下

```cpp
/**
 * Spawn an actor.
 * for example:
 * World:SpawnActor(
 *  WeaponClass, InitialTransform, ESpawnActorCollisionHandlingMethod.AlwaysSpawn,
 *  OwnerActor, Instigator, "Weapon.AK47_C", WeaponColor, ULevel, Name
 * )
 * the last four parameters "Weapon.AK47_C", 'WeaponColor', ULevel and Name are optional.
 * see programming guide for detail.
 */
static int32 UWorld_SpawnActor(lua_State* L)
```



### 对于非 Actor 类，可以使用 NewObject 接口

```lua
NewObject(WidgetClass, self, nil, "Tutorials.IconWidget")
```



`UnLua\Source\UnLua\Private\UELib.cpp`里看一下

```cpp
static int32 Global_NewObject(lua_State *L)
```



### 创建一个`WBP_TestWidget`

一个文本框加俩按钮，实现一个`AdjustPositionInViewport`蓝图函数

用`SetPositionInViewport`更新在viewport下的Position，X用`(GetViewportSize.X - SizeBox.WidthOverride) / 2`，Y用`(GetViewportSize.Y - SizeBox.HeightOverride) / 2`



### 在`BP_AuraPlayerController`里加两个变量用来配置Spawn的ActorClass和WidgetClass

`TestSpawnClass`用前面的`BP_TestUnluaActor`

`TestSpawnWidget`用刚才创建的`WBP_TestWidget`



### 接着用AuraPlayerController的EnhancedInput来测试

按下`Key 1`可以`SpawnActor`

按下`Key 2`可以`NewObject`

```lua
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
```

























































