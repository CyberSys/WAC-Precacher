if SERVER then
	AddCSLuaFile() // Send file to clients
	util.AddNetworkString("wac-precache")
	
	hook.Add("PlayerInitialSpawn", "wac-precache", function(ply)
		net.Start("wac-precache") net.Send(ply)
	end)
elseif CLIENT then
	local function precachewac()
		local c=0
		for k,v in pairs(scripted_ents.GetList()) do
			 if v.t.Category and string.sub(v.t.Category,1,3)=="WAC" and v.t.Spawnable then
				if v.t.Model then
					util.PrecacheModel(v.t.Model)
					c=c+1
				end
				if v.t.TopRotor then 
					util.PrecacheModel(v.t.TopRotor.model)
				end
				if v.t.BackRotor then 
					util.PrecacheModel(v.t.BackRotor.model)
				end
				if v.t.RotorModel then
					util.PrecacheModel(v.t.RotorModel)
				end
				if v.t.Sounds then
					for _,s in pairs(v.t.Sounds) do
						if type(s)=="string" and s:len()>0 then
							util.PrecacheSound(s)
						end
					end
				end
				if v.t.Wheels then
					for _,w in pairs(v.t.Wheels) do
						if w.mdl then
							util.PrecacheModel(w.mdl)
						end
					end
				end
				if v.t.Camera and v.t.Camera.model then
					util.PrecacheModel(v.t.Camera.model)
				end
				if v.t.WeaponAttachments then
					for _,a in pairs(v.t.WeaponAttachments) do
						if a.model then
							util.PrecacheModel(a.model)
						end
					end
				end
				if v.t.Weapons then
					for _,w in pairs(v.t.Weapons) do
						if w.info and w.info.Sounds then
							for _,s in pairs(w.info.Sounds) do
								if type(s)=="string" and s:len()>0 then
									util.PrecacheSound(s)
								end
							end
						end
					end
				end
			end
		end
		print("Precached "..c.." WAC aircraft.")
	end
	net.Receive("wac-precache", precachewac)
end