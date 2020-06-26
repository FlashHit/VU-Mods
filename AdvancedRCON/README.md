# Advanced RCON

| Command        | Arg1           | Arg2  |Default  |
| ------------- |:-------------:| -----:|-----:|
| admin.forceKillPlayer        | Player      | 
| admin.teamSwitchPlayer       | Player      |
| currentLevel                |
| player.isDead         | Player      | 
| player.isRevivable        | Player      | 
| textChatModerationList.addPlayer                 | admin/voice/muted | Player |
| textChatModerationList.clear        |
| textChatModerationList.list       | 
| textChatModerationList.load       | 
| textChatModerationList.removePlayer        | Player    | 
| vars.textChatModerationMode         | free/moderated/muted    |  | free|
| vars.textChatSpamCoolDownTime          | coolDownTime    |  |30 |
| vars.textChatSpamDetectionTime          | detectionTime    |  |6 |
| vars.textChatSpamTriggerCount          | triggerCount    |  |6 |
| vu.Event           | eventName    | false/true |false |

| EventNames        |
| ------------- |
|onLevelLoaded |
|onCapture |
|onCapturePointLost|
|onEngineInit |
|onAuthenticated| 
|onChangingWeapon |
|onChat |
|onCreated| 
|onDestroyed| 
|onEnteredCapturePoint|
|onInstantSuicide |
|onJoining |
|onKickedFromSquad |
|onKilled |
|onKitPickup |
|onLeft |
|onReload| 
|onRespawn| 
|onResupply| 
|onRevive |
|onReviveAccepted |
|onReviveRefused |
|onSetSquad |
|onSetSquadLeader |
|onSpawnAtVehicle |
|onSpawnOnPlayer |
|onSpawnOnSelectedSpawnPoint|
|onSquadChange |
|onSuppressedEnemy |
|onTeamChange |
|onUpdate |
|onUpdateInput |
|onRoundOver |
|onRoundReset |
|onHealthAction| 
|onManDown |
|onPrePhysicsUpdate|
|onDamage |
|onVehicleDestroyed|
|onDisabled |
|onEnter |
|onExit |
|onSpawnDone |
|onUnspawn |
|onEntityFactoryCreated|
|onEntityFactoryCreatedFromBlueprint|
|onFindBestSquad |
|onRequestJoin |
|onSelectTeam |
|onServerSuppressEnemies|
|onSoldierDamage |
