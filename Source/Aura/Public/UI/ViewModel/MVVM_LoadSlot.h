// Copyright syxxmyl

#pragma once

#include "CoreMinimal.h"
#include "MVVMViewModelBase.h"
#include "Game/LoadScreenSaveGame.h"
#include "MVVM_LoadSlot.generated.h"


DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FSetWidgetSwitcherIndex, int32, WidgetSwitcherIndex);
DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam(FEnableSelectSlotButton, bool, bEnable);


/**
 * 
 */
UCLASS()
class AURA_API UMVVM_LoadSlot : public UMVVMViewModelBase
{
	GENERATED_BODY()
	
public:
	void InitializeSlot();

	UPROPERTY()
	FString LoadSlotName;

	UPROPERTY()
	FString SlotIndex;

	UPROPERTY()
	TEnumAsByte<ESaveSlotStatus> SlotStatus;

	/*
	* Field Notifies 
	*/

	UPROPERTY(EditAnywhere, BlueprintReadWrite, FieldNotify, Setter, Getter);
	FString PlayerName;

	void SetPlayerName(FString InPlayerName);

	FString GetPlayerName() const { return PlayerName; }

	/*
	* Delegates
	*/

	UPROPERTY(BlueprintAssignable)
	FSetWidgetSwitcherIndex SetWidgetSwitcherIndex;

	UPROPERTY(BlueprintAssignable)
	FEnableSelectSlotButton EnableSelectSlotButton;
};
