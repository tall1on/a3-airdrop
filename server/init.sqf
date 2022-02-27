// add after server_isReady/attachment_point

// Start Airdrop
dg_airdrop = false;
publicVariable "dg_airdrop"; // watch for battleye filters
[] spawn SERVER_fnc_initAirdrops;