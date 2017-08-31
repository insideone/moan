require("Moan/Moan")

Camera = require("libs.camera")
flux = require("libs.flux")

function love.load()
	-- The FontStruction “Pixel UniCode” (https://fontstruct.com/fontstructions/show/908795)
	-- by “ivancr72” is licensed under a Creative Commons Attribution license
	-- (http://creativecommons.org/licenses/by/3.0/).
	Moan.font = love.graphics.newFont("assets/Pixel UniCode.ttf", 32)

	-- Add font fallbacks for Japanese characters
	JPfallback = love.graphics.newFont("assets/JPfallback.ttf", 32)
	Moan.font:setFallbacks(JPfallback)

	-- Audio from bfxr
	Moan.typeSound = love.audio.newSource("assets/typeSound.wav", "static")
	Moan.optionSound = love.audio.newSource("assets/optionSound.wav", "static")
	Moan.typeSound:setVolume(0.5)
	Moan.optionSound:setVolume(0.5)

	love.graphics.setBackgroundColor(100, 100, 100, 255)
	math.randomseed(os.time())

	-- Make some objects
	p1 = { x=100, y=200 }
	p2 = { x=400, y=150 }
	p3 = { x=200, y=300 }

	-- Create a HUMP camera and pass it to Moan
	camera = Camera(p1.x, p1.y)
	Moan.setCamera(camera)

	-- Set up our image for image argument in Moan.new config table
	avatar = love.graphics.newImage("assets/Obey_Me.png")

	-- Put some messages into the Moan queue
	Moan.new("Möan.lua", {"Hello World!"}, {image=avatar})
	Moan.new("Tutorial", {"Möan.lua is a simple to use messagebox library, it includes;", "Multiple choices,--UTF8 text,--Pauses,--Optional camera control,--Onstart/Oncomplete functions,--Complete customization,--Variable typing speeds umongst other things."},
			{x=p2.x, y=p2.y, image=avatar, onstart=function() rand() end})
	Moan.new("Tutorial", {"Typing sound modulates with speed..."}, {onstart=function() Moan.setSpeed("slow") end, oncomplete=function() Moan.setSpeed("fast") end})
	Moan.new("Tutorial", {"Here's some options:"}, {
			options={{"Red", function() red() end},
					 {"Blue", function() blue() end},
					 {"Green", function() green() end}}})
end

function love.update(dt)
	flux.update(dt)
	Moan.update(dt)

	-- Move the camera around
	camera:rotate(0.01)
end

function love.draw()
	-- Attach the HUMP camera to the objects
    camera:attach()
		love.graphics.rectangle("fill", p1.x, p1.y, 16, 16)
		love.graphics.rectangle("fill", p2.x, p2.y, 16, 16)
		love.graphics.rectangle("fill", p3.x, p3.y, 16, 16)
    camera:detach()

    -- Moan.draw() should be drawn last since we want it to be ontop of everything else
	Moan.draw()
end

function love.keyreleased(key)
	Moan.keyreleased(key)

	if key == "f" then
		Moan.advanceMsg()
	elseif key == "c" then
		Moan.clearMessages()
	elseif key == "p" then
		Moan.pause()
	elseif key == "o" then
		Moan.resume()
	elseif key == "s" then
		Moan.new("Title", {"Message one", "two", "and three..."}, {onstart=function() rand() end})
	end
end

function rand()
	love.graphics.setBackgroundColor(math.random(255), math.random(255), math.random(255))
end

function red()
	love.graphics.setBackgroundColor(255,0,0)
	Moan.new("Hey!", {"You picked Red!"})
	moreMessages()
end

function blue()
	love.graphics.setBackgroundColor(0,0,255)
	Moan.new("Hey!", {"You picked Blue!"})
	moreMessages()
end

function green()
	love.graphics.setBackgroundColor(0,255,0)
	Moan.new("Hey!", {"You picked Green!"})
	moreMessages()
end

function moreMessages()
	Moan.new("Message queue", {"Each message is added to a \"message queue\", i.e. they're presented in the order that they're called. This is part of the design of Möan.lua"}, {x=p1.x, y=p1.y, onstart=function() rand() end})
	Moan.new("UTF8 example", {"アイ・ドーント・ノー・ジャパニーズ・ホープフリー・ジス・トランズレーター・ダズント・メス・ジス・アップ・トゥー・マッチ"})
	Moan.new("Goodbye", {"See ya around!"}, {x=p3.x, y=p3.y, oncomplete=function() rand() end})
end