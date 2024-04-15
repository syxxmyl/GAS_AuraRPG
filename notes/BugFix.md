# Beacon被Overlap的时候会报错

## 原因

```
LogMaterial: Warning: MaterialInstanceDynamic /Game/Maps/UEDPIE_0_Dungeon_1.Dungeon_1:PersistentLevel.BP_Beacon_C_0. MaterialInstanceDynamic_0 is not a valid parent for MaterialInstanceDynamic /Game/Maps/UEDPIE_0_Dungeon_1.Dungeon_1:PersistentLevel.BP_Beacon_C_0.MaterialInstanceDynamic_1.  Only Materials and MaterialInstanceConstants are valid parents for a material instance.  Outer is BP_Beacon_C_0
```



因为` void ACheckpoint::HandleGlowEffects() `的时候会

```cpp
UMaterialInstanceDynamic* DynamicMaterialInstance = UMaterialInstanceDynamic::Create(CheckpointMesh->GetMaterial(0), this);
```

如果`CheckpointMesh->GetMaterial(0)`已经被替换成`UMaterialInstanceDynamic`类型的了就会失败



## 解决方案

加个` bHandleGlowEffect  `，默认为false，第一次执行` HandleGlowEffects `的时候置为true，之后每次执行的时候判断下如果是true了就不执行后面的内容





# 远程敌人进行的是近战攻击

## 原因

 `BT_EnemyBehaviorTree`里攻击和移动的执行先后顺序不对，改成在攻击范围内后先攻击再移动到下次攻击的位置

近战的判断不够准确，判断下如果不是RangedAttacker才近战攻击



## 解决方案

原因的内容改一下





# FireBolt的飞行轨迹不太对

## 原因

速度参数不合适



## 解决方案

`BP_FireBolt`里把`Initial Speed`和`Max Speed`改成750

`GA_FireBolt`里把`Homing Acceleration`的范围改到(8000, 10000)





