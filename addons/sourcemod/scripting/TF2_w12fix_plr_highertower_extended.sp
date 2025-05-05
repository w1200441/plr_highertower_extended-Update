
#pragma newdecls required
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <tf2>
#include <tf2_stocks>

bool CreateFixEntity = false;

public Plugin myinfo = 
{
	name = "plr_highertower_extended Map glitch fixed",
	author = "w1200441",
	description = "plr_highertower_extended red spawnroom fix. increase telefrag damage in x1000 mode",
	version = "0.0.5",
	url = "https://steamcommunity.com/id/w1200441/"
};
public void OnPluginStart()
{
	RegAdminCmd("sm_w12rebuild", Command_ReBuild, ADMFLAG_SLAY, "Rebuild Emtites");
}
public Action Command_ReBuild(int client, int args)
{
	IsCorrectMap() ? Rebuild() : ReplyToCommand(client, "Command enable for map [ plr_highertower_extended ] only.");
	
	return Plugin_Handled;
}
public void OnClientPutInServer(int client)
{
	if(!IsCorrectMap())
		return;
	if(IsValidClient(client))
		SDKHook(client, SDKHook_OnTakeDamage, HookOnTakeDamage);
}
public Action HookOnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype, int &weapon, float damageForce[3], float damagePosition[3], int damagecustom)
{
	if(IsValidClient(victim) && IsValidClient(attacker))
	{
		if(damagecustom == TF_CUSTOM_TELEFRAG)
		{
			if(damage < GetClientHealth(victim))
				damage = GetClientHealth(victim)+1000.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}
public void OnEntityCreated(int entity, const char[] classname)
{
	if(!IsCorrectMap())
		return;
	if (StrEqual(classname, "team_round_timer"))
	{
		CreateFixEntity = false;
		HookSingleEntityOutput(entity, "OnSetupStart", OnSetupStart);
	}
}
public void OnSetupStart(const char[] output, int caller, int activator, float delay)
{
	if(CreateFixEntity)
		return;
	CreateFixEntity = true;
	Rebuild();
}
public void Rebuild()
{
	CreateTimer(0.0, RemoveAll);
	CreateTimer(1.0, BuildEntity);
	PrintToServer("[TF2_w12fix_plr_highertower_extended] plr_highertower_extended loaded.");
}
public Action RemoveAll(Handle timer)
{
	if(!IsCorrectMap())
		return Plugin_Stop;
	int entity = CreateEntityByName("logic_timer");
	if(IsValidEntity(entity))
	{
		DispatchKeyValue(entity, "targetname", "EntFireTimer");
		DispatchKeyValue(entity, "StartDisabled", "0");
		DispatchKeyValue(entity, "RefireTime", "0.1");
		DispatchKeyValue(entity, "spawnflags", "0");
		DispatchSpawn(entity);
		ActivateEntity(entity);
		SetVariantString("OnTimer MapEntity:Kill::0.0:-1");
		AcceptEntityInput(entity, "AddOutput");
		SetVariantString("OnTimer !self:Disable::0.1:-1");
		AcceptEntityInput(entity, "AddOutput");
		SetVariantString("OnTimer !self:Kill::1.0:-1");
		AcceptEntityInput(entity, "AddOutput");
	}
	return Plugin_Stop;
}
public Action BuildEntity(Handle timer)
{
	if(!IsCorrectMap())
		return Plugin_Stop;
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
	prop = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "models/props_2fort/corrugated_metal004.mdl");
		DispatchKeyValue(prop, "origin", "-2540 -3347 -4585");
		DispatchKeyValue(prop, "angles", "76 263 173");
		DispatchKeyValue(prop, "solid", "6");
		DispatchSpawn(prop);
	}
	prop = CreateEntityByName("prop_dynamic");
	if (IsValidEntity(prop))
	{
		DispatchKeyValue(prop, "targetname", "MapEntity");
		DispatchKeyValue(prop, "model", "models/props_farm/fence_metal01a.mdl");
		DispatchKeyValue(prop, "origin", "-3630 -4314 -3980");
		DispatchKeyValue(prop, "angles", "5 266 -20");
		DispatchKeyValue(prop, "solid", "6");
		DispatchSpawn(prop);
		SetEntityRenderMode(prop, RENDER_TRANSCOLOR);
		SetEntityRenderColor(prop, 255, 255, 255, 0);
	}
	return Plugin_Stop;
}
stock bool IsCorrectMap()
{
	char map[32];
	GetCurrentMap(map, sizeof(map));
	return StrEqual(map, "plr_highertower_extended");
}
bool IsValidClient(int client) 
{
    if (client <= 0) return false;
    if (client > MaxClients) return false;
    return IsClientInGame(client);
}