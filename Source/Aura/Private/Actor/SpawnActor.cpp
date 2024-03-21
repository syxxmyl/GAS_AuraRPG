// Copyright syxxmyl


#include "Actor/SpawnActor.h"
#include "Interaction/CombatInterface.h"


ASpawnActor::ASpawnActor()
{
	PrimaryActorTick.bCanEverTick = true;
	AliveActors.Reserve(MaxSpawnAliveCount);
}

// Called when the game starts or when spawned
void ASpawnActor::BeginPlay()
{
	Super::BeginPlay();
	
	if (HasAuthority())
	{
		GetWorldTimerManager().SetTimer(SpawnTimerHandle, this, &ASpawnActor::SpawnActor, IntervalSpawnTimeSecond, true);
		GetWorldTimerManager().SetTimer(RefreshCountTimerHandle, this, &ASpawnActor::RefreshAlive, IntervalCheckCountTimeSecond, true);
	}
}

void ASpawnActor::SpawnActor()
{
	if (AliveActors.Num() >= MaxSpawnAliveCount)
	{
		return;
	}

	if (AActor* SpawnActor = GetWorld()->SpawnActor<AActor>(SpawnActorClass, GetActorLocation(), GetActorRotation()))
	{
		AliveActors.AddUnique(SpawnActor);
	}
}

void ASpawnActor::RefreshAlive()
{
	TArray<AActor*> RemoveActors;
	for (AActor* SpawnActor : AliveActors)
	{
		if (!IsValid(SpawnActor))
		{
			RemoveActors.AddUnique(SpawnActor);
			continue;
		}

		if (ICombatInterface::Execute_IsDead(SpawnActor))
		{
			RemoveActors.AddUnique(SpawnActor);
		}
	}

	for (AActor* SpawnActor : RemoveActors)
	{
		AliveActors.Remove(SpawnActor);
	}
}
