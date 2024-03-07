// Copyright syxxmyl


#include "AbilitySystem/AbilityTasks/TargetDataUnderMouse.h"


UTargetDataUnderMouse* UTargetDataUnderMouse::CreateTargetDataUnderMouse(UGameplayAbility* OwningAbility)
{
	UTargetDataUnderMouse* MyObj = NewAbilityTask<UTargetDataUnderMouse>(OwningAbility);
	return MyObj;
}

void UTargetDataUnderMouse::Activate()
{
	if (APlayerController* PC = Ability->GetCurrentActorInfo()->PlayerController.Get())
	{
		FHitResult CursorHit;
		if (PC->GetHitResultUnderCursor(ECC_Visibility, false, CursorHit))
		{
			ValidData.Broadcast(CursorHit.Location);
		}
	}
}
