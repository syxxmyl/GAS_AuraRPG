// Copyright syxxmyl


#include "AbilitySystem/Data/CharacterClassInfo.h"


FCharacterClassDefaultInfo UCharacterClassInfo::GetClassDefaultInfo(ECharacterClass CharacterClass)
{
	return CharacterClassInfomation.FindChecked(CharacterClass);
}
