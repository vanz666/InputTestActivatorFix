#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <dhooks>

#pragma newdecls required

public Plugin myinfo = 
{
    name = "InputTestActivator Fix",
    author = "quasemago & vanz",
    description = "Fixes crash when activator isn't valid anymore.",
    version = "1.0.0"
};

Handle g_detourInputTestActivator;

public void OnPluginStart()
{
    GameData conf = new GameData("testactivator_fix.games");
    
    if (conf == null) 
        SetFailState("Failed to load testactivator_fix gamedata");
    
    if (!(g_detourInputTestActivator = DHookCreateFromConf(conf, "CBaseFilter::InputTestActivator")))
        SetFailState("Failed to setup detour for CBaseFilter::InputTestActivator");

    delete conf;
    
    if (!DHookEnableDetour(g_detourInputTestActivator, false, Detour_InputTestActivator))
        SetFailState("Failed to detour CBaseFilter::InputTestActivator");
}

public MRESReturn Detour_InputTestActivator(Handle params)
{
    if (DHookIsNullParam(params, 1))
        return MRES_Supercede;

    Address pActivator  = DHookGetParamObjectPtrVar(params, 1, 0, ObjectValueType_Int);
    Address pCaller     = DHookGetParamObjectPtrVar(params, 1, 4, ObjectValueType_Int);

    if (!pActivator || !pCaller)
        return MRES_Supercede;

    return MRES_Ignored;
}