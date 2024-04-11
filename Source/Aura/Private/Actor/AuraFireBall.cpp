// Copyright syxxmyl


#include "Actor/AuraFireBall.h"
#include "AbilitySystemBlueprintLibrary.h"
#include "AbilitySystem/AuraAbilitySystemLibrary.h"


void AAuraFireBall::ApplyExplosionDamage()
{
	FVector OriginLocation = GetActorLocation();
	UAuraAbilitySystemLibrary::SetIsRadialDamageEffectParam(ExplosionDamageParams, true, RadialDamageInnerRadius, RadialDamageOuterRadius, OriginLocation);
	TArray<AActor*> OverlappingActors;
	TArray<AActor*> IgnoreActors;
	IgnoreActors.Add(this);
	IgnoreActors.Add(GetOwner());
	UAuraAbilitySystemLibrary::GetLivePlayersWithinRadius(this, OverlappingActors, IgnoreActors, RadialDamageOuterRadius, OriginLocation);

	for (AActor* Actor : OverlappingActors)
	{
		FRotator Direction = (Actor->GetActorLocation() - OriginLocation).Rotation();
		FRotator KnockbackDirection = Direction;
		KnockbackDirection.Pitch = 45.0f;
		UAuraAbilitySystemLibrary::SetTargetEffectParamsASC(ExplosionDamageParams, UAbilitySystemBlueprintLibrary::GetAbilitySystemComponent(Actor));
		UAuraAbilitySystemLibrary::SetKnockbackDirection(ExplosionDamageParams, KnockbackDirection.Vector(), KnockbackMagnitude);
		UAuraAbilitySystemLibrary::SetDeathImpulseDirection(ExplosionDamageParams, Direction.Vector(), DeathImpulseMagnitude);
		UAuraAbilitySystemLibrary::ApplyDamageEffect(ExplosionDamageParams);
	}

	Destroy();
}

void AAuraFireBall::BeginPlay()
{
	Super::BeginPlay();

	StartOutgoingTimeline();
}

void AAuraFireBall::OnSphereOverlap(UPrimitiveComponent* OverlappedComponent, AActor* OtherActor, UPrimitiveComponent* OtherComp, int32 OtherBodyIndex, bool bFromSweep, const FHitResult& SweepResult)
{
	if (!IsValidOverlap(OtherActor))
	{
		return;
	}

	if (HasAuthority())
	{
		if (UAbilitySystemComponent* TargetASC = UAbilitySystemBlueprintLibrary::GetAbilitySystemComponent(OtherActor))
		{
			DamageEffectParams.DeathImpulse = DamageEffectParams.DeathImpulseMagnitude * GetActorForwardVector();
			DamageEffectParams.TargetAbilitySystemComponent = TargetASC;
			UAuraAbilitySystemLibrary::ApplyDamageEffect(DamageEffectParams);
		}
	}
}
