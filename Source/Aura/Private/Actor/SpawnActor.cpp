// Copyright syxxmyl


#include "Actor/SpawnActor.h"
#include "Interaction/CombatInterface.h"
#include "Character/AuraCharacterBase.h"
// #include "Kismet/KismetSystemLibrary.h"


ASpawnActor::ASpawnActor()
{
	PrimaryActorTick.bCanEverTick = true;
	AliveActors.Reserve(MaxSpawnAliveCount);
}

// Called when the game starts or when spawned
void ASpawnActor::BeginPlay()
{
	Super::BeginPlay();
	InitializeData();
	if (HasAuthority())
	{
		GetWorldTimerManager().SetTimer(SpawnTimerHandle, this, &ASpawnActor::SpawnActor, IntervalSpawnTimeSecond, true);
	}
}

void ASpawnActor::InitializeData()
{
	for (auto& Pair : SpawnActorClassAndWeight)
	{
		TotalSpawnWeight += Pair.Value;
	}

	SpawnActorClassAndWeight.ValueSort(
		[](float A, float B)
		{
			return A < B;
		}
	);	
}

void ASpawnActor::SpawnActor()
{
	if (AliveActors.Num() >= MaxSpawnAliveCount)
	{
		return;
	}

	TSubclassOf<AActor> SpawnActorClass = GetRandomSpawnActor();
	if (!SpawnActorClass)
	{
		return;
	}

	FVector LookAtLocation = this->GetActorForwardVector();
	FVector LeftOfSpread = LookAtLocation.RotateAngleAxis(SpawnSpread / 2.0f, FVector::UpVector);
	FVector RightOfSpread = LookAtLocation.RotateAngleAxis(-SpawnSpread / 2.0f, FVector::UpVector);
	FVector StartupRotation = LeftOfSpread.RotateAngleAxis(-FMath::FRandRange(0.0f, SpawnSpread), FVector::UpVector);
	FVector FVectorStartupLocation = GetActorLocation() + StartupRotation * FMath::RandRange(MinSpawnDistance, MaxSpawnDistance);

	FHitResult Hit;
	GetWorld()->LineTraceSingleByChannel(
		Hit,
		FVectorStartupLocation + FVector(0.0f, 0.0f, 300.0f),
		FVectorStartupLocation + FVector(0.0f, 0.0f, -300.0f),
		ECC_Visibility
	);

	if (Hit.bBlockingHit)
	{
		FVectorStartupLocation.X = Hit.ImpactPoint.X;
		FVectorStartupLocation.Y = Hit.ImpactPoint.Y;
		FVectorStartupLocation.Z = Hit.ImpactPoint.Z + SpawnLocationZIncrement;
	}

	/*
	DrawDebugSphere(GetWorld(), FVectorStartupLocation, 18.0f, 12.0f, FColor::Cyan, false, 3.0f);
	UKismetSystemLibrary::DrawDebugArrow(this, GetActorLocation(), GetActorLocation() + StartupRotation * MaxSpawnDistance, 4.0f, FLinearColor::Green, 3.0f);
	UKismetSystemLibrary::DrawDebugArrow(this, GetActorLocation(), GetActorLocation() + LeftOfSpread * MaxSpawnDistance, 4.0f, FLinearColor::Blue, 3.0f);
	UKismetSystemLibrary::DrawDebugArrow(this, GetActorLocation(), GetActorLocation() + RightOfSpread * MaxSpawnDistance, 4.0f, FLinearColor::Blue, 3.0f);
	*/

	FActorSpawnParameters Parameter;
	Parameter.SpawnCollisionHandlingOverride = ESpawnActorCollisionHandlingMethod::AdjustIfPossibleButAlwaysSpawn;
	AActor* SpawnActor = GetWorld()->SpawnActor<AActor>(SpawnActorClass, FVectorStartupLocation, GetActorRotation(), Parameter);
	if (!SpawnActor)
	{
		return;
	}
	
	if (AAuraCharacterBase* AuraCharacter = Cast<AAuraCharacterBase>(SpawnActor))
	{
		AuraCharacter->CharacterDeadDelegate.AddDynamic(this, &ASpawnActor::OnActorDestroyed);
	}
	else
	{
		SpawnActor->OnDestroyed.AddDynamic(this, &ASpawnActor::OnActorDestroyed);
	}

	AliveActors.AddUnique(SpawnActor);
	
}

void ASpawnActor::OnActorDestroyed(AActor* DestroyedActor)
{
	AliveActors.Remove(DestroyedActor);
	// UE_LOG(LogTemp, Warning, TEXT("remain %d alive."), AliveActors.Num());
}

TSubclassOf<AActor> ASpawnActor::GetRandomSpawnActor()
{
	float RandomWeight = FMath::FRandRange(0, TotalSpawnWeight);
	for (auto& Pair : SpawnActorClassAndWeight)
	{
		if (RandomWeight < Pair.Value)
		{
			return Pair.Key;
		}
		else
		{
			RandomWeight -= Pair.Value;
		}
	}

	return nullptr;
}
