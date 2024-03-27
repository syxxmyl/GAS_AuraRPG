// Copyright syxxmyl


#include "AbilitySystem/Data/LevelUpInfo.h"


int32 ULevelUpInfo::FindLevelForXP(int32 XP) const
{
	int32 Level = 1;
	bool bSearching = true;
	while (bSearching)
	{
		if (LevelUpInformation.Num() - 1 <= Level)
		{
			return Level;
		}

		if (XP >= LevelUpInformation[Level].LevelUpRequirement)
		{
			Level += 1;
		}
		else
		{
			bSearching = false;
		}

	}

	return Level;
}
