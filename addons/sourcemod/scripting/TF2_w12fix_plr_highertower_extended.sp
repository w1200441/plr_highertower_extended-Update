
#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>

public Plugin myinfo = 
{
	name = "plr_highertower_extended Map glitch fixed",
	author = "w1200441",
	description = "plr_highertower_extended red spawnroom fix",
	version = "0.0.1",
	url = "https://steamcommunity.com/id/w1200441/"
};
public void OnEntityCreated(int entity, const char[] classname)
{
	if(IsCorrectMap())
	{
		if (StrEqual(classname, "team_round_timer"))
		{			
			Rebuild();
		}
	}
}
public void Rebuild()
{
	CreateTimer(0.0, RemoveAll);
	CreateTimer(1.0, BuildEntity);
	PrintToServer("[TF2_w12fix_plr_highertower_extended] plr_highertower_extended loaded.");
}
Action RemoveAll(Handle timer)
{
	int entity = -1;
	while ((entity = FindEntityByClassname(entity, "func_respawnroom")) != -1)
	{
		char name[128]; GetEntPropString(entity, Prop_Data, "m_iName", name, sizeof(name));
		if(StrEqual(name, "MapEntity"))
		{
			AcceptEntityInput(entity, "Kill");
		}
	}
	return Plugin_Stop;
}
Action BuildEntity(Handle timer)
{
	int prop;
	prop = CreateEntityByName("func_respawnroom");
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*13");
		DispatchKeyValue(prop, "origin", "0 -170 0");
		DispatchKeyValue(prop, "angles", "0 0 0");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "TeamNum", "2");
		DispatchSpawn(prop);
		ActivateEntity(prop);
	}
	prop = CreateEntityByName("func_respawnroom");
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*8");
		DispatchKeyValue(prop, "origin", "530 -585 -7670");
		DispatchKeyValue(prop, "angles", "0 0 -90");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "TeamNum", "2");
		DispatchSpawn(prop);
		ActivateEntity(prop);
	}
	prop = CreateEntityByName("func_respawnroom");
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "*8");
		DispatchKeyValue(prop, "origin", "630 -585 -7670");
		DispatchKeyValue(prop, "angles", "0 0 -90");
		DispatchKeyValue(prop, "spawnflags", "1");
		DispatchKeyValue(prop, "TeamNum", "2");
		DispatchSpawn(prop);
		ActivateEntity(prop);
	}
	return Plugin_Stop;
}
stock bool IsCorrectMap()
{
	char map[32];
	GetCurrentMap(map, sizeof(map));
	return StrEqual(map, "plr_highertower_extended")
}