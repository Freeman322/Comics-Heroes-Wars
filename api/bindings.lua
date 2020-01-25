CBaseAnimating = {}
CBaseCombatCharacter = {}
CBaseEntity = {}
CBaseFlex = {}
CBaseModelEntity = {}
CBasePlayer = {}
CBaseTrigger = {}
CBodyComponent = {}
CCustomGameEventManager = {}
CCustomNetTableManager = {}
CDOTABaseAbility = {}
CDOTABaseGameMode = {}
CDOTAGameManager = {}
CDOTAPlayer = {}
CDOTAVoteSystem = {}
CDOTA_Ability_Animation_Attack = {}
CDOTA_Ability_Animation_TailSpin = {}
CDOTA_Ability_DataDriven = {}
CDOTA_Ability_Lua = {}
CDOTA_Ability_Nian_Dive = {}
CDOTA_Ability_Nian_Leap = {}
CDOTA_Ability_Nian_Roar = {}
CDOTA_BaseNPC = {}
CDOTA_BaseNPC_Building = {}
CDOTA_BaseNPC_Creature = {}
CDOTA_BaseNPC_Hero = {}
CDOTA_BaseNPC_RotatableBuilding = {}
CDOTA_BaseNPC_Shop = {}
CDOTA_BaseNPC_Trap_Ward = {}
CDOTA_Buff = {}
CDOTA_CustomUIManager = {}
CDOTA_Item = {}
CDOTA_ItemSpawner = {}
CDOTA_Item_DataDriven = {}
CDOTA_Item_Lua = {}
CDOTA_Item_Physical = {}
CDOTA_MapTree = {}
CDOTA_Modifier_Lua = {}
CDOTA_Modifier_Lua_Horizontal_Motion = {}
CDOTA_Modifier_Lua_Motion_Both = {}
CDOTA_Modifier_Lua_Vertical_Motion = {}
CDOTA_PlayerResource = {}
CDOTA_ShopTrigger = {}
CDOTA_SimpleObstruction = {}
CDOTA_Unit_Courier = {}
CDOTA_Unit_Nian = {}
CDebugOverlayScriptHelper = {}
CDotaQuest = {}
CDotaSubquestBase = {}
CEntities = {}
CEntityInstance = {}
CEntityScriptFramework = {}
CEnvEntityMaker = {}
CEnvProjectedTexture = {}
CInfoData = {}
CInfoWorldLayer = {}
CLogicScript = {}
CMarkupVolumeTagged = {}
CNativeOutputs = {}
CParticleSystem = {}
CPhysicsProp = {}
CPointClientUIWorldPanel = {}
CPointTemplate = {}
CPointWorldText = {}
CPropHMDAvatar = {}
CPropVRHand = {}
CSceneEntity = {}
CScriptHeroList = {}
CScriptKeyValues = {}
CScriptParticleManager = {}
CScriptPrecacheContext = {}
Convars = {}
GlobalSys = {}
GridNav = {}
ProjectileManager = {}
SteamInfo = {}

---[[ AddFOWViewer  Add temporary vision for a given team ( nTeamID, vLocation, flRadius, flDuration, bObstructedVision) ]]
-- @return void
-- @param int_1 int
-- @param Vector_2 Vector
-- @param float_3 float
-- @param float_4 float
-- @param bool_5 bool
function AddFOWViewer( int_1, Vector_2, float_3, float_4, bool_5 ) end

---[[ AngleDiff  Returns the number of degrees difference between two yaw angles ]]
-- @return float
-- @param float_1 float
-- @param float_2 float
function AngleDiff( float_1, float_2 ) end

---[[ AppendToLogFile  AppendToLogFile is deprecated. Print to the console for logging instead. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function AppendToLogFile( string_1, string_2 ) end

---[[ ApplyDamage  Damage an npc. ]]
-- @return float
-- @param handle_1 handle
function ApplyDamage( handle_1 ) end

---[[ AxisAngleToQuaternion  (vector,float) constructs a quaternion representing a rotation by angle around the specified vector axis ]]
-- @return Quaternion
-- @param Vector_1 Vector
-- @param float_2 float
function AxisAngleToQuaternion( Vector_1, float_2 ) end

---[[ CalcClosestPointOnEntityOBB  Compute the closest point on the OBB of an entity. ]]
-- @return Vector
-- @param handle_1 handle
-- @param Vector_2 Vector
function CalcClosestPointOnEntityOBB( handle_1, Vector_2 ) end

---[[ CalcDistanceBetweenEntityOBB  Compute the distance between two entity OBB. A negative return value indicates an input error. A return value of zero indicates that the OBBs are overlapping. ]]
-- @return float
-- @param handle_1 handle
-- @param handle_2 handle
function CalcDistanceBetweenEntityOBB( handle_1, handle_2 ) end

---[[ CalcDistanceToLineSegment2D   ]]
-- @return float
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
function CalcDistanceToLineSegment2D( Vector_1, Vector_2, Vector_3 ) end

---[[ CancelEntityIOEvents  Create all I/O events for a particular entity ]]
-- @return void
-- @param ehandle_1 ehandle
function CancelEntityIOEvents( ehandle_1 ) end

---[[ ClearTeamCustomHealthbarColor  ( teamNumber ) ]]
-- @return void
-- @param int_1 int
function ClearTeamCustomHealthbarColor( int_1 ) end

---[[ CreateDamageInfo  (hInflictor, hAttacker, flDamage) - Allocate a damageinfo object, used as an argument to TakeDamage(). Call DestroyDamageInfo( hInfo ) to free the object. ]]
-- @return handle
-- @param handle_1 handle
-- @param handle_2 handle
-- @param Vector_3 Vector
-- @param Vector_4 Vector
-- @param float_5 float
-- @param int_6 int
function CreateDamageInfo( handle_1, handle_2, Vector_3, Vector_4, float_5, int_6 ) end

---[[ CreateEffect  Pass table - Inputs: entity, effect ]]
-- @return bool
-- @param handle_1 handle
function CreateEffect( handle_1 ) end

---[[ CreateHTTPRequest  Create an HTTP request. ]]
-- @return handle
-- @param string_1 string
-- @param string_2 string
function CreateHTTPRequest( string_1, string_2 ) end

---[[ CreateHTTPRequestScriptVM  Create an HTTP request. ]]
-- @return handle
-- @param string_1 string
-- @param string_2 string
function CreateHTTPRequestScriptVM( string_1, string_2 ) end

---[[ CreateHeroForPlayer  Creates a DOTA hero by its dota_npc_units.txt name and sets it as the given player's controlled hero ]]
-- @return handle
-- @param string_1 string
-- @param handle_2 handle
function CreateHeroForPlayer( string_1, handle_2 ) end


function CreateIllusions( handle_1, handle_2, handle_3, int_4, int_5, bool_6, bool_7 ) end

---[[ CreateItem  Create a DOTA item ]]
-- @return handle
-- @param string_1 string
-- @param handle_2 handle
-- @param handle_3 handle
function CreateItem( string_1, handle_2, handle_3 ) end

---[[ CreateItemOnPositionForLaunch  Create a physical item at a given location, can start in air (but doesn't clear a space) ]]
-- @return handle
-- @param Vector_1 Vector
-- @param handle_2 handle
function CreateItemOnPositionForLaunch( Vector_1, handle_2 ) end

---[[ CreateItemOnPositionSync  Create a physical item at a given location ]]
-- @return handle
-- @param Vector_1 Vector
-- @param handle_2 handle
function CreateItemOnPositionSync( Vector_1, handle_2 ) end

---[[ CreateModifierThinker  Create a modifier not associated with an NPC. ( hCaster, hAbility, modifierName, paramTable, vOrigin, nTeamNumber, bPhantomBlocker ) ]]
-- @return handle
-- @param handle_1 handle
-- @param handle_2 handle
-- @param string_3 string
-- @param handle_4 handle
-- @param Vector_5 Vector
-- @param int_6 int
-- @param bool_7 bool
function CreateModifierThinker( handle_1, handle_2, string_3, handle_4, Vector_5, int_6, bool_7 ) end

---[[ CreateSceneEntity  Create a scene entity to play the specified scene. ]]
-- @return handle
-- @param string_1 string
function CreateSceneEntity( string_1 ) end

---[[ CreateTempTree  Create a temporary tree, uses a default tree model. (vLocation, flDuration). ]]
-- @return handle
-- @param Vector_1 Vector
-- @param float_2 float
function CreateTempTree( Vector_1, float_2 ) end

---[[ CreateTempTreeWithModel  Create a temporary tree, specifying the tree model name. (vLocation, flDuration, szModelName). ]]
-- @return handle
-- @param Vector_1 Vector
-- @param float_2 float
-- @param string_3 string
function CreateTempTreeWithModel( Vector_1, float_2, string_3 ) end

---[[ CreateTrigger  CreateTrigger( vecMin, vecMax ) : Creates and returns an AABB trigger ]]
-- @return handle
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
function CreateTrigger( Vector_1, Vector_2, Vector_3 ) end

---[[ CreateTriggerRadiusApproximate  CreateTriggerRadiusApproximate( vecOrigin, flRadius ) : Creates and returns an AABB trigger thats bigger than the radius provided ]]
-- @return handle
-- @param Vector_1 Vector
-- @param float_2 float
function CreateTriggerRadiusApproximate( Vector_1, float_2 ) end

---[[ CreateUnitByName  Creates a DOTA unit by its dota_npc_units.txt name ]]
-- @return handle
-- @param string_1 string
-- @param Vector_2 Vector
-- @param bool_3 bool
-- @param handle_4 handle
-- @param handle_5 handle
-- @param int_6 int
function CreateUnitByName( string_1, Vector_2, bool_3, handle_4, handle_5, int_6 ) end

---[[ CreateUnitByNameAsync  Creates a DOTA unit by its dota_npc_units.txt name ]]
-- @return int
-- @param string_1 string
-- @param Vector_2 Vector
-- @param bool_3 bool
-- @param handle_4 handle
-- @param handle_5 handle
-- @param int_6 int
-- @param handle_7 handle
function CreateUnitByNameAsync( string_1, Vector_2, bool_3, handle_4, handle_5, int_6, handle_7 ) end

---[[ CreateUnitFromTable  Creates a DOTA unit by its dota_npc_units.txt name from a table of entity key values and a position to spawn at. ]]
-- @return handle
-- @param handle_1 handle
-- @param Vector_2 Vector
function CreateUnitFromTable( handle_1, Vector_2 ) end

---[[ CrossVectors  (vector,vector) cross product between two vectors ]]
-- @return Vector
-- @param Vector_1 Vector
-- @param Vector_2 Vector
function CrossVectors( Vector_1, Vector_2 ) end

---[[ DebugBreak  Breaks in the debugger ]]
-- @return void
function DebugBreak(  ) end

---[[ DebugDrawBox  Draw a debug overlay box (origin, mins, maxs, forward, r, g, b, a, duration ) ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param float_8 float
function DebugDrawBox( Vector_1, Vector_2, Vector_3, int_4, int_5, int_6, int_7, float_8 ) end

---[[ DebugDrawBoxDirection  Draw a debug forward box (cent, min, max, forward, vRgb, a, duration) ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param Vector_4 Vector
-- @param Vector_5 Vector
-- @param float_6 float
-- @param float_7 float
function DebugDrawBoxDirection( Vector_1, Vector_2, Vector_3, Vector_4, Vector_5, float_6, float_7 ) end

---[[ DebugDrawCircle  Draw a debug circle (center, vRgb, a, rad, ztest, duration) ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param float_4 float
-- @param bool_5 bool
-- @param float_6 float
function DebugDrawCircle( Vector_1, Vector_2, float_3, float_4, bool_5, float_6 ) end

---[[ DebugDrawClear  Try to clear all the debug overlay info ]]
-- @return void
function DebugDrawClear(  ) end

---[[ DebugDrawLine  Draw a debug overlay line (origin, target, r, g, b, ztest, duration) ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param bool_6 bool
-- @param float_7 float
function DebugDrawLine( Vector_1, Vector_2, int_3, int_4, int_5, bool_6, float_7 ) end

---[[ DebugDrawLine_vCol  Draw a debug line using color vec (start, end, vRgb, a, ztest, duration) ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param bool_4 bool
-- @param float_5 float
function DebugDrawLine_vCol( Vector_1, Vector_2, Vector_3, bool_4, float_5 ) end

---[[ DebugDrawScreenTextLine  Draw text with a line offset (x, y, lineOffset, text, r, g, b, a, duration) ]]
-- @return void
-- @param float_1 float
-- @param float_2 float
-- @param int_3 int
-- @param string_4 string
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param float_9 float
function DebugDrawScreenTextLine( float_1, float_2, int_3, string_4, int_5, int_6, int_7, int_8, float_9 ) end

---[[ DebugDrawSphere  Draw a debug sphere (center, vRgb, a, rad, ztest, duration) ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param float_4 float
-- @param bool_5 bool
-- @param float_6 float
function DebugDrawSphere( Vector_1, Vector_2, float_3, float_4, bool_5, float_6 ) end

---[[ DebugDrawText  Draw text in 3d (origin, text, bViewCheck, duration) ]]
-- @return void
-- @param Vector_1 Vector
-- @param string_2 string
-- @param bool_3 bool
-- @param float_4 float
function DebugDrawText( Vector_1, string_2, bool_3, float_4 ) end

---[[ DebugScreenTextPretty  Draw pretty debug text (x, y, lineOffset, text, r, g, b, a, duration, font, size, bBold) ]]
-- @return void
-- @param float_1 float
-- @param float_2 float
-- @param int_3 int
-- @param string_4 string
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param float_9 float
-- @param string_10 string
-- @param int_11 int
-- @param bool_12 bool
function DebugScreenTextPretty( float_1, float_2, int_3, string_4, int_5, int_6, int_7, int_8, float_9, string_10, int_11, bool_12 ) end

---[[ DestroyDamageInfo  Free a damageinfo object that was created with CreateDamageInfo(). ]]
-- @return void
-- @param handle_1 handle
function DestroyDamageInfo( handle_1 ) end

---[[ DoCleaveAttack  (hAttacker, hTarget, hAbility, fDamage, fRadius, effectName) ]]
-- @return int
-- @param handle_1 handle
-- @param handle_2 handle
-- @param handle_3 handle
-- @param float_4 float
-- @param float_5 float
-- @param float_6 float
-- @param float_7 float
-- @param string_8 string
function DoCleaveAttack( handle_1, handle_2, handle_3, float_4, float_5, float_6, float_7, string_8 ) end

---[[ DoEntFire  #EntFire:Generate and entity i/o event ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param string_3 string
-- @param float_4 float
-- @param handle_5 handle
-- @param handle_6 handle
function DoEntFire( string_1, string_2, string_3, float_4, handle_5, handle_6 ) end

---[[ DoEntFireByInstanceHandle  #EntFireByHandle:Generate and entity i/o event ]]
-- @return void
-- @param handle_1 handle
-- @param string_2 string
-- @param string_3 string
-- @param float_4 float
-- @param handle_5 handle
-- @param handle_6 handle
function DoEntFireByInstanceHandle( handle_1, string_2, string_3, float_4, handle_5, handle_6 ) end

---[[ DoIncludeScript  Execute a script (internal) ]]
-- @return bool
-- @param string_1 string
-- @param handle_2 handle
function DoIncludeScript( string_1, handle_2 ) end

---[[ DoScriptAssert  #ScriptAssert:Asserts the passed in value. Prints out a message and brings up the assert dialog. ]]
-- @return void
-- @param bool_1 bool
-- @param string_2 string
function DoScriptAssert( bool_1, string_2 ) end

---[[ DoUniqueString  #UniqueString:Generate a string guaranteed to be unique across the life of the script VM, with an optional root string. Useful for adding data to tables when not sure what keys are already in use in that table. ]]
-- @return string
-- @param string_1 string
function DoUniqueString( string_1 ) end

---[[ DotProduct   ]]
-- @return float
-- @param Vector_1 Vector
-- @param Vector_2 Vector
function DotProduct( Vector_1, Vector_2 ) end

---[[ EmitAnnouncerSound  Emit an announcer sound for all players. ]]
-- @return void
-- @param string_1 string
function EmitAnnouncerSound( string_1 ) end

---[[ EmitAnnouncerSoundForPlayer  Emit an announcer sound for a player. ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
function EmitAnnouncerSoundForPlayer( string_1, int_2 ) end

---[[ EmitAnnouncerSoundForTeam  Emit an announcer sound for a team. ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
function EmitAnnouncerSoundForTeam( string_1, int_2 ) end

---[[ EmitAnnouncerSoundForTeamOnLocation  Emit an announcer sound for a team at a specific location. ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
-- @param Vector_3 Vector
function EmitAnnouncerSoundForTeamOnLocation( string_1, int_2, Vector_3 ) end

---[[ EmitGlobalSound  Play named sound for all players ]]
-- @return void
-- @param string_1 string
function EmitGlobalSound( string_1 ) end

---[[ EmitSoundOn  Play named sound on Entity ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function EmitSoundOn( string_1, handle_2 ) end

---[[ EmitSoundOnClient  Play named sound only on the client for the passed in player ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function EmitSoundOnClient( string_1, handle_2 ) end

---[[ EmitSoundOnLocationForAllies  Emit a sound on a location from a unit, only for players allied with that unit (vLocation, soundName, hCaster ]]
-- @return void
-- @param Vector_1 Vector
-- @param string_2 string
-- @param handle_3 handle
function EmitSoundOnLocationForAllies( Vector_1, string_2, handle_3 ) end

---[[ EmitSoundOnLocationWithCaster  Emit a sound on a location from a unit. (vLocation, soundName, hCaster). ]]
-- @return void
-- @param Vector_1 Vector
-- @param string_2 string
-- @param handle_3 handle
function EmitSoundOnLocationWithCaster( Vector_1, string_2, handle_3 ) end

---[[ EntIndexToHScript  Turn an entity index integer to an HScript representing that entity's script instance. ]]
-- @return handle
-- @param int_1 int
function EntIndexToHScript( int_1 ) end

---[[ ExecuteOrderFromTable  Issue an order from a script table ]]
-- @return void
-- @param handle_1 handle
function ExecuteOrderFromTable( handle_1 ) end

---[[ ExponentialDecay  Smooth curve decreasing slower as it approaches zero ]]
-- @return float
-- @param float_1 float
-- @param float_2 float
-- @param float_3 float
function ExponentialDecay( float_1, float_2, float_3 ) end

---[[ FindClearRandomPositionAroundUnit  Finds a clear random position around a given target unit, using the target unit's padded collision radius. ]]
-- @return bool
-- @param handle_1 handle
-- @param handle_2 handle
-- @param int_3 int
function FindClearRandomPositionAroundUnit( handle_1, handle_2, int_3 ) end

---[[ FindClearSpaceForUnit  Place a unit somewhere not already occupied. ]]
-- @return bool
-- @param handle_1 handle
-- @param Vector_2 Vector
-- @param bool_3 bool
function FindClearSpaceForUnit( handle_1, Vector_2, bool_3 ) end

---[[ FindUnitsInLine  Find units that intersect the given line with the given flags. ]]
-- @return table
-- @param int_1 int
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param handle_4 handle
-- @param float_5 float
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
function FindUnitsInLine( int_1, Vector_2, Vector_3, handle_4, float_5, int_6, int_7, int_8 ) end

---[[ FindUnitsInRadius  Finds the units in a given radius with the given flags. ]]
-- @return table
-- @param int_1 int
-- @param Vector_2 Vector
-- @param handle_3 handle
-- @param float_4 float
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
function FindUnitsInRadius( int_1, Vector_2, handle_3, float_4, int_5, int_6, int_7, int_8, bool_9 ) end

---[[ FireEntityIOInputNameOnly  Fire Entity's Action Input w/no data ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param string_2 string
function FireEntityIOInputNameOnly( ehandle_1, string_2 ) end

---[[ FireEntityIOInputString  Fire Entity's Action Input with passed String - you own the memory ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param string_2 string
-- @param string_3 string
function FireEntityIOInputString( ehandle_1, string_2, string_3 ) end

---[[ FireEntityIOInputVec  Fire Entity's Action Input with passed Vector - you own the memory ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param string_2 string
-- @param Vector_3 Vector
function FireEntityIOInputVec( ehandle_1, string_2, Vector_3 ) end

---[[ FireGameEvent  Fire a game event. ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function FireGameEvent( string_1, handle_2 ) end

---[[ FireGameEventLocal  Fire a game event without broadcasting to the client. ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function FireGameEventLocal( string_1, handle_2 ) end

---[[ FrameTime  Get the time spent on the server in the last frame ]]
-- @return float
function FrameTime(  ) end

---[[ GetDedicatedServerKey  ( version ) ]]
-- @return string
-- @param string_1 string
function GetDedicatedServerKey( string_1 ) end

---[[ GetDedicatedServerKeyV2  ( version ) ]]
-- @return string
-- @param string_1 string
function GetDedicatedServerKeyV2( string_1 ) end

---[[ GetEntityIndexForTreeId  Get the enity index for a tree id specified as the entindex_target of a DOTA_UNIT_ORDER_CAST_TARGET_TREE. ]]
-- @return <unknown>
-- @param unsigned_1 unsigned
function GetEntityIndexForTreeId( unsigned_1 ) end

---[[ GetFrameCount  Returns the engines current frame count ]]
-- @return int
function GetFrameCount(  ) end

---[[ GetGroundHeight   ]]
-- @return float
-- @param Vector_1 Vector
-- @param handle_2 handle
function GetGroundHeight( Vector_1, handle_2 ) end

---[[ GetGroundPosition  Returns the supplied position moved to the ground. Second parameter is an NPC for measuring movement collision hull offset. ]]
-- @return Vector
-- @param Vector_1 Vector
-- @param handle_2 handle
function GetGroundPosition( Vector_1, handle_2 ) end

---[[ GetItemCost  Get the cost of an item by name. ]]
-- @return int
-- @param string_1 string
function GetItemCost( string_1 ) end

---[[ GetItemDefOwnedCount   ]]
-- @return int
-- @param int_1 int
-- @param int_2 int
function GetItemDefOwnedCount( int_1, int_2 ) end

---[[ GetItemDefQuantity   ]]
-- @return int
-- @param int_1 int
-- @param int_2 int
function GetItemDefQuantity( int_1, int_2 ) end

---[[ GetListenServerHost  Get the local player on a listen server. ]]
-- @return handle
function GetListenServerHost(  ) end

---[[ GetLobbyEventGameDetails  ( ) ]]
-- @return table
function GetLobbyEventGameDetails(  ) end

---[[ GetMapName  Get the name of the map. ]]
-- @return string
function GetMapName(  ) end

---[[ GetMaxOutputDelay  Get the longest delay for all events attached to an output ]]
-- @return float
-- @param ehandle_1 ehandle
-- @param string_2 string
function GetMaxOutputDelay( ehandle_1, string_2 ) end

---[[ GetPhysAngularVelocity  Get Angular Velocity for VPHYS or normal object. Returns a vector of the axis of rotation, multiplied by the degrees of rotation per second. ]]
-- @return Vector
-- @param handle_1 handle
function GetPhysAngularVelocity( handle_1 ) end

---[[ GetPhysVelocity  Get Velocity for VPHYS or normal object ]]
-- @return Vector
-- @param handle_1 handle
function GetPhysVelocity( handle_1 ) end

---[[ GetSystemDate  Get the current real world date ]]
-- @return string
function GetSystemDate(  ) end

---[[ GetSystemTime  Get the current real world time ]]
-- @return string
function GetSystemTime(  ) end

---[[ GetTargetAOELocation   ]]
-- @return Vector
-- @param int_1 int
-- @param int_2 int
-- @param int_3 int
-- @param Vector_4 Vector
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
function GetTargetAOELocation( int_1, int_2, int_3, Vector_4, int_5, int_6, int_7 ) end

---[[ GetTargetLinearLocation   ]]
-- @return Vector
-- @param int_1 int
-- @param int_2 int
-- @param int_3 int
-- @param Vector_4 Vector
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
function GetTargetLinearLocation( int_1, int_2, int_3, Vector_4, int_5, int_6, int_7 ) end

---[[ GetTeamHeroKills  ( int teamID ) ]]
-- @return int
-- @param int_1 int
function GetTeamHeroKills( int_1 ) end

---[[ GetTeamName  ( int teamID ) ]]
-- @return string
-- @param int_1 int
function GetTeamName( int_1 ) end

---[[ GetTreeIdForEntityIndex  Given and entity index of a tree, get the tree id for use for use with with unit orders. ]]
-- @return int
-- @param int_1 int
function GetTreeIdForEntityIndex( int_1 ) end

---[[ GetWorldMaxX  Gets the world's maximum X position. ]]
-- @return float
function GetWorldMaxX(  ) end

---[[ GetWorldMaxY  Gets the world's maximum Y position. ]]
-- @return float
function GetWorldMaxY(  ) end

---[[ GetWorldMinX  Gets the world's minimum X position. ]]
-- @return float
function GetWorldMinX(  ) end

---[[ GetWorldMinY  Gets the world's minimum Y position. ]]
-- @return float
function GetWorldMinY(  ) end

---[[ InitLogFile  InitLogFile is deprecated. Print to the console for logging instead. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function InitLogFile( string_1, string_2 ) end

---[[ IsClient  Returns true if this is lua running from the client.dll. ]]
-- @return bool
function IsClient(  ) end

---[[ IsDedicatedServer  Returns true if this server is a dedicated server. ]]
-- @return bool
function IsDedicatedServer(  ) end

---[[ IsInToolsMode  Returns true if this is lua running within tools mode. ]]
-- @return bool
function IsInToolsMode(  ) end

---[[ IsLocationVisible  Ask fog of war if a location is visible to a certain team (nTeamNumber, vLocation). ]]
-- @return bool
-- @param int_1 int
-- @param Vector_2 Vector
function IsLocationVisible( int_1, Vector_2 ) end

---[[ IsMarkedForDeletion  Returns true if the entity is valid and marked for deletion. ]]
-- @return bool
-- @param handle_1 handle
function IsMarkedForDeletion( handle_1 ) end

---[[ IsServer  Returns true if this is lua running from the server.dll. ]]
-- @return bool
function IsServer(  ) end

---[[ IsValidEntity  Checks to see if the given hScript is a valid entity ]]
-- @return bool
-- @param handle_1 handle
function IsValidEntity( handle_1 ) end

---[[ LerpVectors  (vector,vector,float) lerp between two vectors by a float factor returning new vector ]]
-- @return Vector
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
function LerpVectors( Vector_1, Vector_2, float_3 ) end

---[[ LimitPathingSearchDepth  Set the limit on the pathfinding search space. ]]
-- @return void
-- @param float_1 float
function LimitPathingSearchDepth( float_1 ) end

---[[ LinkLuaModifier  Link a lua-defined modifier with the associated class ( className, fileName, LuaModifierType). ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param int_3 int
function LinkLuaModifier( string_1, string_2, int_3 ) end

---[[ ListenToGameEvent  Register as a listener for a game event from script. ]]
-- @return int
-- @param string_1 string
-- @param handle_2 handle
-- @param handle_3 handle
function ListenToGameEvent( string_1, handle_2, handle_3 ) end

---[[ LoadKeyValues  Creates a table from the specified keyvalues text file ]]
-- @return table
-- @param string_1 string
function LoadKeyValues( string_1 ) end

---[[ LoadKeyValuesFromString  Creates a table from the specified keyvalues string ]]
-- @return table
-- @param string_1 string
function LoadKeyValuesFromString( string_1 ) end

---[[ LocalTime  Get the current local time ]]
-- @return table
function LocalTime(  ) end

---[[ MakeStringToken  Checks to see if the given hScript is a valid entity ]]
-- @return int
-- @param string_1 string
function MakeStringToken( string_1 ) end

---[[ MinimapEvent  Start a minimap event. (nTeamID, hEntity, nXCoord, nYCoord, nEventType, nEventDuration). ]]
-- @return void
-- @param int_1 int
-- @param handle_2 handle
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
function MinimapEvent( int_1, handle_2, int_3, int_4, int_5, int_6 ) end

---[[ Msg  Print a message ]]
-- @return void
-- @param string_1 string
function Msg( string_1 ) end

---[[ PauseGame  Pause or unpause the game. ]]
-- @return void
-- @param bool_1 bool
function PauseGame( bool_1 ) end

---[[ PlayerInstanceFromIndex  Get a script instance of a player by index. ]]
-- @return handle
-- @param int_1 int
function PlayerInstanceFromIndex( int_1 ) end

---[[ PrecacheEntityFromTable  Precache an entity from KeyValues in table ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
-- @param handle_3 handle
function PrecacheEntityFromTable( string_1, handle_2, handle_3 ) end

---[[ PrecacheEntityListFromTable  Precache a list of entity KeyValues tables ]]
-- @return void
-- @param handle_1 handle
-- @param handle_2 handle
function PrecacheEntityListFromTable( handle_1, handle_2 ) end

---[[ PrecacheItemByNameAsync  Asynchronously precaches a DOTA item by its dota_npc_items.txt name, provides a callback when it's finished. ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function PrecacheItemByNameAsync( string_1, handle_2 ) end

---[[ PrecacheItemByNameSync  Precaches a DOTA item by its dota_npc_items.txt name ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function PrecacheItemByNameSync( string_1, handle_2 ) end

---[[ PrecacheModel  ( modelName, context ) - Manually precache a single model ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function PrecacheModel( string_1, handle_2 ) end

---[[ PrecacheResource  Manually precache a single resource ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param handle_3 handle
function PrecacheResource( string_1, string_2, handle_3 ) end

---[[ PrecacheUnitByNameAsync  Asynchronously precaches a DOTA unit by its dota_npc_units.txt name, provides a callback when it's finished. ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
-- @param int_3 int
function PrecacheUnitByNameAsync( string_1, handle_2, int_3 ) end

---[[ PrecacheUnitByNameSync  Precaches a DOTA unit by its dota_npc_units.txt name ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
-- @param int_3 int
function PrecacheUnitByNameSync( string_1, handle_2, int_3 ) end

---[[ PrecacheUnitFromTableAsync  Precaches a DOTA unit from a table of entity key values. ]]
-- @return void
-- @param handle_1 handle
-- @param handle_2 handle
function PrecacheUnitFromTableAsync( handle_1, handle_2 ) end

---[[ PrecacheUnitFromTableSync  Precaches a DOTA unit from a table of entity key values. ]]
-- @return void
-- @param handle_1 handle
-- @param handle_2 handle
function PrecacheUnitFromTableSync( handle_1, handle_2 ) end

---[[ PrintLinkedConsoleMessage  Print a console message with a linked console command ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function PrintLinkedConsoleMessage( string_1, string_2 ) end

---[[ RandomFloat  Get a random float within a range ]]
-- @return float
-- @param float_1 float
-- @param float_2 float
function RandomFloat( float_1, float_2 ) end

---[[ RandomInt  Get a random int within a range ]]
-- @return int
-- @param int_1 int
-- @param int_2 int
function RandomInt( int_1, int_2 ) end

---[[ RandomVector  Get a random 2D vector of the given length. ]]
-- @return Vector
-- @param float_1 float
function RandomVector( float_1 ) end

---[[ RegisterCustomAnimationScriptForModel  Register a custom animation script to run when a model loads ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function RegisterCustomAnimationScriptForModel( string_1, string_2 ) end

---[[ RegisterSpawnGroupFilterProxy  Create a C proxy for a script-based spawn group filter ]]
-- @return void
-- @param string_1 string
function RegisterSpawnGroupFilterProxy( string_1 ) end

---[[ ReloadMOTD  Reloads the MotD file ]]
-- @return void
function ReloadMOTD(  ) end

---[[ RemoveSpawnGroupFilterProxy  Remove the C proxy for a script-based spawn group filter ]]
-- @return void
-- @param string_1 string
function RemoveSpawnGroupFilterProxy( string_1 ) end

---[[ ResolveNPCPositions  Check and fix units that have been assigned a position inside collision radius of other NPCs. ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
function ResolveNPCPositions( Vector_1, float_2 ) end

---[[ RollPercentage  (int nPct) ]]
-- @return bool
-- @param int_1 int
function RollPercentage( int_1 ) end

---[[ RotateOrientation  Rotate a QAngle by another QAngle. ]]
-- @return QAngle
-- @param QAngle_1 QAngle
-- @param QAngle_2 QAngle
function RotateOrientation( QAngle_1, QAngle_2 ) end

---[[ RotatePosition  Rotate a Vector around a point. ]]
-- @return Vector
-- @param Vector_1 Vector
-- @param QAngle_2 QAngle
-- @param Vector_3 Vector
function RotatePosition( Vector_1, QAngle_2, Vector_3 ) end

---[[ RotateQuaternionByAxisAngle  (quaternion,vector,float) rotates a quaternion by the specified angle around the specified vector axis ]]
-- @return Quaternion
-- @param Quaternion_1 Quaternion
-- @param Vector_2 Vector
-- @param float_3 float
function RotateQuaternionByAxisAngle( Quaternion_1, Vector_2, float_3 ) end

---[[ RotationDelta  Find the delta between two QAngles. ]]
-- @return QAngle
-- @param QAngle_1 QAngle
-- @param QAngle_2 QAngle
function RotationDelta( QAngle_1, QAngle_2 ) end

---[[ RotationDeltaAsAngularVelocity  converts delta QAngle to an angular velocity Vector ]]
-- @return Vector
-- @param QAngle_1 QAngle
-- @param QAngle_2 QAngle
function RotationDeltaAsAngularVelocity( QAngle_1, QAngle_2 ) end

---[[ Say  Have Entity say string, and teamOnly or not ]]
-- @return void
-- @param handle_1 handle
-- @param string_2 string
-- @param bool_3 bool
function Say( handle_1, string_2, bool_3 ) end

---[[ ScreenShake  Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param float_3 float
-- @param float_4 float
-- @param float_5 float
-- @param int_6 int
-- @param bool_7 bool
function ScreenShake( Vector_1, float_2, float_3, float_4, float_5, int_6, bool_7 ) end

---[[ SendOverheadEventMessage  ( DOTAPlayer sendToPlayer, int iMessageType, Entity targetEntity, int iValue, DOTAPlayer sourcePlayer ) - sendToPlayer and sourcePlayer can be nil - iMessageType is one of OVERHEAD_ALERT_* ]]
-- @return void
-- @param handle_1 handle
-- @param int_2 int
-- @param handle_3 handle
-- @param int_4 int
-- @param handle_5 handle
function SendOverheadEventMessage( handle_1, int_2, handle_3, int_4, handle_5 ) end

---[[ SendToConsole  Send a string to the console as a client command ]]
-- @return void
-- @param string_1 string
function SendToConsole( string_1 ) end

---[[ SendToServerConsole  Send a string to the console as a server command ]]
-- @return void
-- @param string_1 string
function SendToServerConsole( string_1 ) end

---[[ SetOpvarFloatAll  Sets an opvar value for all players ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param string_3 string
-- @param float_4 float
function SetOpvarFloatAll( string_1, string_2, string_3, float_4 ) end

---[[ SetOpvarFloatPlayer  Sets an opvar value for a single player ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param string_3 string
-- @param float_4 float
-- @param handle_5 handle
function SetOpvarFloatPlayer( string_1, string_2, string_3, float_4, handle_5 ) end

---[[ SetPhysAngularVelocity  Set Angular Velocity for VPHYS or normal object, from a vector of the axis of rotation, multiplied by the degrees of rotation per second. ]]
-- @return void
-- @param handle_1 handle
-- @param Vector_2 Vector
function SetPhysAngularVelocity( handle_1, Vector_2 ) end

---[[ SetQuestName  Set the current quest name. ]]
-- @return void
-- @param string_1 string
function SetQuestName( string_1 ) end

---[[ SetQuestPhase  Set the current quest phase. ]]
-- @return void
-- @param int_1 int
function SetQuestPhase( int_1 ) end

---[[ SetRenderingEnabled  Set rendering on/off for an ehandle ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param bool_2 bool
function SetRenderingEnabled( ehandle_1, bool_2 ) end

---[[ SetTeamCustomHealthbarColor  ( teamNumber, r, g, b ) ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param int_3 int
-- @param int_4 int
function SetTeamCustomHealthbarColor( int_1, int_2, int_3, int_4 ) end

---[[ ShowCustomHeaderMessage  ( const char *pszMessage, int nPlayerID, int nValue, float flTime ) - Supports localized strings - %s1 = PlayerName, %s2 = Value, %s3 = TeamName ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
-- @param int_3 int
-- @param float_4 float
function ShowCustomHeaderMessage( string_1, int_2, int_3, float_4 ) end

---[[ ShowGenericPopup  Show a generic popup dialog for all players. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param string_3 string
-- @param string_4 string
-- @param int_5 int
function ShowGenericPopup( string_1, string_2, string_3, string_4, int_5 ) end

---[[ ShowGenericPopupToPlayer  Show a generic popup dialog to a specific player. ]]
-- @return void
-- @param handle_1 handle
-- @param string_2 string
-- @param string_3 string
-- @param string_4 string
-- @param string_5 string
-- @param int_6 int
function ShowGenericPopupToPlayer( handle_1, string_2, string_3, string_4, string_5, int_6 ) end

---[[ ShowMessage  Print a hud message on all clients ]]
-- @return void
-- @param string_1 string
function ShowMessage( string_1 ) end

---[[ SpawnDOTAShopTriggerRadiusApproximate  (Vector vOrigin, float flRadius ) ]]
-- @return handle
-- @param Vector_1 Vector
-- @param float_2 float
function SpawnDOTAShopTriggerRadiusApproximate( Vector_1, float_2 ) end

---[[ SpawnEntityFromTableSynchronous  Synchronously spawns a single entity from a table ]]
-- @return handle
-- @param string_1 string
-- @param handle_2 handle
function SpawnEntityFromTableSynchronous( string_1, handle_2 ) end

---[[ SpawnEntityGroupFromTable  Hierarchically spawn an entity group from a set of spawn tables. ]]
-- @return bool
-- @param handle_1 handle
-- @param bool_2 bool
-- @param handle_3 handle
function SpawnEntityGroupFromTable( handle_1, bool_2, handle_3 ) end

---[[ SpawnEntityListFromTableAsynchronous  Asynchronously spawn an entity group from a list of spawn tables. A callback will be triggered when the spawning is complete ]]
-- @return int
-- @param handle_1 handle
-- @param handle_2 handle
function SpawnEntityListFromTableAsynchronous( handle_1, handle_2 ) end

---[[ SpawnEntityListFromTableSynchronous  Synchronously spawn an entity group from a list of spawn tables. ]]
-- @return handle
-- @param handle_1 handle
function SpawnEntityListFromTableSynchronous( handle_1 ) end

---[[ SplineQuaternions  (quaternion,quaternion,float) very basic interpolation of v0 to v1 over t on [0,1] ]]
-- @return Quaternion
-- @param Quaternion_1 Quaternion
-- @param Quaternion_2 Quaternion
-- @param float_3 float
function SplineQuaternions( Quaternion_1, Quaternion_2, float_3 ) end

---[[ SplineVectors  (vector,vector,float) very basic interpolation of v0 to v1 over t on [0,1] ]]
-- @return Vector
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
function SplineVectors( Vector_1, Vector_2, float_3 ) end

---[[ StartSoundEvent  Start a sound event ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function StartSoundEvent( string_1, handle_2 ) end

---[[ StartSoundEventFromPosition  Start a sound event from position ]]
-- @return void
-- @param string_1 string
-- @param Vector_2 Vector
function StartSoundEventFromPosition( string_1, Vector_2 ) end

---[[ StartSoundEventFromPositionReliable  Start a sound event from position with reliable delivery ]]
-- @return void
-- @param string_1 string
-- @param Vector_2 Vector
function StartSoundEventFromPositionReliable( string_1, Vector_2 ) end

---[[ StartSoundEventFromPositionUnreliable  Start a sound event from position with optional delivery ]]
-- @return void
-- @param string_1 string
-- @param Vector_2 Vector
function StartSoundEventFromPositionUnreliable( string_1, Vector_2 ) end

---[[ StartSoundEventReliable  Start a sound event with reliable delivery ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function StartSoundEventReliable( string_1, handle_2 ) end

---[[ StartSoundEventUnreliable  Start a sound event with optional delivery ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function StartSoundEventUnreliable( string_1, handle_2 ) end

---[[ StopEffect  Pass entity and effect name ]]
-- @return void
-- @param handle_1 handle
-- @param string_2 string
function StopEffect( handle_1, string_2 ) end

---[[ StopGlobalSound  Stop named sound for all players ]]
-- @return void
-- @param string_1 string
function StopGlobalSound( string_1 ) end

---[[ StopListeningToAllGameEvents  Stop listening to all game events within a specific context. ]]
-- @return void
-- @param handle_1 handle
function StopListeningToAllGameEvents( handle_1 ) end

---[[ StopListeningToGameEvent  Stop listening to a particular game event. ]]
-- @return bool
-- @param int_1 int
function StopListeningToGameEvent( int_1 ) end

---[[ StopSoundEvent  Stops a sound event with optional delivery ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function StopSoundEvent( string_1, handle_2 ) end

---[[ StopSoundOn  Stop named sound on Entity ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function StopSoundOn( string_1, handle_2 ) end

---[[ Time  Get the current server time ]]
-- @return float
function Time(  ) end

---[[ TraceCollideable  Pass table - Inputs: start, end, ent, (optional mins, maxs) -- outputs: pos, fraction, hit, startsolid, normal ]]
-- @return bool
-- @param handle_1 handle
function TraceCollideable( handle_1 ) end

---[[ TraceHull  Pass table - Inputs: start, end, min, max, mask, ignore  -- outputs: pos, fraction, hit, enthit, startsolid ]]
-- @return bool
-- @param handle_1 handle
function TraceHull( handle_1 ) end

---[[ TraceLine  Pass table - Inputs: startpos, endpos, mask, ignore  -- outputs: pos, fraction, hit, enthit, startsolid ]]
-- @return bool
-- @param handle_1 handle
function TraceLine( handle_1 ) end

---[[ UTIL_AngleDiff  Returns the number of degrees difference between two yaw angles ]]
-- @return float
-- @param float_1 float
-- @param float_2 float
function UTIL_AngleDiff( float_1, float_2 ) end

---[[ UTIL_MessageText  Sends colored text to one client. ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
function UTIL_MessageText( int_1, string_2, int_3, int_4, int_5, int_6 ) end

---[[ UTIL_MessageTextAll  Sends colored text to all clients. ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
function UTIL_MessageTextAll( string_1, int_2, int_3, int_4, int_5 ) end

---[[ UTIL_MessageTextAll_WithContext  Sends colored text to all clients. (Valid context keys: player_id, value, team_id) ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param handle_6 handle
function UTIL_MessageTextAll_WithContext( string_1, int_2, int_3, int_4, int_5, handle_6 ) end

---[[ UTIL_MessageText_WithContext  Sends colored text to one client. (Valid context keys: player_id, value, team_id) ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param handle_7 handle
function UTIL_MessageText_WithContext( int_1, string_2, int_3, int_4, int_5, int_6, handle_7 ) end

---[[ UTIL_Remove  Removes the specified entity ]]
-- @return void
-- @param handle_1 handle
function UTIL_Remove( handle_1 ) end

---[[ UTIL_RemoveImmediate  Immediately removes the specified entity ]]
-- @return void
-- @param handle_1 handle
function UTIL_RemoveImmediate( handle_1 ) end

---[[ UTIL_ResetMessageText  Clear all message text on one client. ]]
-- @return void
-- @param int_1 int
function UTIL_ResetMessageText( int_1 ) end

---[[ UTIL_ResetMessageTextAll  Clear all message text from all clients. ]]
-- @return void
function UTIL_ResetMessageTextAll(  ) end

---[[ UnitFilter  Check if a unit passes a set of filters. (hNPC, nTargetTeam, nTargetType, nTargetFlags, nTeam ]]
-- @return int
-- @param handle_1 handle
-- @param int_2 int
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
function UnitFilter( handle_1, int_2, int_3, int_4, int_5 ) end

---[[ UnloadSpawnGroup  Unload a spawn group by name ]]
-- @return void
-- @param string_1 string
function UnloadSpawnGroup( string_1 ) end

---[[ UnloadSpawnGroupByHandle  Unload a spawn group by handle ]]
-- @return void
-- @param int_1 int
function UnloadSpawnGroupByHandle( int_1 ) end

---[[ UpdateEventPoints  ( hEventPointData ) ]]
-- @return void
-- @param handle_1 handle
function UpdateEventPoints( handle_1 ) end

---[[ VectorAngles   ]]
-- @return QAngle
-- @param Vector_1 Vector
function VectorAngles( Vector_1 ) end

---[[ VectorToAngles  Get Qangles (with no roll) for a Vector. ]]
-- @return QAngle
-- @param Vector_1 Vector
function VectorToAngles( Vector_1 ) end

---[[ Warning  Print a warning ]]
-- @return void
-- @param string_1 string
function Warning( string_1 ) end

---[[ cvar_getf  Gets the value of the given cvar, as a float. ]]
-- @return float
-- @param string_1 string
function cvar_getf( string_1 ) end

---[[ cvar_setf  Sets the value of the given cvar, as a float. ]]
-- @return bool
-- @param string_1 string
-- @param float_2 float
function cvar_setf( string_1, float_2 ) end

---[[ rr_AddDecisionRule  Add a rule to the decision database. ]]
-- @return bool
-- @param handle_1 handle
function rr_AddDecisionRule( handle_1 ) end

---[[ rr_CommitAIResponse  Commit the result of QueryBestResponse back to the given entity to play. Call with params (entity, airesponse) ]]
-- @return bool
-- @param handle_1 handle
-- @param handle_2 handle
function rr_CommitAIResponse( handle_1, handle_2 ) end

---[[ rr_GetResponseTargets  Retrieve a table of all available expresser targets, in the form { name : handle, name: handle }. ]]
-- @return handle
function rr_GetResponseTargets(  ) end

---[[ rr_QueryBestResponse  Params: (entity, query) : tests 'query' against entity's response system and returns the best response found (or null if none found). ]]
-- @return bool
-- @param handle_1 handle
-- @param handle_2 handle
-- @param handle_3 handle
function rr_QueryBestResponse( handle_1, handle_2, handle_3 ) end


--- Enum ABILITY_TYPES
ABILITY_TYPE_ATTRIBUTES = 2
ABILITY_TYPE_BASIC = 0
ABILITY_TYPE_HIDDEN = 3
ABILITY_TYPE_ULTIMATE = 1

--- Enum AbilityLearnResult_t
ABILITY_CANNOT_BE_UPGRADED_AT_MAX = 2
ABILITY_CANNOT_BE_UPGRADED_NOT_UPGRADABLE = 1
ABILITY_CANNOT_BE_UPGRADED_REQUIRES_LEVEL = 3
ABILITY_CAN_BE_UPGRADED = 0
ABILITY_NOT_LEARNABLE = 4

--- Enum AttributeDerivedStats
DOTA_ATTRIBUTE_AGILITY_ARMOR = 6
DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED = 7
DOTA_ATTRIBUTE_AGILITY_DAMAGE = 5
DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT = 8
DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE = 9
DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT = 13
DOTA_ATTRIBUTE_INTELLIGENCE_MANA = 10
DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN = 11
DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT = 12
DOTA_ATTRIBUTE_STRENGTH_DAMAGE = 0
DOTA_ATTRIBUTE_STRENGTH_HP = 1
DOTA_ATTRIBUTE_STRENGTH_HP_REGEN = 2
DOTA_ATTRIBUTE_STRENGTH_MAGIC_RESISTANCE_PERCENT = 4
DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT = 3

--- Enum Attributes
DOTA_ATTRIBUTE_AGILITY = 1
DOTA_ATTRIBUTE_INTELLECT = 2
DOTA_ATTRIBUTE_INVALID = -1
DOTA_ATTRIBUTE_MAX = 3
DOTA_ATTRIBUTE_STRENGTH = 0

--- Enum DAMAGE_TYPES
DAMAGE_TYPE_ALL = 7
DAMAGE_TYPE_HP_REMOVAL = 8
DAMAGE_TYPE_MAGICAL = 2
DAMAGE_TYPE_NONE = 0
DAMAGE_TYPE_PHYSICAL = 1
DAMAGE_TYPE_PURE = 4

--- Enum DOTAAbilitySpeakTrigger_t
DOTA_ABILITY_SPEAK_CAST = 1
DOTA_ABILITY_SPEAK_START_ACTION_PHASE = 0

--- Enum DOTADamageFlag_t
DOTA_DAMAGE_FLAG_BYPASSES_BLOCK = 8
DOTA_DAMAGE_FLAG_BYPASSES_INVULNERABILITY = 4
DOTA_DAMAGE_FLAG_DONT_DISPLAY_DAMAGE_IF_SOURCE_HIDDEN = 2048
DOTA_DAMAGE_FLAG_HPLOSS = 32
DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR = 16384
DOTA_DAMAGE_FLAG_IGNORES_MAGIC_ARMOR = 1
DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR = 2
DOTA_DAMAGE_FLAG_NONE = 0
DOTA_DAMAGE_FLAG_NON_LETHAL = 128
DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS = 512
DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT = 64
DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION = 1024
DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL = 4096
DOTA_DAMAGE_FLAG_PROPERTY_FIRE = 8192
DOTA_DAMAGE_FLAG_REFLECTION = 16
DOTA_DAMAGE_FLAG_USE_COMBAT_PROFICIENCY = 256

--- Enum DOTAHUDVisibility_t
DOTA_HUD_CUSTOMUI_BEHIND_HUD_ELEMENTS = 27
DOTA_HUD_VISIBILITY_ACTION_MINIMAP = 4
DOTA_HUD_VISIBILITY_ACTION_PANEL = 3
DOTA_HUD_VISIBILITY_COUNT = 28
DOTA_HUD_VISIBILITY_ENDGAME = 21
DOTA_HUD_VISIBILITY_ENDGAME_CHAT = 22
DOTA_HUD_VISIBILITY_HERO_SELECTION_CLOCK = 15
DOTA_HUD_VISIBILITY_HERO_SELECTION_GAME_NAME = 14
DOTA_HUD_VISIBILITY_HERO_SELECTION_TEAMS = 13
DOTA_HUD_VISIBILITY_INVALID = -1
DOTA_HUD_VISIBILITY_INVENTORY_COURIER = 9
DOTA_HUD_VISIBILITY_INVENTORY_GOLD = 11
DOTA_HUD_VISIBILITY_INVENTORY_ITEMS = 7
DOTA_HUD_VISIBILITY_INVENTORY_PANEL = 5
DOTA_HUD_VISIBILITY_INVENTORY_PROTECT = 10
DOTA_HUD_VISIBILITY_INVENTORY_QUICKBUY = 8
DOTA_HUD_VISIBILITY_INVENTORY_SHOP = 6
DOTA_HUD_VISIBILITY_KILLCAM = 25
DOTA_HUD_VISIBILITY_PREGAME_STRATEGYUI = 24
DOTA_HUD_VISIBILITY_QUICK_STATS = 23
DOTA_HUD_VISIBILITY_SHOP_SUGGESTEDITEMS = 12
DOTA_HUD_VISIBILITY_TOP_BAR = 26
DOTA_HUD_VISIBILITY_TOP_BAR_BACKGROUND = 17
DOTA_HUD_VISIBILITY_TOP_BAR_DIRE_TEAM = 19
DOTA_HUD_VISIBILITY_TOP_BAR_RADIANT_TEAM = 18
DOTA_HUD_VISIBILITY_TOP_BAR_SCORE = 20
DOTA_HUD_VISIBILITY_TOP_HEROES = 1
DOTA_HUD_VISIBILITY_TOP_MENU_BUTTONS = 16
DOTA_HUD_VISIBILITY_TOP_SCOREBOARD = 2
DOTA_HUD_VISIBILITY_TOP_TIMEOFDAY = 0

--- Enum DOTAInventoryFlags_t
DOTA_INVENTORY_ALLOW_DROP_AT_FOUNTAIN = 8
DOTA_INVENTORY_ALLOW_DROP_ON_GROUND = 4
DOTA_INVENTORY_ALLOW_MAIN = 1
DOTA_INVENTORY_ALLOW_NONE = 0
DOTA_INVENTORY_ALLOW_STASH = 2
DOTA_INVENTORY_ALL_ACCESS = 3
DOTA_INVENTORY_LIMIT_DROP_ON_GROUND = 16

--- Enum DOTALimits_t
DOTA_DEFAULT_MAX_TEAM = 5 -- Default number of players per team.
DOTA_DEFAULT_MAX_TEAM_PLAYERS = 10 -- Default number of non-spectator players supported.
DOTA_MAX_PLAYERS = 64 -- Max number of players connected to the server including spectators.
DOTA_MAX_PLAYER_TEAMS = 10 -- Max number of player teams supported.
DOTA_MAX_SPECTATOR_LOBBY_SIZE = 15 -- Max number of viewers in a spectator lobby.
DOTA_MAX_SPECTATOR_TEAM_SIZE = 40 -- How many spectators can watch.
DOTA_MAX_TEAM = 24 -- Max number of players per team.
DOTA_MAX_TEAM_PLAYERS = 24 -- Max number of non-spectator players supported.

--- Enum DOTAMinimapEvent_t
DOTA_MINIMAP_EVENT_ANCIENT_UNDER_ATTACK = 2
DOTA_MINIMAP_EVENT_BASE_GLYPHED = 8
DOTA_MINIMAP_EVENT_BASE_UNDER_ATTACK = 4
DOTA_MINIMAP_EVENT_CANCEL_TELEPORTING = 2048
DOTA_MINIMAP_EVENT_ENEMY_TELEPORTING = 1024
DOTA_MINIMAP_EVENT_HINT_LOCATION = 512
DOTA_MINIMAP_EVENT_MOVE_TO_TARGET = 16384
DOTA_MINIMAP_EVENT_RADAR = 4096
DOTA_MINIMAP_EVENT_RADAR_TARGET = 8192
DOTA_MINIMAP_EVENT_TEAMMATE_DIED = 64
DOTA_MINIMAP_EVENT_TEAMMATE_TELEPORTING = 32
DOTA_MINIMAP_EVENT_TEAMMATE_UNDER_ATTACK = 16
DOTA_MINIMAP_EVENT_TUTORIAL_TASK_ACTIVE = 128
DOTA_MINIMAP_EVENT_TUTORIAL_TASK_FINISHED = 256

--- Enum DOTAModifierAttribute_t
MODIFIER_ATTRIBUTE_AURA_PRIORITY = 8
MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE = 4
MODIFIER_ATTRIBUTE_MULTIPLE = 2
MODIFIER_ATTRIBUTE_NONE = 0
MODIFIER_ATTRIBUTE_PERMANENT = 1

--- Enum DOTAMusicStatus_t
DOTA_MUSIC_STATUS_BATTLE = 2
DOTA_MUSIC_STATUS_DEAD = 4
DOTA_MUSIC_STATUS_EXPLORATION = 1
DOTA_MUSIC_STATUS_LAST = 5
DOTA_MUSIC_STATUS_NONE = 0
DOTA_MUSIC_STATUS_PRE_GAME_EXPLORATION = 3

--- Enum DOTAProjectileAttachment_t
DOTA_PROJECTILE_ATTACHMENT_ATTACK_1 = 1
DOTA_PROJECTILE_ATTACHMENT_ATTACK_2 = 2
DOTA_PROJECTILE_ATTACHMENT_ATTACK_3 = 4
DOTA_PROJECTILE_ATTACHMENT_ATTACK_4 = 5
DOTA_PROJECTILE_ATTACHMENT_HITLOCATION = 3
DOTA_PROJECTILE_ATTACHMENT_LAST = 6
DOTA_PROJECTILE_ATTACHMENT_NONE = 0

--- Enum DOTAScriptInventorySlot_t
DOTA_ITEM_SLOT_1 = 0
DOTA_ITEM_SLOT_2 = 1
DOTA_ITEM_SLOT_3 = 2
DOTA_ITEM_SLOT_4 = 3
DOTA_ITEM_SLOT_5 = 4
DOTA_ITEM_SLOT_6 = 5
DOTA_ITEM_SLOT_7 = 6
DOTA_ITEM_SLOT_8 = 7
DOTA_ITEM_SLOT_9 = 8
DOTA_STASH_SLOT_1 = 9
DOTA_STASH_SLOT_2 = 10
DOTA_STASH_SLOT_3 = 11
DOTA_STASH_SLOT_4 = 12
DOTA_STASH_SLOT_5 = 13
DOTA_STASH_SLOT_6 = 14

--- Enum DOTASlotType_t
DOTA_LOADOUT_PERSONA_1_END = 55
DOTA_LOADOUT_PERSONA_1_START = 28
DOTA_LOADOUT_TYPE_ABILITY1 = 22
DOTA_LOADOUT_TYPE_ABILITY1_PERSONA_1 = 50
DOTA_LOADOUT_TYPE_ABILITY2 = 23
DOTA_LOADOUT_TYPE_ABILITY2_PERSONA_1 = 51
DOTA_LOADOUT_TYPE_ABILITY3 = 24
DOTA_LOADOUT_TYPE_ABILITY3_PERSONA_1 = 52
DOTA_LOADOUT_TYPE_ABILITY4 = 25
DOTA_LOADOUT_TYPE_ABILITY4_PERSONA_1 = 53
DOTA_LOADOUT_TYPE_ABILITY_ATTACK = 21
DOTA_LOADOUT_TYPE_ABILITY_ATTACK_PERSONA_1 = 49
DOTA_LOADOUT_TYPE_ABILITY_ULTIMATE = 26
DOTA_LOADOUT_TYPE_ABILITY_ULTIMATE_PERSONA_1 = 54
DOTA_LOADOUT_TYPE_AMBIENT_EFFECTS = 20
DOTA_LOADOUT_TYPE_AMBIENT_EFFECTS_PERSONA_1 = 48
DOTA_LOADOUT_TYPE_ANNOUNCER = 58
DOTA_LOADOUT_TYPE_ARMOR = 7
DOTA_LOADOUT_TYPE_ARMOR_PERSONA_1 = 35
DOTA_LOADOUT_TYPE_ARMS = 6
DOTA_LOADOUT_TYPE_ARMS_PERSONA_1 = 34
DOTA_LOADOUT_TYPE_BACK = 10
DOTA_LOADOUT_TYPE_BACK_PERSONA_1 = 38
DOTA_LOADOUT_TYPE_BELT = 8
DOTA_LOADOUT_TYPE_BELT_PERSONA_1 = 36
DOTA_LOADOUT_TYPE_BLINK_EFFECT = 69
DOTA_LOADOUT_TYPE_BODY_HEAD = 15
DOTA_LOADOUT_TYPE_BODY_HEAD_PERSONA_1 = 43
DOTA_LOADOUT_TYPE_COUNT = 78
DOTA_LOADOUT_TYPE_COURIER = 57
DOTA_LOADOUT_TYPE_CURSOR_PACK = 67
DOTA_LOADOUT_TYPE_DIRE_CREEPS = 73
DOTA_LOADOUT_TYPE_DIRE_TOWER = 75
DOTA_LOADOUT_TYPE_EMBLEM = 70
DOTA_LOADOUT_TYPE_GLOVES = 12
DOTA_LOADOUT_TYPE_GLOVES_PERSONA_1 = 40
DOTA_LOADOUT_TYPE_HEAD = 4
DOTA_LOADOUT_TYPE_HEAD_PERSONA_1 = 32
DOTA_LOADOUT_TYPE_HEROIC_STATUE = 65
DOTA_LOADOUT_TYPE_HUD_SKIN = 62
DOTA_LOADOUT_TYPE_INVALID = -1
DOTA_LOADOUT_TYPE_LEGS = 11
DOTA_LOADOUT_TYPE_LEGS_PERSONA_1 = 39
DOTA_LOADOUT_TYPE_LOADING_SCREEN = 63
DOTA_LOADOUT_TYPE_MEGA_KILLS = 59
DOTA_LOADOUT_TYPE_MISC = 14
DOTA_LOADOUT_TYPE_MISC_PERSONA_1 = 42
DOTA_LOADOUT_TYPE_MOUNT = 16
DOTA_LOADOUT_TYPE_MOUNT_PERSONA_1 = 44
DOTA_LOADOUT_TYPE_MULTIKILL_BANNER = 66
DOTA_LOADOUT_TYPE_MUSIC = 60
DOTA_LOADOUT_TYPE_NECK = 9
DOTA_LOADOUT_TYPE_NECK_PERSONA_1 = 37
DOTA_LOADOUT_TYPE_NONE = 77
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON = 1
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON2 = 3
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON2_PERSONA_1 = 31
DOTA_LOADOUT_TYPE_OFFHAND_WEAPON_PERSONA_1 = 29
DOTA_LOADOUT_TYPE_PERSONA_SELECTOR = 56
DOTA_LOADOUT_TYPE_RADIANT_CREEPS = 72
DOTA_LOADOUT_TYPE_RADIANT_TOWER = 74
DOTA_LOADOUT_TYPE_SHAPESHIFT = 18
DOTA_LOADOUT_TYPE_SHAPESHIFT_PERSONA_1 = 46
DOTA_LOADOUT_TYPE_SHOULDER = 5
DOTA_LOADOUT_TYPE_SHOULDER_PERSONA_1 = 33
DOTA_LOADOUT_TYPE_SUMMON = 17
DOTA_LOADOUT_TYPE_SUMMON_PERSONA_1 = 45
DOTA_LOADOUT_TYPE_TAIL = 13
DOTA_LOADOUT_TYPE_TAIL_PERSONA_1 = 41
DOTA_LOADOUT_TYPE_TAUNT = 19
DOTA_LOADOUT_TYPE_TAUNT_PERSONA_1 = 47
DOTA_LOADOUT_TYPE_TELEPORT_EFFECT = 68
DOTA_LOADOUT_TYPE_TERRAIN = 71
DOTA_LOADOUT_TYPE_VERSUS_SCREEN = 76
DOTA_LOADOUT_TYPE_VOICE = 27
DOTA_LOADOUT_TYPE_VOICE_PERSONA_1 = 55
DOTA_LOADOUT_TYPE_WARD = 61
DOTA_LOADOUT_TYPE_WEAPON = 0
DOTA_LOADOUT_TYPE_WEAPON2 = 2
DOTA_LOADOUT_TYPE_WEAPON2_PERSONA_1 = 30
DOTA_LOADOUT_TYPE_WEAPON_PERSONA_1 = 28
DOTA_LOADOUT_TYPE_WEATHER = 64
DOTA_PLAYER_LOADOUT_END = 76
DOTA_PLAYER_LOADOUT_START = 57

--- Enum DOTASpeechType_t
DOTA_SPEECH_BAD_TEAM = 7
DOTA_SPEECH_GOOD_TEAM = 6
DOTA_SPEECH_RECIPIENT_TYPE_MAX = 9
DOTA_SPEECH_SPECTATOR = 8
DOTA_SPEECH_USER_ALL = 5
DOTA_SPEECH_USER_INVALID = 0
DOTA_SPEECH_USER_NEARBY = 4
DOTA_SPEECH_USER_SINGLE = 1
DOTA_SPEECH_USER_TEAM = 2
DOTA_SPEECH_USER_TEAM_NEARBY = 3

--- Enum DOTATeam_t
DOTA_TEAM_BADGUYS = 3
DOTA_TEAM_COUNT = 14
DOTA_TEAM_CUSTOM_1 = 6
DOTA_TEAM_CUSTOM_2 = 7
DOTA_TEAM_CUSTOM_3 = 8
DOTA_TEAM_CUSTOM_4 = 9
DOTA_TEAM_CUSTOM_5 = 10
DOTA_TEAM_CUSTOM_6 = 11
DOTA_TEAM_CUSTOM_7 = 12
DOTA_TEAM_CUSTOM_8 = 13
DOTA_TEAM_CUSTOM_COUNT = 8
DOTA_TEAM_CUSTOM_MAX = 13
DOTA_TEAM_CUSTOM_MIN = 6
DOTA_TEAM_FIRST = 2
DOTA_TEAM_GOODGUYS = 2
DOTA_TEAM_NEUTRALS = 4
DOTA_TEAM_NOTEAM = 5

--- Enum DOTAUnitAttackCapability_t
DOTA_UNIT_ATTACK_CAPABILITY_BIT_COUNT = 3
DOTA_UNIT_CAP_MELEE_ATTACK = 1
DOTA_UNIT_CAP_NO_ATTACK = 0
DOTA_UNIT_CAP_RANGED_ATTACK = 2
DOTA_UNIT_CAP_RANGED_ATTACK_DIRECTIONAL = 4

--- Enum DOTAUnitMoveCapability_t
DOTA_UNIT_CAP_MOVE_FLY = 2
DOTA_UNIT_CAP_MOVE_GROUND = 1
DOTA_UNIT_CAP_MOVE_NONE = 0

--- Enum DOTA_ABILITY_BEHAVIOR
DOTA_ABILITY_BEHAVIOR_AOE = 32
DOTA_ABILITY_BEHAVIOR_ATTACK = 131072
DOTA_ABILITY_BEHAVIOR_AURA = 65536
DOTA_ABILITY_BEHAVIOR_AUTOCAST = 4096
DOTA_ABILITY_BEHAVIOR_CAN_SELF_CAST = 0
DOTA_ABILITY_BEHAVIOR_CHANNELLED = 128
DOTA_ABILITY_BEHAVIOR_DIRECTIONAL = 1024
DOTA_ABILITY_BEHAVIOR_DONT_ALERT_TARGET = 16777216
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL = 536870912
DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT = 8388608
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK = 33554432
DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT = 262144
DOTA_ABILITY_BEHAVIOR_FREE_DRAW_TARGETING = 0
DOTA_ABILITY_BEHAVIOR_HIDDEN = 1
DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING = 134217728
DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL = 4194304
DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE = 2097152
DOTA_ABILITY_BEHAVIOR_IMMEDIATE = 2048
DOTA_ABILITY_BEHAVIOR_ITEM = 256
DOTA_ABILITY_BEHAVIOR_LAST_RESORT_POINT = -2147483648
DOTA_ABILITY_BEHAVIOR_NONE = 0
DOTA_ABILITY_BEHAVIOR_NORMAL_WHEN_STOLEN = 67108864
DOTA_ABILITY_BEHAVIOR_NOT_LEARNABLE = 64
DOTA_ABILITY_BEHAVIOR_NO_TARGET = 4
DOTA_ABILITY_BEHAVIOR_OPTIONAL_NO_TARGET = 32768
DOTA_ABILITY_BEHAVIOR_OPTIONAL_POINT = 16384
DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET = 8192
DOTA_ABILITY_BEHAVIOR_PASSIVE = 2
DOTA_ABILITY_BEHAVIOR_POINT = 16
DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES = 524288
DOTA_ABILITY_BEHAVIOR_RUNE_TARGET = 268435456
DOTA_ABILITY_BEHAVIOR_SHOW_IN_GUIDES = 0
DOTA_ABILITY_BEHAVIOR_SUPPRESS_ASSOCIATED_CONSUMABLE = 0
DOTA_ABILITY_BEHAVIOR_TOGGLE = 512
DOTA_ABILITY_BEHAVIOR_UNIT_TARGET = 8
DOTA_ABILITY_BEHAVIOR_UNLOCKED_BY_EFFECT_INDEX = 0
DOTA_ABILITY_BEHAVIOR_UNRESTRICTED = 1048576
DOTA_ABILITY_BEHAVIOR_VECTOR_TARGETING = 1073741824

--- Enum DOTA_GameState
DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP = 2
DOTA_GAMERULES_STATE_DISCONNECT = 10
DOTA_GAMERULES_STATE_GAME_IN_PROGRESS = 8
DOTA_GAMERULES_STATE_HERO_SELECTION = 3
DOTA_GAMERULES_STATE_INIT = 0
DOTA_GAMERULES_STATE_POST_GAME = 9
DOTA_GAMERULES_STATE_PRE_GAME = 7
DOTA_GAMERULES_STATE_STRATEGY_TIME = 4
DOTA_GAMERULES_STATE_TEAM_SHOWCASE = 5
DOTA_GAMERULES_STATE_WAIT_FOR_MAP_TO_LOAD = 6
DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD = 1

--- Enum DOTA_HeroPickState
DOTA_HEROPICK_STATE_ALL_DRAFT_SELECT = 55
DOTA_HEROPICK_STATE_AP_SELECT = 1
DOTA_HEROPICK_STATE_AR_SELECT = 30
DOTA_HEROPICK_STATE_BD_SELECT = 52
DOTA_HEROPICK_STATE_CD_BAN1 = 35
DOTA_HEROPICK_STATE_CD_BAN2 = 36
DOTA_HEROPICK_STATE_CD_BAN3 = 37
DOTA_HEROPICK_STATE_CD_BAN4 = 38
DOTA_HEROPICK_STATE_CD_BAN5 = 39
DOTA_HEROPICK_STATE_CD_BAN6 = 40
DOTA_HEROPICK_STATE_CD_CAPTAINPICK = 34
DOTA_HEROPICK_STATE_CD_INTRO = 33
DOTA_HEROPICK_STATE_CD_PICK = 51
DOTA_HEROPICK_STATE_CD_SELECT1 = 41
DOTA_HEROPICK_STATE_CD_SELECT10 = 50
DOTA_HEROPICK_STATE_CD_SELECT2 = 42
DOTA_HEROPICK_STATE_CD_SELECT3 = 43
DOTA_HEROPICK_STATE_CD_SELECT4 = 44
DOTA_HEROPICK_STATE_CD_SELECT5 = 45
DOTA_HEROPICK_STATE_CD_SELECT6 = 46
DOTA_HEROPICK_STATE_CD_SELECT7 = 47
DOTA_HEROPICK_STATE_CD_SELECT8 = 48
DOTA_HEROPICK_STATE_CD_SELECT9 = 49
DOTA_HEROPICK_STATE_CM_BAN1 = 7
DOTA_HEROPICK_STATE_CM_BAN10 = 16
DOTA_HEROPICK_STATE_CM_BAN11 = 17
DOTA_HEROPICK_STATE_CM_BAN12 = 18
DOTA_HEROPICK_STATE_CM_BAN2 = 8
DOTA_HEROPICK_STATE_CM_BAN3 = 9
DOTA_HEROPICK_STATE_CM_BAN4 = 10
DOTA_HEROPICK_STATE_CM_BAN5 = 11
DOTA_HEROPICK_STATE_CM_BAN6 = 12
DOTA_HEROPICK_STATE_CM_BAN7 = 13
DOTA_HEROPICK_STATE_CM_BAN8 = 14
DOTA_HEROPICK_STATE_CM_BAN9 = 15
DOTA_HEROPICK_STATE_CM_CAPTAINPICK = 6
DOTA_HEROPICK_STATE_CM_INTRO = 5
DOTA_HEROPICK_STATE_CM_PICK = 29
DOTA_HEROPICK_STATE_CM_SELECT1 = 19
DOTA_HEROPICK_STATE_CM_SELECT10 = 28
DOTA_HEROPICK_STATE_CM_SELECT2 = 20
DOTA_HEROPICK_STATE_CM_SELECT3 = 21
DOTA_HEROPICK_STATE_CM_SELECT4 = 22
DOTA_HEROPICK_STATE_CM_SELECT5 = 23
DOTA_HEROPICK_STATE_CM_SELECT6 = 24
DOTA_HEROPICK_STATE_CM_SELECT7 = 25
DOTA_HEROPICK_STATE_CM_SELECT8 = 26
DOTA_HEROPICK_STATE_CM_SELECT9 = 27
DOTA_HEROPICK_STATE_COUNT = 59
DOTA_HEROPICK_STATE_CUSTOM_PICK_RULES = 58
DOTA_HEROPICK_STATE_FH_SELECT = 32
DOTA_HEROPICK_STATE_INTRO_SELECT_UNUSED = 3
DOTA_HEROPICK_STATE_MO_SELECT = 31
DOTA_HEROPICK_STATE_NONE = 0
DOTA_HEROPICK_STATE_RD_SELECT_UNUSED = 4
DOTA_HEROPICK_STATE_SD_SELECT = 2
DOTA_HEROPICK_STATE_SELECT_PENALTY = 57
DOTA_HERO_PICK_STATE_ABILITY_DRAFT_SELECT = 53
DOTA_HERO_PICK_STATE_ARDM_SELECT = 54
DOTA_HERO_PICK_STATE_CUSTOMGAME_SELECT = 56

--- Enum DOTA_MOTION_CONTROLLER_PRIORITY
DOTA_MOTION_CONTROLLER_PRIORITY_HIGH = 3
DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST = 4
DOTA_MOTION_CONTROLLER_PRIORITY_LOW = 1
DOTA_MOTION_CONTROLLER_PRIORITY_LOWEST = 0
DOTA_MOTION_CONTROLLER_PRIORITY_MEDIUM = 2

--- Enum DOTA_RUNES
DOTA_RUNE_ARCANE = 6
DOTA_RUNE_BOUNTY = 5
DOTA_RUNE_COUNT = 8
DOTA_RUNE_DOUBLEDAMAGE = 0
DOTA_RUNE_HASTE = 1
DOTA_RUNE_ILLUSION = 2
DOTA_RUNE_INVALID = -1
DOTA_RUNE_INVISIBILITY = 3
DOTA_RUNE_REGENERATION = 4
DOTA_RUNE_XP = 7

--- Enum DOTA_SHOP_TYPE
DOTA_SHOP_CUSTOM = 6
DOTA_SHOP_GROUND = 3
DOTA_SHOP_HOME = 0
DOTA_SHOP_NONE = 7
DOTA_SHOP_SECRET = 2
DOTA_SHOP_SECRET2 = 5
DOTA_SHOP_SIDE = 1
DOTA_SHOP_SIDE2 = 4

--- Enum DOTA_UNIT_TARGET_FLAGS
DOTA_UNIT_TARGET_FLAG_CHECK_DISABLE_HELP = 65536
DOTA_UNIT_TARGET_FLAG_DEAD = 8
DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE = 128
DOTA_UNIT_TARGET_FLAG_INVULNERABLE = 64
DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES = 16
DOTA_UNIT_TARGET_FLAG_MANA_ONLY = 32768
DOTA_UNIT_TARGET_FLAG_MELEE_ONLY = 4
DOTA_UNIT_TARGET_FLAG_NONE = 0
DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS = 512
DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE = 16384
DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO = 131072
DOTA_UNIT_TARGET_FLAG_NOT_DOMINATED = 2048
DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS = 8192
DOTA_UNIT_TARGET_FLAG_NOT_MAGIC_IMMUNE_ALLIES = 32
DOTA_UNIT_TARGET_FLAG_NOT_NIGHTMARED = 524288
DOTA_UNIT_TARGET_FLAG_NOT_SUMMONED = 4096
DOTA_UNIT_TARGET_FLAG_NO_INVIS = 256
DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD = 262144
DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED = 1024
DOTA_UNIT_TARGET_FLAG_PREFER_ENEMIES = 1048576
DOTA_UNIT_TARGET_FLAG_RANGED_ONLY = 2
DOTA_UNIT_TARGET_FLAG_RESPECT_OBSTRUCTIONS = 2097152

--- Enum DOTA_UNIT_TARGET_TEAM
DOTA_UNIT_TARGET_TEAM_BOTH = 3
DOTA_UNIT_TARGET_TEAM_CUSTOM = 4
DOTA_UNIT_TARGET_TEAM_ENEMY = 2
DOTA_UNIT_TARGET_TEAM_FRIENDLY = 1
DOTA_UNIT_TARGET_TEAM_NONE = 0

--- Enum DOTA_UNIT_TARGET_TYPE
DOTA_UNIT_TARGET_ALL = 55
DOTA_UNIT_TARGET_BASIC = 18
DOTA_UNIT_TARGET_BUILDING = 4
DOTA_UNIT_TARGET_COURIER = 16
DOTA_UNIT_TARGET_CREEP = 2
DOTA_UNIT_TARGET_CUSTOM = 128
DOTA_UNIT_TARGET_HERO = 1
DOTA_UNIT_TARGET_NONE = 0
DOTA_UNIT_TARGET_OTHER = 32
DOTA_UNIT_TARGET_TREE = 64

--- Enum DamageCategory_t
DOTA_DAMAGE_CATEGORY_ATTACK = 1
DOTA_DAMAGE_CATEGORY_SPELL = 0

--- Enum DotaDefaultUIElement_t
DOTA_DEFAULT_UI_ACTION_MINIMAP = 4
DOTA_DEFAULT_UI_ACTION_PANEL = 3
DOTA_DEFAULT_UI_CUSTOMUI_BEHIND_HUD_ELEMENTS = 27
DOTA_DEFAULT_UI_ELEMENT_COUNT = 28
DOTA_DEFAULT_UI_ENDGAME = 21
DOTA_DEFAULT_UI_ENDGAME_CHAT = 22
DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD = 2
DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK = 15
DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME = 14
DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS = 13
DOTA_DEFAULT_UI_INVALID = -1
DOTA_DEFAULT_UI_INVENTORY_COURIER = 9
DOTA_DEFAULT_UI_INVENTORY_GOLD = 11
DOTA_DEFAULT_UI_INVENTORY_ITEMS = 7
DOTA_DEFAULT_UI_INVENTORY_PANEL = 5
DOTA_DEFAULT_UI_INVENTORY_PROTECT = 10
DOTA_DEFAULT_UI_INVENTORY_QUICKBUY = 8
DOTA_DEFAULT_UI_INVENTORY_SHOP = 6
DOTA_DEFAULT_UI_KILLCAM = 25
DOTA_DEFAULT_UI_PREGAME_STRATEGYUI = 24
DOTA_DEFAULT_UI_QUICK_STATS = 23
DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS = 12
DOTA_DEFAULT_UI_TOP_BAR = 26
DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND = 17
DOTA_DEFAULT_UI_TOP_BAR_DIRE_TEAM = 19
DOTA_DEFAULT_UI_TOP_BAR_RADIANT_TEAM = 18
DOTA_DEFAULT_UI_TOP_BAR_SCORE = 20
DOTA_DEFAULT_UI_TOP_HEROES = 1
DOTA_DEFAULT_UI_TOP_MENU_BUTTONS = 16
DOTA_DEFAULT_UI_TOP_TIMEOFDAY = 0

--- Enum EDOTA_ModifyGold_Reason
DOTA_ModifyGold_AbandonedRedistribute = 5
DOTA_ModifyGold_AbilityCost = 7
DOTA_ModifyGold_Building = 11
DOTA_ModifyGold_Buyback = 2
DOTA_ModifyGold_CheatCommand = 8
DOTA_ModifyGold_CourierKill = 15
DOTA_ModifyGold_CreepKill = 13
DOTA_ModifyGold_Death = 1
DOTA_ModifyGold_GameTick = 10
DOTA_ModifyGold_HeroKill = 12
DOTA_ModifyGold_PurchaseConsumable = 3
DOTA_ModifyGold_PurchaseItem = 4
DOTA_ModifyGold_RoshanKill = 14
DOTA_ModifyGold_SelectionPenalty = 9
DOTA_ModifyGold_SellItem = 6
DOTA_ModifyGold_SharedGold = 16
DOTA_ModifyGold_Unspecified = 0

--- Enum EDOTA_ModifyXP_Reason
DOTA_ModifyXP_CreepKill = 2
DOTA_ModifyXP_HeroKill = 1
DOTA_ModifyXP_RoshanKill = 3
DOTA_ModifyXP_Unspecified = 0

--- Enum EShareAbility
ITEM_FULLY_SHAREABLE = 0
ITEM_NOT_SHAREABLE = 2
ITEM_PARTIALLY_SHAREABLE = 1

--- Enum GameActivity_t
ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END = 1580
ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START = 1572
ACT_DOTA_ALCHEMIST_CONCOCTION = 1573
ACT_DOTA_ALCHEMIST_CONCOCTION_THROW = 1579
ACT_DOTA_AMBUSH = 1627
ACT_DOTA_ANCESTRAL_SPIRIT = 1677
ACT_DOTA_ARCTIC_BURN_END = 1682
ACT_DOTA_AREA_DENY = 1661
ACT_DOTA_ATTACK = 1503
ACT_DOTA_ATTACK2 = 1504
ACT_DOTA_ATTACK_EVENT = 1505
ACT_DOTA_ATTACK_EVENT_BASH = 1705
ACT_DOTA_AW_MAGNETIC_FIELD = 1707
ACT_DOTA_BELLYACHE_END = 1614
ACT_DOTA_BELLYACHE_LOOP = 1613
ACT_DOTA_BELLYACHE_START = 1612
ACT_DOTA_BLINK_DAGGER = 1732
ACT_DOTA_BLINK_DAGGER_END = 1733
ACT_DOTA_BRIDGE_DESTROY = 1640
ACT_DOTA_BRIDGE_THREAT = 1650
ACT_DOTA_CAGED_CREEP_RAGE = 1644
ACT_DOTA_CAGED_CREEP_RAGE_OUT = 1645
ACT_DOTA_CAGED_CREEP_SMASH = 1646
ACT_DOTA_CAGED_CREEP_SMASH_OUT = 1647
ACT_DOTA_CANCEL_SIREN_SONG = 1599
ACT_DOTA_CAPTURE = 1533
ACT_DOTA_CAPTURE_CARD = 1717
ACT_DOTA_CAPTURE_PET = 1698
ACT_DOTA_CAPTURE_RARE = 1706
ACT_DOTA_CAST_ABILITY_1 = 1510
ACT_DOTA_CAST_ABILITY_1_END = 1540
ACT_DOTA_CAST_ABILITY_2 = 1511
ACT_DOTA_CAST_ABILITY_2_ALLY = 1748
ACT_DOTA_CAST_ABILITY_2_END = 1541
ACT_DOTA_CAST_ABILITY_2_ES_ROLL = 1653
ACT_DOTA_CAST_ABILITY_2_ES_ROLL_END = 1654
ACT_DOTA_CAST_ABILITY_2_ES_ROLL_START = 1652
ACT_DOTA_CAST_ABILITY_3 = 1512
ACT_DOTA_CAST_ABILITY_3_END = 1542
ACT_DOTA_CAST_ABILITY_4 = 1513
ACT_DOTA_CAST_ABILITY_4_END = 1543
ACT_DOTA_CAST_ABILITY_5 = 1514
ACT_DOTA_CAST_ABILITY_6 = 1515
ACT_DOTA_CAST_ABILITY_7 = 1598
ACT_DOTA_CAST_ABILITY_ROT = 1547
ACT_DOTA_CAST_ALACRITY = 1585
ACT_DOTA_CAST_ALACRITY_ORB = 1741
ACT_DOTA_CAST_BURROW_END = 1702
ACT_DOTA_CAST_CHAOS_METEOR = 1586
ACT_DOTA_CAST_CHAOS_METEOR_ORB = 1742
ACT_DOTA_CAST_COLD_SNAP = 1581
ACT_DOTA_CAST_COLD_SNAP_ORB = 1737
ACT_DOTA_CAST_DEAFENING_BLAST = 1590
ACT_DOTA_CAST_DEAFENING_BLAST_ORB = 1746
ACT_DOTA_CAST_DRAGONBREATH = 1538
ACT_DOTA_CAST_EMP = 1584
ACT_DOTA_CAST_EMP_ORB = 1740
ACT_DOTA_CAST_FORGE_SPIRIT = 1588
ACT_DOTA_CAST_FORGE_SPIRIT_ORB = 1744
ACT_DOTA_CAST_GHOST_SHIP = 1708
ACT_DOTA_CAST_GHOST_WALK = 1582
ACT_DOTA_CAST_GHOST_WALK_ORB = 1738
ACT_DOTA_CAST_ICE_WALL = 1589
ACT_DOTA_CAST_ICE_WALL_ORB = 1745
ACT_DOTA_CAST_LIFE_BREAK_END = 1564
ACT_DOTA_CAST_LIFE_BREAK_START = 1563
ACT_DOTA_CAST_REFRACTION = 1597
ACT_DOTA_CAST_SUN_STRIKE = 1587
ACT_DOTA_CAST_SUN_STRIKE_ORB = 1743
ACT_DOTA_CAST_TORNADO = 1583
ACT_DOTA_CAST_TORNADO_ORB = 1739
ACT_DOTA_CAST_WILD_AXES_END = 1562
ACT_DOTA_CENTAUR_STAMPEDE = 1611
ACT_DOTA_CHANNEL_ABILITY_1 = 1520
ACT_DOTA_CHANNEL_ABILITY_2 = 1521
ACT_DOTA_CHANNEL_ABILITY_3 = 1522
ACT_DOTA_CHANNEL_ABILITY_4 = 1523
ACT_DOTA_CHANNEL_ABILITY_5 = 1524
ACT_DOTA_CHANNEL_ABILITY_6 = 1525
ACT_DOTA_CHANNEL_ABILITY_7 = 1600
ACT_DOTA_CHANNEL_END_ABILITY_1 = 1526
ACT_DOTA_CHANNEL_END_ABILITY_2 = 1527
ACT_DOTA_CHANNEL_END_ABILITY_3 = 1528
ACT_DOTA_CHANNEL_END_ABILITY_4 = 1529
ACT_DOTA_CHANNEL_END_ABILITY_5 = 1530
ACT_DOTA_CHANNEL_END_ABILITY_6 = 1531
ACT_DOTA_CHILLING_TOUCH = 1673
ACT_DOTA_COLD_FEET = 1671
ACT_DOTA_CONSTANT_LAYER = 1532
ACT_DOTA_CUSTOM_TOWER_ATTACK = 1734
ACT_DOTA_CUSTOM_TOWER_DIE = 1736
ACT_DOTA_CUSTOM_TOWER_IDLE = 1735
ACT_DOTA_DAGON = 1651
ACT_DOTA_DEATH_BY_SNIPER = 1642
ACT_DOTA_DEFEAT = 1592
ACT_DOTA_DEFEAT_START = 1711
ACT_DOTA_DIE = 1506
ACT_DOTA_DIE_SPECIAL = 1548
ACT_DOTA_DISABLED = 1509
ACT_DOTA_DP_SPIRIT_SIPHON = 1712
ACT_DOTA_EARTHSHAKER_TOTEM_ATTACK = 1570
ACT_DOTA_ECHO_SLAM = 1539
ACT_DOTA_ENFEEBLE = 1674
ACT_DOTA_ES_STONE_CALLER = 1714
ACT_DOTA_FATAL_BONDS = 1675
ACT_DOTA_FLAIL = 1508
ACT_DOTA_FLEE = 1685
ACT_DOTA_FLINCH = 1507
ACT_DOTA_FORCESTAFF_END = 1602
ACT_DOTA_FRUSTRATION = 1630
ACT_DOTA_FXANIM = 1709
ACT_DOTA_GENERIC_CHANNEL_1 = 1728
ACT_DOTA_GESTURE_ACCENT = 1625
ACT_DOTA_GESTURE_POINT = 1624
ACT_DOTA_GREET = 1690
ACT_DOTA_GREEVIL_BLINK_BONE = 1621
ACT_DOTA_GREEVIL_CAST = 1617
ACT_DOTA_GREEVIL_HOOK_END = 1620
ACT_DOTA_GREEVIL_HOOK_START = 1619
ACT_DOTA_GREEVIL_OVERRIDE_ABILITY = 1618
ACT_DOTA_GS_INK_CREATURE = 1730
ACT_DOTA_GS_SOUL_CHAIN = 1729
ACT_DOTA_ICE_VORTEX = 1672
ACT_DOTA_IDLE = 1500
ACT_DOTA_IDLE_IMPATIENT = 1636
ACT_DOTA_IDLE_IMPATIENT_SWORD_TAP = 1648
ACT_DOTA_IDLE_RARE = 1501
ACT_DOTA_IDLE_SLEEPING = 1622
ACT_DOTA_IDLE_SLEEPING_END = 1639
ACT_DOTA_INTRO = 1623
ACT_DOTA_INTRO_LOOP = 1649
ACT_DOTA_ITEM_DROP = 1697
ACT_DOTA_ITEM_LOOK = 1628
ACT_DOTA_ITEM_PICKUP = 1696
ACT_DOTA_JAKIRO_LIQUIDFIRE_LOOP = 1575
ACT_DOTA_JAKIRO_LIQUIDFIRE_START = 1574
ACT_DOTA_KILLTAUNT = 1535
ACT_DOTA_KINETIC_FIELD = 1679
ACT_DOTA_LASSO_LOOP = 1578
ACT_DOTA_LEAP_STUN = 1658
ACT_DOTA_LEAP_SWIPE = 1659
ACT_DOTA_LIFESTEALER_ASSIMILATE = 1703
ACT_DOTA_LIFESTEALER_EJECT = 1704
ACT_DOTA_LIFESTEALER_INFEST = 1576
ACT_DOTA_LIFESTEALER_INFEST_END = 1577
ACT_DOTA_LIFESTEALER_OPEN_WOUNDS = 1567
ACT_DOTA_LIFESTEALER_RAGE = 1566
ACT_DOTA_LOADOUT = 1601
ACT_DOTA_LOADOUT_RARE = 1683
ACT_DOTA_LOOK_AROUND = 1643
ACT_DOTA_MAGNUS_SKEWER_END = 1606
ACT_DOTA_MAGNUS_SKEWER_START = 1605
ACT_DOTA_MEDUSA_STONE_GAZE = 1607
ACT_DOTA_MIDNIGHT_PULSE = 1676
ACT_DOTA_MINI_TAUNT = 1681
ACT_DOTA_MK_FUR_ARMY = 1722
ACT_DOTA_MK_SPRING_CAST = 1723
ACT_DOTA_MK_SPRING_END = 1719
ACT_DOTA_MK_SPRING_SOAR = 1718
ACT_DOTA_MK_STRIKE = 1715
ACT_DOTA_MK_TREE_END = 1721
ACT_DOTA_MK_TREE_SOAR = 1720
ACT_DOTA_NECRO_GHOST_SHROUD = 1724
ACT_DOTA_NIAN_INTRO_LEAP = 1660
ACT_DOTA_NIAN_PIN_END = 1657
ACT_DOTA_NIAN_PIN_LOOP = 1656
ACT_DOTA_NIAN_PIN_START = 1655
ACT_DOTA_NIAN_PIN_TO_STUN = 1662
ACT_DOTA_NIGHTSTALKER_TRANSITION = 1565
ACT_DOTA_NOTICE = 1747
ACT_DOTA_OVERRIDE_ABILITY_1 = 1516
ACT_DOTA_OVERRIDE_ABILITY_2 = 1517
ACT_DOTA_OVERRIDE_ABILITY_3 = 1518
ACT_DOTA_OVERRIDE_ABILITY_4 = 1519
ACT_DOTA_OVERRIDE_ARCANA = 1725
ACT_DOTA_PET_LEVEL = 1701
ACT_DOTA_PET_WARD_OBSERVER = 1699
ACT_DOTA_PET_WARD_SENTRY = 1700
ACT_DOTA_POOF_END = 1603
ACT_DOTA_PRESENT_ITEM = 1635
ACT_DOTA_RATTLETRAP_BATTERYASSAULT = 1549
ACT_DOTA_RATTLETRAP_HOOKSHOT_END = 1553
ACT_DOTA_RATTLETRAP_HOOKSHOT_LOOP = 1552
ACT_DOTA_RATTLETRAP_HOOKSHOT_START = 1551
ACT_DOTA_RATTLETRAP_POWERCOGS = 1550
ACT_DOTA_RAZE_1 = 1663
ACT_DOTA_RAZE_2 = 1664
ACT_DOTA_RAZE_3 = 1665
ACT_DOTA_RELAX_END = 1610
ACT_DOTA_RELAX_LOOP = 1609
ACT_DOTA_RELAX_LOOP_END = 1634
ACT_DOTA_RELAX_START = 1608
ACT_DOTA_ROQUELAIRE_LAND = 1615
ACT_DOTA_ROQUELAIRE_LAND_IDLE = 1616
ACT_DOTA_RUN = 1502
ACT_DOTA_SAND_KING_BURROW_IN = 1568
ACT_DOTA_SAND_KING_BURROW_OUT = 1569
ACT_DOTA_SHAKE = 1687
ACT_DOTA_SHALLOW_GRAVE = 1670
ACT_DOTA_SHARPEN_WEAPON = 1637
ACT_DOTA_SHARPEN_WEAPON_OUT = 1638
ACT_DOTA_SHOPKEEPER_PET_INTERACT = 1695
ACT_DOTA_SHRUG = 1633
ACT_DOTA_SHUFFLE_L = 1749
ACT_DOTA_SHUFFLE_R = 1750
ACT_DOTA_SLARK_POUNCE = 1604
ACT_DOTA_SLEEPING_END = 1626
ACT_DOTA_SLIDE = 1726
ACT_DOTA_SLIDE_LOOP = 1727
ACT_DOTA_SPAWN = 1534
ACT_DOTA_SPIRIT_BREAKER_CHARGE_END = 1594
ACT_DOTA_SPIRIT_BREAKER_CHARGE_POSE = 1593
ACT_DOTA_STARTLE = 1629
ACT_DOTA_STATIC_STORM = 1680
ACT_DOTA_SWIM = 1684
ACT_DOTA_SWIM_IDLE = 1688
ACT_DOTA_TAUNT = 1536
ACT_DOTA_TAUNT_SNIPER = 1641
ACT_DOTA_TELEPORT = 1595
ACT_DOTA_TELEPORT_COOP_END = 1693
ACT_DOTA_TELEPORT_COOP_EXIT = 1694
ACT_DOTA_TELEPORT_COOP_START = 1691
ACT_DOTA_TELEPORT_COOP_WAIT = 1692
ACT_DOTA_TELEPORT_END = 1596
ACT_DOTA_TELEPORT_END_REACT = 1632
ACT_DOTA_TELEPORT_REACT = 1631
ACT_DOTA_THIRST = 1537
ACT_DOTA_THUNDER_STRIKE = 1678
ACT_DOTA_TINKER_REARM1 = 1555
ACT_DOTA_TINKER_REARM2 = 1556
ACT_DOTA_TINKER_REARM3 = 1557
ACT_DOTA_TRANSITION = 1731
ACT_DOTA_TRICKS_END = 1713
ACT_DOTA_TROT = 1686
ACT_DOTA_UNDYING_DECAY = 1666
ACT_DOTA_UNDYING_SOUL_RIP = 1667
ACT_DOTA_UNDYING_TOMBSTONE = 1668
ACT_DOTA_VERSUS = 1716
ACT_DOTA_VICTORY = 1591
ACT_DOTA_VICTORY_START = 1710
ACT_DOTA_WAIT_IDLE = 1689
ACT_DOTA_WEAVERBUG_ATTACH = 1561
ACT_DOTA_WHEEL_LAYER = 1571
ACT_DOTA_WHIRLING_AXES_RANGED = 1669
ACT_MIRANA_LEAP_END = 1544
ACT_STORM_SPIRIT_OVERLOAD_RUN_OVERRIDE = 1554
ACT_TINY_AVALANCHE = 1558
ACT_TINY_GROWL = 1560
ACT_TINY_TOSS = 1559
ACT_WAVEFORM_END = 1546
ACT_WAVEFORM_START = 1545

--- Enum LuaModifierType
LUA_MODIFIER_INVALID = 4
LUA_MODIFIER_MOTION_BOTH = 3
LUA_MODIFIER_MOTION_HORIZONTAL = 1
LUA_MODIFIER_MOTION_NONE = 0
LUA_MODIFIER_MOTION_VERTICAL = 2

--- Enum ParticleAttachment_t
MAX_PATTACH_TYPES = 15
PATTACH_ABSORIGIN = 0
PATTACH_ABSORIGIN_FOLLOW = 1
PATTACH_CENTER_FOLLOW = 13
PATTACH_CUSTOMORIGIN = 2
PATTACH_CUSTOMORIGIN_FOLLOW = 3
PATTACH_CUSTOM_GAME_STATE_1 = 14
PATTACH_EYES_FOLLOW = 6
PATTACH_INVALID = -1
PATTACH_MAIN_VIEW = 11
PATTACH_OVERHEAD_FOLLOW = 7
PATTACH_POINT = 4
PATTACH_POINT_FOLLOW = 5
PATTACH_RENDERORIGIN_FOLLOW = 10
PATTACH_ROOTBONE_FOLLOW = 9
PATTACH_WATERWAKE = 12
PATTACH_WORLDORIGIN = 8

--- Enum UnitFilterResult
UF_FAIL_ANCIENT = 9
UF_FAIL_ATTACK_IMMUNE = 22
UF_FAIL_BUILDING = 6
UF_FAIL_CONSIDERED_HERO = 4
UF_FAIL_COURIER = 7
UF_FAIL_CREEP = 5
UF_FAIL_CUSTOM = 23
UF_FAIL_DEAD = 15
UF_FAIL_DISABLE_HELP = 25
UF_FAIL_DOMINATED = 12
UF_FAIL_ENEMY = 2
UF_FAIL_FRIENDLY = 1
UF_FAIL_HERO = 3
UF_FAIL_ILLUSION = 10
UF_FAIL_INVALID_LOCATION = 24
UF_FAIL_INVISIBLE = 20
UF_FAIL_INVULNERABLE = 18
UF_FAIL_IN_FOW = 19
UF_FAIL_MAGIC_IMMUNE_ALLY = 16
UF_FAIL_MAGIC_IMMUNE_ENEMY = 17
UF_FAIL_MELEE = 13
UF_FAIL_NIGHTMARED = 27
UF_FAIL_NOT_PLAYER_CONTROLLED = 21
UF_FAIL_OBSTRUCTED = 28
UF_FAIL_OTHER = 8
UF_FAIL_OUT_OF_WORLD = 26
UF_FAIL_RANGED = 14
UF_FAIL_SUMMONED = 11
UF_SUCCESS = 0

--- Enum attackfail
DOTA_ATTACK_RECORD_CANNOT_FAIL = 6
DOTA_ATTACK_RECORD_FAIL_BLOCKED_BY_OBSTRUCTION = 7
DOTA_ATTACK_RECORD_FAIL_NO = 0
DOTA_ATTACK_RECORD_FAIL_SOURCE_MISS = 2
DOTA_ATTACK_RECORD_FAIL_TARGET_EVADED = 3
DOTA_ATTACK_RECORD_FAIL_TARGET_INVULNERABLE = 4
DOTA_ATTACK_RECORD_FAIL_TARGET_OUT_OF_RANGE = 5
DOTA_ATTACK_RECORD_FAIL_TERRAIN_MISS = 1

--- Enum modifierfunction
MODIFIER_EVENT_ON_ABILITY_END_CHANNEL = 168 -- OnAbilityEndChannel
MODIFIER_EVENT_ON_ABILITY_EXECUTED = 165 -- OnAbilityExecuted
MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = 166 -- OnAbilityFullyCast
MODIFIER_EVENT_ON_ABILITY_START = 164 -- OnAbilityStart
MODIFIER_EVENT_ON_ATTACK = 157 -- OnAttack
MODIFIER_EVENT_ON_ATTACKED = 177 -- OnAttacked
MODIFIER_EVENT_ON_ATTACK_ALLIED = 160 -- OnAttackAllied
MODIFIER_EVENT_ON_ATTACK_CANCELLED = 220 -- OnAttackCancelled
MODIFIER_EVENT_ON_ATTACK_FAIL = 159 -- OnAttackFail
MODIFIER_EVENT_ON_ATTACK_FINISHED = 210 -- OnAttackFinished
MODIFIER_EVENT_ON_ATTACK_LANDED = 158 -- OnAttackLanded
MODIFIER_EVENT_ON_ATTACK_RECORD = 155 -- OnAttackRecord
MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY = 217 -- OnAttackRecordDestroy
MODIFIER_EVENT_ON_ATTACK_START = 156 -- OnAttackStart
MODIFIER_EVENT_ON_BREAK_INVISIBILITY = 167 -- OnBreakInvisibility
MODIFIER_EVENT_ON_BUILDING_KILLED = 189 -- OnBuildingKilled
MODIFIER_EVENT_ON_DAMAGE_CALCULATED = 176 -- OnDamageCalculated
MODIFIER_EVENT_ON_DEATH = 178 -- OnDeath
MODIFIER_EVENT_ON_DEATH_PREVENTED = 172 -- OnDamagePrevented
MODIFIER_EVENT_ON_DOMINATED = 207 -- OnDominated
MODIFIER_EVENT_ON_HEALTH_GAINED = 184 -- OnHealthGained
MODIFIER_EVENT_ON_HEAL_RECEIVED = 188 -- OnHealReceived
MODIFIER_EVENT_ON_HERO_KILLED = 187 -- OnHeroKilled
MODIFIER_EVENT_ON_MANA_GAINED = 185 -- OnManaGained
MODIFIER_EVENT_ON_MODEL_CHANGED = 190 -- OnModelChanged
MODIFIER_EVENT_ON_MODIFIER_ADDED = 191 -- OnModifierAdded
MODIFIER_EVENT_ON_ORB_EFFECT = 174 -- Unused
MODIFIER_EVENT_ON_ORDER = 162 -- OnOrder
MODIFIER_EVENT_ON_PROCESS_CLEAVE = 175 -- OnProcessCleave
MODIFIER_EVENT_ON_PROCESS_UPGRADE = 169 -- Unused
MODIFIER_EVENT_ON_PROJECTILE_DODGE = 161 -- OnProjectileDodge
MODIFIER_EVENT_ON_PROJECTILE_OBSTRUCTION_HIT = 218 -- OnProjectileObstructionHit
MODIFIER_EVENT_ON_REFRESH = 170 -- Unused
MODIFIER_EVENT_ON_RESPAWN = 179 -- OnRespawn
MODIFIER_EVENT_ON_SET_LOCATION = 183 -- OnSetLocation
MODIFIER_EVENT_ON_SPELL_TARGET_READY = 154 -- OnSpellTargetReady
MODIFIER_EVENT_ON_SPENT_MANA = 180 -- OnSpentMana
MODIFIER_EVENT_ON_STATE_CHANGED = 173 -- OnStateChanged
MODIFIER_EVENT_ON_TAKEDAMAGE = 171 -- OnTakeDamage
MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT = 186 -- OnTakeDamageKillCredit
MODIFIER_EVENT_ON_TELEPORTED = 182 -- OnTeleported
MODIFIER_EVENT_ON_TELEPORTING = 181 -- OnTeleporting
MODIFIER_EVENT_ON_UNIT_MOVED = 163 -- OnUnitMoved
MODIFIER_FUNCTION_INVALID = 255
MODIFIER_FUNCTION_LAST = 223
MODIFIER_PROPERTY_ABILITY_LAYOUT = 206 -- GetModifierAbilityLayout
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL = 135 -- GetAbsoluteNoDamageMagical
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = 134 -- GetAbsoluteNoDamagePhysical
MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE = 136 -- GetAbsoluteNoDamagePure
MODIFIER_PROPERTY_ABSORB_SPELL = 124 -- GetAbsorbSpell
MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK = 145 -- GetAlwaysAllowAttack
MODIFIER_PROPERTY_ALWAYS_ETHEREAL_ATTACK = 146 -- GetAllowEtherealAttack
MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE = 28 -- GetModifierAttackSpeedBaseOverride
MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = 30 -- GetModifierAttackSpeedBonus_Constant
MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT = 34 -- GetModifierAttackPointConstant
MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE = 95 -- GetModifierAttackRangeOverride
MODIFIER_PROPERTY_ATTACK_RANGE_BONUS = 96 -- GetModifierAttackRangeBonus
MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_PERCENTAGE = 98 -- GetModifierAttackRangeBonusPercentage
MODIFIER_PROPERTY_ATTACK_RANGE_BONUS_UNIQUE = 97 -- GetModifierAttackRangeBonusUnique
MODIFIER_PROPERTY_AVOID_DAMAGE = 58 -- GetModifierAvoidDamage
MODIFIER_PROPERTY_AVOID_SPELL = 59 -- GetModifierAvoidSpell
MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE = 4 -- GetModifierBaseAttack_BonusDamage
MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE = 47 -- GetModifierBaseDamageOutgoing_Percentage
MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE_UNIQUE = 48 -- GetModifierBaseDamageOutgoing_PercentageUnique
MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT = 32 -- GetModifierBaseAttackTimeConstant
MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT_ADJUST = 33 -- GetModifierBaseAttackTimeConstant_Adjust
MODIFIER_PROPERTY_BASE_MANA_REGEN = 72 -- GetModifierBaseRegen
MODIFIER_PROPERTY_BONUS_DAY_VISION = 127 -- GetBonusDayVision
MODIFIER_PROPERTY_BONUS_NIGHT_VISION = 128 -- GetBonusNightVision
MODIFIER_PROPERTY_BONUS_NIGHT_VISION_UNIQUE = 129 -- GetBonusNightVisionUnique
MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE = 130 -- GetBonusVisionPercentage
MODIFIER_PROPERTY_BOT_ATTACK_SCORE_BONUS = 222 -- BotAttackScoreBonus
MODIFIER_PROPERTY_BOUNTY_CREEP_MULTIPLIER = 149 -- Unused
MODIFIER_PROPERTY_BOUNTY_OTHER_MULTIPLIER = 150 -- Unused
MODIFIER_PROPERTY_CAN_ATTACK_TREES = 212 -- GetModifierCanAttackTrees
MODIFIER_PROPERTY_CASTTIME_PERCENTAGE = 109 -- GetModifierPercentageCasttime
MODIFIER_PROPERTY_CAST_RANGE_BONUS = 92 -- GetModifierCastRangeBonus
MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING = 94 -- GetModifierCastRangeBonusStacking
MODIFIER_PROPERTY_CAST_RANGE_BONUS_TARGET = 93 -- GetModifierCastRangeBonusTarget
MODIFIER_PROPERTY_CHANGE_ABILITY_VALUE = 205 -- GetModifierChangeAbilityValue
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE = 107 -- GetModifierPercentageCooldown
MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_ONGOING = 108 -- GetModifierPercentageCooldownOngoing
MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT = 31 -- GetModifierCooldownReduction_Constant
MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE = 35 -- GetModifierDamageOutgoing_Percentage
MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION = 36 -- GetModifierDamageOutgoing_Percentage_Illusion
MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION_AMPLIFY = 37 -- GetModifierDamageOutgoing_Percentage_Illusion_Amplify
MODIFIER_PROPERTY_DEATHGOLDCOST = 112 -- GetModifierConstantDeathGoldCost
MODIFIER_PROPERTY_DISABLE_AUTOATTACK = 126 -- GetDisableAutoAttack
MODIFIER_PROPERTY_DISABLE_HEALING = 144 -- GetDisableHealing
MODIFIER_PROPERTY_DISABLE_TURNING = 203 -- GetModifierDisableTurning
MODIFIER_PROPERTY_DODGE_PROJECTILE = 152 -- GetModifierDodgeProjectile
MODIFIER_PROPERTY_DONT_GIVE_VISION_OF_ATTACKER = 215 -- GetModifierNoVisionOfAttacker
MODIFIER_PROPERTY_EVASION_CONSTANT = 53 -- GetModifierEvasion_Constant
MODIFIER_PROPERTY_EXP_RATE_BOOST = 113 -- GetModifierPercentageExpRateBoost
MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS = 82 -- GetModifierExtraHealthBonus
MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE = 84 -- GetModifierExtraHealthPercentage
MODIFIER_PROPERTY_EXTRA_MANA_BONUS = 83 -- GetModifierExtraManaBonus
MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE = 85 -- GetModifierExtraManaPercentage
MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS = 81 -- GetModifierExtraStrengthBonus
MODIFIER_PROPERTY_FIXED_ATTACK_RATE = 29 -- GetModifierFixedAttackRate
MODIFIER_PROPERTY_FIXED_DAY_VISION = 131 -- GetFixedDayVision
MODIFIER_PROPERTY_FIXED_NIGHT_VISION = 132 -- GetFixedNightVision
MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP = 202 -- GetForceDrawOnMinimap
MODIFIER_PROPERTY_HEALTH_BONUS = 79 -- GetModifierHealthBonus
MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = 76 -- GetModifierConstantHealthRegen
MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE = 77 -- GetModifierHealthRegenPercentage
MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE = 78 -- GetModifierHealthRegenPercentageUnique
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE = 41 -- GetModifierHealAmplify_PercentageSource
MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_TARGET = 42 -- GetModifierHealAmplify_PercentageTarget
MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE = 43 -- GetModifierHPRegenAmplify_Percentage
MODIFIER_PROPERTY_IGNORE_CAST_ANGLE = 204 -- GetModifierIgnoreCastAngle
MODIFIER_PROPERTY_IGNORE_COOLDOWN = 211 -- GetModifierIgnoreCooldown
MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT = 26 -- GetModifierIgnoreMovespeedLimit
MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR = 66 -- GetModifierIgnorePhysicalArmor
MODIFIER_PROPERTY_ILLUSION_LABEL = 138 -- GetModifierIllusionLabel
MODIFIER_PROPERTY_INCOMING_DAMAGE_ILLUSION = 214
MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE = 49 -- GetModifierIncomingDamage_Percentage
MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_CONSTANT = 51 -- GetModifierIncomingPhysicalDamageConstant
MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE = 50 -- GetModifierIncomingPhysicalDamage_Percentage
MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT = 52 -- GetModifierIncomingSpellDamageConstant
MODIFIER_PROPERTY_INVISIBILITY_ATTACK_BEHAVIOR_EXCEPTION = 12 -- GetModifierInvisibilityAttackBehaviorException
MODIFIER_PROPERTY_INVISIBILITY_LEVEL = 11 -- GetModifierInvisibilityLevel
MODIFIER_PROPERTY_IS_ILLUSION = 137 -- GetIsIllusion
MODIFIER_PROPERTY_IS_SCEPTER = 195 -- GetModifierScepter
MODIFIER_PROPERTY_LIFESTEAL_AMPLIFY_PERCENTAGE = 44 -- GetModifierLifestealRegenAmplify_Percentage
MODIFIER_PROPERTY_LIFETIME_FRACTION = 199 -- GetUnitLifetimeFraction
MODIFIER_PROPERTY_MAGICAL_CONSTANT_BLOCK = 116 -- GetModifierMagical_ConstantBlock
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BASE_REDUCTION = 67 -- GetModifierMagicalResistanceBaseReduction
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS = 69 -- GetModifierMagicalResistanceBonus
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS_ILLUSIONS = 70 -- GetModifierMagicalResistanceBonusIllusions
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE = 71 -- GetModifierMagicalResistanceDecrepifyUnique
MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION = 68 -- GetModifierMagicalResistanceDirectModification
MODIFIER_PROPERTY_MANACOST_PERCENTAGE = 110 -- GetModifierPercentageManacost
MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING = 111 -- GetModifierPercentageManacostStacking
MODIFIER_PROPERTY_MANA_BONUS = 80 -- GetModifierManaBonus
MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = 73 -- GetModifierConstantManaRegen
MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE = 74 -- GetModifierConstantManaRegenUnique
MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE = 75 -- GetModifierTotalPercentageManaRegen
MODIFIER_PROPERTY_MAX_ATTACK_RANGE = 99 -- GetModifierMaxAttackRange
MODIFIER_PROPERTY_MIN_HEALTH = 133 -- GetMinHealth
MODIFIER_PROPERTY_MISS_PERCENTAGE = 60 -- GetModifierMiss_Percentage
MODIFIER_PROPERTY_MODEL_CHANGE = 193 -- GetModifierModelChange
MODIFIER_PROPERTY_MODEL_SCALE = 194 -- GetModifierModelScale
MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE = 23 -- GetModifierMoveSpeed_Absolute
MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MAX = 25 -- GetModifierMoveSpeed_AbsoluteMax
MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN = 24 -- GetModifierMoveSpeed_AbsoluteMin
MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE = 15 -- GetModifierMoveSpeedOverride
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = 14 -- GetModifierMoveSpeedBonus_Constant
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT_UNIQUE = 21 -- GetModifierMoveSpeedBonus_Constant_Unique
MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT_UNIQUE_2 = 22 -- GetModifierMoveSpeedBonus_Constant_Unique_2
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE = 16 -- GetModifierMoveSpeedBonus_Percentage
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE = 17 -- GetModifierMoveSpeedBonus_Percentage_Unique
MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE_2 = 18 -- GetModifierMoveSpeedBonus_Percentage_Unique_2
MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE = 19 -- GetModifierMoveSpeedBonus_Special_Boots
MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE_2 = 20 -- GetModifierMoveSpeedBonus_Special_Boots_2
MODIFIER_PROPERTY_MOVESPEED_LIMIT = 27 -- GetModifierMoveSpeed_Limit
MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE = 45 -- GetModifierMPRegenAmplify_Percentage
MODIFIER_PROPERTY_MP_RESTORE_AMPLIFY_PERCENTAGE = 46 -- GetModifierMPRestoreAmplify_Percentage
MODIFIER_PROPERTY_NEGATIVE_EVASION_CONSTANT = 54 -- GetModifierNegativeEvasion_Constant
MODIFIER_PROPERTY_OVERRIDE_ANIMATION = 121 -- GetOverrideAnimation
MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE = 123 -- GetOverrideAnimationRate
MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT = 122 -- GetOverrideAnimationWeight
MODIFIER_PROPERTY_OVERRIDE_ATTACK_DAMAGE = 9 -- GetModifierOverrideAttackDamage
MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL = 147 -- GetOverrideAttackMagical
MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY = 13 -- GetModifierPersistentInvisibility
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE = 61 -- GetModifierPhysicalArmorBase_Percentage
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = 63 -- GetModifierPhysicalArmorBonus
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE = 64 -- GetModifierPhysicalArmorBonusUnique
MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE = 65 -- GetModifierPhysicalArmorBonusUniqueActive
MODIFIER_PROPERTY_PHYSICAL_ARMOR_TOTAL_PERCENTAGE = 62 -- GetModifierPhysicalArmorTotal_Percentage
MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK = 117 -- GetModifierPhysical_ConstantBlock
MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK_SPECIAL = 118 -- GetModifierPhysical_ConstantBlockSpecial
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE = 0 -- GetModifierPreAttack_BonusDamage
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT = 3 -- GetModifierPreAttack_BonusDamagePostCrit
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_PROC = 2 -- GetModifierPreAttack_BonusDamage_Proc
MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_TARGET = 1 -- GetModifierPreAttack_BonusDamage_Target
MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE = 114 -- GetModifierPreAttack_CriticalStrike
MODIFIER_PROPERTY_PREATTACK_TARGET_CRITICALSTRIKE = 115 -- GetModifierPreAttack_Target_CriticalStrike
MODIFIER_PROPERTY_PRESERVE_PARTICLES_ON_MODEL_CHANGE = 209 -- PreserveParticlesOnModelChanged
MODIFIER_PROPERTY_PRE_ATTACK = 10 -- GetModifierPreAttack
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL = 6 -- GetModifierProcAttack_BonusDamage_Magical
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL = 5 -- GetModifierProcAttack_BonusDamage_Physical
MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE = 7 -- GetModifierProcAttack_BonusDamage_Pure
MODIFIER_PROPERTY_PROCATTACK_FEEDBACK = 8 -- GetModifierProcAttack_Feedback
MODIFIER_PROPERTY_PROJECTILE_NAME = 102 -- GetModifierProjectileName
MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS = 100 -- GetModifierProjectileSpeedBonus
MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS_PERCENTAGE = 101 -- GetModifierProjectileSpeedBonusPercentage
MODIFIER_PROPERTY_PROVIDES_FOW_POSITION = 200 -- GetModifierProvidesFOWVision
MODIFIER_PROPERTY_RADAR_COOLDOWN_REDUCTION = 196 -- GetModifierRadarCooldownReduction
MODIFIER_PROPERTY_REFLECT_SPELL = 125 -- GetReflectSpell
MODIFIER_PROPERTY_REINCARNATION = 103 -- ReincarnateTime
MODIFIER_PROPERTY_RESPAWNTIME = 104 -- GetModifierConstantRespawnTime
MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE = 105 -- GetModifierPercentageRespawnTime
MODIFIER_PROPERTY_RESPAWNTIME_STACKING = 106 -- GetModifierStackingRespawnTime
MODIFIER_PROPERTY_SPELLS_REQUIRE_HP = 201 -- GetModifierSpellsRequireHP
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE = 39 -- GetModifierSpellAmplify_Percentage
MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE = 40 -- GetModifierSpellAmplify_PercentageUnique
MODIFIER_PROPERTY_STATS_AGILITY_BONUS = 87 -- GetModifierBonusStats_Agility
MODIFIER_PROPERTY_STATS_AGILITY_BONUS_PERCENTAGE = 90 -- GetModifierBonusStats_Agility_Percentage
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = 88 -- GetModifierBonusStats_Intellect
MODIFIER_PROPERTY_STATS_INTELLECT_BONUS_PERCENTAGE = 91 -- GetModifierBonusStats_Intellect_Percentage
MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = 86 -- GetModifierBonusStats_Strength
MODIFIER_PROPERTY_STATS_STRENGTH_BONUS_PERCENTAGE = 89 -- GetModifierBonusStats_Strength_Percentage
MODIFIER_PROPERTY_STATUS_RESISTANCE = 55 -- GetModifierStatusResistance
MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER = 57 -- GetModifierStatusResistanceCaster
MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING = 56 -- GetModifierStatusResistanceStacking
MODIFIER_PROPERTY_STRONG_ILLUSION = 139 -- GetModifierStrongIllusion
MODIFIER_PROPERTY_SUPER_ILLUSION = 140 -- GetModifierSuperIllusion
MODIFIER_PROPERTY_SUPER_ILLUSION_WITH_ULTIMATE = 141 -- GetModifierSuperIllusionWithUltimate
MODIFIER_PROPERTY_SUPPRESS_CLEAVE = 221 -- GetSuppressCleave
MODIFIER_PROPERTY_SUPPRESS_TELEPORT = 219 -- GetSuppressTeleport
MODIFIER_PROPERTY_TEMPEST_DOUBLE = 208 -- GetModifierTempestDouble
MODIFIER_PROPERTY_TOOLTIP = 192 -- OnTooltip
MODIFIER_PROPERTY_TOOLTIP2 = 216 -- OnTooltip2
MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE = 38 -- GetModifierTotalDamageOutgoing_Percentage
MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK = 120 -- GetModifierTotal_ConstantBlock
MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR = 119 -- GetModifierPhysical_ConstantBlockUnavoidablePreArmor
MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS = 197 -- GetActivityTranslationModifiers
MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND = 198 -- GetAttackSound
MODIFIER_PROPERTY_TRIGGER_COSMETIC_AND_END_ATTACK = 153 -- GetTriggerCosmeticAndEndAttack
MODIFIER_PROPERTY_TURN_RATE_OVERRIDE = 143 -- GetModifierTurnRate_Override
MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE = 142 -- GetModifierTurnRate_Percentage
MODIFIER_PROPERTY_UNIT_DISALLOW_UPGRADING = 151 -- GetModifierUnitDisllowUpgrading
MODIFIER_PROPERTY_UNIT_STATS_NEEDS_REFRESH = 148 -- GetModifierUnitStatsNeedsRefresh
MODIFIER_PROPERTY_VISUAL_Z_DELTA = 213 -- GetVisualZDelta

--- Enum modifierpriority
MODIFIER_PRIORITY_HIGH = 2
MODIFIER_PRIORITY_LOW = 0
MODIFIER_PRIORITY_NORMAL = 1
MODIFIER_PRIORITY_SUPER_ULTRA = 4
MODIFIER_PRIORITY_ULTRA = 3

--- Enum modifierremove
DOTA_BUFF_REMOVE_ALL = 0
DOTA_BUFF_REMOVE_ALLY = 2
DOTA_BUFF_REMOVE_ENEMY = 1

--- Enum modifierstate
MODIFIER_STATE_ALLOW_PATHING_TROUGH_TREES = 36
MODIFIER_STATE_ATTACK_IMMUNE = 2
MODIFIER_STATE_BLIND = 29
MODIFIER_STATE_BLOCK_DISABLED = 12
MODIFIER_STATE_CANNOT_MISS = 16
MODIFIER_STATE_CANNOT_TARGET_ENEMIES = 15
MODIFIER_STATE_COMMAND_RESTRICTED = 19
MODIFIER_STATE_DISARMED = 1
MODIFIER_STATE_DOMINATED = 28
MODIFIER_STATE_EVADE_DISABLED = 13
MODIFIER_STATE_FAKE_ALLY = 31
MODIFIER_STATE_FLYING = 23
MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY = 32
MODIFIER_STATE_FROZEN = 18
MODIFIER_STATE_HEXED = 6
MODIFIER_STATE_IGNORING_MOVE_AND_ATTACK_ORDERS = 35
MODIFIER_STATE_IGNORING_STOP_ORDERS = 40
MODIFIER_STATE_INVISIBLE = 7
MODIFIER_STATE_INVULNERABLE = 8
MODIFIER_STATE_LAST = 41
MODIFIER_STATE_LOW_ATTACK_PRIORITY = 21
MODIFIER_STATE_MAGIC_IMMUNE = 9
MODIFIER_STATE_MUTED = 4
MODIFIER_STATE_NIGHTMARED = 11
MODIFIER_STATE_NOT_ON_MINIMAP = 20
MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES = 37
MODIFIER_STATE_NO_HEALTH_BAR = 22
MODIFIER_STATE_NO_TEAM_MOVE_TO = 25
MODIFIER_STATE_NO_TEAM_SELECT = 26
MODIFIER_STATE_NO_UNIT_COLLISION = 24
MODIFIER_STATE_OUT_OF_GAME = 30
MODIFIER_STATE_PASSIVES_DISABLED = 27
MODIFIER_STATE_PROVIDES_VISION = 10
MODIFIER_STATE_ROOTED = 0
MODIFIER_STATE_SILENCED = 3
MODIFIER_STATE_SPECIALLY_DENIABLE = 17
MODIFIER_STATE_STUNNED = 5
MODIFIER_STATE_TETHERED = 39
MODIFIER_STATE_TRUESIGHT_IMMUNE = 33
MODIFIER_STATE_UNSELECTABLE = 14
MODIFIER_STATE_UNSLOWABLE = 38
MODIFIER_STATE_UNTARGETABLE = 34

--- Enum quest_text_replace_values_t
QUEST_NUM_TEXT_REPLACE_VALUES = 4
QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE = 0
QUEST_TEXT_REPLACE_VALUE_REWARD = 3
QUEST_TEXT_REPLACE_VALUE_ROUND = 2
QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE = 1

--- Enum subquest_text_replace_values_t
SUBQUEST_NUM_TEXT_REPLACE_VALUES = 2
SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE = 0
SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE = 1
---[[ ActiveSequenceDuration  Returns the duration in seconds of the active sequence. ]]
-- @return float
function ActiveSequenceDuration(  ) end

---[[ GetAttachmentAngles  Get the attachment id's angles as a p,y,r vector. ]]
-- @return Vector
-- @param iAttachment int
function GetAttachmentAngles( iAttachment ) end

---[[ GetAttachmentForward  Get the attachment id's forward vector. ]]
-- @return Vector
-- @param iAttachment int
function GetAttachmentForward( iAttachment ) end

---[[ GetAttachmentOrigin  Get the attachment id's origin vector. ]]
-- @return Vector
-- @param iAttachment int
function GetAttachmentOrigin( iAttachment ) end

---[[ GetCycle  Get the cycle of the animation. ]]
-- @return float
function GetCycle(  ) end

---[[ GetGraphParameter  Get the value of the given animGraph parameter ]]
-- @return table
-- @param pszParam string
function GetGraphParameter( pszParam ) end

---[[ GetModelScale  Get scale of entity's model. ]]
-- @return float
function GetModelScale(  ) end

---[[ GetSequence  Returns the name of the active sequence. ]]
-- @return string
function GetSequence(  ) end

---[[ IsSequenceFinished  Ask whether the main sequence is done playing. ]]
-- @return bool
function IsSequenceFinished(  ) end

---[[ ResetSequence  Sets the active sequence by name, resetting the current cycle. ]]
-- @return void
-- @param pSequenceName string
function ResetSequence( pSequenceName ) end

---[[ ScriptLookupAttachment  Get the named attachment id. ]]
-- @return int
-- @param pAttachmentName string
function ScriptLookupAttachment( pAttachmentName ) end

---[[ SequenceDuration  Returns the duration in seconds of the given sequence name. ]]
-- @return float
-- @param pSequenceName string
function SequenceDuration( pSequenceName ) end

---[[ SetGraphLookTarget  Pass the desired look target in world space to the graph ]]
-- @return void
-- @param vValue Vector
function SetGraphLookTarget( vValue ) end

---[[ SetGraphParameter  Set the specific param value, type is inferred from the type in script ]]
-- @return void
-- @param pszParam string
-- @param svArg table
function SetGraphParameter( pszParam, svArg ) end

---[[ SetGraphParameterBool  Set the specific param on or off ]]
-- @return void
-- @param szName string
-- @param bValue bool
function SetGraphParameterBool( szName, bValue ) end

---[[ SetGraphParameterEnum  Pass the enum (int) value to the specified param ]]
-- @return void
-- @param szName string
-- @param nValue int
function SetGraphParameterEnum( szName, nValue ) end

---[[ SetGraphParameterFloat  Pass the float value to the specified param ]]
-- @return void
-- @param szName string
-- @param flValue float
function SetGraphParameterFloat( szName, flValue ) end

---[[ SetGraphParameterInt  Pass the int value to the specified param ]]
-- @return void
-- @param szName string
-- @param nValue int
function SetGraphParameterInt( szName, nValue ) end

---[[ SetGraphParameterVector  Pass the vector value to the specified param in the graph ]]
-- @return void
-- @param szName string
-- @param vValue Vector
function SetGraphParameterVector( szName, vValue ) end

---[[ SetModelScale  Set scale of entity's model. ]]
-- @return void
-- @param flScale float
function SetModelScale( flScale ) end

---[[ SetPoseParameter  Set the specified pose parameter to the specified value. ]]
-- @return float
-- @param szName string
-- @param fValue float
function SetPoseParameter( szName, fValue ) end

---[[ SetSequence  Sets the active sequence by name, keeping the current cycle. ]]
-- @return void
-- @param pSequenceName string
function SetSequence( pSequenceName ) end

---[[ StopAnimation  Stop the current animation by setting playback rate to 0.0. ]]
-- @return void
function StopAnimation(  ) end

---[[ GetEquippedWeapons  GetEquippedWeapons() : Returns an array of all the equipped weapons ]]
-- @return table
function GetEquippedWeapons(  ) end

---[[ GetFaction  Get the combat character faction. ]]
-- @return int
function GetFaction(  ) end

---[[ GetWeaponCount  GetWeaponCount() : Gets the number of weapons currently equipped ]]
-- @return int
function GetWeaponCount(  ) end

---[[ ShootPosition  Returns the shoot position eyes (or hand in VR). ]]
-- @return Vector
-- @param nHand int
-- @param nMuzzle int
function ShootPosition( nHand, nMuzzle ) end

---[[ AddEffects  AddEffects( int ): Adds the render effect flag. ]]
-- @return void
-- @param nFlags int
function AddEffects( nFlags ) end

---[[ ApplyAbsVelocityImpulse  Apply a Velocity Impulse ]]
-- @return void
-- @param vecImpulse Vector
function ApplyAbsVelocityImpulse( vecImpulse ) end

---[[ ApplyLocalAngularVelocityImpulse  Apply an Ang Velocity Impulse ]]
-- @return void
-- @param angImpulse Vector
function ApplyLocalAngularVelocityImpulse( angImpulse ) end

---[[ Attribute_GetFloatValue  Get float value for an entity attribute. ]]
-- @return float
-- @param pName string
-- @param flDefault float
function Attribute_GetFloatValue( pName, flDefault ) end

---[[ Attribute_GetIntValue  Get int value for an entity attribute. ]]
-- @return int
-- @param pName string
-- @param nDefault int
function Attribute_GetIntValue( pName, nDefault ) end

---[[ Attribute_SetFloatValue  Set float value for an entity attribute. ]]
-- @return void
-- @param pName string
-- @param flValue float
function Attribute_SetFloatValue( pName, flValue ) end

---[[ Attribute_SetIntValue  Set int value for an entity attribute. ]]
-- @return void
-- @param pName string
-- @param nValue int
function Attribute_SetIntValue( pName, nValue ) end

---[[ DeleteAttribute  Delete an entity attribute. ]]
-- @return void
-- @param pName string
function DeleteAttribute( pName ) end

---[[ EmitSound  Plays a sound from this entity. ]]
-- @return void
-- @param soundname string
function EmitSound( soundname ) end

---[[ EmitSoundParams  Plays/modifies a sound from this entity. changes sound if nPitch and/or flVol or flSoundTime is > 0. ]]
-- @return void
-- @param soundname string
-- @param nPitch int
-- @param flVolume float
-- @param flDelay float
function EmitSoundParams( soundname, nPitch, flVolume, flDelay ) end

---[[ EyeAngles  Get the qangles that this entity is looking at. ]]
-- @return QAngle
function EyeAngles(  ) end

---[[ EyePosition  Get vector to eye position - absolute coords. ]]
-- @return Vector
function EyePosition(  ) end

---[[ FirstMoveChild   ]]
-- @return handle
function FirstMoveChild(  ) end

---[[ FollowEntity  hEntity to follow, bool bBoneMerge ]]
-- @return void
-- @param hEnt handle
-- @param bBoneMerge bool
function FollowEntity( hEnt, bBoneMerge ) end

---[[ GatherCriteria  Returns a table containing the criteria that would be used for response queries on this entity. This is the same as the table that is passed to response rule script function callbacks. ]]
-- @return void
-- @param hResult handle
function GatherCriteria( hResult ) end

---[[ GetAbsOrigin   ]]
-- @return Vector
function GetAbsOrigin(  ) end

---[[ GetAbsScale   ]]
-- @return float
function GetAbsScale(  ) end

---[[ GetAngles   ]]
-- @return QAngle
function GetAngles(  ) end

---[[ GetAnglesAsVector  Get entity pitch, yaw, roll as a vector. ]]
-- @return Vector
function GetAnglesAsVector(  ) end

---[[ GetAngularVelocity  Get the local angular velocity - returns a vector of pitch,yaw,roll ]]
-- @return Vector
function GetAngularVelocity(  ) end

---[[ GetBaseVelocity  Get Base? velocity. ]]
-- @return Vector
function GetBaseVelocity(  ) end

---[[ GetBoundingMaxs  Get a vector containing max bounds, centered on object. ]]
-- @return Vector
function GetBoundingMaxs(  ) end

---[[ GetBoundingMins  Get a vector containing min bounds, centered on object. ]]
-- @return Vector
function GetBoundingMins(  ) end

---[[ GetBounds  Get a table containing the 'Mins' & 'Maxs' vector bounds, centered on object. ]]
-- @return table
function GetBounds(  ) end

---[[ GetCenter  Get vector to center of object - absolute coords ]]
-- @return Vector
function GetCenter(  ) end

---[[ GetChildren  Get the entities parented to this entity. ]]
-- @return handle
function GetChildren(  ) end

---[[ GetContext  GetContext( name ): looks up a context and returns it if available. May return string, float, or null (if the context isn't found). ]]
-- @return table
-- @param name string
function GetContext( name ) end

---[[ GetForwardVector  Get the forward vector of the entity. ]]
-- @return Vector
function GetForwardVector(  ) end

---[[ GetHealth  Get the health of this entity. ]]
-- @return int
function GetHealth(  ) end

---[[ GetLocalAngles  Get entity local pitch, yaw, roll as a QAngle ]]
-- @return QAngle
function GetLocalAngles(  ) end

---[[ GetLocalAngularVelocity  Maybe local angvel ]]
-- @return QAngle
function GetLocalAngularVelocity(  ) end

---[[ GetLocalOrigin  Get entity local origin as a Vector ]]
-- @return Vector
function GetLocalOrigin(  ) end

---[[ GetLocalScale   ]]
-- @return float
function GetLocalScale(  ) end

---[[ GetLocalVelocity  Get Entity relative velocity. ]]
-- @return Vector
function GetLocalVelocity(  ) end

---[[ GetMass  Get the mass of an entity. (returns 0 if it doesn't have a physics object) ]]
-- @return float
function GetMass(  ) end

---[[ GetMaxHealth  Get the maximum health of this entity. ]]
-- @return int
function GetMaxHealth(  ) end

---[[ GetModelName  Returns the name of the model. ]]
-- @return string
function GetModelName(  ) end

---[[ GetMoveParent  If in hierarchy, retrieves the entity's parent. ]]
-- @return handle
function GetMoveParent(  ) end

---[[ GetOrigin   ]]
-- @return Vector
function GetOrigin(  ) end

---[[ GetOwner  Gets this entity's owner ]]
-- @return handle
function GetOwner(  ) end

---[[ GetOwnerEntity  Get the owner entity, if there is one ]]
-- @return handle
function GetOwnerEntity(  ) end

---[[ GetRightVector  Get the right vector of the entity. ]]
-- @return Vector
function GetRightVector(  ) end

---[[ GetRootMoveParent  If in hierarchy, walks up the hierarchy to find the root parent. ]]
-- @return handle
function GetRootMoveParent(  ) end

---[[ GetSoundDuration  Returns float duration of the sound. Takes soundname and optional actormodelname. ]]
-- @return float
-- @param soundname string
-- @param actormodel string
function GetSoundDuration( soundname, actormodel ) end

---[[ GetTeam  Get the team number of this entity. ]]
-- @return int
function GetTeam(  ) end

---[[ GetTeamNumber  Get the team number of this entity. ]]
-- @return int
function GetTeamNumber(  ) end

---[[ GetUpVector  Get the up vector of the entity. ]]
-- @return Vector
function GetUpVector(  ) end

---[[ GetVelocity   ]]
-- @return Vector
function GetVelocity(  ) end

---[[ HasAttribute  See if an entity has a particular attribute. ]]
-- @return bool
-- @param pName string
function HasAttribute( pName ) end

---[[ IsAlive  Is this entity alive? ]]
-- @return bool
function IsAlive(  ) end

---[[ IsNPC  Is this entity an CAI_BaseNPC? ]]
-- @return bool
function IsNPC(  ) end

---[[ IsPlayer  Is this entity a player? ]]
-- @return bool
function IsPlayer(  ) end

---[[ Kill   ]]
-- @return void
function Kill(  ) end

---[[ NextMovePeer   ]]
-- @return handle
function NextMovePeer(  ) end

---[[ OverrideFriction  Takes duration, value for a temporary override. ]]
-- @return void
-- @param duration float
-- @param friction float
function OverrideFriction( duration, friction ) end

---[[ PrecacheScriptSound  Precache a sound for later playing. ]]
-- @return void
-- @param soundname string
function PrecacheScriptSound( soundname ) end

---[[ RemoveEffects  RemoveEffects( int ): Removes the render effect flag. ]]
-- @return void
-- @param nFlags int
function RemoveEffects( nFlags ) end

---[[ SetAbsAngles  Set entity pitch, yaw, roll by component. ]]
-- @return void
-- @param fPitch float
-- @param fYaw float
-- @param fRoll float
function SetAbsAngles( fPitch, fYaw, fRoll ) end

---[[ SetAbsOrigin   ]]
-- @return void
-- @param origin Vector
function SetAbsOrigin( origin ) end

---[[ SetAbsScale   ]]
-- @return void
-- @param flScale float
function SetAbsScale( flScale ) end

---[[ SetAngles  Set entity pitch, yaw, roll by component. ]]
-- @return void
-- @param fPitch float
-- @param fYaw float
-- @param fRoll float
function SetAngles( fPitch, fYaw, fRoll ) end

---[[ SetAngularVelocity  Set the local angular velocity - takes float pitch,yaw,roll velocities ]]
-- @return void
-- @param pitchVel float
-- @param yawVel float
-- @param rollVel float
function SetAngularVelocity( pitchVel, yawVel, rollVel ) end

---[[ SetConstraint  Set the position of the constraint. ]]
-- @return void
-- @param vPos Vector
function SetConstraint( vPos ) end

---[[ SetContext  SetContext( name , value, duration ): store any key/value pair in this entity's dialog contexts. Value must be a string. Will last for duration (set 0 to mean 'forever'). ]]
-- @return void
-- @param pName string
-- @param pValue string
-- @param duration float
function SetContext( pName, pValue, duration ) end

---[[ SetContextNum  SetContextNum( name , value, duration ): store any key/value pair in this entity's dialog contexts. Value must be a number (int or float). Will last for duration (set 0 to mean 'forever'). ]]
-- @return void
-- @param pName string
-- @param fValue float
-- @param duration float
function SetContextNum( pName, fValue, duration ) end

---[[ SetContextThink  Set a think function on this entity. ]]
-- @return void
-- @param pszContextName string
-- @param hThinkFunc handle
-- @param flInterval float
function SetContextThink( pszContextName, hThinkFunc, flInterval ) end

---[[ SetEntityName  Set the name of an entity. ]]
-- @return void
-- @param pName string
function SetEntityName( pName ) end

---[[ SetForwardVector  Set the orientation of the entity to have this forward vector. ]]
-- @return void
-- @param v Vector
function SetForwardVector( v ) end

---[[ SetFriction  Set PLAYER friction, ignored for objects. ]]
-- @return void
-- @param flFriction float
function SetFriction( flFriction ) end

---[[ SetGravity  Set PLAYER gravity, ignored for objects. ]]
-- @return void
-- @param flGravity float
function SetGravity( flGravity ) end

---[[ SetHealth  Set the health of this entity. ]]
-- @return void
-- @param nHealth int
function SetHealth( nHealth ) end

---[[ SetLocalAngles  Set entity local pitch, yaw, roll by component ]]
-- @return void
-- @param fPitch float
-- @param fYaw float
-- @param fRoll float
function SetLocalAngles( fPitch, fYaw, fRoll ) end

---[[ SetLocalOrigin  Set entity local origin from a Vector ]]
-- @return void
-- @param origin Vector
function SetLocalOrigin( origin ) end

---[[ SetLocalScale   ]]
-- @return void
-- @param flScale float
function SetLocalScale( flScale ) end

---[[ SetMass  Set the mass of an entity. (does nothing if it doesn't have a physics object) ]]
-- @return void
-- @param flMass float
function SetMass( flMass ) end

---[[ SetMaxHealth  Set the maximum health of this entity. ]]
-- @return void
-- @param amt int
function SetMaxHealth( amt ) end

---[[ SetOrigin   ]]
-- @return void
-- @param v Vector
function SetOrigin( v ) end

---[[ SetOwner  Sets this entity's owner ]]
-- @return void
-- @param pOwner handle
function SetOwner( pOwner ) end

---[[ SetParent  Set the parent for this entity. ]]
-- @return void
-- @param hParent handle
-- @param pAttachmentname string
function SetParent( hParent, pAttachmentname ) end

---[[ SetTeam   ]]
-- @return void
-- @param iTeamNum int
function SetTeam( iTeamNum ) end

---[[ SetVelocity   ]]
-- @return void
-- @param vecVelocity Vector
function SetVelocity( vecVelocity ) end

---[[ StopSound  Stops a named sound playing from this entity. ]]
-- @return void
-- @param soundname string
function StopSound( soundname ) end

---[[ TakeDamage  Apply damage to this entity. Use CreateDamageInfo() to create a damageinfo object. ]]
-- @return int
-- @param hInfo handle
function TakeDamage( hInfo ) end

---[[ TransformPointEntityToWorld  Returns the input Vector transformed from entity to world space ]]
-- @return Vector
-- @param vPoint Vector
function TransformPointEntityToWorld( vPoint ) end

---[[ TransformPointWorldToEntity  Returns the input Vector transformed from world to entity space ]]
-- @return Vector
-- @param vPoint Vector
function TransformPointWorldToEntity( vPoint ) end

---[[ Trigger  Fires off this entity's OnTrigger responses. ]]
-- @return void
function Trigger(  ) end

---[[ ValidatePrivateScriptScope  Validates the private script scope and creates it if one doesn't exist. ]]
-- @return void
function ValidatePrivateScriptScope(  ) end

---[[ GetCurrentScene  Returns the instance of the oldest active scene entity (if any). ]]
-- @return handle
function GetCurrentScene(  ) end

---[[ GetSceneByIndex  Returns the instance of the scene entity at the specified index. ]]
-- @return handle
-- @param index int
function GetSceneByIndex( index ) end

---[[ ScriptPlayScene  ( vcd file, delay ) - play specified vcd file ]]
-- @return float
-- @param pszScene string
-- @param flDelay float
function ScriptPlayScene( pszScene, flDelay ) end

---[[ GetMaterialGroupHash  GetMaterialGroupHash(): Get the material group hash of this entity. ]]
-- @return unsigned
function GetMaterialGroupHash(  ) end

---[[ GetMaterialGroupMask  GetMaterialGroupMask(): Get the mesh group mask of this entity. ]]
-- @return uint64
function GetMaterialGroupMask(  ) end

---[[ GetRenderAlpha  GetRenderAlpha(): Get the alpha modulation of this entity. ]]
-- @return int
function GetRenderAlpha(  ) end

---[[ GetRenderColor  GetRenderColor(): Get the render color of the entity. ]]
-- @return Vector
function GetRenderColor(  ) end

---[[ SetBodygroup  Sets a bodygroup. ]]
-- @return void
-- @param iGroup int
-- @param iValue int
function SetBodygroup( iGroup, iValue ) end

---[[ SetBodygroupByName  Sets a bodygroup by name. ]]
-- @return void
-- @param pName string
-- @param iValue int
function SetBodygroupByName( pName, iValue ) end

---[[ SetLightGroup  SetLightGroup( string ): Sets the light group of the entity. ]]
-- @return void
-- @param pLightGroup string
function SetLightGroup( pLightGroup ) end

---[[ SetMaterialGroup  SetMaterialGroup( string ): Set the material group of this entity. ]]
-- @return void
-- @param pMaterialGroup string
function SetMaterialGroup( pMaterialGroup ) end

---[[ SetMaterialGroupHash  SetMaterialGroupHash( uint32 ): Set the material group hash of this entity. ]]
-- @return void
-- @param nHash unsigned
function SetMaterialGroupHash( nHash ) end

---[[ SetMaterialGroupMask  SetMaterialGroupMask( uint64 ): Set the mesh group mask of this entity. ]]
-- @return void
-- @param nMeshGroupMask uint64
function SetMaterialGroupMask( nMeshGroupMask ) end

---[[ SetModel   ]]
-- @return void
-- @param pModelName string
function SetModel( pModelName ) end

---[[ SetRenderAlpha  SetRenderAlpha( int ): Set the alpha modulation of this entity. ]]
-- @return void
-- @param nAlpha int
function SetRenderAlpha( nAlpha ) end

---[[ SetRenderColor  SetRenderColor( r, g, b ): Sets the render color of the entity. ]]
-- @return void
-- @param r int
-- @param g int
-- @param b int
function SetRenderColor( r, g, b ) end

---[[ SetRenderMode  SetRenderMode( int ): Sets the render mode of the entity. ]]
-- @return void
-- @param nMode int
function SetRenderMode( nMode ) end

---[[ SetSingleMeshGroup  SetSingleMeshGroup( string ): Set a single mesh group for this entity. ]]
-- @return void
-- @param pMeshGroupName string
function SetSingleMeshGroup( pMeshGroupName ) end

---[[ SetSize   ]]
-- @return void
-- @param mins Vector
-- @param maxs Vector
function SetSize( mins, maxs ) end

---[[ SetSkin  Set skin (int). ]]
-- @return void
-- @param iSkin int
function SetSkin( iSkin ) end

---[[ AreChaperoneBoundsVisible  Returns whether this player's chaperone bounds are visible. ]]
-- @return bool
function AreChaperoneBoundsVisible(  ) end

---[[ GetHMDAnchor  Returns the HMD anchor entity for this player if it exists. ]]
-- @return handle
function GetHMDAnchor(  ) end

---[[ GetHMDAvatar  Returns the HMD Avatar entity for this player if it exists. ]]
-- @return handle
function GetHMDAvatar(  ) end

---[[ GetPlayArea  Returns the Vector position of the point you ask for. Pass 0-3 to get the four points. ]]
-- @return Vector
-- @param nPoint int
function GetPlayArea( nPoint ) end

---[[ GetUserID  Returns the player's user id. ]]
-- @return int
function GetUserID(  ) end

---[[ GetVRControllerType  Returns the type of controller being used while in VR. ]]
-- @return <unknown>
function GetVRControllerType(  ) end

---[[ IsNoclipping  Returns true if the player is in noclip mode. ]]
-- @return bool
function IsNoclipping(  ) end

---[[ IsUsePressed  Returns true if the use key is pressed. ]]
-- @return bool
function IsUsePressed(  ) end

---[[ IsVRControllerButtonPressed  Returns true if the controller button is pressed. ]]
-- @return bool
-- @param nButton int
function IsVRControllerButtonPressed( nButton ) end

---[[ IsVRDashboardShowing  Returns true if the SteamVR dashboard is showing for this player. ]]
-- @return bool
function IsVRDashboardShowing(  ) end

---[[ Disable  Disable's the trigger ]]
-- @return void
function Disable(  ) end

---[[ Enable  Enable the trigger ]]
-- @return void
function Enable(  ) end

---[[ IsTouching  Checks whether the passed entity is touching the trigger. ]]
-- @return bool
-- @param hEnt handle
function IsTouching( hEnt ) end

---[[ AddImpulseAtPosition  Apply an impulse at a worldspace position to the physics ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
function AddImpulseAtPosition( Vector_1, Vector_2 ) end

---[[ AddVelocity  Add linear and angular velocity to the physics object ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
function AddVelocity( Vector_1, Vector_2 ) end

---[[ DetachFromParent  Detach from its parent ]]
-- @return void
function DetachFromParent(  ) end

---[[ GetSequence  Returns the active sequence

-- @return <unknown>
function GetSequence(  ) end

---[[ IsAttachedToParent  Is attached to parent ]]
-- @return bool
function IsAttachedToParent(  ) end

---[[ LookupSequence  Returns a sequence id given a name
-- @return <unknown>
-- @param string_1 string
function LookupSequence( string_1 ) end

---[[ SequenceDuration  Returns the duration in seconds of the specified sequence ]]
-- @return float
-- @param string_1 string
function SequenceDuration( string_1 ) end

---[[ SetAngularVelocity   ]]
-- @return void
-- @param Vector_1 Vector
function SetAngularVelocity( Vector_1 ) end

---[[ SetAnimation  Pass string for the animation to play on this model ]]
-- @return void
-- @param string_1 string
function SetAnimation( string_1 ) end

---[[ SetMaterialGroup   ]]
-- @return void
-- @param utlstringtoken_1 utlstringtoken
function SetMaterialGroup( utlstringtoken_1 ) end

---[[ SetVelocity   ]]
-- @return void
-- @param Vector_1 Vector
function SetVelocity( Vector_1 ) end

---[[ RegisterListener  ( string EventName, func CallbackFunction ) - Register a callback to be called when a particular custom event arrives. Returns a listener ID that can be used to unregister later. ]]
-- @return int
-- @param string_1 string
-- @param handle_2 handle
function RegisterListener( string_1, handle_2 ) end

---[[ Send_ServerToAllClients  ( string EventName, table EventData ) ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
function Send_ServerToAllClients( string_1, handle_2 ) end

---[[ Send_ServerToPlayer  ( Entity Player, string EventName, table EventData ) ]]
-- @return void
-- @param handle_1 handle
-- @param string_2 string
-- @param handle_3 handle
function Send_ServerToPlayer( handle_1, string_2, handle_3 ) end

---[[ Send_ServerToTeam  ( int TeamNumber, string EventName, table EventData ) ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
-- @param handle_3 handle
function Send_ServerToTeam( int_1, string_2, handle_3 ) end

---[[ UnregisterListener  ( int ListnerID ) - Unregister a specific listener ]]
-- @return void
-- @param int_1 int
function UnregisterListener( int_1 ) end

---[[ GetTableValue  ( string TableName, string KeyName ) ]]
-- @return table
-- @param string_1 string
-- @param string_2 string
function GetTableValue( string_1, string_2 ) end

---[[ SetTableValue  ( string TableName, string KeyName, script_table Value ) ]]
-- @return bool
-- @param string_1 string
-- @param string_2 string
-- @param handle_3 handle
function SetTableValue( string_1, string_2, handle_3 ) end

---[[ CanAbilityBeUpgraded   ]]
-- @return <unknown>
function CanAbilityBeUpgraded(  ) end

---[[ CastAbility   ]]
-- @return bool
function CastAbility(  ) end

---[[ ContinueCasting   ]]
-- @return bool
function ContinueCasting(  ) end

---[[ CreateVisibilityNode   ]]
-- @return void
-- @param vLocation Vector
-- @param fRadius float
-- @param fDuration float
function CreateVisibilityNode( vLocation, fRadius, fDuration ) end

---[[ DecrementModifierRefCount   ]]
-- @return void
function DecrementModifierRefCount(  ) end

---[[ EndChannel   ]]
-- @return void
-- @param bInterrupted bool
function EndChannel( bInterrupted ) end

---[[ EndCooldown  Clear the cooldown remaining on this ability. ]]
-- @return void
function EndCooldown(  ) end

---[[ GetAOERadius   ]]
-- @return int
function GetAOERadius(  ) end

---[[ GetAbilityDamage   ]]
-- @return int
function GetAbilityDamage(  ) end

---[[ GetAbilityDamageType   ]]
-- @return int
function GetAbilityDamageType(  ) end

---[[ GetAbilityIndex   ]]
-- @return int
function GetAbilityIndex(  ) end

---[[ GetAbilityKeyValues  Gets the key values definition for this ability. ]]
-- @return table
function GetAbilityKeyValues(  ) end

---[[ GetAbilityName  Returns the name of this ability. ]]
-- @return string
function GetAbilityName(  ) end

---[[ GetAbilityTargetFlags   ]]
-- @return int
function GetAbilityTargetFlags(  ) end

---[[ GetAbilityTargetTeam   ]]
-- @return int
function GetAbilityTargetTeam(  ) end

---[[ GetAbilityTargetType   ]]
-- @return int
function GetAbilityTargetType(  ) end

---[[ GetAbilityType   ]]
-- @return int
function GetAbilityType(  ) end

---[[ GetAnimationIgnoresModelScale   ]]
-- @return bool
function GetAnimationIgnoresModelScale(  ) end

---[[ GetAssociatedPrimaryAbilities   ]]
-- @return string
function GetAssociatedPrimaryAbilities(  ) end

---[[ GetAssociatedSecondaryAbilities   ]]
-- @return string
function GetAssociatedSecondaryAbilities(  ) end

---[[ GetAutoCastState   ]]
-- @return bool
function GetAutoCastState(  ) end

---[[ GetBackswingTime   ]]
-- @return float
function GetBackswingTime(  ) end

---[[ GetBehavior   ]]
-- @return int
function GetBehavior(  ) end

---[[ GetCastPoint   ]]
-- @return float
function GetCastPoint(  ) end

---[[ GetCastRange  Gets the cast range of the ability. ]]
-- @return int
-- @param vLocation Vector
-- @param hTarget handle
function GetCastRange( vLocation, hTarget ) end

---[[ GetCaster   ]]
-- @return handle
function GetCaster(  ) end

---[[ GetChannelStartTime   ]]
-- @return float
function GetChannelStartTime(  ) end

---[[ GetChannelTime   ]]
-- @return float
function GetChannelTime(  ) end

---[[ GetChannelledManaCostPerSecond   ]]
-- @return int
-- @param iLevel int
function GetChannelledManaCostPerSecond( iLevel ) end

---[[ GetCloneSource   ]]
-- @return handle
function GetCloneSource(  ) end

---[[ GetConceptRecipientType   ]]
-- @return int
function GetConceptRecipientType(  ) end

---[[ GetCooldown  Get the cooldown duration for this ability at a given level, not the amount of cooldown actually left. ]]
-- @return float
-- @param iLevel int
function GetCooldown( iLevel ) end

---[[ GetCooldownTime   ]]
-- @return float
function GetCooldownTime(  ) end

---[[ GetCooldownTimeRemaining   ]]
-- @return float
function GetCooldownTimeRemaining(  ) end

---[[ GetCursorPosition   ]]
-- @return Vector
function GetCursorPosition(  ) end

---[[ GetCursorTarget   ]]
-- @return handle
function GetCursorTarget(  ) end

---[[ GetCursorTargetingNothing   ]]
-- @return bool
function GetCursorTargetingNothing(  ) end

---[[ GetDuration   ]]
-- @return float
function GetDuration(  ) end

---[[ GetEffectiveCooldown   ]]
-- @return float
-- @param iLevel int
function GetEffectiveCooldown( iLevel ) end

---[[ GetGoldCost   ]]
-- @return int
-- @param iLevel int
function GetGoldCost( iLevel ) end

---[[ GetGoldCostForUpgrade   ]]
-- @return int
-- @param iLevel int
function GetGoldCostForUpgrade( iLevel ) end

---[[ GetHeroLevelRequiredToUpgrade   ]]
-- @return int
function GetHeroLevelRequiredToUpgrade(  ) end

---[[ GetIntrinsicModifierName   ]]
-- @return string
function GetIntrinsicModifierName(  ) end

---[[ GetLevel  Get the current level of the ability. ]]
-- @return int
function GetLevel(  ) end

---[[ GetLevelSpecialValueFor   ]]
-- @return table
-- @param szName string
-- @param nLevel int
function GetLevelSpecialValueFor( szName, nLevel ) end

---[[ GetManaCost   ]]
-- @return int
-- @param iLevel int
function GetManaCost( iLevel ) end

---[[ GetMaxLevel   ]]
-- @return int
function GetMaxLevel(  ) end

---[[ GetModifierValue   ]]
-- @return float
function GetModifierValue(  ) end

---[[ GetModifierValueBonus   ]]
-- @return float
function GetModifierValueBonus(  ) end

---[[ GetPlaybackRateOverride   ]]
-- @return float
function GetPlaybackRateOverride(  ) end

---[[ GetSharedCooldownName   ]]
-- @return string
function GetSharedCooldownName(  ) end

---[[ GetSpecialValueFor  Gets a value from this ability's special value block for its current level. ]]
-- @return table
-- @param szName string
function GetSpecialValueFor( szName ) end

---[[ GetStolenActivityModifier   ]]
-- @return string
function GetStolenActivityModifier(  ) end

---[[ GetToggleState   ]]
-- @return bool
function GetToggleState(  ) end

---[[ GetUpgradeRecommended   ]]
-- @return bool
function GetUpgradeRecommended(  ) end

---[[ HeroXPChange   ]]
-- @return bool
-- @param flXP float
function HeroXPChange( flXP ) end

---[[ IncrementModifierRefCount   ]]
-- @return void
function IncrementModifierRefCount(  ) end

---[[ IsActivated   ]]
-- @return bool
function IsActivated(  ) end

---[[ IsAttributeBonus   ]]
-- @return bool
function IsAttributeBonus(  ) end

---[[ IsChanneling  Returns whether the ability is currently channeling. ]]
-- @return bool
function IsChanneling(  ) end

---[[ IsCooldownReady   ]]
-- @return bool
function IsCooldownReady(  ) end

---[[ IsCosmetic   ]]
-- @return bool
-- @param hEntity handle
function IsCosmetic( hEntity ) end

---[[ IsFullyCastable  Returns whether the ability can be cast. ]]
-- @return bool
function IsFullyCastable(  ) end

---[[ IsHidden   ]]
-- @return bool
function IsHidden(  ) end

---[[ IsHiddenAsSecondaryAbility   ]]
-- @return bool
function IsHiddenAsSecondaryAbility(  ) end

---[[ IsHiddenWhenStolen   ]]
-- @return bool
function IsHiddenWhenStolen(  ) end

---[[ IsInAbilityPhase  Returns whether the ability is currently casting. ]]
-- @return bool
function IsInAbilityPhase(  ) end

---[[ IsItem   ]]
-- @return bool
function IsItem(  ) end

---[[ IsOwnersGoldEnough   ]]
-- @return bool
-- @param nIssuerPlayerID int
function IsOwnersGoldEnough( nIssuerPlayerID ) end

---[[ IsOwnersGoldEnoughForUpgrade   ]]
-- @return bool
function IsOwnersGoldEnoughForUpgrade(  ) end

---[[ IsOwnersManaEnough   ]]
-- @return bool
function IsOwnersManaEnough(  ) end

---[[ IsPassive   ]]
-- @return bool
function IsPassive(  ) end

---[[ IsRefreshable   ]]
-- @return bool
function IsRefreshable(  ) end

---[[ IsSharedWithTeammates   ]]
-- @return bool
function IsSharedWithTeammates(  ) end

---[[ IsStealable   ]]
-- @return bool
function IsStealable(  ) end

---[[ IsStolen   ]]
-- @return bool
function IsStolen(  ) end

---[[ IsToggle   ]]
-- @return bool
function IsToggle(  ) end

---[[ IsTrained   ]]
-- @return bool
function IsTrained(  ) end

---[[ MarkAbilityButtonDirty  Mark the ability button for this ability as needing a refresh. ]]
-- @return void
function MarkAbilityButtonDirty(  ) end

---[[ NumModifiersUsingAbility   ]]
-- @return int
function NumModifiersUsingAbility(  ) end

---[[ OnAbilityPhaseInterrupted   ]]
-- @return void
function OnAbilityPhaseInterrupted(  ) end

---[[ OnAbilityPhaseStart   ]]
-- @return bool
function OnAbilityPhaseStart(  ) end

---[[ OnAbilityPinged   ]]
-- @return void
-- @param nPlayerID int
-- @param bCtrlHeld bool
function OnAbilityPinged( nPlayerID, bCtrlHeld ) end

---[[ OnChannelFinish   ]]
-- @return void
-- @param bInterrupted bool
function OnChannelFinish( bInterrupted ) end

---[[ OnChannelThink   ]]
-- @return void
-- @param flInterval float
function OnChannelThink( flInterval ) end

---[[ OnHeroCalculateStatBonus   ]]
-- @return void
function OnHeroCalculateStatBonus(  ) end

---[[ OnHeroLevelUp   ]]
-- @return void
function OnHeroLevelUp(  ) end

---[[ OnOwnerDied   ]]
-- @return void
function OnOwnerDied(  ) end

---[[ OnOwnerSpawned   ]]
-- @return void
function OnOwnerSpawned(  ) end

---[[ OnSpellStart   ]]
-- @return void
function OnSpellStart(  ) end

---[[ OnToggle   ]]
-- @return void
function OnToggle(  ) end

---[[ OnUpgrade   ]]
-- @return void
function OnUpgrade(  ) end

---[[ PayGoldCost   ]]
-- @return void
function PayGoldCost(  ) end

---[[ PayGoldCostForUpgrade   ]]
-- @return void
function PayGoldCostForUpgrade(  ) end

---[[ PayManaCost   ]]
-- @return void
function PayManaCost(  ) end

---[[ PlaysDefaultAnimWhenStolen   ]]
-- @return bool
function PlaysDefaultAnimWhenStolen(  ) end

---[[ ProcsMagicStick   ]]
-- @return bool
function ProcsMagicStick(  ) end

---[[ RefCountsModifiers   ]]
-- @return bool
function RefCountsModifiers(  ) end

---[[ RefreshCharges   ]]
-- @return void
function RefreshCharges(  ) end

---[[ RefundManaCost   ]]
-- @return void
function RefundManaCost(  ) end

---[[ ResetToggleOnRespawn   ]]
-- @return bool
function ResetToggleOnRespawn(  ) end

---[[ SetAbilityIndex   ]]
-- @return void
-- @param iIndex int
function SetAbilityIndex( iIndex ) end

---[[ SetActivated   ]]
-- @return void
-- @param bActivated bool
function SetActivated( bActivated ) end

---[[ SetChanneling   ]]
-- @return void
-- @param bChanneling bool
function SetChanneling( bChanneling ) end

---[[ SetFrozenCooldown   ]]
-- @return void
-- @param bFrozenCooldown bool
function SetFrozenCooldown( bFrozenCooldown ) end

---[[ SetHidden   ]]
-- @return void
-- @param bHidden bool
function SetHidden( bHidden ) end

---[[ SetInAbilityPhase   ]]
-- @return void
-- @param bInAbilityPhase bool
function SetInAbilityPhase( bInAbilityPhase ) end

---[[ SetLevel  Sets the level of this ability. ]]
-- @return void
-- @param iLevel int
function SetLevel( iLevel ) end

---[[ SetOverrideCastPoint   ]]
-- @return void
-- @param flCastPoint float
function SetOverrideCastPoint( flCastPoint ) end

---[[ SetRefCountsModifiers   ]]
-- @return void
-- @param bRefCounts bool
function SetRefCountsModifiers( bRefCounts ) end

---[[ SetStealable   ]]
-- @return void
-- @param bStealable bool
function SetStealable( bStealable ) end

---[[ SetStolen   ]]
-- @return void
-- @param bStolen bool
function SetStolen( bStolen ) end

---[[ SetUpgradeRecommended   ]]
-- @return void
-- @param bUpgradeRecommended bool
function SetUpgradeRecommended( bUpgradeRecommended ) end

---[[ ShouldUseResources   ]]
-- @return bool
function ShouldUseResources(  ) end

---[[ SpeakAbilityConcept   ]]
-- @return void
-- @param iConcept int
function SpeakAbilityConcept( iConcept ) end

---[[ SpeakTrigger   ]]
-- @return <unknown>
function SpeakTrigger(  ) end

---[[ StartCooldown   ]]
-- @return void
-- @param flCooldown float
function StartCooldown( flCooldown ) end

---[[ ToggleAbility   ]]
-- @return void
function ToggleAbility(  ) end

---[[ ToggleAutoCast   ]]
-- @return void
function ToggleAutoCast(  ) end

---[[ UpgradeAbility   ]]
-- @return void
-- @param bSupressSpeech bool
function UpgradeAbility( bSupressSpeech ) end

---[[ UseResources   ]]
-- @return void
-- @param bMana bool
-- @param bGold bool
-- @param bCooldown bool
function UseResources( bMana, bGold, bCooldown ) end

---[[ AddRealTimeCombatAnalyzerQuery  Begin tracking a sequence of events using the real time combat analyzer. ]]
-- @return int
-- @param hQueryTable handle
-- @param hPlayer handle
-- @param pszQueryName string
function AddRealTimeCombatAnalyzerQuery( hQueryTable, hPlayer, pszQueryName ) end

---[[ AreWeatherEffectsDisabled  Get if weather effects are disabled on the client. ]]
-- @return bool
function AreWeatherEffectsDisabled(  ) end

---[[ ClearBountyRunePickupFilter  Clear the script filter that controls bounty rune pickup behavior. ]]
-- @return void
function ClearBountyRunePickupFilter(  ) end

---[[ ClearDamageFilter  Clear the script filter that controls how a unit takes damage. ]]
-- @return void
function ClearDamageFilter(  ) end

---[[ ClearExecuteOrderFilter  Clear the script filter that controls when a unit picks up an item. ]]
-- @return void
function ClearExecuteOrderFilter(  ) end

---[[ ClearHealingFilter  Clear the script filter that controls how a unit heals. ]]
-- @return void
function ClearHealingFilter(  ) end

---[[ ClearItemAddedToInventoryFilter  Clear the script filter that controls the item added to inventory filter. ]]
-- @return void
function ClearItemAddedToInventoryFilter(  ) end

---[[ ClearModifierGainedFilter  Clear the script filter that controls the modifier filter. ]]
-- @return void
function ClearModifierGainedFilter(  ) end

---[[ ClearModifyExperienceFilter  Clear the script filter that controls how hero experience is modified. ]]
-- @return void
function ClearModifyExperienceFilter(  ) end

---[[ ClearModifyGoldFilter  Clear the script filter that controls how hero gold is modified. ]]
-- @return void
function ClearModifyGoldFilter(  ) end

---[[ ClearRuneSpawnFilter  Clear the script filter that controls what rune spawns. ]]
-- @return void
function ClearRuneSpawnFilter(  ) end

---[[ ClearTrackingProjectileFilter  Clear the script filter that controls when tracking projectiles are launched. ]]
-- @return void
function ClearTrackingProjectileFilter(  ) end

---[[ DisableHudFlip  Use to disable hud flip for this mod ]]
-- @return void
-- @param bDisable bool
function DisableHudFlip( bDisable ) end

---[[ GetAlwaysShowPlayerInventory  Show the player hero's inventory in the HUD, regardless of what unit is selected. ]]
-- @return bool
function GetAlwaysShowPlayerInventory(  ) end

---[[ GetAlwaysShowPlayerNames  Get whether player names are always shown, regardless of client setting. ]]
-- @return bool
function GetAlwaysShowPlayerNames(  ) end

---[[ GetAnnouncerDisabled  Are in-game announcers disabled? ]]
-- @return bool
function GetAnnouncerDisabled(  ) end

---[[ GetCameraDistanceOverride  Set a different camera distance; dota default is 1134. ]]
-- @return float
function GetCameraDistanceOverride(  ) end

---[[ GetCustomAttributeDerivedStatValue  Get current derived stat value constant. ]]
-- @return float
-- @param nDerivedStatType int
-- @param hHero handle
function GetCustomAttributeDerivedStatValue( nDerivedStatType, hHero ) end

---[[ GetCustomBackpackCooldownPercent  Get the current rate cooldown ticks down for items in the backpack. ]]
-- @return float
function GetCustomBackpackCooldownPercent(  ) end

---[[ GetCustomBackpackSwapCooldown  Get the current custom backpack swap cooldown. ]]
-- @return float
function GetCustomBackpackSwapCooldown(  ) end

---[[ GetCustomBuybackCooldownEnabled  Turns on capability to define custom buyback cooldowns. ]]
-- @return bool
function GetCustomBuybackCooldownEnabled(  ) end

---[[ GetCustomBuybackCostEnabled  Turns on capability to define custom buyback costs. ]]
-- @return bool
function GetCustomBuybackCostEnabled(  ) end

---[[ GetCustomGlyphCooldown  Get the current custom glyph cooldown. ]]
-- @return float
function GetCustomGlyphCooldown(  ) end

---[[ GetCustomHeroMaxLevel  Allows definition of the max level heroes can achieve (default is 25). ]]
-- @return int
function GetCustomHeroMaxLevel(  ) end

---[[ GetCustomScanCooldown  Get the current custom scan cooldown. ]]
-- @return float
function GetCustomScanCooldown(  ) end

---[[ GetFixedRespawnTime  Gets the fixed respawn time. ]]
-- @return float
function GetFixedRespawnTime(  ) end

---[[ GetFogOfWarDisabled  Turn the fog of war on or off. ]]
-- @return bool
function GetFogOfWarDisabled(  ) end

---[[ GetGoldSoundDisabled  Turn the sound when gold is acquired off/on. ]]
-- @return bool
function GetGoldSoundDisabled(  ) end

---[[ GetHUDVisible  Returns the HUD element visibility. ]]
-- @return bool
-- @param iElement int
function GetHUDVisible( iElement ) end

---[[ GetMaximumAttackSpeed  Get the maximum attack speed for units. ]]
-- @return int
function GetMaximumAttackSpeed(  ) end

---[[ GetMinimumAttackSpeed  Get the minimum attack speed for units. ]]
-- @return int
function GetMinimumAttackSpeed(  ) end

---[[ GetRecommendedItemsDisabled  Turn the panel for showing recommended items at the shop off/on. ]]
-- @return bool
function GetRecommendedItemsDisabled(  ) end

---[[ GetRespawnTimeScale  Returns the scale applied to non-fixed respawn times. ]]
-- @return float
function GetRespawnTimeScale(  ) end

---[[ GetStashPurchasingDisabled  Turn purchasing items to the stash off/on. If purchasing to the stash is off the player must be at a shop to purchase items. ]]
-- @return bool
function GetStashPurchasingDisabled(  ) end

---[[ GetStickyItemDisabled  Hide the sticky item in the quickbuy. ]]
-- @return bool
function GetStickyItemDisabled(  ) end

---[[ GetTopBarTeamValuesOverride  Override the values of the team values on the top game bar. ]]
-- @return bool
function GetTopBarTeamValuesOverride(  ) end

---[[ GetTopBarTeamValuesVisible  Turning on/off the team values on the top game bar. ]]
-- @return bool
function GetTopBarTeamValuesVisible(  ) end

---[[ GetTowerBackdoorProtectionEnabled  Gets whether tower backdoor protection is enabled or not. ]]
-- @return bool
function GetTowerBackdoorProtectionEnabled(  ) end

---[[ GetUseCustomHeroLevels  Are custom-defined XP values for hero level ups in use? ]]
-- @return bool
function GetUseCustomHeroLevels(  ) end

---[[ IsBuybackEnabled  Enables or disables buyback completely. ]]
-- @return bool
function IsBuybackEnabled(  ) end

---[[ IsDaynightCycleDisabled  Is the day/night cycle disabled? ]]
-- @return bool
function IsDaynightCycleDisabled(  ) end

---[[ ListenForQueryFailed  Set function and context for real time combat analyzer query failed. ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function ListenForQueryFailed( hFunction, hContext ) end

---[[ ListenForQueryProgressChanged  Set function and context for real time combat analyzer query progress changed. ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function ListenForQueryProgressChanged( hFunction, hContext ) end

---[[ ListenForQuerySucceeded  Set function and context for real time combat analyzer query succeeded. ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function ListenForQuerySucceeded( hFunction, hContext ) end

---[[ RemoveRealTimeCombatAnalyzerQuery  Stop tracking a combat analyzer query. ]]
-- @return void
-- @param nQueryID int
function RemoveRealTimeCombatAnalyzerQuery( nQueryID ) end

---[[ SetAbilityTuningValueFilter  Set a filter function to control the tuning values that abilities use. (Modify the table and Return true to use new values, return false to use the old values) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetAbilityTuningValueFilter( hFunction, hContext ) end

---[[ SetAlwaysShowPlayerInventory  Show the player hero's inventory in the HUD, regardless of what unit is selected. ]]
-- @return void
-- @param bAlwaysShow bool
function SetAlwaysShowPlayerInventory( bAlwaysShow ) end

---[[ SetAlwaysShowPlayerNames  Set whether player names are always shown, regardless of client setting. ]]
-- @return void
-- @param bEnabled bool
function SetAlwaysShowPlayerNames( bEnabled ) end

---[[ SetAnnouncerDisabled  Mutes the in-game announcer. ]]
-- @return void
-- @param bDisabled bool
function SetAnnouncerDisabled( bDisabled ) end

---[[ SetBotThinkingEnabled  Enables/Disables bots in custom games. Note: this will only work with default heroes in the dota map. ]]
-- @return void
-- @param bEnabled bool
function SetBotThinkingEnabled( bEnabled ) end

---[[ SetBotsAlwaysPushWithHuman  Set if the bots should try their best to push with a human player. ]]
-- @return void
-- @param bAlwaysPush bool
function SetBotsAlwaysPushWithHuman( bAlwaysPush ) end

---[[ SetBotsInLateGame  Set if bots should enable their late game behavior. ]]
-- @return void
-- @param bLateGame bool
function SetBotsInLateGame( bLateGame ) end

---[[ SetBotsMaxPushTier  Set the max tier of tower that bots want to push. (-1 to disable) ]]
-- @return void
-- @param nMaxTier int
function SetBotsMaxPushTier( nMaxTier ) end

---[[ SetBountyRunePickupFilter  Set a filter function to control the behavior when a bounty rune is picked up. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetBountyRunePickupFilter( hFunction, hContext ) end

---[[ SetBountyRuneSpawnInterval  Set bounty rune spawn rate ]]
-- @return void
-- @param flInterval float
function SetBountyRuneSpawnInterval( flInterval ) end

---[[ SetBuybackEnabled  Enables or disables buyback completely. ]]
-- @return void
-- @param bEnabled bool
function SetBuybackEnabled( bEnabled ) end

---[[ SetCameraDistanceOverride  Set a different camera distance; dota default is 1134. ]]
-- @return void
-- @param flCameraDistanceOverride float
function SetCameraDistanceOverride( flCameraDistanceOverride ) end

---[[ SetCameraSmoothCountOverride  Set a different camera smooth count; dota default is 8. ]]
-- @return void
-- @param nSmoothCount int
function SetCameraSmoothCountOverride( nSmoothCount ) end

---[[ SetCustomAttributeDerivedStatValue  Modify derived stat value constants. ( AttributeDerivedStat eStatType, float flNewValue. ]]
-- @return void
-- @param nStatType int
-- @param flNewValue float
function SetCustomAttributeDerivedStatValue( nStatType, flNewValue ) end

---[[ SetCustomBackpackCooldownPercent  Set the rate cooldown ticks down for items in the backpack. ]]
-- @return void
-- @param flPercent float
function SetCustomBackpackCooldownPercent( flPercent ) end

---[[ SetCustomBackpackSwapCooldown  Set a custom cooldown for swapping items into the backpack. ]]
-- @return void
-- @param flCooldown float
function SetCustomBackpackSwapCooldown( flCooldown ) end

---[[ SetCustomBuybackCooldownEnabled  Turns on capability to define custom buyback cooldowns. ]]
-- @return void
-- @param bEnabled bool
function SetCustomBuybackCooldownEnabled( bEnabled ) end

---[[ SetCustomBuybackCostEnabled  Turns on capability to define custom buyback costs. ]]
-- @return void
-- @param bEnabled bool
function SetCustomBuybackCostEnabled( bEnabled ) end

---[[ SetCustomGameForceHero  Force all players to use the specified hero and disable the normal hero selection process. Must be used before hero selection. ]]
-- @return void
-- @param pHeroName string
function SetCustomGameForceHero( pHeroName ) end

---[[ SetCustomGlyphCooldown  Set a custom cooldown for team Glyph ability. ]]
-- @return void
-- @param flCooldown float
function SetCustomGlyphCooldown( flCooldown ) end

---[[ SetCustomHeroMaxLevel  Allows definition of the max level heroes can achieve (default is 25). ]]
-- @return void
-- @param int_1 int
function SetCustomHeroMaxLevel( int_1 ) end

---[[ SetCustomScanCooldown  Set a custom cooldown for team Scan ability. ]]
-- @return void
-- @param flCooldown float
function SetCustomScanCooldown( flCooldown ) end

---[[ SetCustomTerrainWeatherEffect  Set the effect used as a custom weather effect, when units are on non-default terrain, in this mode. ]]
-- @return void
-- @param pszEffectName string
function SetCustomTerrainWeatherEffect( pszEffectName ) end

---[[ SetCustomXPRequiredToReachNextLevel  Allows definition of a table of hero XP values. ]]
-- @return void
-- @param hTable handle
function SetCustomXPRequiredToReachNextLevel( hTable ) end

---[[ SetDamageFilter  Set a filter function to control the behavior when a unit takes damage. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetDamageFilter( hFunction, hContext ) end

---[[ SetDaynightCycleDisabled  Enable or disable the day/night cycle. ]]
-- @return void
-- @param bDisable bool
function SetDaynightCycleDisabled( bDisable ) end

---[[ SetDeathOverlayDisabled  Specify whether the full screen death overlay effect plays when the selected hero dies. ]]
-- @return void
-- @param bDisabled bool
function SetDeathOverlayDisabled( bDisabled ) end

---[[ SetDraftingBanningTimeOverride  Set drafting hero banning time ]]
-- @return void
-- @param flValue float
function SetDraftingBanningTimeOverride( flValue ) end

---[[ SetDraftingHeroPickSelectTimeOverride  Set drafting hero pick time ]]
-- @return void
-- @param flValue float
function SetDraftingHeroPickSelectTimeOverride( flValue ) end

---[[ SetExecuteOrderFilter  Set a filter function to control the behavior when a unit picks up an item. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetExecuteOrderFilter( hFunction, hContext ) end

---[[ SetFixedRespawnTime  Set a fixed delay for all players to respawn after. ]]
-- @return void
-- @param flFixedRespawnTime float
function SetFixedRespawnTime( flFixedRespawnTime ) end

---[[ SetFogOfWarDisabled  Turn the fog of war on or off. ]]
-- @return void
-- @param bDisabled bool
function SetFogOfWarDisabled( bDisabled ) end

---[[ SetFountainConstantManaRegen  Set the constant rate that the fountain will regen mana. (-1 for default) ]]
-- @return void
-- @param flConstantManaRegen float
function SetFountainConstantManaRegen( flConstantManaRegen ) end

---[[ SetFountainPercentageHealthRegen  Set the percentage rate that the fountain will regen health. (-1 for default) ]]
-- @return void
-- @param flPercentageHealthRegen float
function SetFountainPercentageHealthRegen( flPercentageHealthRegen ) end

---[[ SetFountainPercentageManaRegen  Set the percentage rate that the fountain will regen mana. (-1 for default) ]]
-- @return void
-- @param flPercentageManaRegen float
function SetFountainPercentageManaRegen( flPercentageManaRegen ) end

---[[ SetFreeCourierModeEnabled  If set to true, enable 7.23 free courier mode. ]]
-- @return void
-- @param bEnabled bool
function SetFreeCourierModeEnabled( bEnabled ) end

---[[ SetFriendlyBuildingMoveToEnabled  Allows clicks on friendly buildings to be handled normally. ]]
-- @return void
-- @param bEnabled bool
function SetFriendlyBuildingMoveToEnabled( bEnabled ) end

---[[ SetGoldSoundDisabled  Turn the sound when gold is acquired off/on. ]]
-- @return void
-- @param bDisabled bool
function SetGoldSoundDisabled( bDisabled ) end

---[[ SetHUDVisible  Set the HUD element visibility. ]]
-- @return void
-- @param iHUDElement int
-- @param bVisible bool
function SetHUDVisible( iHUDElement, bVisible ) end

---[[ SetHealingFilter  Set a filter function to control the behavior when a unit heals. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetHealingFilter( hFunction, hContext ) end

---[[ SetHudCombatEventsDisabled  Specify whether the default combat events will show in the HUD. ]]
-- @return void
-- @param bDisabled bool
function SetHudCombatEventsDisabled( bDisabled ) end

---[[ SetItemAddedToInventoryFilter  Set a filter function to control what happens to items that are added to an inventory, return false to cancel the event ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetItemAddedToInventoryFilter( hFunction, hContext ) end

---[[ SetKillableTombstones  Set whether tombstones can be channeled to be removed by enemy heroes. ]]
-- @return void
-- @param bEnabled bool
function SetKillableTombstones( bEnabled ) end

---[[ SetKillingSpreeAnnouncerDisabled  Mutes the in-game killing spree announcer. ]]
-- @return void
-- @param bDisabled bool
function SetKillingSpreeAnnouncerDisabled( bDisabled ) end

---[[ SetLoseGoldOnDeath  Use to disable gold loss on death. ]]
-- @return void
-- @param bEnabled bool
function SetLoseGoldOnDeath( bEnabled ) end

---[[ SetMaximumAttackSpeed  Set the maximum attack speed for units. ]]
-- @return void
-- @param nMaxSpeed int
function SetMaximumAttackSpeed( nMaxSpeed ) end

---[[ SetMinimumAttackSpeed  Set the minimum attack speed for units. ]]
-- @return void
-- @param nMinSpeed int
function SetMinimumAttackSpeed( nMinSpeed ) end

---[[ SetModifierGainedFilter  Set a filter function to control modifiers that are gained, return false to destroy modifier. ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetModifierGainedFilter( hFunction, hContext ) end

---[[ SetModifyExperienceFilter  Set a filter function to control the behavior when a hero's experience is modified. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetModifyExperienceFilter( hFunction, hContext ) end

---[[ SetModifyGoldFilter  Set a filter function to control the behavior when a hero's gold is modified. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetModifyGoldFilter( hFunction, hContext ) end

---[[ SetOverrideSelectionEntity  Set an override for the default selection entity, instead of each player's hero. ]]
-- @return void
-- @param hOverrideEntity handle
function SetOverrideSelectionEntity( hOverrideEntity ) end

---[[ SetPauseEnabled  Set pausing enabled/disabled ]]
-- @return void
-- @param bEnabled bool
function SetPauseEnabled( bEnabled ) end

---[[ SetPowerRuneSpawnInterval  Set power rune spawn rate ]]
-- @return void
-- @param flInterval float
function SetPowerRuneSpawnInterval( flInterval ) end

---[[ SetRecommendedItemsDisabled  Turn the panel for showing recommended items at the shop off/on. ]]
-- @return void
-- @param bDisabled bool
function SetRecommendedItemsDisabled( bDisabled ) end

---[[ SetRemoveIllusionsOnDeath  Make it so illusions are immediately removed upon death, rather than sticking around for a few seconds. ]]
-- @return void
-- @param bRemove bool
function SetRemoveIllusionsOnDeath( bRemove ) end

---[[ SetRespawnTimeScale  Sets the scale applied to non-fixed respawn times. 1 = default DOTA respawn calculations. ]]
-- @return void
-- @param flValue float
function SetRespawnTimeScale( flValue ) end

---[[ SetRuneEnabled  Set if a given type of rune is enabled. ]]
-- @return void
-- @param nRune int
-- @param bEnabled bool
function SetRuneEnabled( nRune, bEnabled ) end

---[[ SetRuneSpawnFilter  Set a filter function to control what rune spawns. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetRuneSpawnFilter( hFunction, hContext ) end

---[[ SetSelectionGoldPenaltyEnabled  Enable/disable gold penalty for late picking. ]]
-- @return void
-- @param bEnabled bool
function SetSelectionGoldPenaltyEnabled( bEnabled ) end

---[[ SetStashPurchasingDisabled  Turn purchasing items to the stash off/on. If purchasing to the stash is off the player must be at a shop to purchase items. ]]
-- @return void
-- @param bDisabled bool
function SetStashPurchasingDisabled( bDisabled ) end

---[[ SetStickyItemDisabled  Hide the sticky item in the quickbuy. ]]
-- @return void
-- @param bDisabled bool
function SetStickyItemDisabled( bDisabled ) end

---[[ SetTopBarTeamValue  Set the team values on the top game bar. ]]
-- @return void
-- @param iTeam int
-- @param nValue int
function SetTopBarTeamValue( iTeam, nValue ) end

---[[ SetTopBarTeamValuesOverride  Override the values of the team values on the top game bar. ]]
-- @return void
-- @param bOverride bool
function SetTopBarTeamValuesOverride( bOverride ) end

---[[ SetTopBarTeamValuesVisible  Turning on/off the team values on the top game bar. ]]
-- @return void
-- @param bVisible bool
function SetTopBarTeamValuesVisible( bVisible ) end

---[[ SetTowerBackdoorProtectionEnabled  Enables/Disables tower backdoor protection. ]]
-- @return void
-- @param bEnabled bool
function SetTowerBackdoorProtectionEnabled( bEnabled ) end

---[[ SetTrackingProjectileFilter  Set a filter function to control when tracking projectiles are launched. (Modify the table and Return true to use new values, return false to cancel the event) ]]
-- @return void
-- @param hFunction handle
-- @param hContext handle
function SetTrackingProjectileFilter( hFunction, hContext ) end

---[[ SetUnseenFogOfWarEnabled  Enable or disable unseen fog of war. When enabled parts of the map the player has never seen will be completely hidden by fog of war. ]]
-- @return void
-- @param bEnabled bool
function SetUnseenFogOfWarEnabled( bEnabled ) end

---[[ SetUseCustomHeroLevels  Turn on custom-defined XP values for hero level ups.  The table should be defined before switching this on. ]]
-- @return void
-- @param bEnabled bool
function SetUseCustomHeroLevels( bEnabled ) end

---[[ SetUseDefaultDOTARuneSpawnLogic  If set to true, use current rune spawn rules.  Either setting respects custom spawn intervals. ]]
-- @return void
-- @param bEnabled bool
function SetUseDefaultDOTARuneSpawnLogic( bEnabled ) end

---[[ SetWeatherEffectsDisabled  Set if weather effects are disabled. ]]
-- @return void
-- @param bDisable bool
function SetWeatherEffectsDisabled( bDisable ) end

---[[ GetHeroDataByName_Script  Get the hero unit  ]]
-- @return table
-- @param string_1 string
function GetHeroDataByName_Script( string_1 ) end

---[[ GetHeroIDByName  Get the hero ID given the hero name. ]]
-- @return int
-- @param string_1 string
function GetHeroIDByName( string_1 ) end

---[[ GetHeroNameByID  Get the hero name given a hero ID. ]]
-- @return string
-- @param int_1 int
function GetHeroNameByID( int_1 ) end

---[[ GetHeroNameForUnitName  Get the hero name given a unit name. ]]
-- @return string
-- @param string_1 string
function GetHeroNameForUnitName( string_1 ) end

---[[ GetHeroUnitNameByID  Get the hero unit name given the hero ID. ]]
-- @return string
-- @param int_1 int
function GetHeroUnitNameByID( int_1 ) end

---[[ CheckForCourierSpawning  Attempt to spawn the appropriate couriers for this mode. ]]
-- @return void
-- @param hHero handle
function CheckForCourierSpawning( hHero ) end

---[[ GetAssignedHero  Get the player's hero. ]]
-- @return handle
function GetAssignedHero(  ) end

---[[ GetPlayerID  Get the player's official PlayerID; notably is -1 when the player isn't yet on a team. ]]
-- @return int
function GetPlayerID(  ) end

---[[ MakeRandomHeroSelection  Randoms this player's hero. ]]
-- @return void
function MakeRandomHeroSelection(  ) end

---[[ SetAssignedHeroEntity  Sets this player's hero . ]]
-- @return void
-- @param hHero handle
function SetAssignedHeroEntity( hHero ) end

---[[ SetKillCamUnit  Set the kill cam unit for this hero. ]]
-- @return void
-- @param hEntity handle
function SetKillCamUnit( hEntity ) end

---[[ SetMusicStatus  (nMusicStatus, flIntensity) - Set the music status for this player, note this will only really apply if dota_music_battle_enable is off. ]]
-- @return void
-- @param nMusicStatus int
-- @param flIntensity float
function SetMusicStatus( nMusicStatus, flIntensity ) end

---[[ SetSelectedHero  Sets this player's hero selection. ]]
-- @return void
-- @param pszHeroName string
function SetSelectedHero( pszHeroName ) end

---[[ StartVote  Starts a vote, based upon a table of parameters ]]
-- @return void
-- @param handle_1 handle
function StartVote( handle_1 ) end

---[[ CDOTA_Ability_Animation_Attack:SetPlaybackRate  Override playbackrate ]]
-- @return void
-- @param flRate float
function CDOTA_Ability_Animation_Attack:SetPlaybackRate( flRate ) end

---[[ CDOTA_Ability_Animation_TailSpin:SetPlaybackRate  Override playbackrate ]]
-- @return void
-- @param flRate float
function CDOTA_Ability_Animation_TailSpin:SetPlaybackRate( flRate ) end

---[[ ApplyDataDrivenModifier  Applies a data driven modifier to the target ]]
-- @return handle
-- @param hCaster handle
-- @param hTarget handle
-- @param pszModifierName string
-- @param hModifierTable handle
function ApplyDataDrivenModifier( hCaster, hTarget, pszModifierName, hModifierTable ) end

---[[ ApplyDataDrivenThinker  Applies a data driven thinker at the location ]]
-- @return handle
-- @param hCaster handle
-- @param vLocation Vector
-- @param pszModifierName string
-- @param hModifierTable handle
function ApplyDataDrivenThinker( hCaster, vLocation, pszModifierName, hModifierTable ) end

---[[ CastFilterResult  Determine whether an issued command with no target is valid. ]]
-- @return int
function CastFilterResult(  ) end

---[[ CastFilterResultLocation  (Vector vLocation) Determine whether an issued command on a location is valid. ]]
-- @return int
-- @param vLocation Vector
function CastFilterResultLocation( vLocation ) end

---[[ CastFilterResultTarget  (HSCRIPT hTarget) Determine whether an issued command on a target is valid. ]]
-- @return int
-- @param hTarget handle
function CastFilterResultTarget( hTarget ) end

---[[ GetAOERadius  Controls the size of the AOE casting cursor. ]]
-- @return float
function GetAOERadius(  ) end

---[[ GetAssociatedPrimaryAbilities  Returns abilities that are stolen simultaneously, or otherwise related in functionality. ]]
-- @return string
function GetAssociatedPrimaryAbilities(  ) end

---[[ GetAssociatedSecondaryAbilities  Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities. ]]
-- @return string
function GetAssociatedSecondaryAbilities(  ) end

---[[ GetBehavior  Return cast behavior type of this ability. ]]
-- @return int
function GetBehavior(  ) end

---[[ GetCastAnimation  Return casting animation of this ability. ]]
-- @return int
function GetCastAnimation(  ) end

---[[ GetCastPoint  Return cast point of this ability. ]]
-- @return float
function GetCastPoint(  ) end

---[[ GetCastRange  Return cast range of this ability. ]]
-- @return int
-- @param vLocation Vector
-- @param hTarget handle
function GetCastRange( vLocation, hTarget ) end

---[[ GetChannelAnimation  Return channel animation of this ability. ]]
-- @return int
function GetChannelAnimation(  ) end

---[[ GetChannelTime  Return the channel time of this ability. ]]
-- @return float
function GetChannelTime(  ) end

---[[ GetChannelledManaCostPerSecond  Return mana cost at the given level per second while channeling (-1 is current). ]]
-- @return int
-- @param iLevel int
function GetChannelledManaCostPerSecond( iLevel ) end

---[[ GetConceptRecipientType  Return who hears speech when this spell is cast. ]]
-- @return int
function GetConceptRecipientType(  ) end

---[[ GetCooldown  Return cooldown of this ability. ]]
-- @return float
-- @param iLevel int
function GetCooldown( iLevel ) end

---[[ GetCustomCastError  Return the error string of a failed command with no target. ]]
-- @return string
function GetCustomCastError(  ) end

---[[ GetCustomCastErrorLocation  (Vector vLocation) Return the error string of a failed command on a location. ]]
-- @return string
-- @param vLocation Vector
function GetCustomCastErrorLocation( vLocation ) end

---[[ GetCustomCastErrorTarget  (HSCRIPT hTarget) Return the error string of a failed command on a target. ]]
-- @return string
-- @param hTarget handle
function GetCustomCastErrorTarget( hTarget ) end

---[[ GetGoldCost  Return gold cost at the given level (-1 is current). ]]
-- @return int
-- @param iLevel int
function GetGoldCost( iLevel ) end

---[[ GetIntrinsicModifierName  Returns the name of the modifier applied passively by this ability. ]]
-- @return string
function GetIntrinsicModifierName(  ) end

---[[ GetManaCost  Return mana cost at the given level (-1 is current). ]]
-- @return int
-- @param iLevel int
function GetManaCost( iLevel ) end

---[[ GetPlaybackRateOverride  Return the animation rate of the cast animation. ]]
-- @return float
function GetPlaybackRateOverride(  ) end

---[[ IsHiddenAbilityCastable  Returns true if this ability can be used when not on the action panel. ]]
-- @return bool
function IsHiddenAbilityCastable(  ) end

---[[ IsHiddenWhenStolen  Returns true if this ability is hidden when stolen by Spell Steal. ]]
-- @return bool
function IsHiddenWhenStolen(  ) end

---[[ IsRefreshable  Returns true if this ability is refreshed by Refresher Orb. ]]
-- @return bool
function IsRefreshable(  ) end

---[[ IsStealable  Returns true if this ability can be stolen by Spell Steal. ]]
-- @return bool
function IsStealable(  ) end

---[[ OnAbilityPhaseInterrupted  Cast time did not complete successfully. ]]
-- @return void
function OnAbilityPhaseInterrupted(  ) end

---[[ OnAbilityPhaseStart  Cast time begins (return true for successful cast). ]]
-- @return bool
function OnAbilityPhaseStart(  ) end

---[[ OnAbilityPinged  The ability was pinged (nPlayerID, bCtrlHeld). ]]
-- @return void
-- @param nPlayerID int
-- @param bCtrlHeld bool
function OnAbilityPinged( nPlayerID, bCtrlHeld ) end

---[[ OnChannelFinish  (bool bInterrupted) Channel finished. ]]
-- @return void
-- @param bInterrupted bool
function OnChannelFinish( bInterrupted ) end

---[[ OnChannelThink  (float flInterval) Channeling is taking place. ]]
-- @return void
-- @param flInterval float
function OnChannelThink( flInterval ) end

---[[ OnHeroCalculateStatBonus  Caster (hero only) gained a level, skilled an ability, or received a new stat bonus. ]]
-- @return void
function OnHeroCalculateStatBonus(  ) end

---[[ OnHeroDiedNearby  A hero has died in the vicinity (ie Urn), takes table of params. ]]
-- @return void
-- @param unit handle
-- @param attacker handle
-- @param table handle
function OnHeroDiedNearby( unit, attacker, table ) end

---[[ OnHeroLevelUp  Caster gained a level. ]]
-- @return void
function OnHeroLevelUp(  ) end

---[[ OnInventoryContentsChanged  Caster inventory changed. ]]
-- @return void
function OnInventoryContentsChanged(  ) end

---[[ OnItemEquipped  ( HSCRIPT hItem ) Caster equipped item. ]]
-- @return void
-- @param hItem handle
function OnItemEquipped( hItem ) end

---[[ OnOwnerDied  Caster died. ]]
-- @return void
function OnOwnerDied(  ) end

---[[ OnOwnerSpawned  Caster respawned or spawned for the first time. ]]
-- @return void
function OnOwnerSpawned(  ) end

---[[ OnProjectileHit  (HSCRIPT hTarget, Vector vLocation) Projectile has collided with a given target or reached its destination (target is invalid). ]]
-- @return bool
-- @param hTarget handle
-- @param vLocation Vector
function OnProjectileHit( hTarget, vLocation ) end

---[[ OnProjectileHitHandle  (HSCRIPT hTarget, Vector vLocation, int nHandle) Projectile has collided with a given target or reached its destination (target is invalid). ]]
-- @return bool
-- @param hTarget handle
-- @param vLocation Vector
-- @param iProjectileHandle int
function OnProjectileHitHandle( hTarget, vLocation, iProjectileHandle ) end

---[[ OnProjectileHit_ExtraData  (HSCRIPT hTarget, Vector vLocation, table kv) Projectile has collided with a given target or reached its destination (target is invalid). ]]
-- @return bool
-- @param hTarget handle
-- @param vLocation Vector
-- @param table handle
function OnProjectileHit_ExtraData( hTarget, vLocation, table ) end

---[[ OnProjectileThink  (Vector vLocation) Projectile is actively moving. ]]
-- @return void
-- @param vLocation Vector
function OnProjectileThink( vLocation ) end

---[[ OnProjectileThinkHandle  (int nProjectileHandle) Projectile is actively moving. ]]
-- @return void
-- @param iProjectileHandle int
function OnProjectileThinkHandle( iProjectileHandle ) end

---[[ OnProjectileThink_ExtraData  (Vector vLocation, table kv ) Projectile is actively moving. ]]
-- @return void
-- @param vLocation Vector
-- @param table handle
function OnProjectileThink_ExtraData( vLocation, table ) end

---[[ OnSpellStart  Cast time finished, spell effects begin. ]]
-- @return void
function OnSpellStart(  ) end

---[[ OnStolen  ( HSCRIPT hAbility ) Special behavior when stolen by Spell Steal. ]]
-- @return void
-- @param hSourceAbility handle
function OnStolen( hSourceAbility ) end

---[[ OnToggle  Ability is toggled on/off. ]]
-- @return void
function OnToggle(  ) end

---[[ OnUnStolen  Special behavior when lost by Spell Steal. ]]
-- @return void
function OnUnStolen(  ) end

---[[ OnUpgrade  Ability gained a level. ]]
-- @return void
function OnUpgrade(  ) end

---[[ ProcsMagicStick  Returns true if this ability will generate magic stick charges for nearby enemies. ]]
-- @return bool
function ProcsMagicStick(  ) end

---[[ ResetToggleOnRespawn  Returns true if this ability should return to the default toggle state when its parent respawns. ]]
-- @return bool
function ResetToggleOnRespawn(  ) end

---[[ SpeakTrigger  Return the type of speech used. ]]
-- @return int
function SpeakTrigger(  ) end

---[[ SetPlaybackRate  Override playbackrate ]]
-- @return void
-- @param flRate float
function SetPlaybackRate( flRate ) end

---[[ SetPlaybackRate  Override playbackrate ]]
-- @return void
-- @param flRate float
function SetPlaybackRate( flRate ) end

---[[ CDOTA_Ability_Nian_Roar:GetCastCount  Number of times Nian has used the roar ]]
-- @return int
function CDOTA_Ability_Nian_Roar:GetCastCount(  ) end

---[[ AddAbility  Add an ability to this unit by name. ]]
-- @return handle
-- @param pszAbilityName string
function AddAbility( pszAbilityName ) end

---[[ AddActivityModifier  Add an activity modifier that affects future StartGesture calls ]]
-- @return void
-- @param szName string
function AddActivityModifier( szName ) end

---[[ AddItem  Add an item to this unit's inventory. ]]
-- @return handle
-- @param hItem handle
function AddItem( hItem ) end

---[[ AddItemByName  Add an item to this unit's inventory. ]]
-- @return handle
-- @param pszItemName string
function AddItemByName( pszItemName ) end

---[[ AddNewModifier  Add a modifier to this unit. ]]
-- @return handle
-- @param hCaster handle
-- @param hAbility handle
-- @param pszScriptName string
-- @param hModifierTable handle
function AddNewModifier( hCaster, hAbility, pszScriptName, hModifierTable ) end

---[[ AddNoDraw  Adds the no draw flag. ]]
-- @return void
function AddNoDraw(  ) end

---[[ AddSpeechBubble  Add a speech bubble(1-4 live at a time) to this NPC. ]]
-- @return void
-- @param iBubble int
-- @param pszSpeech string
-- @param flDuration float
-- @param unOffsetX unsigned
-- @param unOffsetY unsigned
function AddSpeechBubble( iBubble, pszSpeech, flDuration, unOffsetX, unOffsetY ) end

---[[ AlertNearbyUnits   ]]
-- @return void
-- @param hAttacker handle
-- @param hAbility handle
function AlertNearbyUnits( hAttacker, hAbility ) end

---[[ AngerNearbyUnits   ]]
-- @return void
function AngerNearbyUnits(  ) end

---[[ AttackNoEarlierThan   ]]
-- @return void
-- @param flTime float
function AttackNoEarlierThan( flTime ) end

---[[ AttackReady   ]]
-- @return bool
function AttackReady(  ) end

---[[ BoundingRadius2D   ]]
-- @return float
function BoundingRadius2D(  ) end

---[[ CanEntityBeSeenByMyTeam  Check FoW to see if an entity is visible. ]]
-- @return bool
-- @param hEntity handle
function CanEntityBeSeenByMyTeam( hEntity ) end

---[[ CanSellItems  Query if this unit can sell items. ]]
-- @return bool
function CanSellItems(  ) end

---[[ CastAbilityImmediately  Cast an ability immediately. ]]
-- @return void
-- @param hAbility handle
-- @param iPlayerIndex int
function CastAbilityImmediately( hAbility, iPlayerIndex ) end

---[[ CastAbilityNoTarget  Cast an ability with no target. ]]
-- @return void
-- @param hAbility handle
-- @param iPlayerIndex int
function CastAbilityNoTarget( hAbility, iPlayerIndex ) end

---[[ CastAbilityOnPosition  Cast an ability on a position. ]]
-- @return void
-- @param vPosition Vector
-- @param hAbility handle
-- @param iPlayerIndex int
function CastAbilityOnPosition( vPosition, hAbility, iPlayerIndex ) end

---[[ CastAbilityOnTarget  Cast an ability on a target entity. ]]
-- @return void
-- @param hTarget handle
-- @param hAbility handle
-- @param iPlayerIndex int
function CastAbilityOnTarget( hTarget, hAbility, iPlayerIndex ) end

---[[ CastAbilityToggle  Toggle an ability. ]]
-- @return void
-- @param hAbility handle
-- @param iPlayerIndex int
function CastAbilityToggle( hAbility, iPlayerIndex ) end

---[[ ClearActivityModifiers  Clear Activity modifiers ]]
-- @return void
function ClearActivityModifiers(  ) end

---[[ DestroyAllSpeechBubbles   ]]
-- @return void
function DestroyAllSpeechBubbles(  ) end

---[[ DisassembleItem  Disassemble the passed item in this unit's inventory. ]]
-- @return void
-- @param hItem handle
function DisassembleItem( hItem ) end

---[[ DropItemAtPosition  Drop an item at a given point. ]]
-- @return void
-- @param vDest Vector
-- @param hItem handle
function DropItemAtPosition( vDest, hItem ) end

---[[ DropItemAtPositionImmediate  Immediately drop a carried item at a given position. ]]
-- @return void
-- @param hItem handle
-- @param vPosition Vector
function DropItemAtPositionImmediate( hItem, vPosition ) end

---[[ EjectItemFromStash  Drops the selected item out of this unit's stash. ]]
-- @return void
-- @param hItem handle
function EjectItemFromStash( hItem ) end

---[[ FaceTowards  This unit will be set to face the target point. ]]
-- @return void
-- @param vTarget Vector
function FaceTowards( vTarget ) end

---[[ FadeGesture  Fade and remove the given gesture activity. ]]
-- @return void
-- @param nActivity int
function FadeGesture( nActivity ) end

---[[ FindAbilityByName  Retrieve an ability by name from the unit. ]]
-- @return handle
-- @param pAbilityName string
function FindAbilityByName( pAbilityName ) end

---[[ FindAllModifiers  Returns a table of all of the modifiers on the NPC. ]]
-- @return table
function FindAllModifiers(  ) end

---[[ FindAllModifiersByName  Returns a table of all of the modifiers on the NPC with the passed name (modifierName) ]]
-- @return table
-- @param pszScriptName string
function FindAllModifiersByName( pszScriptName ) end

---[[ FindItemInInventory  Get handle to first item in inventory, else nil. ]]
-- @return handle
-- @param pszItemName string
function FindItemInInventory( pszItemName ) end

---[[ FindModifierByName  Return a handle to the modifier of the given name if found, else nil (string Name ) ]]
-- @return handle
-- @param pszScriptName string
function FindModifierByName( pszScriptName ) end

---[[ FindModifierByNameAndCaster  Return a handle to the modifier of the given name from the passed caster if found, else nil ( string Name, hCaster ) ]]
-- @return handle
-- @param pszScriptName string
-- @param hCaster handle
function FindModifierByNameAndCaster( pszScriptName, hCaster ) end

---[[ ForceKill  Kill this unit immediately. ]]
-- @return void
-- @param bReincarnate bool
function ForceKill( bReincarnate ) end

---[[ ForcePlayActivityOnce  Play an activity once, and then go back to idle. ]]
-- @return void
-- @param nActivity int
function ForcePlayActivityOnce( nActivity ) end

---[[ GetAbilityByIndex  Retrieve an ability by index from the unit. ]]
-- @return handle
-- @param iIndex int
function GetAbilityByIndex( iIndex ) end

---[[ GetAbilityCount   ]]
-- @return int
function GetAbilityCount(  ) end

---[[ GetAcquisitionRange  Gets the range at which this unit will auto-acquire. ]]
-- @return float
function GetAcquisitionRange(  ) end

---[[ GetAdditionalBattleMusicWeight  Combat involving this creature will have this weight added to the music calcuations. ]]
-- @return float
function GetAdditionalBattleMusicWeight(  ) end

---[[ GetAggroTarget  Returns this unit's aggro target. ]]
-- @return handle
function GetAggroTarget(  ) end

---[[ GetAttackAnimationPoint   ]]
-- @return float
function GetAttackAnimationPoint(  ) end

---[[ GetAttackCapability   ]]
-- @return int
function GetAttackCapability(  ) end

---[[ GetAttackDamage  Returns a random integer between the minimum and maximum base damage of the unit. ]]
-- @return int
function GetAttackDamage(  ) end

---[[ GetAttackRangeBuffer  Gets the attack range buffer. ]]
-- @return float
function GetAttackRangeBuffer(  ) end

---[[ GetAttackSpeed   ]]
-- @return float
function GetAttackSpeed(  ) end

---[[ GetAttackTarget   ]]
-- @return handle
function GetAttackTarget(  ) end

---[[ GetAttacksPerSecond   ]]
-- @return float
function GetAttacksPerSecond(  ) end

---[[ GetAverageTrueAttackDamage  Returns the average value of the minimum and maximum damage values. ]]
-- @return int
-- @param hTarget handle
function GetAverageTrueAttackDamage( hTarget ) end

---[[ GetBaseAttackRange   ]]
-- @return int
function GetBaseAttackRange(  ) end

---[[ GetBaseAttackTime   ]]
-- @return float
function GetBaseAttackTime(  ) end

---[[ GetBaseDamageMax  Get the maximum attack damage of this unit. ]]
-- @return int
function GetBaseDamageMax(  ) end

---[[ GetBaseDamageMin  Get the minimum attack damage of this unit. ]]
-- @return int
function GetBaseDamageMin(  ) end

---[[ GetBaseDayTimeVisionRange  Returns the vision range before modifiers. ]]
-- @return int
function GetBaseDayTimeVisionRange(  ) end

---[[ GetBaseHealthRegen   ]]
-- @return float
function GetBaseHealthRegen(  ) end

---[[ GetBaseMagicalResistanceValue  Returns base magical armor value. ]]
-- @return float
function GetBaseMagicalResistanceValue(  ) end

---[[ GetBaseMaxHealth  Gets the base max health value. ]]
-- @return float
function GetBaseMaxHealth(  ) end

---[[ GetBaseMoveSpeed   ]]
-- @return float
function GetBaseMoveSpeed(  ) end

---[[ GetBaseNightTimeVisionRange  Returns the vision range after modifiers. ]]
-- @return int
function GetBaseNightTimeVisionRange(  ) end

---[[ GetBonusManaRegen  This Mana regen is derived from constant bonuses like Basilius. ]]
-- @return float
function GetBonusManaRegen(  ) end

---[[ GetCastPoint   ]]
-- @return float
-- @param bAttack bool
function GetCastPoint( bAttack ) end

---[[ GetCastRangeBonus   ]]
-- @return float
function GetCastRangeBonus(  ) end

---[[ GetCloneSource  Get clone source (Meepo Prime, if this is a Meepo) ]]
-- @return handle
function GetCloneSource(  ) end

---[[ GetCollisionPadding  Returns the size of the collision padding around the hull. ]]
-- @return float
function GetCollisionPadding(  ) end

---[[ GetCooldownReduction   ]]
-- @return float
function GetCooldownReduction(  ) end

---[[ GetCreationTime   ]]
-- @return float
function GetCreationTime(  ) end

---[[ GetCurrentActiveAbility  Get the ability this unit is currently casting. ]]
-- @return handle
function GetCurrentActiveAbility(  ) end

---[[ GetCurrentVisionRange  Gets the current vision range. ]]
-- @return int
function GetCurrentVisionRange(  ) end

---[[ GetCursorCastTarget   ]]
-- @return handle
function GetCursorCastTarget(  ) end

---[[ GetCursorPosition   ]]
-- @return Vector
function GetCursorPosition(  ) end

---[[ GetCursorTargetingNothing   ]]
-- @return bool
function GetCursorTargetingNothing(  ) end

---[[ GetDayTimeVisionRange  Returns the vision range after modifiers. ]]
-- @return int
function GetDayTimeVisionRange(  ) end

---[[ GetDeathXP  Get the XP bounty on this unit. ]]
-- @return int
function GetDeathXP(  ) end

---[[ GetDisplayAttackSpeed  Attack speed expressed as constant value ]]
-- @return float
function GetDisplayAttackSpeed(  ) end

---[[ GetEvasion   ]]
-- @return float
function GetEvasion(  ) end

---[[ GetForceAttackTarget   ]]
-- @return handle
function GetForceAttackTarget(  ) end

---[[ GetGoldBounty  Get the gold bounty on this unit. ]]
-- @return int
function GetGoldBounty(  ) end

---[[ GetHasteFactor   ]]
-- @return float
function GetHasteFactor(  ) end

---[[ GetHealthDeficit  Returns integer amount of health missing from max. ]]
-- @return int
function GetHealthDeficit(  ) end

---[[ GetHealthPercent  Get the current health percent of the unit. ]]
-- @return int
function GetHealthPercent(  ) end

---[[ GetHealthRegen   ]]
-- @return float
function GetHealthRegen(  ) end

---[[ GetHullRadius  Get the collision hull radius of this NPC. ]]
-- @return float
function GetHullRadius(  ) end

---[[ GetIdealSpeed  Returns speed after all modifiers. ]]
-- @return float
function GetIdealSpeed(  ) end

---[[ GetIdealSpeedNoSlows  Returns speed after all modifiers, but excluding those that reduce speed. ]]
-- @return float
function GetIdealSpeedNoSlows(  ) end

---[[ GetIncreasedAttackSpeed   ]]
-- @return float
function GetIncreasedAttackSpeed(  ) end

---[[ GetInitialGoalEntity  Returns the initial waypoint goal for this NPC. ]]
-- @return handle
function GetInitialGoalEntity(  ) end

---[[ GetInitialGoalPosition  Get waypoint position for this NPC. ]]
-- @return Vector
function GetInitialGoalPosition(  ) end

---[[ GetItemInSlot  Returns nth item in inventory slot (index is zero based). ]]
-- @return handle
-- @param i int
function GetItemInSlot( i ) end

---[[ GetLastAttackTime   ]]
-- @return float
function GetLastAttackTime(  ) end

---[[ GetLastDamageTime  Get the last time this NPC took damage ]]
-- @return float
function GetLastDamageTime(  ) end

---[[ GetLastIdleChangeTime  Get the last game time that this unit switched to/from idle state. ]]
-- @return float
function GetLastIdleChangeTime(  ) end

---[[ GetLevel  Returns the level of this unit. ]]
-- @return int
function GetLevel(  ) end

---[[ GetMagicalArmorValue  Returns current magical armor value. ]]
-- @return float
function GetMagicalArmorValue(  ) end

---[[ GetMainControllingPlayer  Returns the player ID of the controlling player. ]]
-- @return int
function GetMainControllingPlayer(  ) end

---[[ GetMana  Get the mana on this unit. ]]
-- @return float
function GetMana(  ) end

---[[ GetManaPercent  Get the percent of mana remaining. ]]
-- @return int
function GetManaPercent(  ) end

---[[ GetManaRegen   ]]
-- @return float
function GetManaRegen(  ) end

---[[ GetMaxMana  Get the maximum mana of this unit. ]]
-- @return float
function GetMaxMana(  ) end

---[[ GetMaximumGoldBounty  Get the maximum gold bounty for this unit. ]]
-- @return int
function GetMaximumGoldBounty(  ) end

---[[ GetMinimumGoldBounty  Get the minimum gold bounty for this unit. ]]
-- @return int
function GetMinimumGoldBounty(  ) end

---[[ GetModelRadius   ]]
-- @return float
function GetModelRadius(  ) end

---[[ GetModifierCount  How many modifiers does this unit have? ]]
-- @return int
function GetModifierCount(  ) end

---[[ GetModifierNameByIndex  Get a modifier name by index. ]]
-- @return string
-- @param nIndex int
function GetModifierNameByIndex( nIndex ) end

---[[ GetModifierStackCount  Gets the stack count of a given modifier. ]]
-- @return int
-- @param pszScriptName string
-- @param hCaster handle
function GetModifierStackCount( pszScriptName, hCaster ) end

---[[ GetMoveSpeedModifier   ]]
-- @return float
-- @param flBaseSpeed float
-- @param bReturnUnslowed bool
function GetMoveSpeedModifier( flBaseSpeed, bReturnUnslowed ) end

---[[ GetMustReachEachGoalEntity  Set whether this NPC is required to reach each goal entity, rather than being allowed to unkink their path. ]]
-- @return bool
function GetMustReachEachGoalEntity(  ) end

---[[ GetNeverMoveToClearSpace  If set to true, we will never attempt to move this unit to clear space, even when it unphases. ]]
-- @return bool
function GetNeverMoveToClearSpace(  ) end

---[[ GetNightTimeVisionRange  Returns the vision range after modifiers. ]]
-- @return int
function GetNightTimeVisionRange(  ) end

---[[ GetOpposingTeamNumber   ]]
-- @return int
function GetOpposingTeamNumber(  ) end

---[[ GetPaddedCollisionRadius  Get the collision hull radius (including padding) of this NPC. ]]
-- @return float
function GetPaddedCollisionRadius(  ) end

---[[ GetPhysicalArmorBaseValue  Returns base physical armor value. ]]
-- @return float
function GetPhysicalArmorBaseValue(  ) end

---[[ GetPhysicalArmorValue  Returns current physical armor value. ]]
-- @return float
-- @param bIgnoreBase bool
function GetPhysicalArmorValue( bIgnoreBase ) end

---[[ GetPlayerOwner  Returns the player that owns this unit. ]]
-- @return handle
function GetPlayerOwner(  ) end

---[[ GetPlayerOwnerID  Get the owner player ID for this unit. ]]
-- @return int
function GetPlayerOwnerID(  ) end

---[[ GetProjectileSpeed   ]]
-- @return int
function GetProjectileSpeed(  ) end

---[[ GetRangeToUnit   ]]
-- @return float
-- @param hNPC handle
function GetRangeToUnit( hNPC ) end

---[[ GetRangedProjectileName   ]]
-- @return string
function GetRangedProjectileName(  ) end

---[[ GetSecondsPerAttack   ]]
-- @return float
function GetSecondsPerAttack(  ) end

---[[ GetSpellAmplification   ]]
-- @return float
-- @param bBaseOnly bool
function GetSpellAmplification( bBaseOnly ) end

---[[ GetStatusResistance   ]]
-- @return float
function GetStatusResistance(  ) end

---[[ GetTotalPurchasedUpgradeGoldCost  Get how much gold has been spent on ability upgrades. ]]
-- @return int
function GetTotalPurchasedUpgradeGoldCost(  ) end

---[[ GetUnitLabel   ]]
-- @return string
function GetUnitLabel(  ) end

---[[ GetUnitName  Get the name of this unit. ]]
-- @return string
function GetUnitName(  ) end

---[[ GiveMana  Give mana to this unit, this can be used for mana gained by abilities or item usage. ]]
-- @return void
-- @param flMana float
function GiveMana( flMana ) end

---[[ HasAbility  See whether this unit has an ability by name. ]]
-- @return bool
-- @param pszAbilityName string
function HasAbility( pszAbilityName ) end

---[[ HasAnyActiveAbilities   ]]
-- @return bool
function HasAnyActiveAbilities(  ) end

---[[ HasAttackCapability   ]]
-- @return bool
function HasAttackCapability(  ) end

---[[ HasFlyMovementCapability   ]]
-- @return bool
function HasFlyMovementCapability(  ) end

---[[ HasFlyingVision   ]]
-- @return bool
function HasFlyingVision(  ) end

---[[ HasGroundMovementCapability   ]]
-- @return bool
function HasGroundMovementCapability(  ) end

---[[ HasInventory  Does this unit have an inventory. ]]
-- @return bool
function HasInventory(  ) end

---[[ HasItemInInventory  See whether this unit has an item by name. ]]
-- @return bool
-- @param pItemName string
function HasItemInInventory( pItemName ) end

---[[ HasModifier  Sees if this unit has a given modifier. ]]
-- @return bool
-- @param pszScriptName string
function HasModifier( pszScriptName ) end

---[[ HasMovementCapability   ]]
-- @return bool
function HasMovementCapability(  ) end

---[[ HasScepter   ]]
-- @return bool
function HasScepter(  ) end

---[[ Heal  Heal this unit. ]]
-- @return void
-- @param flAmount float
-- @param hInflictor handle
function Heal( flAmount, hInflictor ) end

---[[ Hold  Hold position. ]]
-- @return void
function Hold(  ) end

---[[ Interrupt   ]]
-- @return void
function Interrupt(  ) end

---[[ InterruptChannel   ]]
-- @return void
function InterruptChannel(  ) end

---[[ InterruptMotionControllers   ]]
-- @return void
-- @param bFindClearSpace bool
function InterruptMotionControllers( bFindClearSpace ) end

---[[ IsAlive  Is this unit alive? ]]
-- @return bool
function IsAlive(  ) end

---[[ IsAncient  Is this unit an Ancient? ]]
-- @return bool
function IsAncient(  ) end

---[[ IsAttackImmune   ]]
-- @return bool
function IsAttackImmune(  ) end

---[[ IsAttacking   ]]
-- @return bool
function IsAttacking(  ) end

---[[ IsAttackingEntity   ]]
-- @return bool
-- @param hEntity handle
function IsAttackingEntity( hEntity ) end

---[[ IsBarracks  Is this unit a Barracks? ]]
-- @return bool
function IsBarracks(  ) end

---[[ IsBlind   ]]
-- @return bool
function IsBlind(  ) end

---[[ IsBlockDisabled   ]]
-- @return bool
function IsBlockDisabled(  ) end

---[[ IsBoss  Is this unit a boss? ]]
-- @return bool
function IsBoss(  ) end

---[[ IsBuilding  Is this unit a building? ]]
-- @return bool
function IsBuilding(  ) end

---[[ IsChanneling  Is this unit currently channeling a spell? ]]
-- @return bool
function IsChanneling(  ) end

---[[ IsClone  Is this unit a clone? (Meepo) ]]
-- @return bool
function IsClone(  ) end

---[[ IsCommandRestricted   ]]
-- @return bool
function IsCommandRestricted(  ) end

---[[ IsConsideredHero  Is this unit a considered a hero for targeting purposes? ]]
-- @return bool
function IsConsideredHero(  ) end

---[[ IsControllableByAnyPlayer  Is this unit controlled by any non-bot player? ]]
-- @return bool
function IsControllableByAnyPlayer(  ) end

---[[ IsCourier  Is this unit a courier? ]]
-- @return bool
function IsCourier(  ) end

---[[ IsCreature  Is this a Creature type NPC? ]]
-- @return bool
function IsCreature(  ) end

---[[ IsCreep  Is this unit a creep? ]]
-- @return bool
function IsCreep(  ) end

---[[ IsDeniable   ]]
-- @return bool
function IsDeniable(  ) end

---[[ IsDisarmed   ]]
-- @return bool
function IsDisarmed(  ) end

---[[ IsDominated   ]]
-- @return bool
function IsDominated(  ) end

---[[ IsEvadeDisabled   ]]
-- @return bool
function IsEvadeDisabled(  ) end

---[[ IsFort  Is this unit an Ancient? ]]
-- @return bool
function IsFort(  ) end

---[[ IsFrozen   ]]
-- @return bool
function IsFrozen(  ) end

---[[ IsHero  Is this a hero or hero illusion? ]]
-- @return bool
function IsHero(  ) end

---[[ IsHexed   ]]
-- @return bool
function IsHexed(  ) end

---[[ IsIdle  Is this creature currently idle? ]]
-- @return bool
function IsIdle(  ) end

---[[ IsIllusion   ]]
-- @return bool
function IsIllusion(  ) end

---[[ IsInRangeOfShop  Ask whether this unit is in range of the specified shop ( DOTA_SHOP_TYPE shop, bool bMustBePhysicallyNear ]]
-- @return bool
-- @param nShopType int
-- @param bPhysical bool
function IsInRangeOfShop( nShopType, bPhysical ) end

---[[ IsInvisible   ]]
-- @return bool
function IsInvisible(  ) end

---[[ IsInvulnerable   ]]
-- @return bool
function IsInvulnerable(  ) end

---[[ IsLowAttackPriority   ]]
-- @return bool
function IsLowAttackPriority(  ) end

---[[ IsMagicImmune   ]]
-- @return bool
function IsMagicImmune(  ) end

---[[ IsMovementImpaired   ]]
-- @return bool
function IsMovementImpaired(  ) end

---[[ IsMoving  Is this unit moving? ]]
-- @return bool
function IsMoving(  ) end

---[[ IsMuted   ]]
-- @return bool
function IsMuted(  ) end

---[[ IsNeutralUnitType  Is this a neutral? ]]
-- @return bool
function IsNeutralUnitType(  ) end

---[[ IsNightmared   ]]
-- @return bool
function IsNightmared(  ) end

---[[ IsOpposingTeam   ]]
-- @return bool
-- @param nTeam int
function IsOpposingTeam( nTeam ) end

---[[ IsOther  Is this unit a ward-type unit? ]]
-- @return bool
function IsOther(  ) end

---[[ IsOutOfGame   ]]
-- @return bool
function IsOutOfGame(  ) end

---[[ IsOwnedByAnyPlayer  Is this unit owned by any non-bot player? ]]
-- @return bool
function IsOwnedByAnyPlayer(  ) end

---[[ IsPhantom  Is this a phantom unit? ]]
-- @return bool
function IsPhantom(  ) end

---[[ IsPhantomBlocker   ]]
-- @return bool
function IsPhantomBlocker(  ) end

---[[ IsPhased   ]]
-- @return bool
function IsPhased(  ) end

---[[ IsPositionInRange   ]]
-- @return bool
-- @param vPosition Vector
-- @param flRange float
function IsPositionInRange( vPosition, flRange ) end

---[[ IsRangedAttacker  Is this unit a ranged attacker? ]]
-- @return bool
function IsRangedAttacker(  ) end

---[[ IsRealHero  Is this a real hero? ]]
-- @return bool
function IsRealHero(  ) end

---[[ IsRooted   ]]
-- @return bool
function IsRooted(  ) end

---[[ IsShrine  Is this a shrine? ]]
-- @return bool
function IsShrine(  ) end

---[[ IsSilenced   ]]
-- @return bool
function IsSilenced(  ) end

---[[ IsSpeciallyDeniable   ]]
-- @return bool
function IsSpeciallyDeniable(  ) end

---[[ IsStunned   ]]
-- @return bool
function IsStunned(  ) end

---[[ IsSummoned  Is this unit summoned? ]]
-- @return bool
function IsSummoned(  ) end

---[[ IsTempestDouble   ]]
-- @return bool
function IsTempestDouble(  ) end

---[[ IsTower  Is this a tower? ]]
-- @return bool
function IsTower(  ) end

---[[ IsUnableToMiss   ]]
-- @return bool
function IsUnableToMiss(  ) end

---[[ IsUnselectable   ]]
-- @return bool
function IsUnselectable(  ) end

---[[ IsUntargetable   ]]
-- @return bool
function IsUntargetable(  ) end

---[[ Kill  Kills this NPC, with the params Ability and Attacker. ]]
-- @return void
-- @param hAbility handle
-- @param hAttacker handle
function Kill( hAbility, hAttacker ) end

---[[ MakeIllusion   ]]
-- @return void
function MakeIllusion(  ) end

---[[ MakePhantomBlocker   ]]
-- @return void
function MakePhantomBlocker(  ) end

---[[ MakeVisibleDueToAttack   ]]
-- @return void
-- @param iTeam int
-- @param flRadius float
function MakeVisibleDueToAttack( iTeam, flRadius ) end

---[[ MakeVisibleToTeam   ]]
-- @return void
-- @param iTeam int
-- @param flDuration float
function MakeVisibleToTeam( iTeam, flDuration ) end

---[[ ManageModelChanges   ]]
-- @return void
function ManageModelChanges(  ) end

---[[ ModifyHealth  Sets the health to a specific value, with optional flags or inflictors. ]]
-- @return void
-- @param iDesiredHealthValue int
-- @param hAbility handle
-- @param bLethal bool
-- @param iAdditionalFlags int
function ModifyHealth( iDesiredHealthValue, hAbility, bLethal, iAdditionalFlags ) end

---[[ MoveToNPC  Move to follow a unit. ]]
-- @return void
-- @param hNPC handle
function MoveToNPC( hNPC ) end

---[[ MoveToNPCToGiveItem  Give an item to another unit. ]]
-- @return void
-- @param hNPC handle
-- @param hItem handle
function MoveToNPCToGiveItem( hNPC, hItem ) end

---[[ MoveToPosition  Issue a Move-To command. ]]
-- @return void
-- @param vDest Vector
function MoveToPosition( vDest ) end

---[[ MoveToPositionAggressive  Issue an Attack-Move-To command. ]]
-- @return void
-- @param vDest Vector
function MoveToPositionAggressive( vDest ) end

---[[ MoveToTargetToAttack  Move to a target to attack. ]]
-- @return void
-- @param hTarget handle
function MoveToTargetToAttack( hTarget ) end

---[[ NoHealthBar   ]]
-- @return bool
function NoHealthBar(  ) end

---[[ NoTeamMoveTo   ]]
-- @return bool
function NoTeamMoveTo(  ) end

---[[ NoTeamSelect   ]]
-- @return bool
function NoTeamSelect(  ) end

---[[ NoUnitCollision   ]]
-- @return bool
function NoUnitCollision(  ) end

---[[ NotOnMinimap   ]]
-- @return bool
function NotOnMinimap(  ) end

---[[ NotOnMinimapForEnemies   ]]
-- @return bool
function NotOnMinimapForEnemies(  ) end

---[[ NotifyWearablesOfModelChange   ]]
-- @return void
-- @param bOriginalModel bool
function NotifyWearablesOfModelChange( bOriginalModel ) end

---[[ PassivesDisabled   ]]
-- @return bool
function PassivesDisabled(  ) end

---[[ PatrolToPosition  Issue a Patrol-To command. ]]
-- @return void
-- @param vDest Vector
function PatrolToPosition( vDest ) end

---[[ PerformAttack  Performs an attack on a target. ]]
-- @return void
-- @param hTarget handle
-- @param bUseCastAttackOrb bool
-- @param bProcessProcs bool
-- @param bSkipCooldown bool
-- @param bIgnoreInvis bool
-- @param bUseProjectile bool
-- @param bFakeAttack bool
-- @param bNeverMiss bool
function PerformAttack( hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss ) end

---[[ PickupDroppedItem  Pick up a dropped item. ]]
-- @return void
-- @param hItem handle
function PickupDroppedItem( hItem ) end

---[[ PickupRune  Pick up a rune. ]]
-- @return void
-- @param hItem handle
function PickupRune( hItem ) end

---[[ PlayVCD  Play a VCD on the NPC. ]]
-- @return void
-- @param pVCD string
function PlayVCD( pVCD ) end

---[[ ProvidesVision   ]]
-- @return bool
function ProvidesVision(  ) end

---[[ Purge  (bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions ]]
-- @return void
-- @param bRemovePositiveBuffs bool
-- @param bRemoveDebuffs bool
-- @param bFrameOnly bool
-- @param bRemoveStuns bool
-- @param bRemoveExceptions bool
function Purge( bRemovePositiveBuffs, bRemoveDebuffs, bFrameOnly, bRemoveStuns, bRemoveExceptions ) end

---[[ ReduceMana  Remove mana from this unit, this can be used for involuntary mana loss, not for mana that is spent. ]]
-- @return void
-- @param flAmount float
function ReduceMana( flAmount ) end

---[[ RemoveAbility  Remove an ability from this unit by name. ]]
-- @return void
-- @param pszAbilityName string
function RemoveAbility( pszAbilityName ) end

---[[ RemoveAbilityByHandle  Remove the passed ability from this unit. ]]
-- @return void
-- @param hAbility handle
function RemoveAbilityByHandle( hAbility ) end

---[[ RemoveGesture  Remove the given gesture activity. ]]
-- @return void
-- @param nActivity int
function RemoveGesture( nActivity ) end

---[[ RemoveHorizontalMotionController   ]]
-- @return void
-- @param hBuff handle
function RemoveHorizontalMotionController( hBuff ) end

---[[ RemoveItem  Removes the passed item from this unit's inventory and deletes it. ]]
-- @return void
-- @param hItem handle
function RemoveItem( hItem ) end

---[[ RemoveModifierByName  Removes a modifier. ]]
-- @return void
-- @param pszScriptName string
function RemoveModifierByName( pszScriptName ) end

---[[ RemoveModifierByNameAndCaster  Removes a modifier that was cast by the given caster. ]]
-- @return void
-- @param pszScriptName string
-- @param hCaster handle
function RemoveModifierByNameAndCaster( pszScriptName, hCaster ) end

---[[ RemoveNoDraw  Remove the no draw flag. ]]
-- @return void
function RemoveNoDraw(  ) end

---[[ RemoveVerticalMotionController   ]]
-- @return void
-- @param hBuff handle
function RemoveVerticalMotionController( hBuff ) end

---[[ RespawnUnit  Respawns the target unit if it can be respawned. ]]
-- @return void
function RespawnUnit(  ) end

---[[ Script_GetAttackRange  Gets this unit's attack range after all modifiers. ]]
-- @return float
function Script_GetAttackRange(  ) end

---[[ SellItem  Sells the passed item in this unit's inventory. ]]
-- @return void
-- @param hItem handle
function SellItem( hItem ) end

---[[ SetAbilityByIndex  Set the ability by index. ]]
-- @return void
-- @param hAbility handle
-- @param iIndex int
function SetAbilityByIndex( hAbility, iIndex ) end

---[[ SetAcquisitionRange   ]]
-- @return void
-- @param nRange int
function SetAcquisitionRange( nRange ) end

---[[ SetAdditionalBattleMusicWeight  Combat involving this creature will have this weight added to the music calcuations. ]]
-- @return void
-- @param flWeight float
function SetAdditionalBattleMusicWeight( flWeight ) end

---[[ SetAggroTarget  Set this unit's aggro target to a specified unit. ]]
-- @return void
-- @param hAggroTarget handle
function SetAggroTarget( hAggroTarget ) end

---[[ SetAttackCapability   ]]
-- @return void
-- @param iAttackCapabilities int
function SetAttackCapability( iAttackCapabilities ) end

---[[ SetAttacking   ]]
-- @return void
-- @param hAttackTarget handle
function SetAttacking( hAttackTarget ) end

---[[ SetBaseAttackTime   ]]
-- @return void
-- @param flBaseAttackTime float
function SetBaseAttackTime( flBaseAttackTime ) end

---[[ SetBaseDamageMax  Sets the maximum base damage. ]]
-- @return void
-- @param nMax int
function SetBaseDamageMax( nMax ) end

---[[ SetBaseDamageMin  Sets the minimum base damage. ]]
-- @return void
-- @param nMin int
function SetBaseDamageMin( nMin ) end

---[[ SetBaseHealthRegen   ]]
-- @return void
-- @param flHealthRegen float
function SetBaseHealthRegen( flHealthRegen ) end

---[[ SetBaseMagicalResistanceValue  Sets base magical armor value. ]]
-- @return void
-- @param flMagicalResistanceValue float
function SetBaseMagicalResistanceValue( flMagicalResistanceValue ) end

---[[ SetBaseManaRegen   ]]
-- @return void
-- @param flManaRegen float
function SetBaseManaRegen( flManaRegen ) end

---[[ SetBaseMaxHealth  Set a new base max health value. ]]
-- @return void
-- @param flBaseMaxHealth float
function SetBaseMaxHealth( flBaseMaxHealth ) end

---[[ SetBaseMoveSpeed   ]]
-- @return void
-- @param iMoveSpeed int
function SetBaseMoveSpeed( iMoveSpeed ) end

---[[ SetCanSellItems  Set whether or not this unit is allowed to sell items (bCanSellItems) ]]
-- @return void
-- @param bCanSell bool
function SetCanSellItems( bCanSell ) end

---[[ SetControllableByPlayer  Set this unit controllable by the player with the passed ID. ]]
-- @return void
-- @param iIndex int
-- @param bSkipAdjustingPosition bool
function SetControllableByPlayer( iIndex, bSkipAdjustingPosition ) end

---[[ SetCursorCastTarget   ]]
-- @return void
-- @param hEntity handle
function SetCursorCastTarget( hEntity ) end

---[[ SetCursorPosition   ]]
-- @return void
-- @param vLocation Vector
function SetCursorPosition( vLocation ) end

---[[ SetCursorTargetingNothing   ]]
-- @return void
-- @param bTargetingNothing bool
function SetCursorTargetingNothing( bTargetingNothing ) end

---[[ SetCustomHealthLabel   ]]
-- @return void
-- @param pLabel string
-- @param r int
-- @param g int
-- @param b int
function SetCustomHealthLabel( pLabel, r, g, b ) end

---[[ SetDayTimeVisionRange  Set the base vision range. ]]
-- @return void
-- @param iRange int
function SetDayTimeVisionRange( iRange ) end

---[[ SetDeathXP  Set the XP bounty on this unit. ]]
-- @return void
-- @param iXPBounty int
function SetDeathXP( iXPBounty ) end

---[[ SetForceAttackTarget   ]]
-- @return void
-- @param hNPC handle
function SetForceAttackTarget( hNPC ) end

---[[ SetForceAttackTargetAlly   ]]
-- @return void
-- @param hNPC handle
function SetForceAttackTargetAlly( hNPC ) end

---[[ SetHasInventory  Set if this unit has an inventory. ]]
-- @return void
-- @param bHasInventory bool
function SetHasInventory( bHasInventory ) end

---[[ SetHullRadius  Set the collision hull radius of this NPC. ]]
-- @return void
-- @param flHullRadius float
function SetHullRadius( flHullRadius ) end

---[[ SetIdleAcquire   ]]
-- @return void
-- @param bIdleAcquire bool
function SetIdleAcquire( bIdleAcquire ) end

---[[ SetInitialGoalEntity  Sets the initial waypoint goal for this NPC. ]]
-- @return void
-- @param hGoal handle
function SetInitialGoalEntity( hGoal ) end

---[[ SetInitialGoalPosition  Set waypoint position for this NPC. ]]
-- @return void
-- @param vPosition Vector
function SetInitialGoalPosition( vPosition ) end

---[[ SetMana  Set the mana on this unit. ]]
-- @return void
-- @param flMana float
function SetMana( flMana ) end

---[[ SetMaxMana  Set the maximum mana of this unit. ]]
-- @return void
-- @param flMaxMana float
function SetMaxMana( flMaxMana ) end

---[[ SetMaximumGoldBounty  Set the maximum gold bounty for this unit. ]]
-- @return void
-- @param iGoldBountyMax int
function SetMaximumGoldBounty( iGoldBountyMax ) end

---[[ SetMinimumGoldBounty  Set the minimum gold bounty for this unit. ]]
-- @return void
-- @param iGoldBountyMin int
function SetMinimumGoldBounty( iGoldBountyMin ) end

---[[ SetModifierStackCount  Sets the stack count of a given modifier. ]]
-- @return void
-- @param pszScriptName string
-- @param hCaster handle
-- @param nStackCount int
function SetModifierStackCount( pszScriptName, hCaster, nStackCount ) end

---[[ SetMoveCapability   ]]
-- @return void
-- @param iMoveCapabilities int
function SetMoveCapability( iMoveCapabilities ) end

---[[ SetMustReachEachGoalEntity  Set whether this NPC is required to reach each goal entity, rather than being allowed to unkink their path. ]]
-- @return void
-- @param must bool
function SetMustReachEachGoalEntity( must ) end

---[[ SetNeverMoveToClearSpace  If set to true, we will never attempt to move this unit to clear space, even when it unphases. ]]
-- @return void
-- @param neverMoveToClearSpace bool
function SetNeverMoveToClearSpace( neverMoveToClearSpace ) end

---[[ SetNightTimeVisionRange  Returns the vision range after modifiers. ]]
-- @return void
-- @param iRange int
function SetNightTimeVisionRange( iRange ) end

---[[ SetOrigin  Set the unit's origin. ]]
-- @return void
-- @param vLocation Vector
function SetOrigin( vLocation ) end

---[[ SetOriginalModel  Sets the original model of this entity, which it will tend to fall back to anytime its state changes. ]]
-- @return void
-- @param pszModelName string
function SetOriginalModel( pszModelName ) end

---[[ SetPhysicalArmorBaseValue  Sets base physical armor value. ]]
-- @return void
-- @param flPhysicalArmorValue float
function SetPhysicalArmorBaseValue( flPhysicalArmorValue ) end

---[[ SetRangedProjectileName   ]]
-- @return void
-- @param pProjectileName string
function SetRangedProjectileName( pProjectileName ) end

---[[ SetRevealRadius  sets the client side map reveal radius for this unit ]]
-- @return void
-- @param revealRadius float
function SetRevealRadius( revealRadius ) end

---[[ SetShouldDoFlyHeightVisual   ]]
-- @return void
-- @param bShouldVisuallyFly bool
function SetShouldDoFlyHeightVisual( bShouldVisuallyFly ) end

---[[ SetStolenScepter   ]]
-- @return void
-- @param bStolenScepter bool
function SetStolenScepter( bStolenScepter ) end

---[[ SetUnitCanRespawn   ]]
-- @return void
-- @param bCanRespawn bool
function SetUnitCanRespawn( bCanRespawn ) end

---[[ SetUnitName   ]]
-- @return void
-- @param pName string
function SetUnitName( pName ) end

---[[ ShouldIdleAcquire   ]]
-- @return bool
function ShouldIdleAcquire(  ) end

---[[ SpendMana  Spend mana from this unit, this can be used for spending mana from abilities or item usage. ]]
-- @return void
-- @param flManaSpent float
-- @param hAbility handle
function SpendMana( flManaSpent, hAbility ) end

---[[ StartGesture  Add the given gesture activity. ]]
-- @return void
-- @param nActivity int
function StartGesture( nActivity ) end

---[[ StartGestureWithPlaybackRate  Add the given gesture activity with a playback rate override. ]]
-- @return void
-- @param nActivity int
-- @param flRate float
function StartGestureWithPlaybackRate( nActivity, flRate ) end

---[[ Stop  Stop the current order. ]]
-- @return void
function Stop(  ) end

---[[ StopFacing   ]]
-- @return void
function StopFacing(  ) end

---[[ SwapAbilities  Swaps the slots of the two passed abilities and sets them enabled/disabled. ]]
-- @return void
-- @param pAbilityName1 string
-- @param pAbilityName2 string
-- @param bEnable1 bool
-- @param bEnable2 bool
function SwapAbilities( pAbilityName1, pAbilityName2, bEnable1, bEnable2 ) end

---[[ SwapItems  Swap the contents of two item slots (slot1, slot2) ]]
-- @return void
-- @param nSlot1 int
-- @param nSlot2 int
function SwapItems( nSlot1, nSlot2 ) end

---[[ TakeItem  Removed the passed item from this unit's inventory. ]]
-- @return handle
-- @param hItem handle
function TakeItem( hItem ) end

---[[ TimeUntilNextAttack   ]]
-- @return float
function TimeUntilNextAttack(  ) end

---[[ TriggerModifierDodge   ]]
-- @return bool
function TriggerModifierDodge(  ) end

---[[ TriggerSpellAbsorb   ]]
-- @return bool
-- @param hAbility handle
function TriggerSpellAbsorb( hAbility ) end

---[[ TriggerSpellReflect  Trigger the Lotus Orb-like effect.(hAbility) ]]
-- @return void
-- @param hAbility handle
function TriggerSpellReflect( hAbility ) end

---[[ UnHideAbilityToSlot  Makes the first ability unhidden, and puts it where second ability currently is. Will do nothing if the first ability is already unhidden and in a valid slot. ]]
-- @return void
-- @param pszAbilityName string
-- @param pszReplacedAbilityName string
function UnHideAbilityToSlot( pszAbilityName, pszReplacedAbilityName ) end

---[[ UnitCanRespawn   ]]
-- @return bool
function UnitCanRespawn(  ) end

---[[ GetInvulnCount  Get the invulnerability count for a building. ]]
-- @return int
function GetInvulnCount(  ) end

---[[ SetInvulnCount  Set the invulnerability counter of this building. ]]
-- @return void
-- @param nInvulnCount int
function SetInvulnCount( nInvulnCount ) end

---[[ AddItemDrop  Add the specified item drop to this creature. ]]
-- @return void
-- @param hDropData handle
function AddItemDrop( hDropData ) end

---[[ CreatureLevelUp  Level the creature up by the specified number of levels ]]
-- @return void
-- @param iLevels int
function CreatureLevelUp( iLevels ) end

---[[ IsChampion  Is this unit a champion? ]]
-- @return bool
function IsChampion(  ) end

---[[ RemoveAllItemDrops  Remove all item drops from this creature. ]]
-- @return void
function RemoveAllItemDrops(  ) end

---[[ SetArmorGain  Set the armor gained per level on this creature. ]]
-- @return void
-- @param flArmorGain float
function SetArmorGain( flArmorGain ) end

---[[ SetAttackTimeGain  Set the attack time gained per level on this creature. ]]
-- @return void
-- @param flAttackTimeGain float
function SetAttackTimeGain( flAttackTimeGain ) end

---[[ SetBountyGain  Set the bounty gold gained per level on this creature. ]]
-- @return void
-- @param nBountyGain int
function SetBountyGain( nBountyGain ) end

---[[ SetChampion  Flag this unit as a champion creature. ]]
-- @return void
-- @param bIsChampion bool
function SetChampion( bIsChampion ) end

---[[ SetDamageGain  Set the damage gained per level on this creature. ]]
-- @return void
-- @param nDamageGain int
function SetDamageGain( nDamageGain ) end

---[[ SetDisableResistanceGain  Set the disable resistance gained per level on this creature. ]]
-- @return void
-- @param flDisableResistanceGain float
function SetDisableResistanceGain( flDisableResistanceGain ) end

---[[ SetHPGain  Set the hit points gained per level on this creature. ]]
-- @return void
-- @param nHPGain int
function SetHPGain( nHPGain ) end

---[[ SetHPRegenGain  Set the hit points regen gained per level on this creature. ]]
-- @return void
-- @param flHPRegenGain float
function SetHPRegenGain( flHPRegenGain ) end

---[[ SetMagicResistanceGain  Set the magic resistance gained per level on this creature. ]]
-- @return void
-- @param flMagicResistanceGain float
function SetMagicResistanceGain( flMagicResistanceGain ) end

---[[ SetManaGain  Set the mana points gained per level on this creature. ]]
-- @return void
-- @param nManaGain int
function SetManaGain( nManaGain ) end

---[[ SetManaRegenGain  Set the mana points regen gained per level on this creature. ]]
-- @return void
-- @param flManaRegenGain float
function SetManaRegenGain( flManaRegenGain ) end

---[[ SetMoveSpeedGain  Set the move speed gained per level on this creature. ]]
-- @return void
-- @param nMoveSpeedGain int
function SetMoveSpeedGain( nMoveSpeedGain ) end

---[[ SetRequiresReachingEndPath  Set whether creatures require reaching their end path before becoming idle ]]
-- @return void
-- @param bRequiresReachingEndPath bool
function SetRequiresReachingEndPath( bRequiresReachingEndPath ) end

---[[ SetXPGain  Set the XP gained per level on this creature. ]]
-- @return void
-- @param nXPGain int
function SetXPGain( nXPGain ) end

---[[ AddExperience  Params: Float XP, Bool applyBotDifficultyScaling ]]
-- @return bool
-- @param flXP float
-- @param nReason int
-- @param bApplyBotDifficultyScaling bool
-- @param bIncrementTotal bool
function AddExperience( flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal ) end

---[[ Buyback  Spend the gold and buyback with this hero. ]]
-- @return void
function Buyback(  ) end

---[[ CalculateStatBonus  Recalculate all stats after the hero gains stats. ]]
-- @return void
function CalculateStatBonus(  ) end

---[[ CanEarnGold  Returns boolean value result of buyback gold limit time less than game time. ]]
-- @return bool
function CanEarnGold(  ) end

---[[ ClearLastHitMultikill  Value is stored in PlayerResource. ]]
-- @return void
function ClearLastHitMultikill(  ) end

---[[ ClearLastHitStreak  Value is stored in PlayerResource. ]]
-- @return void
function ClearLastHitStreak(  ) end

---[[ ClearStreak  Value is stored in PlayerResource. ]]
-- @return void
function ClearStreak(  ) end

---[[ GetAbilityPoints  Gets the current unspent ability points. ]]
-- @return int
function GetAbilityPoints(  ) end

---[[ GetAdditionalOwnedUnits   ]]
-- @return table
function GetAdditionalOwnedUnits(  ) end

---[[ GetAgility   ]]
-- @return float
function GetAgility(  ) end

---[[ GetAgilityGain   ]]
-- @return float
function GetAgilityGain(  ) end

---[[ GetAssists  Value is stored in PlayerResource. ]]
-- @return int
function GetAssists(  ) end

---[[ GetAttacker   ]]
-- @return int
-- @param nIndex int
function GetAttacker( nIndex ) end

---[[ GetBaseAgility   ]]
-- @return float
function GetBaseAgility(  ) end

---[[ GetBaseDamageMax  Hero damage is also affected by attributes. ]]
-- @return int
function GetBaseDamageMax(  ) end

---[[ GetBaseDamageMin  Hero damage is also affected by attributes. ]]
-- @return int
function GetBaseDamageMin(  ) end

---[[ GetBaseIntellect   ]]
-- @return float
function GetBaseIntellect(  ) end

---[[ GetBaseManaRegen  Returns the base mana regen. ]]
-- @return float
function GetBaseManaRegen(  ) end

---[[ GetBaseStrength   ]]
-- @return float
function GetBaseStrength(  ) end

---[[ GetBonusDamageFromPrimaryStat   ]]
-- @return int
function GetBonusDamageFromPrimaryStat(  ) end

---[[ GetBuybackCooldownTime  Return float value for the amount of time left on cooldown for this hero's buyback. ]]
-- @return float
function GetBuybackCooldownTime(  ) end

---[[ GetBuybackCost  Return integer value for the gold cost of a buyback. ]]
-- @return int
-- @param bReturnOldValues bool
function GetBuybackCost( bReturnOldValues ) end

---[[ GetBuybackGoldLimitTime  Returns the amount of time gold gain is limited after buying back. ]]
-- @return float
function GetBuybackGoldLimitTime(  ) end

---[[ GetCurrentXP  Returns the amount of XP  ]]
-- @return int
function GetCurrentXP(  ) end

---[[ GetDeathGoldCost   ]]
-- @return int
function GetDeathGoldCost(  ) end

---[[ GetDeaths  Value is stored in PlayerResource. ]]
-- @return int
function GetDeaths(  ) end

---[[ GetDenies  Value is stored in PlayerResource. ]]
-- @return int
function GetDenies(  ) end

---[[ GetGold  Returns gold amount for the player owning this hero ]]
-- @return int
function GetGold(  ) end

---[[ GetGoldBounty   ]]
-- @return int
function GetGoldBounty(  ) end

---[[ GetIncreasedAttackSpeed  Hero attack speed is also affected by agility. ]]
-- @return float
function GetIncreasedAttackSpeed(  ) end

---[[ GetIntellect   ]]
-- @return float
function GetIntellect(  ) end

---[[ GetIntellectGain   ]]
-- @return float
function GetIntellectGain(  ) end

---[[ GetKills  Value is stored in PlayerResource. ]]
-- @return int
function GetKills(  ) end

---[[ GetLastHits  Value is stored in PlayerResource. ]]
-- @return int
function GetLastHits(  ) end

---[[ GetMostRecentDamageTime   ]]
-- @return float
function GetMostRecentDamageTime(  ) end

---[[ GetMultipleKillCount   ]]
-- @return int
function GetMultipleKillCount(  ) end

---[[ GetNumAttackers   ]]
-- @return int
function GetNumAttackers(  ) end

---[[ GetNumItemsInInventory   ]]
-- @return int
function GetNumItemsInInventory(  ) end

---[[ GetNumItemsInStash   ]]
-- @return int
function GetNumItemsInStash(  ) end

---[[ GetPhysicalArmorBaseValue  Hero armor is affected by attributes. ]]
-- @return float
function GetPhysicalArmorBaseValue(  ) end

---[[ GetPlayerID  Returns player ID of the player owning this hero ]]
-- @return int
function GetPlayerID(  ) end

---[[ GetPrimaryAttribute  0 = strength, 1 = agility, 2 = intelligence. ]]
-- @return int
function GetPrimaryAttribute(  ) end

---[[ GetPrimaryStatValue   ]]
-- @return float
function GetPrimaryStatValue(  ) end

---[[ GetRespawnTime   ]]
-- @return float
function GetRespawnTime(  ) end

---[[ GetRespawnsDisabled  Is this hero prevented from respawning? ]]
-- @return bool
function GetRespawnsDisabled(  ) end

---[[ GetStreak  Value is stored in PlayerResource. ]]
-- @return int
function GetStreak(  ) end

---[[ GetStrength   ]]
-- @return float
function GetStrength(  ) end

---[[ GetStrengthGain   ]]
-- @return float
function GetStrengthGain(  ) end

---[[ GetTimeUntilRespawn   ]]
-- @return float
function GetTimeUntilRespawn(  ) end

---[[ GetTogglableWearable  Get wearable entity in slot (slot) ]]
-- @return handle
-- @param nSlotType int
function GetTogglableWearable( nSlotType ) end

---[[ HasAnyAvailableInventorySpace   ]]
-- @return bool
function HasAnyAvailableInventorySpace(  ) end

---[[ HasFlyingVision   ]]
-- @return bool
function HasFlyingVision(  ) end

---[[ HasOwnerAbandoned   ]]
-- @return bool
function HasOwnerAbandoned(  ) end

---[[ HasRoomForItem  Args: const char* pItemName, bool bIncludeStashCombines, bool bAllowSelling ]]
-- @return int
-- @param pItemName string
-- @param bIncludeStashCombines bool
-- @param bAllowSelling bool
function HasRoomForItem( pItemName, bIncludeStashCombines, bAllowSelling ) end

---[[ HeroLevelUp  Levels up the hero, true or false to play effects. ]]
-- @return void
-- @param bPlayEffects bool
function HeroLevelUp( bPlayEffects ) end

---[[ IncrementAssists  Value is stored in PlayerResource. ]]
-- @return void
-- @param iKillerID int
function IncrementAssists( iKillerID ) end

---[[ IncrementDeaths  Value is stored in PlayerResource. ]]
-- @return void
-- @param iKillerID int
function IncrementDeaths( iKillerID ) end

---[[ IncrementDenies  Value is stored in PlayerResource. ]]
-- @return void
function IncrementDenies(  ) end

---[[ IncrementKills  Passed ID is for the victim, killer ID is ID of the current hero.  Value is stored in PlayerResource. ]]
-- @return void
-- @param iVictimID int
function IncrementKills( iVictimID ) end

---[[ IncrementLastHitMultikill  Value is stored in PlayerResource. ]]
-- @return void
function IncrementLastHitMultikill(  ) end

---[[ IncrementLastHitStreak  Value is stored in PlayerResource. ]]
-- @return void
function IncrementLastHitStreak(  ) end

---[[ IncrementLastHits  Value is stored in PlayerResource. ]]
-- @return void
function IncrementLastHits(  ) end

---[[ IncrementNearbyCreepDeaths  Value is stored in PlayerResource. ]]
-- @return void
function IncrementNearbyCreepDeaths(  ) end

---[[ IncrementStreak  Value is stored in PlayerResource. ]]
-- @return void
function IncrementStreak(  ) end

---[[ IsBuybackDisabledByReapersScythe   ]]
-- @return bool
function IsBuybackDisabledByReapersScythe(  ) end

---[[ IsReincarnating   ]]
-- @return bool
function IsReincarnating(  ) end

---[[ IsStashEnabled   ]]
-- @return bool
function IsStashEnabled(  ) end

---[[ KilledHero  Args: Hero, Inflictor ]]
-- @return void
-- @param hHero handle
-- @param hInflictor handle
function KilledHero( hHero, hInflictor ) end

---[[ ModifyAgility  Adds passed value to base attribute value, then calls CalculateStatBonus. ]]
-- @return void
-- @param flNewAgility float
function ModifyAgility( flNewAgility ) end

---[[ ModifyGold  Gives this hero some gold.  Args: int nGoldChange, bool bReliable, int reason ]]
-- @return int
-- @param iGoldChange int
-- @param bReliable bool
-- @param iReason int
function ModifyGold( iGoldChange, bReliable, iReason ) end

---[[ ModifyIntellect  Adds passed value to base attribute value, then calls CalculateStatBonus. ]]
-- @return void
-- @param flNewIntellect float
function ModifyIntellect( flNewIntellect ) end

---[[ ModifyStrength  Adds passed value to base attribute value, then calls CalculateStatBonus. ]]
-- @return void
-- @param flNewStrength float
function ModifyStrength( flNewStrength ) end

---[[ PerformTaunt   ]]
-- @return void
function PerformTaunt(  ) end

---[[ RecordLastHit   ]]
-- @return void
function RecordLastHit(  ) end

---[[ RespawnHero  Respawn this hero. ]]
-- @return void
-- @param bBuyBack bool
-- @param bRespawnPenalty bool
function RespawnHero( bBuyBack, bRespawnPenalty ) end

---[[ SetAbilityPoints  Sets the current unspent ability points. ]]
-- @return void
-- @param iPoints int
function SetAbilityPoints( iPoints ) end

---[[ SetBaseAgility   ]]
-- @return void
-- @param flAgility float
function SetBaseAgility( flAgility ) end

---[[ SetBaseIntellect   ]]
-- @return void
-- @param flIntellect float
function SetBaseIntellect( flIntellect ) end

---[[ SetBaseStrength   ]]
-- @return void
-- @param flStrength float
function SetBaseStrength( flStrength ) end

---[[ SetBotDifficulty   ]]
-- @return void
-- @param nDifficulty int
function SetBotDifficulty( nDifficulty ) end

---[[ SetBuyBackDisabledByReapersScythe   ]]
-- @return void
-- @param bBuybackDisabled bool
function SetBuyBackDisabledByReapersScythe( bBuybackDisabled ) end

---[[ SetBuybackCooldownTime  Sets the buyback cooldown time. ]]
-- @return void
-- @param flTime float
function SetBuybackCooldownTime( flTime ) end

---[[ SetBuybackGoldLimitTime  Set the amount of time gold gain is limited after buying back. ]]
-- @return void
-- @param flTime float
function SetBuybackGoldLimitTime( flTime ) end

---[[ SetCustomDeathXP  Sets a custom experience value for this hero.  Note, GameRules boolean must be set for this to work! ]]
-- @return void
-- @param iValue int
function SetCustomDeathXP( iValue ) end

---[[ SetGold  Sets the gold amount for the player owning this hero ]]
-- @return void
-- @param iGold int
-- @param bReliable bool
function SetGold( iGold, bReliable ) end

---[[ SetPlayerID   ]]
-- @return void
-- @param iPlayerID int
function SetPlayerID( iPlayerID ) end

---[[ SetPrimaryAttribute  Set this hero's primary attribute value. ]]
-- @return void
-- @param nPrimaryAttribute int
function SetPrimaryAttribute( nPrimaryAttribute ) end

---[[ SetRespawnPosition   ]]
-- @return void
-- @param vOrigin Vector
function SetRespawnPosition( vOrigin ) end

---[[ SetRespawnsDisabled  Prevent this hero from respawning. ]]
-- @return void
-- @param bDisableRespawns bool
function SetRespawnsDisabled( bDisableRespawns ) end

---[[ SetStashEnabled   ]]
-- @return void
-- @param bEnabled bool
function SetStashEnabled( bEnabled ) end

---[[ SetTimeUntilRespawn   ]]
-- @return void
-- @param time float
function SetTimeUntilRespawn( time ) end

---[[ ShouldDoFlyHeightVisual   ]]
-- @return bool
function ShouldDoFlyHeightVisual(  ) end

---[[ SpendGold  Args: int nGold, int nReason ]]
-- @return void
-- @param iCost int
-- @param iReason int
function SpendGold( iCost, iReason ) end

---[[ UnitCanRespawn   ]]
-- @return bool
function UnitCanRespawn(  ) end

---[[ UpgradeAbility  This upgrades the passed ability if it exists and the hero has enough ability points. ]]
-- @return void
-- @param hAbility handle
function UpgradeAbility( hAbility ) end

---[[ WillReincarnate   ]]
-- @return bool
function WillReincarnate(  ) end

---[[ GetShopType  Get the DOTA_SHOP_TYPE ]]
-- @return int
function GetShopType(  ) end

---[[ SetShopType  Set the DOTA_SHOP_TYPE. ]]
-- @return void
-- @param eShopType int
function SetShopType( eShopType ) end

---[[ GetTrapTarget  Get the trap target for this entity. ]]
-- @return Vector
function GetTrapTarget(  ) end

---[[ SetAnimation  Set the animation sequence for this entity. ]]
-- @return void
-- @param pAnimation string
function SetAnimation( pAnimation ) end

---[[ AddParticle  (index, bDestroyImmediately, bStatusEffect, priority, bHeroEffect, bOverheadEffect ]]
-- @return void
-- @param i int
-- @param bDestroyImmediately bool
-- @param bStatusEffect bool
-- @param iPriority int
-- @param bHeroEffect bool
-- @param bOverheadEffect bool
function AddParticle( i, bDestroyImmediately, bStatusEffect, iPriority, bHeroEffect, bOverheadEffect ) end

---[[ DecrementStackCount  Decrease this modifier's stack count by 1. ]]
-- @return void
function DecrementStackCount(  ) end

---[[ Destroy  Run all associated destroy functions, then remove the modifier. ]]
-- @return void
function Destroy(  ) end

---[[ ForceRefresh  Run all associated refresh functions on this modifier as if it was re-applied. ]]
-- @return void
function ForceRefresh(  ) end

---[[ GetAbility  Get the ability that generated the modifier. ]]
-- @return handle
function GetAbility(  ) end

---[[ GetAuraDuration  Returns aura stickiness (default 0.5) ]]
-- @return float
function GetAuraDuration(  ) end

---[[ GetAuraOwner   ]]
-- @return handle
function GetAuraOwner(  ) end

---[[ GetCaster  Get the owner of the ability responsible for the modifier. ]]
-- @return handle
function GetCaster(  ) end

---[[ GetClass   ]]
-- @return string
function GetClass(  ) end

---[[ GetCreationTime   ]]
-- @return float
function GetCreationTime(  ) end

---[[ GetDieTime   ]]
-- @return float
function GetDieTime(  ) end

---[[ GetDuration   ]]
-- @return float
function GetDuration(  ) end

---[[ GetElapsedTime   ]]
-- @return float
function GetElapsedTime(  ) end

---[[ GetLastAppliedTime   ]]
-- @return float
function GetLastAppliedTime(  ) end

---[[ GetName   ]]
-- @return string
function GetName(  ) end

---[[ GetParent  Get the unit the modifier is parented to. ]]
-- @return handle
function GetParent(  ) end

---[[ GetRemainingTime   ]]
-- @return float
function GetRemainingTime(  ) end

---[[ GetSerialNumber   ]]
-- @return int
function GetSerialNumber(  ) end

---[[ GetStackCount   ]]
-- @return int
function GetStackCount(  ) end

---[[ HasFunction   ]]
-- @return bool
-- @param iFunction int
function HasFunction( iFunction ) end

---[[ IncrementStackCount  Increase this modifier's stack count by 1. ]]
-- @return void
function IncrementStackCount(  ) end

---[[ IsDebuff   ]]
-- @return bool
function IsDebuff(  ) end

---[[ IsHexDebuff   ]]
-- @return bool
function IsHexDebuff(  ) end

---[[ IsStunDebuff   ]]
-- @return bool
function IsStunDebuff(  ) end

---[[ SetDuration  (flTime, bInformClients) ]]
-- @return void
-- @param flDuration float
-- @param bInformClient bool
function SetDuration( flDuration, bInformClient ) end

---[[ SetStackCount   ]]
-- @return void
-- @param iCount int
function SetStackCount( iCount ) end

---[[ StartIntervalThink  Start this modifier's think function (OnIntervalThink) with the given interval (float).  To stop, call with -1. ]]
-- @return void
-- @param flInterval float
function StartIntervalThink( flInterval ) end

---[[ DynamicHud_Create  Create a new custom UI HUD element for the specified player(s). ( int PlayerID /*-1 means everyone*/, string ElementID /* should be unique */, string LayoutFileName, table DialogVariables /* can be nil */ ) ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
-- @param string_3 string
-- @param handle_4 handle
function DynamicHud_Create( int_1, string_2, string_3, handle_4 ) end

---[[ DynamicHud_Destroy  Destroy a custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID ) ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
function DynamicHud_Destroy( int_1, string_2 ) end

---[[ DynamicHud_SetDialogVariables  Add or modify dialog variables for an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, table DialogVariables ) ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
-- @param handle_3 handle
function DynamicHud_SetDialogVariables( int_1, string_2, handle_3 ) end

---[[ DynamicHud_SetVisible  Toggle the visibility of an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, bool Visible ) ]]
-- @return void
-- @param int_1 int
-- @param string_2 string
-- @param bool_3 bool
function DynamicHud_SetVisible( int_1, string_2, bool_3 ) end

---[[ CanBeUsedOutOfInventory   ]]
-- @return bool
function CanBeUsedOutOfInventory(  ) end

---[[ GetContainer  Get the container for this item. ]]
-- @return handle
function GetContainer(  ) end

---[[ GetCost   ]]
-- @return int
function GetCost(  ) end

---[[ GetCurrentCharges  Get the number of charges this item currently has. ]]
-- @return int
function GetCurrentCharges(  ) end

---[[ GetInitialCharges  Get the initial number of charges this item has. ]]
-- @return int
function GetInitialCharges(  ) end

---[[ GetItemSlot   ]]
-- @return int
function GetItemSlot(  ) end

---[[ GetItemState  Gets whether item is unequipped or ready. ]]
-- @return int
function GetItemState(  ) end

---[[ GetParent  Get the parent for this item. ]]
-- @return handle
function GetParent(  ) end

---[[ GetPurchaseTime  Get the purchase time of this item ]]
-- @return float
function GetPurchaseTime(  ) end

---[[ GetPurchaser  Get the purchaser for this item. ]]
-- @return handle
function GetPurchaser(  ) end

---[[ GetSecondaryCharges  Get the number of secondary charges this item currently has. ]]
-- @return int
function GetSecondaryCharges(  ) end

---[[ GetShareability   ]]
-- @return int
function GetShareability(  ) end

---[[ IsAlertableItem   ]]
-- @return bool
function IsAlertableItem(  ) end

---[[ IsCastOnPickup   ]]
-- @return bool
function IsCastOnPickup(  ) end

---[[ IsCombinable   ]]
-- @return bool
function IsCombinable(  ) end

---[[ IsDisassemblable   ]]
-- @return bool
function IsDisassemblable(  ) end

---[[ IsDroppable   ]]
-- @return bool
function IsDroppable(  ) end

---[[ IsInBackpack   ]]
-- @return bool
function IsInBackpack(  ) end

---[[ IsItem   ]]
-- @return bool
function IsItem(  ) end

---[[ IsKillable   ]]
-- @return bool
function IsKillable(  ) end

---[[ IsMuted   ]]
-- @return bool
function IsMuted(  ) end

---[[ IsPermanent   ]]
-- @return bool
function IsPermanent(  ) end

---[[ IsPurchasable   ]]
-- @return bool
function IsPurchasable(  ) end

---[[ IsRecipe   ]]
-- @return bool
function IsRecipe(  ) end

---[[ IsRecipeGenerated   ]]
-- @return bool
function IsRecipeGenerated(  ) end

---[[ IsSellable   ]]
-- @return bool
function IsSellable(  ) end

---[[ IsStackable   ]]
-- @return bool
function IsStackable(  ) end

---[[ LaunchLoot   ]]
-- @return void
-- @param bAutoUse bool
-- @param flHeight float
-- @param flDuration float
-- @param vEndPoint Vector
function LaunchLoot( bAutoUse, flHeight, flDuration, vEndPoint ) end

---[[ LaunchLootInitialHeight   ]]
-- @return void
-- @param bAutoUse bool
-- @param flInitialHeight float
-- @param flLaunchHeight float
-- @param flDuration float
-- @param vEndPoint Vector
function LaunchLootInitialHeight( bAutoUse, flInitialHeight, flLaunchHeight, flDuration, vEndPoint ) end

---[[ OnEquip   ]]
-- @return void
function OnEquip(  ) end

---[[ OnUnequip   ]]
-- @return void
function OnUnequip(  ) end

---[[ RequiresCharges   ]]
-- @return bool
function RequiresCharges(  ) end

---[[ SetCanBeUsedOutOfInventory   ]]
-- @return void
-- @param bValue bool
function SetCanBeUsedOutOfInventory( bValue ) end

---[[ SetCastOnPickup   ]]
-- @return void
-- @param bCastOnPickUp bool
function SetCastOnPickup( bCastOnPickUp ) end

---[[ SetCurrentCharges  Set the number of charges on this item ]]
-- @return void
-- @param iCharges int
function SetCurrentCharges( iCharges ) end

---[[ SetDroppable   ]]
-- @return void
-- @param bDroppable bool
function SetDroppable( bDroppable ) end

---[[ SetItemState  Sets whether item is unequipped or ready. ]]
-- @return void
-- @param iState int
function SetItemState( iState ) end

---[[ SetPurchaseTime  Set the purchase time of this item ]]
-- @return void
-- @param flTime float
function SetPurchaseTime( flTime ) end

---[[ SetPurchaser  Set the purchaser of record for this item. ]]
-- @return void
-- @param hPurchaser handle
function SetPurchaser( hPurchaser ) end

---[[ SetSecondaryCharges  Set the number of secondary charges on this item ]]
-- @return void
-- @param iCharges int
function SetSecondaryCharges( iCharges ) end

---[[ SetSellable   ]]
-- @return void
-- @param bSellable bool
function SetSellable( bSellable ) end

---[[ SetShareability   ]]
-- @return void
-- @param iShareability int
function SetShareability( iShareability ) end

---[[ SetStacksWithOtherOwners   ]]
-- @return void
-- @param bStacksWithOtherOwners bool
function SetStacksWithOtherOwners( bStacksWithOtherOwners ) end

---[[ SpendCharge   ]]
-- @return void
function SpendCharge(  ) end

---[[ StacksWithOtherOwners   ]]
-- @return bool
function StacksWithOtherOwners(  ) end

---[[ Think  Think this item ]]
-- @return void
function Think(  ) end

---[[ GetItemName  Returns the item name ]]
-- @return string
function GetItemName(  ) end

---[[ ApplyDataDrivenModifier  Applies a data driven modifier to the target ]]
-- @return void
-- @param hCaster handle
-- @param hTarget handle
-- @param pszModifierName string
-- @param hModifierTable handle
function ApplyDataDrivenModifier( hCaster, hTarget, pszModifierName, hModifierTable ) end

---[[ ApplyDataDrivenThinker  Applies a data driven thinker at the location ]]
-- @return handle
-- @param hCaster handle
-- @param vLocation Vector
-- @param pszModifierName string
-- @param hModifierTable handle
function ApplyDataDrivenThinker( hCaster, vLocation, pszModifierName, hModifierTable ) end

---[[ CanUnitPickUp  Returns true if this item can be picked up by the target unit. ]]
-- @return bool
-- @param hUnit handle
function CanUnitPickUp( hUnit ) end

---[[ CastFilterResult  Determine whether an issued command with no target is valid. ]]
-- @return int
function CastFilterResult(  ) end

---[[ CastFilterResultLocation  (Vector vLocation) Determine whether an issued command on a location is valid. ]]
-- @return int
-- @param vLocation Vector
function CastFilterResultLocation( vLocation ) end

---[[ CastFilterResultTarget  (HSCRIPT hTarget) Determine whether an issued command on a target is valid. ]]
-- @return int
-- @param hTarget handle
function CastFilterResultTarget( hTarget ) end

---[[ GetAssociatedPrimaryAbilities  Returns abilities that are stolen simultaneously, or otherwise related in functionality. ]]
-- @return string
function GetAssociatedPrimaryAbilities(  ) end

---[[ GetAssociatedSecondaryAbilities  Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities. ]]
-- @return string
function GetAssociatedSecondaryAbilities(  ) end

---[[ GetBehavior  Return cast behavior type of this ability. ]]
-- @return int
function GetBehavior(  ) end

---[[ GetCastRange  Return cast range of this ability. ]]
-- @return int
-- @param vLocation Vector
-- @param hTarget handle
function GetCastRange( vLocation, hTarget ) end

---[[ GetChannelTime  Return the channel time of this ability. ]]
-- @return float
function GetChannelTime(  ) end

---[[ GetChannelledManaCostPerSecond  Return mana cost at the given level per second while channeling (-1 is current). ]]
-- @return int
-- @param iLevel int
function GetChannelledManaCostPerSecond( iLevel ) end

---[[ GetConceptRecipientType  Return who hears speech when this spell is cast. ]]
-- @return int
function GetConceptRecipientType(  ) end

---[[ GetCooldown  Return cooldown of this ability. ]]
-- @return float
-- @param iLevel int
function GetCooldown( iLevel ) end

---[[ GetCustomCastError  Return the error string of a failed command with no target. ]]
-- @return string
function GetCustomCastError(  ) end

---[[ GetCustomCastErrorLocation  (Vector vLocation) Return the error string of a failed command on a location. ]]
-- @return string
-- @param vLocation Vector
function GetCustomCastErrorLocation( vLocation ) end

---[[ GetCustomCastErrorTarget  (HSCRIPT hTarget) Return the error string of a failed command on a target. ]]
-- @return string
-- @param hTarget handle
function GetCustomCastErrorTarget( hTarget ) end

---[[ GetGoldCost  Return gold cost at the given level (-1 is current). ]]
-- @return int
-- @param iLevel int
function GetGoldCost( iLevel ) end

---[[ GetIntrinsicModifierName  Returns the name of the modifier applied passively by this ability. ]]
-- @return string
function GetIntrinsicModifierName(  ) end

---[[ GetManaCost  Return mana cost at the given level (-1 is current). ]]
-- @return int
-- @param iLevel int
function GetManaCost( iLevel ) end

---[[ GetPlaybackRateOverride  Return the animation rate of the cast animation. ]]
-- @return float
function GetPlaybackRateOverride(  ) end

---[[ IsHiddenAbilityCastable  Returns true if this ability can be used when not on the action panel. ]]
-- @return bool
function IsHiddenAbilityCastable(  ) end

---[[ IsHiddenWhenStolen  Returns true if this ability is hidden when stolen by Spell Steal. ]]
-- @return bool
function IsHiddenWhenStolen(  ) end

---[[ IsMuted  Returns whether this item is muted or not. ]]
-- @return bool
function IsMuted(  ) end

---[[ IsRefreshable  Returns true if this ability is refreshed by Refresher Orb. ]]
-- @return bool
function IsRefreshable(  ) end

---[[ IsStealable  Returns true if this ability can be stolen by Spell Steal. ]]
-- @return bool
function IsStealable(  ) end

---[[ OnAbilityPhaseInterrupted  Cast time did not complete successfully. ]]
-- @return void
function OnAbilityPhaseInterrupted(  ) end

---[[ OnAbilityPhaseStart  Cast time begins (return true for successful cast). ]]
-- @return bool
function OnAbilityPhaseStart(  ) end

---[[ OnChannelFinish  (bool bInterrupted) Channel finished. ]]
-- @return void
-- @param bInterrupted bool
function OnChannelFinish( bInterrupted ) end

---[[ OnChannelThink  (float flInterval) Channeling is taking place. ]]
-- @return void
-- @param flInterval float
function OnChannelThink( flInterval ) end

---[[ OnHeroCalculateStatBonus  Caster (hero only) gained a level, skilled an ability, or received a new stat bonus. ]]
-- @return void
function OnHeroCalculateStatBonus(  ) end

---[[ OnHeroDiedNearby  A hero has died in the vicinity (ie Urn), takes table of params. ]]
-- @return void
-- @param unit handle
-- @param attacker handle
-- @param table handle
function OnHeroDiedNearby( unit, attacker, table ) end

---[[ OnHeroLevelUp  Caster gained a level. ]]
-- @return void
function OnHeroLevelUp(  ) end

---[[ OnInventoryContentsChanged  Caster inventory changed. ]]
-- @return void
function OnInventoryContentsChanged(  ) end

---[[ OnItemEquipped  ( HSCRIPT hItem ) Caster equipped item. ]]
-- @return void
-- @param hItem handle
function OnItemEquipped( hItem ) end

---[[ OnOwnerDied  Caster died. ]]
-- @return void
function OnOwnerDied(  ) end

---[[ OnOwnerSpawned  Caster respawned or spawned for the first time. ]]
-- @return void
function OnOwnerSpawned(  ) end

---[[ OnProjectileHit  (HSCRIPT hTarget, Vector vLocation) Projectile has collided with a given target or reached its destination (target is invalid). ]]
-- @return bool
-- @param hTarget handle
-- @param vLocation Vector
function OnProjectileHit( hTarget, vLocation ) end

---[[ OnProjectileThink  (Vector vLocation) Projectile is actively moving. ]]
-- @return void
-- @param vLocation Vector
function OnProjectileThink( vLocation ) end

---[[ OnSpellStart  Cast time finished, spell effects begin. ]]
-- @return void
function OnSpellStart(  ) end

---[[ OnStolen  ( HSCRIPT hAbility ) Special behavior when stolen by Spell Steal. ]]
-- @return void
-- @param hSourceAbility handle
function OnStolen( hSourceAbility ) end

---[[ OnToggle  Ability is toggled on/off. ]]
-- @return void
function OnToggle(  ) end

---[[ OnUnStolen  Special behavior when lost by Spell Steal. ]]
-- @return void
function OnUnStolen(  ) end

---[[ OnUpgrade  Ability gained a level. ]]
-- @return void
function OnUpgrade(  ) end

---[[ ProcsMagicStick  Returns true if this ability will generate magic stick charges for nearby enemies. ]]
-- @return bool
function ProcsMagicStick(  ) end

---[[ SpeakTrigger  Return the type of speech used. ]]
-- @return int
function SpeakTrigger(  ) end

---[[ GetContainedItem  Returned the contained item. ]]
-- @return handle
function GetContainedItem(  ) end

---[[ GetCreationTime  Returns the game time when this item was created in the world ]]
-- @return float
function GetCreationTime(  ) end

---[[ SetContainedItem  Set the contained item. ]]
-- @return void
-- @param hItem handle
function SetContainedItem( hItem ) end

---[[ CDOTA_MapTree:CutDown  Cuts down this tree. Parameters: int nTeamNumberKnownTo (-1 = invalid team) ]]
-- @return void
-- @param nTeamNumberKnownTo int
function CDOTA_MapTree:CutDown( nTeamNumberKnownTo ) end

---[[ CDOTA_MapTree:CutDownRegrowAfter  Cuts down this tree. Parameters: float flRegrowAfter (-1 = never regrow), int nTeamNumberKnownTo (-1 = invalid team) ]]
-- @return void
-- @param flRegrowAfter float
-- @param nTeamNumberKnownTo int
function CDOTA_MapTree:CutDownRegrowAfter( flRegrowAfter, nTeamNumberKnownTo ) end

---[[ CDOTA_MapTree:GrowBack  Grows back the tree if it was cut down. ]]
-- @return void
function CDOTA_MapTree:GrowBack(  ) end

---[[ CDOTA_MapTree:IsStanding  Returns true if the tree is standing, false if it has been cut down ]]
-- @return bool
function CDOTA_MapTree:IsStanding(  ) end

---[[ AllowIllusionDuplicate  True/false if this modifier is active on illusions. ]]
-- @return bool
function AllowIllusionDuplicate(  ) end

---[[ CanParentBeAutoAttacked   ]]
-- @return bool
function CanParentBeAutoAttacked(  ) end

---[[ DestroyOnExpire  True/false if this buff is removed when the duration expires. ]]
-- @return bool
function DestroyOnExpire(  ) end

---[[ GetAttributes  Return the types of attributes applied to this modifier (enum value from DOTAModifierAttribute_t ]]
-- @return int
function GetAttributes(  ) end

---[[ GetAuraDuration  Returns aura stickiness ]]
-- @return float
function GetAuraDuration(  ) end

---[[ GetAuraEntityReject  Return true/false if this entity should receive the aura under specific conditions ]]
-- @return bool
-- @param hEntity handle
function GetAuraEntityReject( hEntity ) end

---[[ GetAuraRadius  Return the range around the parent this aura tries to apply its buff. ]]
-- @return int
function GetAuraRadius(  ) end

---[[ GetAuraSearchFlags  Return the unit flags this aura respects when placing buffs. ]]
-- @return int
function GetAuraSearchFlags(  ) end

---[[ GetAuraSearchTeam  Return the teams this aura applies its buff to. ]]
-- @return int
function GetAuraSearchTeam(  ) end

---[[ GetAuraSearchType  Return the unit classifications this aura applies its buff to. ]]
-- @return int
function GetAuraSearchType(  ) end

---[[ GetEffectAttachType  Return the attach type of the particle system from GetEffectName. ]]
-- @return int
function GetEffectAttachType(  ) end

---[[ GetEffectName  Return the name of the particle system that is created while this modifier is active. ]]
-- @return string
function GetEffectName(  ) end

---[[ GetHeroEffectName  Return the name of the hero effect particle system that is created while this modifier is active. ]]
-- @return string
function GetHeroEffectName(  ) end

---[[ GetModifierAura  The name of the secondary modifier that will be applied by this modifier (if it is an aura). ]]
-- @return string
function GetModifierAura(  ) end

---[[ GetPriority  Return the priority order this modifier will be applied over others. ]]
-- @return int
function GetPriority(  ) end

---[[ GetStatusEffectName  Return the name of the status effect particle system that is created while this modifier is active. ]]
-- @return string
function GetStatusEffectName(  ) end

---[[ GetTexture  Return the name of the buff icon to be shown for this modifier. ]]
-- @return string
function GetTexture(  ) end

---[[ HeroEffectPriority  Relationship of this hero effect with those from other buffs (higher is more likely to be shown). ]]
-- @return int
function HeroEffectPriority(  ) end

---[[ IsAura  True/false if this modifier is an aura. ]]
-- @return bool
function IsAura(  ) end

---[[ IsAuraActiveOnDeath  True/false if this aura provides buffs when the parent is dead. ]]
-- @return bool
function IsAuraActiveOnDeath(  ) end

---[[ IsDebuff  True/false if this modifier should be displayed as a debuff. ]]
-- @return bool
function IsDebuff(  ) end

---[[ IsHidden  True/false if this modifier should be displayed on the buff bar. ]]
-- @return bool
function IsHidden(  ) end

---[[ IsPermanent   ]]
-- @return bool
function IsPermanent(  ) end

---[[ IsPurgable  True/false if this modifier can be purged. ]]
-- @return bool
function IsPurgable(  ) end

---[[ IsPurgeException  True/false if this modifier can be purged by strong dispels. ]]
-- @return bool
function IsPurgeException(  ) end

---[[ IsStunDebuff  True/false if this modifier is considered a stun for purge reasons. ]]
-- @return bool
function IsStunDebuff(  ) end

---[[ OnCreated  Runs when the modifier is created. ]]
-- @return void
-- @param table handle
function OnCreated( table ) end

---[[ OnDestroy  Runs when the modifier is destroyed (after unit loses modifier). ]]
-- @return void
function OnDestroy(  ) end

---[[ OnIntervalThink  Runs when the think interval occurs. ]]
-- @return void
function OnIntervalThink(  ) end

---[[ OnRefresh  Runs when the modifier is refreshed. ]]
-- @return void
-- @param table handle
function OnRefresh( table ) end

---[[ OnRemoved  Runs when the modifier is destroyed (before unit loses modifier). ]]
-- @return void
function OnRemoved(  ) end

---[[ OnStackCountChanged  Runs when stack count changes (param is old count). ]]
-- @return void
-- @param iStackCount int
function OnStackCountChanged( iStackCount ) end

---[[ RemoveOnDeath  True/false if this modifier is removed when the parent dies. ]]
-- @return bool
function RemoveOnDeath(  ) end

---[[ ShouldUseOverheadOffset  Apply the overhead offset to the attached effect. ]]
-- @return bool
function ShouldUseOverheadOffset(  ) end

---[[ StatusEffectPriority  Relationship of this status effect with those from other buffs (higher is more likely to be shown). ]]
-- @return int
function StatusEffectPriority(  ) end

---[[ ApplyHorizontalMotionController  Starts the horizontal motion controller effects for this buff.  Returns true if successful. ]]
-- @return bool
function ApplyHorizontalMotionController(  ) end

---[[ GetPriority  Get the priority ]]
-- @return int
function GetPriority(  ) end

---[[ OnHorizontalMotionInterrupted  Called when the motion gets interrupted. ]]
-- @return void
function OnHorizontalMotionInterrupted(  ) end

---[[ SetPriority  Set the priority ]]
-- @return void
-- @param nMotionPriority int
function SetPriority( nMotionPriority ) end

---[[ UpdateHorizontalMotion  Perform any motion from the given interval on the NPC. ]]
-- @return void
-- @param me handle
-- @param dt float
function UpdateHorizontalMotion( me, dt ) end

---[[ ApplyHorizontalMotionController  Starts the horizontal motion controller effects for this buff.  Returns true if successful. ]]
-- @return bool
function ApplyHorizontalMotionController(  ) end

---[[ ApplyVerticalMotionController  Starts the vertical motion controller effects for this buff.  Returns true if successful. ]]
-- @return bool
function ApplyVerticalMotionController(  ) end

---[[ GetPriority  Get the priority ]]
-- @return int
function GetPriority(  ) end

---[[ OnHorizontalMotionInterrupted  Called when the motion gets interrupted. ]]
-- @return void
function OnHorizontalMotionInterrupted(  ) end

---[[ OnVerticalMotionInterrupted  Called when the motion gets interrupted. ]]
-- @return void
function OnVerticalMotionInterrupted(  ) end

---[[ SetPriority  Set the priority ]]
-- @return void
-- @param nMotionPriority int
function SetPriority( nMotionPriority ) end

---[[ UpdateHorizontalMotion  Perform any motion from the given interval on the NPC. ]]
-- @return void
-- @param me handle
-- @param dt float
function UpdateHorizontalMotion( me, dt ) end

---[[ UpdateVerticalMotion  Perform any motion from the given interval on the NPC. ]]
-- @return void
-- @param me handle
-- @param dt float
function UpdateVerticalMotion( me, dt ) end

---[[ ApplyVerticalMotionController  Starts the vertical motion controller effects for this buff.  Returns true if successful. ]]
-- @return bool
function ApplyVerticalMotionController(  ) end

---[[ GetMotionPriority  Get the priority ]]
-- @return int
function GetMotionPriority(  ) end

---[[ OnVerticalMotionInterrupted  Called when the motion gets interrupted. ]]
-- @return void
function OnVerticalMotionInterrupted(  ) end

---[[ SetMotionPriority  Set the priority ]]
-- @return void
-- @param nMotionPriority int
function SetMotionPriority( nMotionPriority ) end

---[[ UpdateVerticalMotion  Perform any motion from the given interval on the NPC. ]]
-- @return void
-- @param me handle
-- @param dt float
function UpdateVerticalMotion( me, dt ) end

---[[ AddAegisPickup   ]]
-- @return void
-- @param iPlayerID int
function AddAegisPickup( iPlayerID ) end

---[[ AddClaimedFarm   ]]
-- @return void
-- @param iPlayerID int
-- @param flFarmValue float
-- @param bEarnedValue bool
function AddClaimedFarm( iPlayerID, flFarmValue, bEarnedValue ) end

---[[ AddGoldSpentOnSupport   ]]
-- @return void
-- @param iPlayerID int
-- @param iCost int
function AddGoldSpentOnSupport( iPlayerID, iCost ) end

---[[ AddRunePickup   ]]
-- @return void
-- @param iPlayerID int
function AddRunePickup( iPlayerID ) end

---[[ AreUnitsSharedWithPlayerID   ]]
-- @return bool
-- @param nUnitOwnerPlayerID int
-- @param nOtherPlayerID int
function AreUnitsSharedWithPlayerID( nUnitOwnerPlayerID, nOtherPlayerID ) end

---[[ CanRepick   ]]
-- @return bool
-- @param iPlayerID int
function CanRepick( iPlayerID ) end

---[[ ClearKillsMatrix   ]]
-- @return void
-- @param iPlayerID int
function ClearKillsMatrix( iPlayerID ) end

---[[ ClearLastHitMultikill   ]]
-- @return void
-- @param iPlayerID int
function ClearLastHitMultikill( iPlayerID ) end

---[[ ClearLastHitStreak   ]]
-- @return void
-- @param iPlayerID int
function ClearLastHitStreak( iPlayerID ) end

---[[ ClearRawPlayerDamageMatrix   ]]
-- @return void
-- @param iPlayerID int
function ClearRawPlayerDamageMatrix( iPlayerID ) end

---[[ ClearStreak   ]]
-- @return void
-- @param iPlayerID int
function ClearStreak( iPlayerID ) end

---[[ GetAegisPickups   ]]
-- @return int
-- @param iPlayerID int
function GetAegisPickups( iPlayerID ) end

---[[ GetAssists   ]]
-- @return int
-- @param iPlayerID int
function GetAssists( iPlayerID ) end

---[[ GetBroadcasterChannel   ]]
-- @return unsigned
-- @param iPlayerID int
function GetBroadcasterChannel( iPlayerID ) end

---[[ GetBroadcasterChannelSlot   ]]
-- @return unsigned
-- @param iPlayerID int
function GetBroadcasterChannelSlot( iPlayerID ) end

---[[ GetClaimedDenies   ]]
-- @return int
-- @param iPlayerID int
function GetClaimedDenies( iPlayerID ) end

---[[ GetClaimedFarm   ]]
-- @return float
-- @param iPlayerID int
-- @param bOnlyEarned bool
function GetClaimedFarm( iPlayerID, bOnlyEarned ) end

---[[ GetClaimedMisses   ]]
-- @return int
-- @param iPlayerID int
function GetClaimedMisses( iPlayerID ) end

---[[ GetConnectionState   ]]
-- @return <unknown>
-- @param iPlayerID int
function GetConnectionState( iPlayerID ) end

---[[ GetCreepDamageTaken   ]]
-- @return int
-- @param iPlayerID int
-- @param bTotal bool
function GetCreepDamageTaken( iPlayerID, bTotal ) end

---[[ GetCustomBuybackCooldown   ]]
-- @return float
-- @param iPlayerID int
function GetCustomBuybackCooldown( iPlayerID ) end

---[[ GetCustomBuybackCost   ]]
-- @return int
-- @param iPlayerID int
function GetCustomBuybackCost( iPlayerID ) end

---[[ GetCustomTeamAssignment  Get the current custom team assignment for this player. ]]
-- @return int
-- @param iPlayerID int
function GetCustomTeamAssignment( iPlayerID ) end

---[[ GetDamageDoneToHero   ]]
-- @return int
-- @param iPlayerID int
-- @param iVictimID int
function GetDamageDoneToHero( iPlayerID, iVictimID ) end

---[[ GetDeaths   ]]
-- @return int
-- @param iPlayerID int
function GetDeaths( iPlayerID ) end

---[[ GetDenies   ]]
-- @return int
-- @param iPlayerID int
function GetDenies( iPlayerID ) end

---[[ GetEventPointsForPlayerID   ]]
-- @return unsigned
-- @param nPlayerID int
function GetEventPointsForPlayerID( nPlayerID ) end

---[[ GetEventPremiumPoints   ]]
-- @return unsigned
-- @param nPlayerID int
function GetEventPremiumPoints( nPlayerID ) end

---[[ GetEventRanks   ]]
-- @return <unknown>
-- @param nPlayerID int
function GetEventRanks( nPlayerID ) end

---[[ GetGold   ]]
-- @return int
-- @param iPlayerID int
function GetGold( iPlayerID ) end

---[[ GetGoldLostToDeath   ]]
-- @return int
-- @param iPlayerID int
function GetGoldLostToDeath( iPlayerID ) end

---[[ GetGoldPerMin   ]]
-- @return float
-- @param iPlayerID int
function GetGoldPerMin( iPlayerID ) end

---[[ GetGoldSpentOnBuybacks   ]]
-- @return int
-- @param iPlayerID int
function GetGoldSpentOnBuybacks( iPlayerID ) end

---[[ GetGoldSpentOnConsumables   ]]
-- @return int
-- @param iPlayerID int
function GetGoldSpentOnConsumables( iPlayerID ) end

---[[ GetGoldSpentOnItems   ]]
-- @return int
-- @param iPlayerID int
function GetGoldSpentOnItems( iPlayerID ) end

---[[ GetGoldSpentOnSupport   ]]
-- @return int
-- @param iPlayerID int
function GetGoldSpentOnSupport( iPlayerID ) end

---[[ GetHealing   ]]
-- @return float
-- @param iPlayerID int
function GetHealing( iPlayerID ) end

---[[ GetHeroDamageTaken   ]]
-- @return int
-- @param iPlayerID int
-- @param bTotal bool
function GetHeroDamageTaken( iPlayerID, bTotal ) end

---[[ GetKills   ]]
-- @return int
-- @param iPlayerID int
function GetKills( iPlayerID ) end

---[[ GetKillsDoneToHero   ]]
-- @return int
-- @param iPlayerID int
-- @param iVictimID int
function GetKillsDoneToHero( iPlayerID, iVictimID ) end

---[[ GetLastHitMultikill   ]]
-- @return int
-- @param iPlayerID int
function GetLastHitMultikill( iPlayerID ) end

---[[ GetLastHitStreak   ]]
-- @return int
-- @param iPlayerID int
function GetLastHitStreak( iPlayerID ) end

---[[ GetLastHits   ]]
-- @return int
-- @param iPlayerID int
function GetLastHits( iPlayerID ) end

---[[ GetLevel   ]]
-- @return int
-- @param iPlayerID int
function GetLevel( iPlayerID ) end

---[[ GetMisses   ]]
-- @return int
-- @param iPlayerID int
function GetMisses( iPlayerID ) end

---[[ GetNearbyCreepDeaths   ]]
-- @return int
-- @param iPlayerID int
function GetNearbyCreepDeaths( iPlayerID ) end

---[[ GetNetWorth   ]]
-- @return int
-- @param iPlayerID int
function GetNetWorth( iPlayerID ) end

---[[ GetNthCourierForTeam   ]]
-- @return handle
-- @param nCourierIndex int
-- @param nTeamNumber int
function GetNthCourierForTeam( nCourierIndex, nTeamNumber ) end

---[[ GetNthPlayerIDOnTeam   ]]
-- @return int
-- @param iTeamNumber int
-- @param iNthPlayer int
function GetNthPlayerIDOnTeam( iTeamNumber, iNthPlayer ) end

---[[ GetNumConsumablesPurchased   ]]
-- @return int
-- @param iPlayerID int
function GetNumConsumablesPurchased( iPlayerID ) end

---[[ GetNumCouriersForTeam   ]]
-- @return int
-- @param nTeamNumber int
function GetNumCouriersForTeam( nTeamNumber ) end

---[[ GetNumItemsPurchased   ]]
-- @return int
-- @param iPlayerID int
function GetNumItemsPurchased( iPlayerID ) end

---[[ GetPartyID   ]]
-- @return uint64
-- @param iPlayerID int
function GetPartyID( iPlayerID ) end

---[[ GetPlayer   ]]
-- @return handle
-- @param iPlayerID int
function GetPlayer( iPlayerID ) end

---[[ GetPlayerCount  Includes spectators and players not assigned to a team ]]
-- @return int
function GetPlayerCount(  ) end

---[[ GetPlayerCountForTeam   ]]
-- @return int
-- @param iTeam int
function GetPlayerCountForTeam( iTeam ) end

---[[ GetPlayerLoadedCompletely   ]]
-- @return bool
-- @param iPlayerID int
function GetPlayerLoadedCompletely( iPlayerID ) end

---[[ GetPlayerName   ]]
-- @return string
-- @param iPlayerID int
function GetPlayerName( iPlayerID ) end

---[[ GetRawPlayerDamage   ]]
-- @return int
-- @param iPlayerID int
function GetRawPlayerDamage( iPlayerID ) end

---[[ GetReliableGold   ]]
-- @return int
-- @param iPlayerID int
function GetReliableGold( iPlayerID ) end

---[[ GetRespawnSeconds   ]]
-- @return int
-- @param iPlayerID int
function GetRespawnSeconds( iPlayerID ) end

---[[ GetRoshanKills   ]]
-- @return int
-- @param iPlayerID int
function GetRoshanKills( iPlayerID ) end

---[[ GetRunePickups   ]]
-- @return int
-- @param iPlayerID int
function GetRunePickups( iPlayerID ) end

---[[ GetSelectedHeroEntity   ]]
-- @return handle
-- @param iPlayerID int
function GetSelectedHeroEntity( iPlayerID ) end

---[[ GetSelectedHeroID   ]]
-- @return int
-- @param iPlayerID int
function GetSelectedHeroID( iPlayerID ) end

---[[ GetSelectedHeroName   ]]
-- @return string
-- @param iPlayerID int
function GetSelectedHeroName( iPlayerID ) end

---[[ GetSteamAccountID   ]]
-- @return unsigned
-- @param iPlayerID int
function GetSteamAccountID( iPlayerID ) end

---[[ GetSteamID  Get the 64 bit steam ID for a given player. ]]
-- @return uint64
-- @param iPlayerID int
function GetSteamID( iPlayerID ) end

---[[ GetStreak   ]]
-- @return int
-- @param iPlayerID int
function GetStreak( iPlayerID ) end

---[[ GetStuns   ]]
-- @return float
-- @param iPlayerID int
function GetStuns( iPlayerID ) end

---[[ GetTeam   ]]
-- @return int
-- @param iPlayerID int
function GetTeam( iPlayerID ) end

---[[ GetTeamKills   ]]
-- @return int
-- @param iTeam int
function GetTeamKills( iTeam ) end

---[[ GetTeamPlayerCount  Players on a valid team (radiant, dire, or custom*) who haven't abandoned the game ]]
-- @return int
function GetTeamPlayerCount(  ) end

---[[ GetTimeOfLastConsumablePurchase   ]]
-- @return float
-- @param iPlayerID int
function GetTimeOfLastConsumablePurchase( iPlayerID ) end

---[[ GetTimeOfLastDeath   ]]
-- @return float
-- @param iPlayerID int
function GetTimeOfLastDeath( iPlayerID ) end

---[[ GetTimeOfLastItemPurchase   ]]
-- @return float
-- @param iPlayerID int
function GetTimeOfLastItemPurchase( iPlayerID ) end

---[[ GetTotalEarnedGold   ]]
-- @return int
-- @param iPlayerID int
function GetTotalEarnedGold( iPlayerID ) end

---[[ GetTotalEarnedXP   ]]
-- @return int
-- @param iPlayerID int
function GetTotalEarnedXP( iPlayerID ) end

---[[ GetTotalGoldSpent   ]]
-- @return int
-- @param iPlayerID int
function GetTotalGoldSpent( iPlayerID ) end

---[[ GetTowerDamageTaken   ]]
-- @return int
-- @param iPlayerID int
-- @param bTotal bool
function GetTowerDamageTaken( iPlayerID, bTotal ) end

---[[ GetTowerKills   ]]
-- @return int
-- @param iPlayerID int
function GetTowerKills( iPlayerID ) end

---[[ GetUnitShareMaskForPlayer   ]]
-- @return int
-- @param nPlayerID int
-- @param nOtherPlayerID int
function GetUnitShareMaskForPlayer( nPlayerID, nOtherPlayerID ) end

---[[ GetUnreliableGold   ]]
-- @return int
-- @param iPlayerID int
function GetUnreliableGold( iPlayerID ) end

---[[ GetXPPerMin   ]]
-- @return float
-- @param iPlayerID int
function GetXPPerMin( iPlayerID ) end

---[[ HasCustomGameTicketForPlayerID  Does this player have a custom game ticket for this game? ]]
-- @return bool
-- @param iPlayerID int
function HasCustomGameTicketForPlayerID( iPlayerID ) end

---[[ HasRandomed   ]]
-- @return bool
-- @param iPlayerID int
function HasRandomed( iPlayerID ) end

---[[ HasSelectedHero   ]]
-- @return bool
-- @param iPlayerID int
function HasSelectedHero( iPlayerID ) end

---[[ HaveAllPlayersJoined   ]]
-- @return bool
function HaveAllPlayersJoined(  ) end

---[[ IncrementAssists   ]]
-- @return void
-- @param iPlayerID int
-- @param iVictimID int
function IncrementAssists( iPlayerID, iVictimID ) end

---[[ IncrementClaimedDenies   ]]
-- @return void
-- @param iPlayerID int
function IncrementClaimedDenies( iPlayerID ) end

---[[ IncrementClaimedMisses   ]]
-- @return void
-- @param iPlayerID int
function IncrementClaimedMisses( iPlayerID ) end

---[[ IncrementDeaths   ]]
-- @return void
-- @param iPlayerID int
-- @param iKillerID int
function IncrementDeaths( iPlayerID, iKillerID ) end

---[[ IncrementDenies   ]]
-- @return void
-- @param iPlayerID int
function IncrementDenies( iPlayerID ) end

---[[ IncrementKills   ]]
-- @return void
-- @param iPlayerID int
-- @param iVictimID int
function IncrementKills( iPlayerID, iVictimID ) end

---[[ IncrementLastHitMultikill   ]]
-- @return void
-- @param iPlayerID int
function IncrementLastHitMultikill( iPlayerID ) end

---[[ IncrementLastHitStreak   ]]
-- @return void
-- @param iPlayerID int
function IncrementLastHitStreak( iPlayerID ) end

---[[ IncrementLastHits   ]]
-- @return void
-- @param iPlayerID int
function IncrementLastHits( iPlayerID ) end

---[[ IncrementMisses   ]]
-- @return void
-- @param iPlayerID int
function IncrementMisses( iPlayerID ) end

---[[ IncrementNearbyCreepDeaths   ]]
-- @return void
-- @param iPlayerID int
function IncrementNearbyCreepDeaths( iPlayerID ) end

---[[ IncrementStreak   ]]
-- @return void
-- @param iPlayerID int
function IncrementStreak( iPlayerID ) end

---[[ IncrementTotalEarnedXP   ]]
-- @return void
-- @param iPlayerID int
-- @param iXP int
-- @param nReason int
function IncrementTotalEarnedXP( iPlayerID, iXP, nReason ) end

---[[ IsBroadcaster   ]]
-- @return bool
-- @param iPlayerID int
function IsBroadcaster( iPlayerID ) end

---[[ IsDisableHelpSetForPlayerID   ]]
-- @return bool
-- @param nPlayerID int
-- @param nOtherPlayerID int
function IsDisableHelpSetForPlayerID( nPlayerID, nOtherPlayerID ) end

---[[ IsFakeClient   ]]
-- @return bool
-- @param iPlayerID int
function IsFakeClient( iPlayerID ) end

---[[ IsHeroSelected   ]]
-- @return bool
-- @param pHeroname string
function IsHeroSelected( pHeroname ) end

---[[ IsHeroSharedWithPlayerID   ]]
-- @return bool
-- @param nUnitOwnerPlayerID int
-- @param nOtherPlayerID int
function IsHeroSharedWithPlayerID( nUnitOwnerPlayerID, nOtherPlayerID ) end

---[[ IsValidPlayer   ]]
-- @return bool
-- @param iPlayerID int
function IsValidPlayer( iPlayerID ) end

---[[ IsValidPlayerID   ]]
-- @return bool
-- @param iPlayerID int
function IsValidPlayerID( iPlayerID ) end

---[[ IsValidTeamPlayer   ]]
-- @return bool
-- @param iPlayerID int
function IsValidTeamPlayer( iPlayerID ) end

---[[ IsValidTeamPlayerID   ]]
-- @return bool
-- @param iPlayerID int
function IsValidTeamPlayerID( iPlayerID ) end

---[[ ModifyGold   ]]
-- @return int
-- @param iPlayerID int
-- @param iGoldChange int
-- @param bReliable bool
-- @param nReason int
function ModifyGold( iPlayerID, iGoldChange, bReliable, nReason ) end

---[[ NumPlayers   ]]
-- @return int
function NumPlayers(  ) end

---[[ NumTeamPlayers   ]]
-- @return int
function NumTeamPlayers(  ) end

---[[ RecordConsumableAbilityChargeChange  Increment or decrement consumable charges (nPlayerID, item_definition_index, nChargeIncrementOrDecrement) ]]
-- @return void
-- @param iPlayerID int
-- @param item_definition_index int
-- @param nChargeIncrementOrDecrement int
function RecordConsumableAbilityChargeChange( iPlayerID, item_definition_index, nChargeIncrementOrDecrement ) end

---[[ ReplaceHeroWith  (playerID, heroClassName, gold, XP) - replaces the player's hero with a new one of the specified class, gold and XP ]]
-- @return handle
-- @param iPlayerID int
-- @param pszHeroClass string
-- @param nGold int
-- @param nXP int
function ReplaceHeroWith( iPlayerID, pszHeroClass, nGold, nXP ) end

---[[ ResetBuybackCostTime   ]]
-- @return void
-- @param nPlayerID int
function ResetBuybackCostTime( nPlayerID ) end

---[[ ResetTotalEarnedGold   ]]
-- @return void
-- @param iPlayerID int
function ResetTotalEarnedGold( iPlayerID ) end

---[[ SetBuybackCooldownTime   ]]
-- @return void
-- @param nPlayerID int
-- @param flBuybackCooldown float
function SetBuybackCooldownTime( nPlayerID, flBuybackCooldown ) end

---[[ SetBuybackGoldLimitTime   ]]
-- @return void
-- @param nPlayerID int
-- @param flBuybackCooldown float
function SetBuybackGoldLimitTime( nPlayerID, flBuybackCooldown ) end

---[[ SetCameraTarget  (playerID, entity) - force the given player's camera to follow the given entity ]]
-- @return void
-- @param nPlayerID int
-- @param hTarget handle
function SetCameraTarget( nPlayerID, hTarget ) end

---[[ SetCanRepick   ]]
-- @return void
-- @param iPlayerID int
-- @param bCanRepick bool
function SetCanRepick( iPlayerID, bCanRepick ) end

---[[ SetCustomBuybackCooldown  Set the buyback cooldown for this player. ]]
-- @return void
-- @param iPlayerID int
-- @param flCooldownTime float
function SetCustomBuybackCooldown( iPlayerID, flCooldownTime ) end

---[[ SetCustomBuybackCost  Set the buyback cost for this player. ]]
-- @return void
-- @param iPlayerID int
-- @param iGoldCost int
function SetCustomBuybackCost( iPlayerID, iGoldCost ) end

---[[ SetCustomPlayerColor  Set custom color for player (minimap, scoreboard, etc) ]]
-- @return void
-- @param iPlayerID int
-- @param r int
-- @param g int
-- @param b int
function SetCustomPlayerColor( iPlayerID, r, g, b ) end

---[[ SetCustomTeamAssignment  Set custom team assignment for this player. ]]
-- @return void
-- @param iPlayerID int
-- @param iTeamAssignment int
function SetCustomTeamAssignment( iPlayerID, iTeamAssignment ) end

---[[ SetGold   ]]
-- @return void
-- @param iPlayerID int
-- @param iGold int
-- @param bReliable bool
function SetGold( iPlayerID, iGold, bReliable ) end

---[[ SetHasRandomed   ]]
-- @return void
-- @param iPlayerID int
function SetHasRandomed( iPlayerID ) end

---[[ SetLastBuybackTime   ]]
-- @return void
-- @param iPlayerID int
-- @param iLastBuybackTime int
function SetLastBuybackTime( iPlayerID, iLastBuybackTime ) end

---[[ SetOverrideSelectionEntity  Set the forced selection entity for a player. ]]
-- @return void
-- @param nPlayerID int
-- @param hEntity handle
function SetOverrideSelectionEntity( nPlayerID, hEntity ) end

---[[ SetUnitShareMaskForPlayer   ]]
-- @return void
-- @param nPlayerID int
-- @param nOtherPlayerID int
-- @param nFlag int
-- @param bState bool
function SetUnitShareMaskForPlayer( nPlayerID, nOtherPlayerID, nFlag, bState ) end

---[[ SpendGold   ]]
-- @return void
-- @param iPlayerID int
-- @param iCost int
-- @param iReason int
function SpendGold( iPlayerID, iCost, iReason ) end

---[[ UpdateTeamSlot   ]]
-- @return void
-- @param iPlayerID int
-- @param iTeamNumber int
-- @param desiredSlot int
function UpdateTeamSlot( iPlayerID, iTeamNumber, desiredSlot ) end

---[[ WhoSelectedHero   ]]
-- @return int
-- @param pHeroFilename string
function WhoSelectedHero( pHeroFilename ) end

---[[ CDOTA_ShopTrigger:GetShopType  Get the DOTA_SHOP_TYPE ]]
-- @return int
function CDOTA_ShopTrigger:GetShopType(  ) end

---[[ CDOTA_ShopTrigger:SetShopType  Set the DOTA_SHOP_TYPE. ]]
-- @return void
-- @param eShopType int
function CDOTA_ShopTrigger:SetShopType( eShopType ) end

---[[ CDOTA_SimpleObstruction:IsEnabled  Returns whether the obstruction is currently active ]]
-- @return bool
function CDOTA_SimpleObstruction:IsEnabled(  ) end

---[[ CDOTA_SimpleObstruction:SetEnabled  Enable or disable the obstruction ]]
-- @return void
-- @param bEnabled bool
-- @param bForce bool
function CDOTA_SimpleObstruction:SetEnabled( bEnabled, bForce ) end

---[[ CDOTA_Unit_Nian:GetHorn  Is the Nian horn? ]]
-- @return handle
function CDOTA_Unit_Nian:GetHorn(  ) end

---[[ CDOTA_Unit_Nian:GetTail  Is the Nian's tail broken? ]]
-- @return handle
function CDOTA_Unit_Nian:GetTail(  ) end

---[[ CDOTA_Unit_Nian:IsHornAlive  Is the Nian's horn broken? ]]
-- @return bool
function CDOTA_Unit_Nian:IsHornAlive(  ) end

---[[ CDOTA_Unit_Nian:IsTailAlive  Is the Nian's tail broken? ]]
-- @return bool
function CDOTA_Unit_Nian:IsTailAlive(  ) end

---[[ CDebugOverlayScriptHelper:Axis  Draws an axis. Specify origin + orientation in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Quaternion_2 Quaternion
-- @param float_3 float
-- @param bool_4 bool
-- @param float_5 float
function CDebugOverlayScriptHelper:Axis( Vector_1, Quaternion_2, float_3, bool_4, float_5 ) end

---[[ CDebugOverlayScriptHelper:Box  Draws a world-space axis-aligned box. Specify bounds in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param bool_7 bool
-- @param float_8 float
function CDebugOverlayScriptHelper:Box( Vector_1, Vector_2, int_3, int_4, int_5, int_6, bool_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:BoxAngles  Draws an oriented box at the origin. Specify bounds in local space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param Quaternion_4 Quaternion
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
-- @param float_10 float
function CDebugOverlayScriptHelper:BoxAngles( Vector_1, Vector_2, Vector_3, Quaternion_4, int_5, int_6, int_7, int_8, bool_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:Capsule  Draws a capsule. Specify base in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Quaternion_2 Quaternion
-- @param float_3 float
-- @param float_4 float
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
-- @param float_10 float
function CDebugOverlayScriptHelper:Capsule( Vector_1, Quaternion_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:Circle  Draws a circle. Specify center in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Quaternion_2 Quaternion
-- @param float_3 float
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param bool_8 bool
-- @param float_9 float
function CDebugOverlayScriptHelper:Circle( Vector_1, Quaternion_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:CircleScreenOriented  Draws a circle oriented to the screen. Specify center in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param bool_7 bool
-- @param float_8 float
function CDebugOverlayScriptHelper:CircleScreenOriented( Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:Cone  Draws a wireframe cone. Specify endpoint and direction in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param float_4 float
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
-- @param float_10 float
function CDebugOverlayScriptHelper:Cone( Vector_1, Vector_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:Cross  Draws a screen-aligned cross. Specify origin in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param bool_7 bool
-- @param float_8 float
function CDebugOverlayScriptHelper:Cross( Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:Cross3D  Draws a world-aligned cross. Specify origin in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param bool_7 bool
-- @param float_8 float
function CDebugOverlayScriptHelper:Cross3D( Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:Cross3DOriented  Draws an oriented cross. Specify origin in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Quaternion_2 Quaternion
-- @param float_3 float
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param bool_8 bool
-- @param float_9 float
function CDebugOverlayScriptHelper:Cross3DOriented( Vector_1, Quaternion_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:DrawTickMarkedLine  Draws a dashed line. Specify endpoints in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
-- @param float_10 float
function CDebugOverlayScriptHelper:DrawTickMarkedLine( Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, int_8, bool_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:EntityAttachments  Draws the attachments of the entity ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param float_2 float
-- @param float_3 float
function CDebugOverlayScriptHelper:EntityAttachments( ehandle_1, float_2, float_3 ) end

---[[ CDebugOverlayScriptHelper:EntityAxis  Draws the axis of the entity origin ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param float_2 float
-- @param bool_3 bool
-- @param float_4 float
function CDebugOverlayScriptHelper:EntityAxis( ehandle_1, float_2, bool_3, float_4 ) end

---[[ CDebugOverlayScriptHelper:EntityBounds  Draws bounds of an entity ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param int_2 int
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param bool_6 bool
-- @param float_7 float
function CDebugOverlayScriptHelper:EntityBounds( ehandle_1, int_2, int_3, int_4, int_5, bool_6, float_7 ) end

---[[ CDebugOverlayScriptHelper:EntitySkeleton  Draws the skeleton of the entity ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param float_2 float
function CDebugOverlayScriptHelper:EntitySkeleton( ehandle_1, float_2 ) end

---[[ CDebugOverlayScriptHelper:EntityText  Draws text on an entity ]]
-- @return void
-- @param ehandle_1 ehandle
-- @param int_2 int
-- @param string_3 string
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param float_8 float
function CDebugOverlayScriptHelper:EntityText( ehandle_1, int_2, string_3, int_4, int_5, int_6, int_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:FilledRect2D  Draws a screen-space filled 2D rectangle. Coordinates are in pixels. ]]
-- @return void
-- @param Vector2D_1 Vector2D
-- @param Vector2D_2 Vector2D
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param float_7 float
function CDebugOverlayScriptHelper:FilledRect2D( Vector2D_1, Vector2D_2, int_3, int_4, int_5, int_6, float_7 ) end

---[[ CDebugOverlayScriptHelper:HorzArrow  Draws a horizontal arrow. Specify endpoints in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param bool_8 bool
-- @param float_9 float
function CDebugOverlayScriptHelper:HorzArrow( Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:Line  Draws a line between two points ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param bool_7 bool
-- @param float_8 float
function CDebugOverlayScriptHelper:Line( Vector_1, Vector_2, int_3, int_4, int_5, int_6, bool_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:Line2D  Draws a line between two points in screenspace ]]
-- @return void
-- @param Vector2D_1 Vector2D
-- @param Vector2D_2 Vector2D
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param float_7 float
function CDebugOverlayScriptHelper:Line2D( Vector2D_1, Vector2D_2, int_3, int_4, int_5, int_6, float_7 ) end

---[[ CDebugOverlayScriptHelper:PopDebugOverlayScope  Pops the identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch. ]]
-- @return void
function CDebugOverlayScriptHelper:PopDebugOverlayScope(  ) end

---[[ CDebugOverlayScriptHelper:PushAndClearDebugOverlayScope  Pushes an identifier used to group overlays. Deletes all existing overlays using this overlay id. ]]
-- @return void
-- @param utlstringtoken_1 utlstringtoken
function CDebugOverlayScriptHelper:PushAndClearDebugOverlayScope( utlstringtoken_1 ) end

---[[ CDebugOverlayScriptHelper:PushDebugOverlayScope  Pushes an identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch. ]]
-- @return void
-- @param utlstringtoken_1 utlstringtoken
function CDebugOverlayScriptHelper:PushDebugOverlayScope( utlstringtoken_1 ) end

---[[ CDebugOverlayScriptHelper:RemoveAllInScope  Removes all overlays marked with a specific identifier, regardless of their lifetime. ]]
-- @return void
-- @param utlstringtoken_1 utlstringtoken
function CDebugOverlayScriptHelper:RemoveAllInScope( utlstringtoken_1 ) end

---[[ CDebugOverlayScriptHelper:SolidCone  Draws a solid cone. Specify endpoint and direction in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param float_4 float
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
-- @param float_10 float
function CDebugOverlayScriptHelper:SolidCone( Vector_1, Vector_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:Sphere  Draws a wireframe sphere. Specify center in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param int_3 int
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param bool_7 bool
-- @param float_8 float
function CDebugOverlayScriptHelper:Sphere( Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8 ) end

---[[ CDebugOverlayScriptHelper:SweptBox  Draws a swept box. Specify endpoints in world space and the bounds in local space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param Vector_4 Vector
-- @param Quaternion_5 Quaternion
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param int_9 int
-- @param float_10 float
function CDebugOverlayScriptHelper:SweptBox( Vector_1, Vector_2, Vector_3, Vector_4, Quaternion_5, int_6, int_7, int_8, int_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:Text  Draws 2D text. Specify origin in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param int_2 int
-- @param string_3 string
-- @param float_4 float
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param float_9 float
function CDebugOverlayScriptHelper:Text( Vector_1, int_2, string_3, float_4, int_5, int_6, int_7, int_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:Texture  Draws a screen-space texture. Coordinates are in pixels. ]]
-- @return void
-- @param string_1 string
-- @param Vector2D_2 Vector2D
-- @param Vector2D_3 Vector2D
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param Vector2D_8 Vector2D
-- @param Vector2D_9 Vector2D
-- @param float_10 float
function CDebugOverlayScriptHelper:Texture( string_1, Vector2D_2, Vector2D_3, int_4, int_5, int_6, int_7, Vector2D_8, Vector2D_9, float_10 ) end

---[[ CDebugOverlayScriptHelper:Triangle  Draws a filled triangle. Specify vertices in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param Vector_3 Vector
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param bool_8 bool
-- @param float_9 float
function CDebugOverlayScriptHelper:Triangle( Vector_1, Vector_2, Vector_3, int_4, int_5, int_6, int_7, bool_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:UnitTestCycleOverlayRenderType  Toggles the overlay render type, for unit tests ]]
-- @return void
function CDebugOverlayScriptHelper:UnitTestCycleOverlayRenderType(  ) end

---[[ CDebugOverlayScriptHelper:VectorText3D  Draws 3D text. Specify origin + orientation in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Quaternion_2 Quaternion
-- @param string_3 string
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param bool_8 bool
-- @param float_9 float
function CDebugOverlayScriptHelper:VectorText3D( Vector_1, Quaternion_2, string_3, int_4, int_5, int_6, int_7, bool_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:VertArrow  Draws a vertical arrow. Specify endpoints in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param Vector_2 Vector
-- @param float_3 float
-- @param int_4 int
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param bool_8 bool
-- @param float_9 float
function CDebugOverlayScriptHelper:VertArrow( Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9 ) end

---[[ CDebugOverlayScriptHelper:YawArrow  Draws a arrow associated with a specific yaw. Specify endpoints in world space. ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param float_3 float
-- @param float_4 float
-- @param int_5 int
-- @param int_6 int
-- @param int_7 int
-- @param int_8 int
-- @param bool_9 bool
-- @param float_10 float
function CDebugOverlayScriptHelper:YawArrow( Vector_1, float_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10 ) end

---[[ CDotaQuest:AddSubquest  Add a subquest to this quest ]]
-- @return void
-- @param hSubquest handle
function CDotaQuest:AddSubquest( hSubquest ) end

---[[ CDotaQuest:CompleteQuest  Mark this quest complete ]]
-- @return void
function CDotaQuest:CompleteQuest(  ) end

---[[ CDotaQuest:GetSubquest  Finds a subquest from this quest by index ]]
-- @return handle
-- @param nIndex int
function CDotaQuest:GetSubquest( nIndex ) end

---[[ CDotaQuest:GetSubquestByName  Finds a subquest from this quest by name ]]
-- @return handle
-- @param pszName string
function CDotaQuest:GetSubquestByName( pszName ) end

---[[ CDotaQuest:RemoveSubquest  Remove a subquest from this quest ]]
-- @return void
-- @param hSubquest handle
function CDotaQuest:RemoveSubquest( hSubquest ) end

---[[ CDotaQuest:SetTextReplaceString  Set the text replace string for this quest ]]
-- @return void
-- @param pszString string
function CDotaQuest:SetTextReplaceString( pszString ) end

---[[ CDotaQuest:SetTextReplaceValue  Set a quest value ]]
-- @return void
-- @param valueSlot int
-- @param value int
function CDotaQuest:SetTextReplaceValue( valueSlot, value ) end

---[[ CDotaSubquestBase:CompleteSubquest  Mark this subquest complete ]]
-- @return void
function CDotaSubquestBase:CompleteSubquest(  ) end

---[[ CDotaSubquestBase:SetTextReplaceString  Set the text replace string for this subquest ]]
-- @return void
-- @param pszString string
function CDotaSubquestBase:SetTextReplaceString( pszString ) end

---[[ CDotaSubquestBase:SetTextReplaceValue  Set a subquest value ]]
-- @return void
-- @param valueSlot int
-- @param value int
function CDotaSubquestBase:SetTextReplaceValue( valueSlot, value ) end

---[[ CreateByClassname  Creates an entity by classname ]]
-- @return handle
-- @param string_1 string
function CreateByClassname( string_1 ) end

---[[ FindAllByClassname  Finds all entities by class name. Returns an array containing all the found entities. ]]
-- @return table
-- @param string_1 string
function FindAllByClassname( string_1 ) end

---[[ FindAllByClassnameWithin  Find entities by class name within a radius. ]]
-- @return table
-- @param string_1 string
-- @param Vector_2 Vector
-- @param float_3 float
function FindAllByClassnameWithin( string_1, Vector_2, float_3 ) end

---[[ FindAllByModel  Find entities by model name. ]]
-- @return table
-- @param string_1 string
function FindAllByModel( string_1 ) end

---[[ FindAllByName  Find all entities by name. Returns an array containing all the found entities in it. ]]
-- @return table
-- @param string_1 string
function FindAllByName( string_1 ) end

---[[ FindAllByNameWithin  Find entities by name within a radius. ]]
-- @return table
-- @param string_1 string
-- @param Vector_2 Vector
-- @param float_3 float
function FindAllByNameWithin( string_1, Vector_2, float_3 ) end

---[[ FindAllByTarget  Find entities by targetname. ]]
-- @return table
-- @param string_1 string
function FindAllByTarget( string_1 ) end

---[[ FindAllInSphere  Find entities within a radius. ]]
-- @return table
-- @param Vector_1 Vector
-- @param float_2 float
function FindAllInSphere( Vector_1, float_2 ) end

---[[ FindByClassname  Find entities by class name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
function FindByClassname( handle_1, string_2 ) end

---[[ FindByClassnameNearest  Find entities by class name nearest to a point. ]]
-- @return handle
-- @param string_1 string
-- @param Vector_2 Vector
-- @param float_3 float
function FindByClassnameNearest( string_1, Vector_2, float_3 ) end

---[[ FindByClassnameWithin  Find entities by class name within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
-- @param Vector_3 Vector
-- @param float_4 float
function FindByClassnameWithin( handle_1, string_2, Vector_3, float_4 ) end

---[[ FindByModel  Find entities by model name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
function FindByModel( handle_1, string_2 ) end

---[[ FindByModelWithin  Find entities by model name within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
-- @param Vector_3 Vector
-- @param float_4 float
function FindByModelWithin( handle_1, string_2, Vector_3, float_4 ) end

---[[ FindByName  Find entities by name. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
function FindByName( handle_1, string_2 ) end

---[[ FindByNameNearest  Find entities by name nearest to a point. ]]
-- @return handle
-- @param string_1 string
-- @param Vector_2 Vector
-- @param float_3 float
function FindByNameNearest( string_1, Vector_2, float_3 ) end

---[[ FindByNameWithin  Find entities by name within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
-- @param Vector_3 Vector
-- @param float_4 float
function FindByNameWithin( handle_1, string_2, Vector_3, float_4 ) end

---[[ FindByTarget  Find entities by targetname. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param string_2 string
function FindByTarget( handle_1, string_2 ) end

---[[ FindInSphere  Find entities within a radius. Pass 'null' to start an iteration, or reference to a previously found entity to continue a search ]]
-- @return handle
-- @param handle_1 handle
-- @param Vector_2 Vector
-- @param float_3 float
function FindInSphere( handle_1, Vector_2, float_3 ) end

---[[ First  Begin an iteration over the list of entities ]]
-- @return handle
function First(  ) end

---[[ GetLocalPlayer  Get the local player. ]]
-- @return handle
function GetLocalPlayer(  ) end

---[[ Next  Continue an iteration over the list of entities, providing reference to a previously found entity ]]
-- @return handle
-- @param handle_1 handle
function Next( handle_1 ) end

---[[ ConnectOutput  Adds an I/O connection that will call the named function on this entity when the specified output fires. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function ConnectOutput( string_1, string_2 ) end

---[[ Destroy   ]]
-- @return void
function Destroy(  ) end

---[[ DisconnectOutput  Removes a connected script function from an I/O event on this entity. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function DisconnectOutput( string_1, string_2 ) end

---[[ DisconnectRedirectedOutput  Removes a connected script function from an I/O event on the passed entity. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param handle_3 handle
function DisconnectRedirectedOutput( string_1, string_2, handle_3 ) end

---[[ FireOutput  Fire an entity output ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
-- @param handle_3 handle
-- @param table_4 table
-- @param float_5 float
function FireOutput( string_1, handle_2, handle_3, table_4, float_5 ) end

---[[ GetClassname   ]]
-- @return string
function GetClassname(  ) end

---[[ GetDebugName  Get the entity name w/help if not defined (i.e. classname/etc) ]]
-- @return string
function GetDebugName(  ) end

---[[ GetEntityHandle  Get the entity as an EHANDLE ]]
-- @return ehandle
function GetEntityHandle(  ) end

---[[ GetEntityIndex   ]]
-- @return int
function GetEntityIndex(  ) end

---[[ GetIntAttr  Get Integer Attribute ]]
-- @return int
-- @param string_1 string
function GetIntAttr( string_1 ) end

---[[ GetName   ]]
-- @return string
function GetName(  ) end

---[[ GetOrCreatePrivateScriptScope  Retrieve, creating if necessary, the private per-instance script-side data associated with an entity ]]
-- @return handle
function GetOrCreatePrivateScriptScope(  ) end

---[[ GetOrCreatePublicScriptScope  Retrieve, creating if necessary, the public script-side data associated with an entity ]]
-- @return handle
function GetOrCreatePublicScriptScope(  ) end

---[[ GetPrivateScriptScope  Retrieve the private per-instance script-side data associated with an entity ]]
-- @return handle
function GetPrivateScriptScope(  ) end

---[[ GetPublicScriptScope  Retrieve the public script-side data associated with an entity ]]
-- @return handle
function GetPublicScriptScope(  ) end

---[[ RedirectOutput  Adds an I/O connection that will call the named function on the passed entity when the specified output fires. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param handle_3 handle
function RedirectOutput( string_1, string_2, handle_3 ) end

---[[ RemoveSelf  Delete this entity ]]
-- @return void
function RemoveSelf(  ) end

---[[ SetIntAttr  Set Integer Attribute ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
function SetIntAttr( string_1, int_2 ) end

---[[ entindex   ]]
-- @return int
function entindex(  ) end

---[[ CEnvEntityMaker:SpawnEntity  Create an entity at the location of the maker ]]
-- @return void
function CEnvEntityMaker:SpawnEntity(  ) end

---[[ CEnvEntityMaker:SpawnEntityAtEntityOrigin  Create an entity at the location of a specified entity instance ]]
-- @return void
-- @param hEntity handle
function CEnvEntityMaker:SpawnEntityAtEntityOrigin( hEntity ) end

---[[ CEnvEntityMaker:SpawnEntityAtLocation  Create an entity at a specified location and orientaton, orientation is Euler angle in degrees (pitch, yaw, roll) ]]
-- @return void
-- @param vecAlternateOrigin Vector
-- @param vecAlternateAngles Vector
function CEnvEntityMaker:SpawnEntityAtLocation( vecAlternateOrigin, vecAlternateAngles ) end

---[[ CEnvEntityMaker:SpawnEntityAtNamedEntityOrigin  Create an entity at the location of a named entity ]]
-- @return void
-- @param pszName string
function CEnvEntityMaker:SpawnEntityAtNamedEntityOrigin( pszName ) end

---[[ CEnvProjectedTexture:SetFarRange  Set light maximum range ]]
-- @return void
-- @param flRange float
function CEnvProjectedTexture:SetFarRange( flRange ) end

---[[ CEnvProjectedTexture:SetLinearAttenuation  Set light linear attenuation value ]]
-- @return void
-- @param flAtten float
function CEnvProjectedTexture:SetLinearAttenuation( flAtten ) end

---[[ CEnvProjectedTexture:SetNearRange  Set light minimum range ]]
-- @return void
-- @param flRange float
function CEnvProjectedTexture:SetNearRange( flRange ) end

---[[ CEnvProjectedTexture:SetQuadraticAttenuation  Set light quadratic attenuation value ]]
-- @return void
-- @param flAtten float
function CEnvProjectedTexture:SetQuadraticAttenuation( flAtten ) end

---[[ CEnvProjectedTexture:SetVolumetrics  Turn on/off light volumetrics: bool bOn, float flIntensity, float flNoise, int nPlanes, float flPlaneOffset ]]
-- @return void
-- @param bOn bool
-- @param flIntensity float
-- @param flNoise float
-- @param nPlanes int
-- @param flPlaneOffset float
function CEnvProjectedTexture:SetVolumetrics( bOn, flIntensity, flNoise, nPlanes, flPlaneOffset ) end

---[[ CInfoData:QueryColor  Query color data for this key ]]
-- @return Vector
-- @param tok utlstringtoken
-- @param vDefault Vector
function CInfoData:QueryColor( tok, vDefault ) end

---[[ CInfoData:QueryFloat  Query float data for this key ]]
-- @return float
-- @param tok utlstringtoken
-- @param flDefault float
function CInfoData:QueryFloat( tok, flDefault ) end

---[[ CInfoData:QueryInt  Query int data for this key ]]
-- @return int
-- @param tok utlstringtoken
-- @param nDefault int
function CInfoData:QueryInt( tok, nDefault ) end

---[[ CInfoData:QueryNumber  Query number data for this key ]]
-- @return float
-- @param tok utlstringtoken
-- @param flDefault float
function CInfoData:QueryNumber( tok, flDefault ) end

---[[ CInfoData:QueryString  Query string data for this key ]]
-- @return string
-- @param tok utlstringtoken
-- @param pDefault string
function CInfoData:QueryString( tok, pDefault ) end

---[[ CInfoData:QueryVector  Query vector data for this key ]]
-- @return Vector
-- @param tok utlstringtoken
-- @param vDefault Vector
function CInfoData:QueryVector( tok, vDefault ) end

---[[ CInfoWorldLayer:HideWorldLayer  Hides this layer ]]
-- @return void
function CInfoWorldLayer:HideWorldLayer(  ) end

---[[ CInfoWorldLayer:ShowWorldLayer  Shows this layer ]]
-- @return void
function CInfoWorldLayer:ShowWorldLayer(  ) end

---[[ CMarkupVolumeTagged:HasTag  Does this volume have the given tag. ]]
-- @return bool
-- @param pszTagName string
function CMarkupVolumeTagged:HasTag( pszTagName ) end

---[[ CNativeOutputs:AddOutput  Add an output ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function CNativeOutputs:AddOutput( string_1, string_2 ) end

---[[ CNativeOutputs:Init  Initialize with number of outputs ]]
-- @return void
-- @param int_1 int
function CNativeOutputs:Init( int_1 ) end

---[[ CPhysicsProp:DisableMotion  Disable motion for the prop ]]
-- @return void
function CPhysicsProp:DisableMotion(  ) end

---[[ CPhysicsProp:EnableMotion  Enable motion for the prop ]]
-- @return void
function CPhysicsProp:EnableMotion(  ) end

---[[ CPhysicsProp:SetDynamicVsDynamicContinuous  Enable/disable dynamic vs dynamic continuous collision traces ]]
-- @return void
-- @param bIsDynamicVsDynamicContinuousEnabled bool
function CPhysicsProp:SetDynamicVsDynamicContinuous( bIsDynamicVsDynamicContinuousEnabled ) end

---[[ CPointClientUIWorldPanel:AcceptUserInput  Tells the panel to accept user input. ]]
-- @return void
function CPointClientUIWorldPanel:AcceptUserInput(  ) end

---[[ CPointClientUIWorldPanel:AddCSSClasses  Adds CSS class(es) to the panel ]]
-- @return void
-- @param pszClasses string
function CPointClientUIWorldPanel:AddCSSClasses( pszClasses ) end

---[[ CPointClientUIWorldPanel:IgnoreUserInput  Tells the panel to ignore user input. ]]
-- @return void
function CPointClientUIWorldPanel:IgnoreUserInput(  ) end

---[[ CPointClientUIWorldPanel:IsGrabbable  Returns whether this entity is grabbable. ]]
-- @return bool
function CPointClientUIWorldPanel:IsGrabbable(  ) end

---[[ CPointClientUIWorldPanel:RemoveCSSClasses  Remove CSS class(es) from the panel ]]
-- @return void
-- @param pszClasses string
function CPointClientUIWorldPanel:RemoveCSSClasses( pszClasses ) end

---[[ CPointTemplate:DeleteCreatedSpawnGroups  DeleteCreatedSpawnGroups() : Deletes any spawn groups that this point_template has spawned. Note: The point_template will not be deleted by this. ]]
-- @return void
function CPointTemplate:DeleteCreatedSpawnGroups(  ) end

---[[ CPointTemplate:ForceSpawn  ForceSpawn() : Spawns all of the entities the point_template is pointing at. ]]
-- @return void
function CPointTemplate:ForceSpawn(  ) end

---[[ CPointTemplate:GetSpawnedEntities  GetSpawnedEntities() : Get the list of the most recent spawned entities ]]
-- @return handle
function CPointTemplate:GetSpawnedEntities(  ) end

---[[ CPointTemplate:SetSpawnCallback  SetSpawnCallback( hCallbackFunc, hCallbackScope, hCallbackData ) : Set a callback for when the template spawns entities. The spawned entities will be passed in as an array. ]]
-- @return void
-- @param hCallbackFunc handle
-- @param hCallbackScope handle
function CPointTemplate:SetSpawnCallback( hCallbackFunc, hCallbackScope ) end

---[[ CPointWorldText:SetMessage  Set the message on this entity. ]]
-- @return void
-- @param pMessage string
function CPointWorldText:SetMessage( pMessage ) end

---[[ CPropHMDAvatar:GetVRHand  Get VR hand by ID ]]
-- @return handle
-- @param nHandID int
function CPropHMDAvatar:GetVRHand( nHandID ) end

---[[ CPropVRHand:AddHandAttachment  Add the attachment to this hand ]]
-- @return void
-- @param hAttachment handle
function CPropVRHand:AddHandAttachment( hAttachment ) end

---[[ CPropVRHand:AddHandModelOverride  Add a model override for this hand ]]
-- @return handle
-- @param pModelName string
function CPropVRHand:AddHandModelOverride( pModelName ) end

---[[ CPropVRHand:FindHandModelOverride  Find a specific model override for this hand ]]
-- @return handle
-- @param pModelName string
function CPropVRHand:FindHandModelOverride( pModelName ) end

---[[ CPropVRHand:FireHapticPulse  Fire a haptic pulse on this hand. [0,2] for strength. ]]
-- @return void
-- @param nStrength int
function CPropVRHand:FireHapticPulse( nStrength ) end

---[[ CPropVRHand:FireHapticPulsePrecise  Fire a haptic pulse on this hand. Specify the duration in micro seconds. ]]
-- @return void
-- @param nPulseDuration int
function CPropVRHand:FireHapticPulsePrecise( nPulseDuration ) end

---[[ CPropVRHand:GetHandAttachment  Get the attachment on this hand ]]
-- @return handle
function CPropVRHand:GetHandAttachment(  ) end

---[[ CPropVRHand:GetHandID  Get hand ID ]]
-- @return int
function CPropVRHand:GetHandID(  ) end

---[[ CPropVRHand:GetLiteralHandType  Get literal type for this hand ]]
-- @return int
function CPropVRHand:GetLiteralHandType(  ) end

---[[ CPropVRHand:GetPlayer  Get the player for this hand ]]
-- @return handle
function CPropVRHand:GetPlayer(  ) end

---[[ CPropVRHand:GetVelocity  Get the filtered controller velocity. ]]
-- @return Vector
function CPropVRHand:GetVelocity(  ) end

---[[ CPropVRHand:RemoveAllHandModelOverrides  Remove all model overrides for this hand ]]
-- @return void
function CPropVRHand:RemoveAllHandModelOverrides(  ) end

---[[ CPropVRHand:RemoveHandAttachmentByHandle  Remove hand attachment by handle ]]
-- @return void
-- @param hAttachment handle
function CPropVRHand:RemoveHandAttachmentByHandle( hAttachment ) end

---[[ CPropVRHand:RemoveHandModelOverride  Remove a model override for this hand ]]
-- @return void
-- @param pModelName string
function CPropVRHand:RemoveHandModelOverride( pModelName ) end

---[[ CPropVRHand:SetHandAttachment  Set the attachment for this hand ]]
-- @return void
-- @param hAttachment handle
function CPropVRHand:SetHandAttachment( hAttachment ) end

---[[ CSceneEntity:AddBroadcastTeamTarget  Adds a team (by index) to the broadcast list ]]
-- @return void
-- @param int_1 int
function CSceneEntity:AddBroadcastTeamTarget( int_1 ) end

---[[ CSceneEntity:Cancel  Cancel scene playback ]]
-- @return void
function CSceneEntity:Cancel(  ) end

---[[ CSceneEntity:EstimateLength  Returns length of this scene in seconds. ]]
-- @return float
function CSceneEntity:EstimateLength(  ) end

---[[ CSceneEntity:FindCamera  Get the camera ]]
-- @return handle
function CSceneEntity:FindCamera(  ) end

---[[ CSceneEntity:FindNamedEntity  given an entity reference, such as !target, get actual entity from scene object ]]
-- @return handle
-- @param string_1 string
function CSceneEntity:FindNamedEntity( string_1 ) end

---[[ CSceneEntity:IsPaused  If this scene is currently paused. ]]
-- @return bool
function CSceneEntity:IsPaused(  ) end

---[[ CSceneEntity:IsPlayingBack  If this scene is currently playing. ]]
-- @return bool
function CSceneEntity:IsPlayingBack(  ) end

---[[ CSceneEntity:LoadSceneFromString  given a dummy scene name and a vcd string, load the scene ]]
-- @return bool
-- @param string_1 string
-- @param string_2 string
function CSceneEntity:LoadSceneFromString( string_1, string_2 ) end

---[[ CSceneEntity:RemoveBroadcastTeamTarget  Removes a team (by index) from the broadcast list ]]
-- @return void
-- @param int_1 int
function CSceneEntity:RemoveBroadcastTeamTarget( int_1 ) end

---[[ CSceneEntity:Start  Start scene playback, takes activatorEntity as param ]]
-- @return void
-- @param handle_1 handle
function CSceneEntity:Start( handle_1 ) end

---[[ CScriptHeroList:GetAllHeroes  Returns all the heroes in the world ]]
-- @return table
function CScriptHeroList:GetAllHeroes(  ) end

---[[ CScriptHeroList:GetHero  Get the Nth hero in the Hero List ]]
-- @return handle
-- @param int_1 int
function CScriptHeroList:GetHero( int_1 ) end

---[[ CScriptHeroList:GetHeroCount  Returns the number of heroes in the world ]]
-- @return int
function CScriptHeroList:GetHeroCount(  ) end

---[[ CScriptKeyValues:GetValue  Reads a spawn key ]]
-- @return table
-- @param string_1 string
function CScriptKeyValues:GetValue( string_1 ) end

---[[ CScriptParticleManager:CreateParticle  Creates a new particle effect ]]
-- @return int
-- @param string_1 string
-- @param int_2 int
-- @param handle_3 handle
function CScriptParticleManager:CreateParticle( string_1, int_2, handle_3 ) end

---[[ CScriptParticleManager:CreateParticleForPlayer  Creates a new particle effect that only plays for the specified player ]]
-- @return int
-- @param string_1 string
-- @param int_2 int
-- @param handle_3 handle
-- @param handle_4 handle
function CScriptParticleManager:CreateParticleForPlayer( string_1, int_2, handle_3, handle_4 ) end

---[[ CScriptParticleManager:CreateParticleForTeam  Creates a new particle effect that only plays for the specified team ]]
-- @return int
-- @param string_1 string
-- @param int_2 int
-- @param handle_3 handle
-- @param int_4 int
function CScriptParticleManager:CreateParticleForTeam( string_1, int_2, handle_3, int_4 ) end

---[[ CScriptParticleManager:DestroyParticle  (int index, bool bDestroyImmediately) - Destroy a particle, if bDestroyImmediately destroy it without playing end caps. ]]
-- @return void
-- @param int_1 int
-- @param bool_2 bool
function CScriptParticleManager:DestroyParticle( int_1, bool_2 ) end

---[[ CScriptParticleManager:GetParticleReplacement   ]]
-- @return string
-- @param string_1 string
-- @param handle_2 handle
function CScriptParticleManager:GetParticleReplacement( string_1, handle_2 ) end

---[[ CScriptParticleManager:ReleaseParticleIndex  Frees the specified particle index ]]
-- @return void
-- @param int_1 int
function CScriptParticleManager:ReleaseParticleIndex( int_1 ) end

---[[ CScriptParticleManager:SetParticleAlwaysSimulate   ]]
-- @return void
-- @param int_1 int
function CScriptParticleManager:SetParticleAlwaysSimulate( int_1 ) end

---[[ CScriptParticleManager:SetParticleControl  Set the control point data for a control on a particle effect ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param Vector_3 Vector
function CScriptParticleManager:SetParticleControl( int_1, int_2, Vector_3 ) end

---[[ CScriptParticleManager:SetParticleControlEnt   ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param handle_3 handle
-- @param int_4 int
-- @param string_5 string
-- @param Vector_6 Vector
-- @param bool_7 bool
function CScriptParticleManager:SetParticleControlEnt( int_1, int_2, handle_3, int_4, string_5, Vector_6, bool_7 ) end

---[[ CScriptParticleManager:SetParticleControlFallback  (int iIndex, int iPoint, Vector vecPosition) ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param Vector_3 Vector
function CScriptParticleManager:SetParticleControlFallback( int_1, int_2, Vector_3 ) end

---[[ CScriptParticleManager:SetParticleControlForward  (int nFXIndex, int nPoint, vForward) ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param Vector_3 Vector
function CScriptParticleManager:SetParticleControlForward( int_1, int_2, Vector_3 ) end

---[[ CScriptParticleManager:SetParticleControlOrientation  (int nFXIndex, int nPoint, vForward, vRight, vUp) - Set the orientation for a control on a particle effect (NOTE: This is left handed -- bad!!) ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param Vector_3 Vector
-- @param Vector_4 Vector
-- @param Vector_5 Vector
function CScriptParticleManager:SetParticleControlOrientation( int_1, int_2, Vector_3, Vector_4, Vector_5 ) end

---[[ CScriptParticleManager:SetParticleControlOrientationFLU  (int nFXIndex, int nPoint, Vector vecForward, Vector vecLeft, Vector vecUp) - Set the orientation for a control on a particle effect ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param Vector_3 Vector
-- @param Vector_4 Vector
-- @param Vector_5 Vector
function CScriptParticleManager:SetParticleControlOrientationFLU( int_1, int_2, Vector_3, Vector_4, Vector_5 ) end

---[[ CScriptParticleManager:SetParticleFoWProperties  int nfxindex, int nPoint, int nPoint2, float flRadius ]]
-- @return void
-- @param int_1 int
-- @param int_2 int
-- @param int_3 int
-- @param float_4 float
function CScriptParticleManager:SetParticleFoWProperties( int_1, int_2, int_3, float_4 ) end

---[[ CScriptParticleManager:SetParticleShouldCheckFoW  int nfxindex, bool bCheckFoW ]]
-- @return bool
-- @param int_1 int
-- @param bool_2 bool
function CScriptParticleManager:SetParticleShouldCheckFoW( int_1, bool_2 ) end

---[[ CScriptPrecacheContext:AddResource  Precaches a specific resource ]]
-- @return void
-- @param string_1 string
function CScriptPrecacheContext:AddResource( string_1 ) end

---[[ CScriptPrecacheContext:GetValue  Reads a spawn key ]]
-- @return table
-- @param string_1 string
function CScriptPrecacheContext:GetValue( string_1 ) end

---[[ GetBool  GetBool(name) : returns the convar as a boolean flag. ]]
-- @return table
-- @param string_1 string
function GetBool( string_1 ) end

---[[ GetCommandClient  GetCommandClient() : returns the player who issued this console command. ]]
-- @return handle
function GetCommandClient(  ) end

---[[ GetDOTACommandClient  GetDOTACommandClient() : returns the DOTA player who issued this console command. ]]
-- @return handle
function GetDOTACommandClient(  ) end

---[[ GetFloat  GetFloat(name) : returns the convar as a float. May return null if no such convar. ]]
-- @return table
-- @param string_1 string
function GetFloat( string_1 ) end

---[[ GetInt  GetInt(name) : returns the convar as an int. May return null if no such convar. ]]
-- @return table
-- @param string_1 string
function GetInt( string_1 ) end

---[[ GetStr  GetStr(name) : returns the convar as a string. May return null if no such convar. ]]
-- @return table
-- @param string_1 string
function GetStr( string_1 ) end

---[[ RegisterCommand  RegisterCommand(name, fn, helpString, flags) : register a console command. ]]
-- @return void
-- @param string_1 string
-- @param handle_2 handle
-- @param string_3 string
-- @param int_4 int
function RegisterCommand( string_1, handle_2, string_3, int_4 ) end

---[[ RegisterConvar  RegisterConvar(name, defaultValue, helpString, flags): register a new console variable. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
-- @param string_3 string
-- @param int_4 int
function RegisterConvar( string_1, string_2, string_3, int_4 ) end

---[[ SetBool  SetBool(name, val) : sets the value of the convar to the bool. ]]
-- @return void
-- @param string_1 string
-- @param bool_2 bool
function SetBool( string_1, bool_2 ) end

---[[ SetFloat  SetFloat(name, val) : sets the value of the convar to the float. ]]
-- @return void
-- @param string_1 string
-- @param float_2 float
function SetFloat( string_1, float_2 ) end

---[[ SetInt  SetInt(name, val) : sets the value of the convar to the int. ]]
-- @return void
-- @param string_1 string
-- @param int_2 int
function SetInt( string_1, int_2 ) end

---[[ SetStr  SetStr(name, val) : sets the value of the convar to the string. ]]
-- @return void
-- @param string_1 string
-- @param string_2 string
function SetStr( string_1, string_2 ) end

---[[ GlobalSys:CommandLineCheck  CommandLineCheck(name) : returns true if the command line param was used, otherwise false. ]]
-- @return table
-- @param string_1 string
function GlobalSys:CommandLineCheck( string_1 ) end

---[[ GlobalSys:CommandLineFloat  CommandLineFloat(name) : returns the command line param as a float. ]]
-- @return table
-- @param string_1 string
-- @param float_2 float
function GlobalSys:CommandLineFloat( string_1, float_2 ) end

---[[ GlobalSys:CommandLineInt  CommandLineInt(name) : returns the command line param as an int. ]]
-- @return table
-- @param string_1 string
-- @param int_2 int
function GlobalSys:CommandLineInt( string_1, int_2 ) end

---[[ GlobalSys:CommandLineStr  CommandLineStr(name) : returns the command line param as a string. ]]
-- @return table
-- @param string_1 string
-- @param string_2 string
function GlobalSys:CommandLineStr( string_1, string_2 ) end

---[[ GridNav:CanFindPath  Determine if it is possible to reach the specified end point from the specified start point. bool (vStart, vEnd) ]]
-- @return bool
-- @param Vector_1 Vector
-- @param Vector_2 Vector
function GridNav:CanFindPath( Vector_1, Vector_2 ) end

---[[ GridNav:DestroyTreesAroundPoint  Destroy all trees in the area(vPosition, flRadius, bFullCollision ]]
-- @return void
-- @param Vector_1 Vector
-- @param float_2 float
-- @param bool_3 bool
function GridNav:DestroyTreesAroundPoint( Vector_1, float_2, bool_3 ) end

---[[ GridNav:FindPathLength  Find a path between the two points an return the length of the path. If there is not a path between the points the returned value will be -1. float (vStart, vEnd ) ]]
-- @return float
-- @param Vector_1 Vector
-- @param Vector_2 Vector
function GridNav:FindPathLength( Vector_1, Vector_2 ) end

---[[ GridNav:GetAllTreesAroundPoint  Returns a table full of tree HSCRIPTS (vPosition, flRadius, bFullCollision). ]]
-- @return table
-- @param Vector_1 Vector
-- @param float_2 float
-- @param bool_3 bool
function GridNav:GetAllTreesAroundPoint( Vector_1, float_2, bool_3 ) end

---[[ GridNav:GridPosToWorldCenterX  Get the X position of the center of a given X index ]]
-- @return float
-- @param int_1 int
function GridNav:GridPosToWorldCenterX( int_1 ) end

---[[ GridNav:GridPosToWorldCenterY  Get the Y position of the center of a given Y index ]]
-- @return float
-- @param int_1 int
function GridNav:GridPosToWorldCenterY( int_1 ) end

---[[ GridNav:IsBlocked  Checks whether the given position is blocked ]]
-- @return bool
-- @param Vector_1 Vector
function GridNav:IsBlocked( Vector_1 ) end

---[[ GridNav:IsNearbyTree  (position, radius, checkFullTreeRadius?) Checks whether there are any trees overlapping the given point ]]
-- @return bool
-- @param Vector_1 Vector
-- @param float_2 float
-- @param bool_3 bool
function GridNav:IsNearbyTree( Vector_1, float_2, bool_3 ) end

---[[ GridNav:IsTraversable  Checks whether the given position is traversable ]]
-- @return bool
-- @param Vector_1 Vector
function GridNav:IsTraversable( Vector_1 ) end

---[[ GridNav:RegrowAllTrees  Causes all trees in the map to regrow ]]
-- @return void
function GridNav:RegrowAllTrees(  ) end

---[[ GridNav:WorldToGridPosX  Get the X index of a given world X position ]]
-- @return int
-- @param float_1 float
function GridNav:WorldToGridPosX( float_1 ) end

---[[ GridNav:WorldToGridPosY  Get the Y index of a given world Y position ]]
-- @return int
-- @param float_1 float
function GridNav:WorldToGridPosY( float_1 ) end

---[[ ChangeTrackingProjectileSpeed  Update speed ]]
-- @return void
-- @param handle_1 handle
-- @param int_2 int
function ChangeTrackingProjectileSpeed( handle_1, int_2 ) end

---[[ CreateLinearProjectile  Creates a linear projectile and returns the projectile ID ]]
-- @return int
-- @param handle_1 handle
function CreateLinearProjectile( handle_1 ) end

---[[ CreateTrackingProjectile  Creates a tracking projectile ]]
-- @return void
-- @param handle_1 handle
function CreateTrackingProjectile( handle_1 ) end

---[[ DestroyLinearProjectile  Destroys the linear projectile matching the argument ID ]]
-- @return void
-- @param int_1 int
function DestroyLinearProjectile( int_1 ) end

---[[ GetLinearProjectileLocation  Returns current location of projectile ]]
-- @return Vector
-- @param int_1 int
function GetLinearProjectileLocation( int_1 ) end

---[[ GetLinearProjectileRadius  Returns current radius of projectile ]]
-- @return float
-- @param int_1 int
function GetLinearProjectileRadius( int_1 ) end

---[[ GetLinearProjectileVelocity  Returns a vector representing the current velocity of the projectile. ]]
-- @return Vector
-- @param int_1 int
function GetLinearProjectileVelocity( int_1 ) end

---[[ ProjectileDodge  Makes the specified unit dodge projectiles ]]
-- @return void
-- @param handle_1 handle
function ProjectileDodge( handle_1 ) end

---[[ UpdateLinearProjectileDirection  Update velocity ]]
-- @return void
-- @param int_1 int
-- @param Vector_2 Vector
-- @param float_3 float
function UpdateLinearProjectileDirection( int_1, Vector_2, float_3 ) end

---[[ SteamInfo:IsPublicUniverse  Is the script connected to the public Steam universe ]]
-- @return bool
function SteamInfo:IsPublicUniverse(  ) end