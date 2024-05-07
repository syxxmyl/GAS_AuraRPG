# Project Features
- **Multiplayer support** for almost all features(save/load progress except)
- Using Unreal Engine's **Gameplay Ability System** to architect a Top-Down RPG
  - **Custom Gameplay Ability System Component**
  - **Attribute Set**
    - Primary Attributes
    - Secondary Attributes
    - Vital Attributes
    - Meta Attributes
  - **Gameplay Tags**
    - Create a static-singleton-class to manage
  - **Gameplay Ability**
    - Offensive Spells
    - Passive Spells
  - **Custom Ability Task**
  - **Gameplay Effect**
    - Apply changes to Attributes
    - Handle Ability's Cost and Cooldown
    - **Custom Gameplay Effect Context**
    - **Custom Modifier Magnitude Calculations**
    - **Custom Execution Calculations**
  - **Gameplay Cue**
    - GameplayCueNotify_Static
    - GameplayCueNotify_Burst
    - GameplayCueNotify_Actor
  - **Custom Ability System Library**, provide convenience functions for blueprints and other cpp class
- Monster AI
  - Custom Service and Task
  - Use **BehaviorTree** and **EQS** to Design  customized  behaviors for different types of monsters
- UI
  - MVC based
    - **Attribute Menu**, show attribute informations and using attribute points to upgrade primary arrtibutes
    - **Spell Menu**, show spell informations, change ability input slot and using spell points to unlock or upgrade spells
    - Other widgets inherit from `UAuraUserWidget`  
  - MVVM based
    - **Load Menu**, handle player create a new game data or load old game data
- Enhanced Input
  - InputAction
  - InputMappingContext
- Different types of character class
  - Melee
  - Ranged
  - Elementalist
- Character Move
  - Mouse-clicked
  - Auto move to target location when release mouse
-  **Experience and Level-Up System**, awarding XP from monsters and leveling up when gain enough XP,all display in the HUD
- **Debuff**
- Custom Async Tasks
- Saving/Load Progress(Standalone only)
- **Enemy and item selection** with outline effects
- **Fading geometry** when it gets in the way of the camera for a top-down game
- **Level Transitions**
- LootItems
- Custom AnimNotify





# Unreal Engine 5.2

**Game Assets:** Licensed for use with the Unreal Engine only. Without a custom license you cannot use to create sequels, remasters, or otherwise emulate the original game or use the original game’s trademarks, character names, or other IP to advertise or name your game. (Unreal Engine EULA applies) 

