-- vim: ts=4 sw=4

math.randomseed(os.time())

require("movement")
require("rotation")

function newpiece()
	piece = {
		t = {},
		x = math.floor(width/2),
		y = 0
	}
	local t = tetra[math.random(#tetra)] --todo: replace #tetra with actual value
	for i = 4, 1, -1 do
		block = t[i]
		local contact = false
		for j = #heap, 1, -1 do
			if block.x + piece.x == heap[j].x and
			   block.y + piece.y == heap[j].y then
				contact = true
				break
			end
		end
		if contact then
			love.event.quit()
		else
			table.insert(piece.t, {x = block.x, y = block.y})
			keydown = false
			keyleft = false
			keyright = false
		end
	end
end

function love.load()
	width = 10
	height = 20
	bs = 20
	love.window.setMode(width*bs, height*bs)
	
	timestep = 0.30
	timer = 0
	keytimestep = 0.05
	keytimer = 0
	keypause = 5
	keydownpause, keyleftpause, keyrightpause = 0, 0, 0
	
	tetra = {
		{{x=1, y=1}, {x=1, y=2}, {x=2, y=2}, {x=2, y=1}}, --o
		{{x=2, y=0}, {x=2, y=1}, {x=1, y=1}, {x=1, y=2}}, --z
		{{x=1, y=0}, {x=1, y=1}, {x=2, y=1}, {x=2, y=2}}, --s
		{{x=0, y=1}, {x=1, y=1}, {x=2, y=1}, {x=3, y=1}}, --|
		{{x=1, y=0}, {x=2, y=0}, {x=2, y=1}, {x=2, y=2}}, --L
		{{x=2, y=0}, {x=1, y=0}, {x=1, y=1}, {x=1, y=2}}, --r
		{{x=1, y=1}, {x=2, y=1}, {x=3, y=1}, {x=2, y=2}}  --T
	}
	heap = {}
	newpiece()
end

function love.update(dt)
	if keydown or keyleft or keyright then
		keytimer = keytimer + dt
		if keytimer > keytimestep then
			keytimer = 0
			if keydown then
				if keydownpause > 0 then keydownpause = keydownpause - 1
				else movepiecedown() end
			end
			if keyleft then
				if keyleftpause > 0 then keyleftpause = keyleftpause - 1
				else movepieceleft() end
			end
			if keyright then
				if keyrightpause > 0 then keyrightpause = keyrightpause - 1
				else movepieceright() end
			end
		end
	end
	timer = timer + dt
	if timer > timestep then
		timer = 0
		movepiecedown()
	end
end

function love.draw()
	love.graphics.rectangle("line", 0, 0, width * bs, height * bs)
	for i = 1, #piece.t do
		love.graphics.rectangle("fill",
			(piece.t[i].x + piece.x) * bs,
			(piece.t[i].y + piece.y) * bs,
			bs, bs
		)
	end
	for i = 1, #heap do
		love.graphics.rectangle("line", heap[i].x * bs, heap[i].y * bs, bs, bs)
	end
end

function love.keypressed(k)
	if k == "left" then
		keyleft = true
		keyleftpause = keypause
		movepieceleft()
	elseif k == "right" then
		keyright = true
		keyrightpause = keypause
		movepieceright()
	elseif k == "down" then
		keydown = true
		keydownpause = keypause
		movepiecedown()
	elseif k == "z" then
		rotatepiece(false)
	elseif k == "x" then
		rotatepiece(true)
	end
end

function love.keyreleased(k)
	if k == "left" then
		keyleft = false
	elseif k == "right" then
		keyright = false
	elseif k == "down" then
		keydown = false
	end
end

function love.run()
	math.randomseed(os.time())
	math.random() math.random()

	if love.load then love.load(arg) end

	local dt = 0

	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
			for e,a,b,c,d in love.event.poll() do
				if e == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return
					end
				end
				love.handlers[e](a,b,c,d)
			end
		end

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
		if love.graphics then
			love.graphics.clear()
			if love.draw then love.draw() end
		end

		if love.timer then love.timer.sleep(0.01) end
		if love.graphics then love.graphics.present() end

	end

end
