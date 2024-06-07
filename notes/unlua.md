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



## 05_BindDelegates

可以通过对委托原生接口的调用，完成对UI事件的监听

### 给`WBP_TestWidget`添加对应的绑定的lua文件

在编辑器里的`Graph->Interfaces`填入lua的文件名，然后生成lua文件

执行`Construct`给`TextBlock_Title`设置一下文本，然后给两个按钮绑定上`OnClicked`事件，最后调用`UE.UKismetSystemLibrary.K2_SetTimerDelegate`创建一个Timer每1秒执行一次`OnTimer`函数

`OnTimer`每次执行的时候更新一下`TextBlock_Message`的文本

执行`Destruct`的时候把绑定的委托都取消绑定，TimerHandle也都Clear掉

```lua
function M:Construct()
    self.TextBlock_Title:SetText("Test Widget")

    self.Button_No.Button.OnClicked:Add(self, self.OnNoButtonClicked)
    self.Button_Yes.Button.OnClicked:Add(self, self.OnYesButtonClicked)

    self.TimerHandle = UE.UKismetSystemLibrary.K2_SetTimerDelegate({self, self.OnTimer}, 1, true)
    self:OnTimer()
end

function M:OnNoButtonClicked()
    Screen.Print("NoButtonClicked")
    self:RemoveFromParent()
end

function M:OnYesButtonClicked()
    Screen.Print("YesButtonClicked")
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
```



### 加两个单独的按键输入映射`IA_5`和`IA_6`用来测试使用

不要和之前项目里的内容用同一个按键





## 06_NativeContainers

创建原生容器时通常需要指定参数类型，来确定容器内存放的数据类型

```cpp
参数类型        示例             实际类型
boolean        true             Boolean
number         0                Interger
string         ""               String
table          FVector          Vector
userdata       FVector(1,1,1)   Vector
```



```lua
local array = TArray({ElementType})
local set = TSet({ElementType})
local map = TMap({KeyType}, {ValueType})
```

创建完成后，和原来的原生容器类型使用方式是相同的，更多接口可以参考源码：

```lua
TArray      Plugins\UnLua\Source\UnLua\Private\BaseLib\LuaLib_Array.cpp

TSet        Plugins\UnLua\Source\UnLua\Private\BaseLib\LuaLib_Set.cpp

TMap        Plugins\UnLua\Source\UnLua\Private\BaseLib\LuaLib_Map.cpp
```



```cpp
static const luaL_Reg TArrayLib[] =
{
    {"Length", TArray_Length},
    {"Num", TArray_Length},
    {"Add", TArray_Add},
    {"AddUnique", TArray_AddUnique},
    {"Find", TArray_Find},
    {"Insert", TArray_Insert},
    {"Remove", TArray_Remove},
    {"RemoveItem", TArray_RemoveItem},
    {"Clear", TArray_Clear},
    {"Reserve", TArray_Reserve},
    {"Resize", TArray_Resize},
    {"GetData", TArray_GetData},
    {"Get", TArray_Get},
    {"GetRef", TArray_GetRef},
    {"Set", TArray_Set},
    {"Swap", TArray_Swap},
    {"Shuffle", TArray_Shuffle},
    {"LastIndex", TArray_LastIndex},
    {"IsValidIndex", TArray_IsValidIndex},
    {"Contains", TArray_Contains},
    {"Append", TArray_Append},
    {"ToTable", TArray_ToTable},
    {"__gc", TArray_Delete},
    {"__call", TArray_New},
    {"__pairs", TArray_Pairs},
    {"__index", TArray_Index},
    {"__newindex", TArray_NewIndex},
    {nullptr, nullptr}
};
```



```cpp
static const luaL_Reg TSetLib[] =
{
    {"Length", TSet_Length},
    {"Num", TSet_Length},
    {"Add", TSet_Add},
    {"Remove", TSet_Remove},
    {"Contains", TSet_Contains},
    {"Clear", TSet_Clear},
    {"ToArray", TSet_ToArray},
    {"ToTable", TSet_ToTable},
    {"__gc", TSet_Delete},
    {"__call", TSet_New},
    {nullptr, nullptr}
};
```



```cpp
static const luaL_Reg TMapLib[] =
{
    {"Length", TMap_Length},
    {"Num", TMap_Length},
    {"Add", TMap_Add},
    {"Remove", TMap_Remove},
    {"Find", TMap_Find},
    {"FindRef", TMap_FindRef},
    {"Clear", TMap_Clear},
    {"Keys", TMap_Keys},
    {"Values", TMap_Values},
    {"ToTable", TMap_ToTable},
    {"__gc", TMap_Delete},
    {"__call", TMap_New},
    {"__pairs", TMap_Pairs},
    {nullptr, nullptr}
};
```



### 加个新的`Common.lua`用来写输出容器的部分

```lua
function print_array(array)
    local ret = {}
    for i = 1, array:Length() do
        table.insert(ret, array:Get(i))
    end
    print("[" .. table.concat(ret, ",") .. "]")
end

function print_set(set)
    local array = set:ToArray()
    local ret = {}
    for i = 1, array:Length() do
        table.insert(ret, array:Get(i))
    end
    print("(" .. table.concat(ret, ",") .. ")")
end

function print_map(map)
    local ret = {}
    local keys = map:Keys()

    for i = 1, keys:Length() do
        local key = keys:Get(i)
        local val = map:Find(key)
        table.insert(ret, key .. ":" .. tostring(val))
    end

    print("{" .. table.concat(ret, ",") .. "}")
end
```



### 继续在`AuraPlayerController.lua`里用输入映射测试

```lua
require('Common')

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
```



## 07_CallLatentFunction

在Lua协程中可以方便的使用UE的Delay函数实现延迟执行的效果

### 加个`Test.lua`用来存各种学习用的代码

把前面的array、set、map的内容也挪过去

```lua
local function task(context, name)
    Screen.Print(string.format('coroutine %s begin', name))

    for i = 1,5 do
        UE.UKismetSystemLibrary.Delay(context, 1)
        Screen.Print(string.format('coroutine %s print %d', name, i))
    end

    Screen.Print(string.format('coroutine %s end', name))
end

function CoroutineTest(context)
    coroutine.resume(coroutine.create(task), context, 'A')
    coroutine.resume(coroutine.create(task), context, 'B')
end
```



### 在`AuraPlayerController.lua`里处理

改成用`Test.lua`里的内容

```lua
require('Test.Test')

EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_5", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    -- ArrayTest()
    -- SetTest()
    -- MapTest()
    CoroutineTest(self)
end)
```





## 08_CppCallLua

在cpp里调用lua里写的函数

如果需要从C++侧调用Lua，需要将UnLua模块添加到 {工程名}.Build.cs 的依赖配置里

```cpp
PrivateDependencyModuleNames.AddRange(new string[] { "UnLua", "Lua" });
```



### 修改`Test.lua`的内容

用`UnLua.Class()`创建一个Table，用来支持在cpp里通过LuaTable调用函数

```lua
local M = UnLua.Class()

function M.CppCallLuaTest(a, b)
    local ret = a + b
    Screen.Print(string.format('LuaSide calculate a = %f, b = %f, a + b = %f', a, b, ret))
    return ret
end

return M
```



### 接着用`AuraPlayerController.lua`里的输入做触发

```lua
EnhancedBindAction(M, "/Game/Blueprints/Input/InputActions/IA_5", "Started", function(self, ActionValue, ElapsedSeconds, TriggeredSeconds)
    -- ArrayTest()
    -- SetTest()
    -- MapTest()
    -- CoroutineTest(self)
    UE.UAuraAbilitySystemLibrary.CallLuaByGlobalTable()
    UE.UAuraAbilitySystemLibrary.CallLuaByFLuaTable()
end)
```



### 在`AuraAbilitySystemLibrary`加俩函数用来处理cpp调用lua

一种是通过`UnLua::CallTableFunc`用`GlobalTable`调用lua函数

另一种是先拿到`Require`的`LuaTable`，然后调用`LuaTable.Call`调用lua函数

```cpp
public:
	UFUNCTION(BlueprintCallable, Category = "AuraAbilitySystemLibrary|TestUnlua")
	static void CallLuaByGlobalTable();

	UFUNCTION(BlueprintCallable, Category = "AuraAbilitySystemLibrary|TestUnlua")
	static void CallLuaByFLuaTable();
```



```cpp
#include "UnLua.h"
#include "Kismet/KismetSystemLibrary.h"

void UAuraAbilitySystemLibrary::CallLuaByGlobalTable()
{
	UnLua::FLuaEnv Env;
	const bool bSuccess = Env.DoString("G_TestTable = require 'Test.Test'");
	check(bSuccess);

	const UnLua::FLuaRetValues RetValues = UnLua::CallTableFunc(Env.GetMainState(), "G_TestTable", "CppCallLuaTest", 1.2f, 3.4f);
	
	check(RetValues.Num() == 1);

	UKismetSystemLibrary::PrintString(
		nullptr, 
		FString::Printf(TEXT("CppSide CallLuaByGlobalTable receive ret from lua value = %f"), RetValues[0].Value<float>()), 
		true, 
		false, 
		FLinearColor(1.0f,1.0f,1.0f),
		10
	);
	
}

void UAuraAbilitySystemLibrary::CallLuaByFLuaTable()
{
	UnLua::FLuaEnv Env;
	const UnLua::FLuaFunction Require = UnLua::FLuaFunction(&Env, "_G", "require");
	const UnLua::FLuaRetValues RequireRetValues = Require.Call("Test.Test");
	check(RequireRetValues.Num() == 2);

	const UnLua::FLuaValue RequireRetValue = RequireRetValues[0];
	const UnLua::FLuaTable LuaTable =  UnLua::FLuaTable(&Env, RequireRetValue);
	const UnLua::FLuaRetValues RetValues = LuaTable.Call("CppCallLuaTest", 1.2f, 3.4f);
	check(RetValues.Num() == 1);

	UKismetSystemLibrary::PrintString(
		nullptr,
		FString::Printf(TEXT("CppSide CallLuaByFLuaTable receive ret from lua value = %f"), RetValues[0].Value<float>()),
		true,
		false,
		FLinearColor(1.0f, 1.0f, 1.0f),
		10
	);
}
```



























