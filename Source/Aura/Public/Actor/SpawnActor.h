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
	TMap<TSubclassOf<AActor>, float> SpawnActorClassAndWeight;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	float IntervalSpawnTimeSecond = 10.0f;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	int32 MaxSpawnAliveCount = 10;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	float SpawnSpread = 90.0f;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	float MinSpawnDistance = 0.0f;

	UPROPERTY(EditAnywhere, Category = "Spawn")
	float MaxSpawnDistance = 100.0f;

	FTimerHandle SpawnTimerHandle;

	UPROPERTY(BlueprintReadOnly, Category = "Spawn")
	TArray<AActor*> AliveActors;

private:
	UFUNCTION()
	void SpawnActor();

	UFUNCTION()
	void OnActorDestroyed(AActor* DestroyedActor);

	UFUNCTION(BlueprintCallable, Category = "Spawn")
	TSubclassOf<AActor> GetRandomSpawnActor();

	void InitializeData();

	float TotalSpawnWeight = 0.0f;
};
