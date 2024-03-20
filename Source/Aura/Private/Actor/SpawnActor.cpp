// Copyright syxxmyl


#include "Actor/SpawnActor.h"


ASpawnActor::ASpawnActor()
{
	PrimaryActorTick.bCanEverTick = true;

}

// Called when the game starts or when spawned
void ASpawnActor::BeginPlay()
{
	Super::BeginPlay();
	
	if (HasAuthority())
	{
		GetWorldTimerManager().SetTimer(SpawnTimerHandle, this, &ASpawnActor::SpawnActor, IntervalTimeSecond, true);
	}
}

void ASpawnActor::SpawnActor()
{
	AActor* SpawnActor = GetWorld()->SpawnActor<AActor>(SpawnActorClass, GetActorLocation(), GetActorRotation());
}
