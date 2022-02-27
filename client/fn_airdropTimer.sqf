/*
    DemonsGaming (c)2022
    Author: Tallion
*/
#include "..\..\script_macros.hpp"
private["_uiDisp","_time","_timer"];
disableSerialization;
6 cutRsc ["dg_event_timer","PLAIN"];
_uiDisp = uiNamespace getVariable "dg_event_timer";
_timer = _uiDisp displayCtrl 39301;
_timerDesc = _uiDisp displayCtrl 39302;
_timerDesc ctrlSetText 'Airdrop-Event';

_airdropStart = dg_airdrop_obj getVariable ["dg_airdrop_start", nil];
if(isNil "_airdropStart") exitWith {diag_log "Exit Start";};

_time = _airdropStart + (25 * 60);
for "_i" from 0 to 1 step 0 do {
    if(!(dg_airdrop_obj getVariable ['dg_airdrop', false])) exitWith {diag_log "Exit Airdrop";};
    if (isNull _uiDisp) then {
        6 cutRsc ["dg_event_timer","PLAIN"];
        _uiDisp = uiNamespace getVariable "dg_event_timer";
        _timer = _uiDisp displayCtrl 39301;
        _timerDesc = _uiDisp displayCtrl 39302;
        _timerDesc ctrlSetText 'Airdrop-Event';
    };
    if (round(_time - time) < 1) exitWith {diag_log "Exit Timer";};
    _timer ctrlSetText format["%1",[(_time - time),"MM:SS.MS"] call BIS_fnc_secondsToString];
    sleep 0.08;
};

6 cutText["","PLAIN"];