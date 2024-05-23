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

## 以官方案例01的HelloWorld为例

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





