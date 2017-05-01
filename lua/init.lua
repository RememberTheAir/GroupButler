redis = require 'resty.redis' -- Load redis client
pgmoon = require 'pgmoon' -- Load postgres client
json = require 'cjson' -- Load json library
http = require 'resty.http' -- Load resty http library
config = require 'config' -- Load configuration file
i18n = require 'i18n' -- Load localization library
api = require 'methods' -- Load Telegram API
db = require 'database' -- Load database helper functions
u = require 'utilities' -- Load miscellaneous and cross-plugin functions

i18n.loadFile('i18n/core.lua') -- Load core localization
i18n.setLocale(config.lang) -- Set core localization

for i,plugin in ipairs(config.plugins) do -- Load plugins localization
	i18n.loadFile('i18n/' .. plugin .. '.lua')
end

plugins = {} -- Load plugins.
for i,v in ipairs(config.plugins) do
	local p = require('plugins.'..v)
	package.loaded['plugins.'..v] = nil
	if p.triggers then
		for funct, trgs in pairs(p.triggers) do
			for i = 1, #trgs do
				-- interpret any whitespace character in commands just as space
				trgs[i] = trgs[i]:gsub(' ', '%%s+')
			end
			if not p[funct] then
				p.trgs[funct] = nil
				print(funct..' triggers ignored in '..v..': '..funct..' function not defined')
			end
		end
	end
	table.insert(plugins, p)
end

local function bot_init() -- Warns the admin when the bot is started
	local temp = os.date("*t")
	temp["plugins"] = #plugins
	api.sendAdmin(i18n('bot_started',temp), true)
	start_timestamp = os.time()
	current = {h = 0}
	last = {h = 0}
end

-- bot_init() -- Disabled. cosockets are not available from the init context, we have to find a
