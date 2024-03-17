// Copyright syxxmyl


#include "AI/BTService_FindNearestPlayer.h"
#include "AIController.h"
#include "Kismet/GameplayStatics.h"


void UBTService_FindNearestPlayer::TickNode(UBehaviorTreeComponent& OwnerComp, uint8* NodeMemory, float DeltaSeconds)
{
	Super::TickNode(OwnerComp, NodeMemory, DeltaSeconds);

	// GEngine->AddOnScreenDebugMessage(1, 1.f, FColor::Red, *AIOwner->GetName());
	// GEngine->AddOnScreenDebugMessage(2, 1.f, FColor::Green, *ActorOwner->GetName());

	if (APawn* OwningPawn = AIOwner->GetPawn())
	{
		const FName TargetTag = OwningPawn->ActorHasTag(FName("Player")) ? FName("Enemy") : FName("Player");
		TArray<AActor*> ActorsWithTag;
		UGameplayStatics::GetAllActorsWithTag(OwningPawn, TargetTag, ActorsWithTag);
	}


}
