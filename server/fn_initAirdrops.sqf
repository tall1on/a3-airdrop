/*
    DemonsGaming (c)2022
    Author: Tallion
*/
airdropHelicopter = "B_T_VTOL_01_armed_F";
airdropPositions = [
    getMarkerPos 'airdrop_1',
    getMarkerPos 'airdrop_2',
    getMarkerPos 'airdrop_3',
    getMarkerPos 'airdrop_4',
    getMarkerPos 'airdrop_5',
    getMarkerPos 'airdrop_6',
    getMarkerPos 'airdrop_7',
    getMarkerPos 'airdrop_8',
    getMarkerPos 'airdrop_9',
    getMarkerPos 'airdrop_10'
];

//WARNING: Not too much for server performance
wepsCount = 9;
magsCount = 40;
equipCount = 10;
itemCount = 10;

weps = [];
mags = [];
equip = [];
itemss = [];

_weaponShop = getArray(missionConfigFile >> "WeaponShops" >> "rebel" >> "items");
{
    _classname = _x select 0;
    _type      = toUpper (([ _x select 0] call BIS_fnc_itemType) select 0);
    switch ( _type ) do {
    	case "MAGAZINE": {
    		mags pushBack _classname;
    		true;
    	};
    	case "ITEM": {
    		itemss pushBack _classname;
    		true;
    	};
    	case "WEAPON": {
    		weps pushBack _classname;
    		true;
    	};
    	case "EQUIPMENT": {
    		equip pushBack _classname;
    		true;
    	};
    };
} count _weaponShop;

fnc_amazonDelivery = {
    _index = _this select 0;
    _dest = _this select 1;

    _marker = createMarker [format["Airdropmarker_%1",_index + 1], _dest];
    _marker setMarkerColor "ColorOrange";
    _marker setMarkerText "Airdrop Abwurfzone";
    _marker setMarkerType "mil_end";

    _redZone = createMarker [format ["Airdropredzone_%1",_index + 1],_dest];
	_redZone setMarkerShape "ELLIPSE";
	_redZone setMarkerColor "ColorRed";
	_redZone setMarkerSize [400,400];

    _heli = createVehicle [airdropHelicopter, [7950, 9667, 0], [], 0, "FLY"];
    _heli allowDamage false;
    dg_dont_cleanup pushBackUnique _heli;

    _heliGroup = [[7950, 9667, 0], civilian, ["O_G_Soldier_SL_F"],[],[],[],[],[],180] call BIS_fnc_spawnGroup;
    {_x moveInDriver _heli} forEach units _heliGroup;
    _heliGroup addWaypoint [_dest, 0];
    _heliGroup addWaypoint [[2380.47,22267.8,0], 0];

    // amazon pls deliver this shit
    _amazonMarker = createMarker [format["amazon_marker_%1", _index + 1], [14028.5,18719.7,0.0014267]];
    _amazonMarker setMarkerColor "ColorBlue";
    _amazonMarker setMarkerText "Airdrop";
    _amazonMarker setMarkerType "mil_destroy";

    _containerdummy = createVehicle ["Land_Cargo20_military_green_F", [3450.7363, 16708.432, 90], [], 0, "CAN_COLLIDE"];
    _containerdummy attachTo [_heli,[0,0,-3.5]];
    _containerdummy setDir 90;

    while { _dest distance _heli > 200 } do { _amazonMarker setMarkerPos getPos _heli; sleep 1; };

    // Drop the container
    deleteMarker _marker;
    deleteVehicle _containerdummy;

    _container = createVehicle ["Land_Cargo20_military_green_F", [3450.7363, 16708.432, 90], [], 0, "CAN_COLLIDE"];

    _para = createVehicle ["O_Parachute_02_F", [getPos _heli select 0, getPos _heli select 1, getPos _heli select 2], [], 0, ""];
    _para setPosATL (_heli modelToWorld[0,0,100]);
    _para attachTo [_heli,[0,0,-10]];
    detach _para;

    _container attachTo [_para,[0,0,-2]];
    _container setDir 90;

    playSound3D ["a3\sounds_f\weapons\Flare_Gun\flaregun_1_shoot.wss", _container];

    _smoke="SmokeShellBlue" createVehicle [getPos _container select 0, getPos _container select 1,0];
    _smoke attachTo [_container,[0,0,0]];

    _light = "Chemlight_blue" createVehicle getPos _container;
    _light attachTo [_container,[0,0,0]];

    _flare = "F_40mm_Blue" createVehicle getPos _container;
    _flare attachTo [_container,[0,0,0]];

    sleep 0.1;

    while { (getPos _container select 2) > 2 } do { _amazonMarker setMarkerPos getPos _container;sleep 1; };
    detach _container;
    _container setPos [getPos _container select 0, getPos _container select 1, (getPos _container select 2)+0.5];
    playSound3D ["A3\Sounds_F\sfx\alarm_independent.wss", _container];
    sleep 6;
    "M_NLAW_AT_F" createVehicle [getPos _container select 0, getPos _container select 1, 0];
    _pos_container = getPos _container;
    deleteVehicle _container;
    sleep 0.5;

    _box = createVehicle ["B_CargoNet_01_ammo_F", [_pos_container select 0, _pos_container select 1, 2], [], 0, "CAN_COLLIDE"];
    _box allowDamage false;

    // Fill box
    clearWeaponCargoGlobal _box;
    clearMagazineCargoGlobal _box;
    clearItemCargoGlobal _box;

    // weapons
    _weaponsCount = count weps;
    for "_i" from 1 to wepsCount do {
        _index = floor(random _weaponsCount);
        _box addItemCargoGlobal [(weps select _index), 1];
        sleep 0.1;
    };

    // mags
    _magsCount = count mags;
    for "_i" from 1 to magsCount do {
        _index = floor(random _magsCount);
        _box addItemCargoGlobal [(mags select _index), 1];
        sleep 0.1;
    };

    // equipment
    _equipCount = count equip;
    for "_i" from 1 to equipCount do {
        _index = floor(random _equipCount);
        _box addItemCargoGlobal [(equip select _index), 1];
        sleep 0.1;
    };

    // items
    _itemsCount = count itemss;
    for "_i" from 1 to itemCount do {
        _index = floor(random _itemsCount);
        _box addItemCargoGlobal [(itemss select _index), 1];
        sleep 0.1;
    };

    // Fill box end

    sleep 60;

    deleteVehicle _heli;

    waitUntil {dg_time in ['15:25', '19:25', '23:25']};

    deleteVehicle _box;
    deleteMarker _amazonMarker;
    deleteMarker _redZone;
};

waitUntil{!isNil 'dg_time'};

dg_throw = false;
waitUntil {dg_throw || dg_time in ['15:00', '19:00', '23:00']};
if(dg_throw) then {
    sleep 60;
};
dg_throw = false;
if(dg_airdrop) exitWith {};
dg_airdrop = true;
dg_airdrop_obj setVariable ["dg_airdrop",true,true];
dg_airdrop_obj setVariable ["dg_airdrop_start",time,true];
['Airdrop-Event: Das Airdrop-Event startet - Die Abwurfstellen wurde auf der Karte markiert!','info',30] remoteExec ['CLIENT_fnc_hint', civilian];

[] remoteExec ['CLIENT_fnc_airdropTimer', civilian];

_positions = count airdropPositions;
_index = floor(random _positions);
_dest = airdropPositions select _index;
[_index, _dest] spawn fnc_amazonDelivery;
airdropPositions deleteAt _index;

waitUntil {dg_time in ['15:25', '19:25', '23:25']};

// disable airdrop
dg_airdrop_obj setVariable ["dg_airdrop",false,true];

_winner = grpNull;
_kills = 0;
{
    if(_x getVariable ["dg_airdrop_kills", 0] > _kills) then {
        _winner = _x;
        _kills = _x getVariable ["dg_airdrop_kills", 0];
    };
} forEach allGroups;

if(!isNull _winner) then {
    [format['Die Gang %1 hat das Airdrop-Event mit %2 Kills gewonnen!', _winner getVariable ["gang_name",""], _kills],'info',30] remoteExec ['CLIENT_fnc_hint', civilian];

    // add gang-coin
    _currentCoins = _winner getVariable ['gang_coins', 0];
    _winner setVariable ['gang_coins', _currentCoins + 1, true];
    [5,_winner] call dg_fnc_updateGang;
} else {
    ['Das Airdrop-Event wurde beendet!','info',30] remoteExec ['CLIENT_fnc_hint', civilian];
};

