-- Get the required services
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

--thing

local function GetAssetList()
		local url = "https://api.github.com/repos/pizzellefromsugaryspire/SonicExe-TheForsaken/git/trees/main?recursive=1"
		local assetList = {}

		local success, errorMessage = pcall(function()
			local Request = http_request or syn.request or request
			if Request then
				local response = Request({
					Url = url,
					Method = "GET",
					Headers = { ["Content-Type"] = "application/json" },
				})

				if response and response.Body then
					local data = game:GetService("HttpService"):JSONDecode(response.Body)
					for _, item in ipairs(data.tree) do
						if
							item.path:match("^Assets/.+%.png$")
							or item.path:match("^Assets/.+%.mp4$")
							or item.path:match("Assets/(.+)%.mp3$")
							or item.path:match("^Assets/.+%.wav$")
						then
							local rawUrl = "https://raw.githubusercontent.com/pizzellefromsugaryspire/SonicExe-TheForsaken/main/" .. item.path
							table.insert(assetList, rawUrl)

							local name = item.path:match("Assets/(.+)%.png$") or item.path:match("Assets/(.+)%.mp4$")
							if name then
								table.insert(NameProtectNames, name)
							end
						end
					end
				end
			end
		end)

		if not success then
			print("nonono you cant do that")
		end
		return assetList
	end

local function DownloadBallers(url, path)
		if not isfile(path) then
			local suc, res = pcall(function()
				return game:HttpGet(url, true)
			end)
			if not suc or res == "404: Not Found" then
				print("WRONG")
			end
			writefile(path, res)
		end
	end

local function CheckIfAudiosDownloaded()
		local assetList = GetAssetList()
		local basePath = "theforsaken/Assets/"
		if not isfolder("theforsaken") then
			makefolder("theforsaken")
		end
		if not isfolder(basePath) then
			makefolder(basePath)
		end
		for _, url in ipairs(assetList) do
			local filePath = basePath .. url:match("Assets/(.+)")
			if filePath then
				local newFilePath =
					filePath:gsub("%.png$", ".frskng"):gsub("%.mp4$", "frsk4"):gsub("%.mp3$", ".frsk3"):gsub("%.wav$", ".frsk")
				if not isfile(newFilePath) then
					local folderPath = newFilePath:match("(.*/)")
					if folderPath and not isfolder(folderPath) then
						makefolder(folderPath)
					end
					DownloadBallers(url, newFilePath)
				end
			end
		end
	end

CheckIfAudiosDownloaded()


-- Mapping of old SoundIds to new replacements
local soundReplacements = {
    [133273560899979] = getcustomasset("theforsaken/Assets/Fuck.frsk"),
	[12119890576] = getcustomasset("theforsaken/Assets/what.frsk3"),
	[6785997143] = getcustomasset("theforsaken/Assets/huh.frsk3"), --hill finale
	[103949533369117] = getcustomasset("theforsaken/Assets/yeah.frsk3"), --base finale
	[140650920518971] = getcustomasset("theforsaken/Assets/cupcakeselect.frsk3") -- not perfect select
    [18957584009] = getcustomasset("theforsaken/Assets/cupcakes.frsk3") -- not perfect
    [122213380433287] = getcustomasset("theforsaken/Assets/cupcakesSCARY.frsk3") -- not perfect finale
}

-- Function to check and replace sound ID
local function replaceSoundId()
    local currentSound = SoundService.mainSounds:FindFirstChild("current")
    if currentSound and currentSound:IsA("Sound") then
        local currentId = tonumber(currentSound.SoundId:match("%d+")) -- Extract numeric part
        if soundReplacements[currentId] then
            currentSound.SoundId = soundReplacements[currentId] -- Replace with new ID
            print("Replaced SoundId:", currentId, "->", currentSound.SoundId)
        end
    end
end

-- Infinite loop to constantly check and replace sound
RunService.Heartbeat:Connect(replaceSoundId)


--	[114805617662705] = getcustomasset("theforsaken/Assets/Shit.frsk"), --base
--	[103949533369117] = getcustomasset("theforsaken/Assets/Bitch.frsk"), --finale base
--	[13346317174] = getcustomasset("theforsaken/Assets/Riggity.frsk") --hill select
--	[12119890576] = getcustomasset("theforsaken/Assets/what.frsk3") --hill ambience
--	[6785997143] = getcustomasset("theforsaken/Assets/huh.frsk") --hill finale
--	[7017400992] = getcustomasset("theforsaken/Assets/.frsk") --hill gameover i think
