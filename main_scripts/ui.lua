--UI新增和修改

AddClassPostConstruct("widgets/controls", function(self)
	--添加新UI
	local mod_version = env.modinfo.version
	if mod_version == "dev" then
		self.xp = self:AddChild(Text(UIFONT, 16, "x正"))
		self.xn = self:AddChild(Text(UIFONT, 16, "x负"))
		self.zp = self:AddChild(Text(UIFONT, 16, "z正"))
		self.zn = self:AddChild(Text(UIFONT, 16, "z负"))

		self.inst:DoPeriodicTask(FRAMES, function()
			local pos = ThePlayer:GetPosition()
			self.xp:SetPosition(TheSim:GetScreenPos((pos + Vector3(1.2, 0, 0)):Get()))
			self.xn:SetPosition(TheSim:GetScreenPos((pos + Vector3(-1.2, 0, 0)):Get()))
			self.zp:SetPosition(TheSim:GetScreenPos((pos + Vector3(0, 0, 1.2)):Get()))
			self.zn:SetPosition(TheSim:GetScreenPos((pos + Vector3(0, 0, -1.2)):Get()))
		end)
	end
end)