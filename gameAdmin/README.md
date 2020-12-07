# gameAdmin

A simple example mod that makes use of this is the <a href="https://github.com/FlashHit/VU-Mods/tree/master/InGameAdmin">InGameAdmin</a> mod.

This mod is for admin permissions that can be used for other mods by adding this code:
```lua
local admins = {}
Events:Subscribe('GameAdmin:Player', function(playerName, abilitities)
	admins[playerName] = abilitities
end)

Events:Subscribe('GameAdmin:Clear', function()
	admins = {}
end)
```

Then you can check this admin ability like this:
```lua
if adminList["Flash_Hit"] ~= nil and adminList["Flash_Hit"].canMovePlayers == true then
  -- Move player
end
```

The adminList for the player looks like this:
```lua
adminList[playerName] = {
  abilityCount = 0-13,
  canMovePlayers = true/false,
  canKillPlayers = true/false,
  canKickPlayers = true/false,
  canTemporaryBanPlayers = true/false,
  canPermanentlyBanPlayers = true/false,
  canEditGameAdminList = true/false,
  canEditBanList = true/false,
  canEditMapList = true/false,
  canUseMapFunctions = true/false,
  canAlterServerSettings = true/false,
  canEditReservedSlotsList = true/false,
  canEditTextChatModerationList = true/false,
  canShutdownServer = true/false
}
```

The mod provides following RCON commands:

```html
 gameAdmin.add <playerName> <bool canMovePlayers> <bool canKillPlayers> <bool canKickPlayers> <bool canTemporaryBanPlayers> <bool canPermanentlyBanPlayers> <bool canEditGameAdminList> <bool canEditBanList> <bool canEditMapList> <bool canUseMapFunctions> <bool canAlterServerSettings> <bool canEditReservedSlotsList> <bool canEditTextChatModerationList> <bool canShutdownServer>
 gameAdmin.clear
 gameAdmin.load
 gameAdmin.remove <playerName>
 gameAdmin.save
```

You can use the html to generate the RCON gameAdmin.add command.
<img src="https://image.prntscr.com/image/tbYyfnI3QJeI2s_fQAdq9A.jpeg"/>

