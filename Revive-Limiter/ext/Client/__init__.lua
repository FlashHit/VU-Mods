class 'ReviveLimiter'

function ReviveLimiter:__init()
	print("Initializing ReviveLimiter")
	self:RegisterVars()
	self:RegisterEvents()
end

function ReviveLimiter:RegisterVars()
	self.coolDownSeconds = 15
	self.reviveAmount = 2
	self.checkTimeOfDeath = false
	self.timeOfDeath = 0
	self.timeOfLastDeath = 0
	self.differenceSeconds = 0
	self.deathCounter = 0
end

function ReviveLimiter:RegisterEvents()
	Events:Subscribe('Soldier:HealthAction', self, self.OnHealthAction)
end

function ReviveLimiter:OnHealthAction(soldier, action)
	if action == 6 then
		self.timeOfDeath = os.date ("%H")*3600 + os.date ("%M")*60 + os.date ("%S")
		self.differenceSeconds = self.timeOfDeath - self.timeOfLastDeath
		if self.differenceSeconds >= self.coolDownSeconds then
			self.deathCounter = 0
		end
		self.deathCounter = self.deathCounter + 1
		self.timeOfLastDeath = self.timeOfDeath
		if self.deathCounter > self.reviveAmount then
			NetEvents:Send("Player:ForceDead")
			self.deathCounter = 0
			self.timeOfLastDeath = 0
		end
	end
end
g_reviveLimiter = ReviveLimiter()
