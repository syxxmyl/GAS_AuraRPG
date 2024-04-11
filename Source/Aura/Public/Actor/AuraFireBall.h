// Copyright syxxmyl

#pragma once

#include "CoreMinimal.h"
#include "Actor/AuraProjectile.h"
#include "AuraFireBall.generated.h"

/**
 * 
 */
UCLASS()
class AURA_API AAuraFireBall : public AAuraProjectile
{
	GENERATED_BODY()
public:
	UFUNCTION(BlueprintImplementableEvent)
	void StartOutgoingTimeline();

	UPROPERTY(BlueprintReadOnly)
	TObjectPtr<AActor> ReturnToActor;

	UPROPERTY(BlueprintReadWrite)
	FDamageEffectParams ExplosionDamageParams;

	UFUNCTION(BlueprintCallable)
	void ApplyExplosionDamage();

protected:
	virtual void BeginPlay() override;
	virtual void OnSphereOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor, UPrimitiveComponent* OtherComp, int32 OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult) override;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category = "Explosion")
	float RadialDamageInnerRadius = 50.0f;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category = "Explosion")
	float RadialDamageOuterRadius = 300.0f;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category = "Explosion")
	float KnockbackMagnitude = 800.0f;

	UPROPERTY(EditDefaultsOnly, BlueprintReadOnly, Category = "Explosion")
	float DeathImpulseMagnitude = 800.0f;
};
