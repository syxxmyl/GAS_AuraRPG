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





































































































