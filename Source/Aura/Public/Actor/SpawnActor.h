// Copyright syxxmyl

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "SpawnActor.generated.h"

UCLASS()
class AURA_API ASpawnActor : public AActor
{
	GENERATED_BODY()
	
public:	
	ASpawnActor();

protected:
	virtual void BeginPlay() override;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	TSubclassOf<AActor> SpawnActorClass;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	float IntervalTimeSecond = 10.0f;

	FTimerHandle SpawnTimerHandle;

	void SpawnActor();
};
