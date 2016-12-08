require("reload")
require("draw")
--require("debug")

function love.load()
	reload()
end

function love.update(dt) --update key or mouse presses
	if love.mouse.isDown(1, 2) and
       edit == 1 then
		selection[2].x = math.floor(love.mouse.getX()/sr) + 1 + camx
		selection[2].y = math.floor(love.mouse.getY()/sr) + 1 + camy
	end
	if love.keyboard.isDown("left") then
		if waitleft > 0.3 then
			if p.x > camx+1 and
               math.abs(p.z-getMaxZ(p.x-1, p.y))<=1 then
				p.x = p.x-1
                p.z = getMaxZ(p.x, p.y)
                waitleft = 0.15
                mvScreen(-1, 0)
            end
		else
            waitleft = waitleft + dt
        end
	elseif waitleft ~= 0 then
        waitleft = 0
	end
	if love.keyboard.isDown("right") then
		if waitright > 0.3 then
			if p.x < camx+15 and
               math.abs(p.z-getMaxZ(p.x+1, p.y)) <= 1 then
				p.x = p.x+1
                p.z = getMaxZ(p.x, p.y)
                waitright = 0.15
                mvScreen(1, 0)
            end
		else
            waitright = waitright + dt
        end
	elseif waitright ~= 0 then
        waitright = 0
	end
	if love.keyboard.isDown("up") then
		if waitup > 0.3 then
			if p.y > camy+1 and
               math.abs(p.z-getMaxZ(p.x, p.y-1)) <= 1 then
				p.y = p.y-1
                p.z = getMaxZ(p.x, p.y)
                waitup = 0.15
                mvScreen(0, -1)
            end
		else
            waitup = waitup + dt
        end
	elseif waitup ~= 0 then
        waitup = 0
	end
	if love.keyboard.isDown("down") then
		if waitdown > 0.3 then
			if p.y < camy+15 and
               math.abs(p.z-getMaxZ(p.x, p.y+1)) <= 1 then
				p.y = p.y+1
                p.z = getMaxZ(p.x, p.y)
                waitdown = 0.15
                mvScreen(0, 1)
            end
		else
            waitdown = waitdown + dt
        end
	elseif waitdown ~= 0 then
        waitdown = 0
	end
end

function love.draw()
	love.graphics.setColor(250, 200, 70)
	love.graphics.rectangle("fill", 0, 0, 15*sr, 15*sr)
	if view == 1 then
		for y = camy, camy+15 do
            for z = 0, sz do
                -- draw every block from world[][][] array
                for x = camx, camx+15 do
                    -- draw blocks of type 1
                    if world[x][y][z] == 1 then
                        drawBlock(x, y, z)
                        -- draw shadows around elevated blocks
                        if getMaxZ(x, y) > 0 and
                           x > 1 and x < sx and
                           y > 0 and y < sy then
                            love.graphics.setColor(40, 40, 40, 145)
                            if world[x-1][y][z] == nil then
                                love.graphics.line(
                                    (x-camx-1)*sr + 1,
                                    (y-camy-1)*sr - z*sr/2,
                                    (x-camx-1)*sr + 1,
                                    (y-camy  )*sr - z*sr/2)
                            end
                            if world[x+1][y][z] == nil then
                                love.graphics.line(
                                    (x-camx  )*sr - 1,
                                    (y-camy-1)*sr - z*sr/2,
                                    (x-camx  )*sr - 1,
                                    (y-camy  )*sr - z*sr/2)
                            end
                            if world[x][y-1][z] == nil then
                                love.graphics.line(
                                    (x-camx-1)*sr,
                                    (y-camy-1)*sr - z*sr/2+1,
                                    (x-camx  )*sr,
                                    (y-camy-1)*sr - z*sr/2+1)
                            end
                        end
                    end
                    -- draw character
                    if p.y == y and
                       (p.z == z or
                        p.z == 0) and
                       p.x == x then
                        love.graphics.setColor(20, 20, 110, 125)
                        love.graphics.rectangle(
                            "fill",
                            (p.x-camx)*sr,
                            (p.y-camy)*sr - p.z*sr/2,
                            -sr, -sr)
                        love.graphics.setColor(30, 30, 190)
                        love.graphics.rectangle(
                            "fill",
                            (p.x-camx)*sr - sr/3,
                            (p.y-camy)*sr - (p.z+1)*sr/2,
                            -sr/3, -sr)
                    end
                end
            end
        end
        -- draw character again (fake tranparancies)
		love.graphics.setColor(20, 20, 110, 35)
		love.graphics.rectangle(
            "fill",
            (p.x-camx)*sr,
            (p.y-camy)*sr - p.z*sr/2,
            -sr, -sr)
		love.graphics.setColor(30, 30, 190, 50)
		love.graphics.rectangle(
            "fill",
            (p.x-camx)*sr - sr/3,
            (p.y-camy)*sr - (p.z+1)*sr/2,
            -sr/3, -sr)
		if edit == 1 then
            -- draw green cursor
			x = math.floor(love.mouse.getX()/sr)+1
            y = math.floor(love.mouse.getY()/sr)+1
			z = getMaxZ(x+camx, y+camy)
			love.graphics.setColor(40, 80, 40, 150)
			love.graphics.rectangle(
                "fill",
                x*sr, y*sr-z*sr/2,
                -sr, -sr)
		end
		if selection[1].x ~= nil then
            -- draw red selection box
			love.graphics.setColor(255, 0, 0, 220)
			if selection[1].x <= selection[2].x then
                smallx = 1
            else
                smallx = 2
            end
			if selection[1].y <= selection[2].y then
                smally = 1
            else
                smally = 2
            end
			for ix = selection[smallx].x, selection[3-smallx].x do
                for iy = selection[smally].y, selection[3-smally].y do
                    z = getMaxZ(ix, iy)
                    love.graphics.rectangle(
                        "fill",
                        (ix-camx)*sr,
                        (iy-camy)*sr - z*sr/2,
                        -sr, -sr)
                end
            end
		end
	elseif view == 0 then
		for x = camx, camx+15 do
            for y = camy, camy+15 do
                z = getMaxZ(x, y)
                if z > 0 then
                    love.graphics.setColor(255-20*z, 255-20*z, 255-20*z)
                    love.graphics.rectangle(
                        "fill",
                        (x-camx)*sr,
                        (y-camy)*sr,
                        -sr, -sr)
                end
            end
        end
        -- draw character base (color)
		love.graphics.setColor(20, 20, 110, 125)
        -- draw character base (rectangle)
		love.graphics.rectangle(
            "fill",
            (p.x-camx)*sr,
            (p.y-camy)*sr,
            -sr, -sr)
        -- draw character
		love.graphics.setColor(30, 30, 190)
        -- draw character (rectangle)
		love.graphics.rectangle(
            "fill",
            (p.x-camx)*sr-sr/3,
            (p.y-camy)*sr-sr/3,
            -sr/3, -sr/3)
		if edit == 1 then
            -- draw green cursor
			x = math.floor(love.mouse.getX()/sr)+1
            y = math.floor(love.mouse.getY()/sr)+1
			love.graphics.setColor(40, 80, 40, 150)
			love.graphics.rectangle("fill", x*sr, y*sr, -sr, -sr)
		end
	end
	if grid == 1 then
        -- draw red grid
		love.graphics.setColor(255, 0, 0, 100)
		for y = 1, sy-1 do
            love.graphics.line(0, y*sr, sx*sr, y*sr)
        end
		for x = 1, sx-1 do
            love.graphics.line(x*sr, 0, x*sr, sy*sr)
        end
	end
	love.graphics.setColor(250, 190, 40)
    --draw monster
	--[[
    love.graphics.circle(
        "fill",
        (m.x-camx)*sr,
        (m.y-camy)*sr,
        sr/2, 20)
    --]]
end

function love.mousepressed(x, y, k)
	x = math.floor(x/sr)+1+camx
    y = math.floor(y/sr)+1+camy
	if (k == 1 or
        k == 2) and
       edit == 1 and
       selection[1].x == nil then
		selection[1].x = x
        selection[1].y = y
		selection[2].x = x
        selection[2].y = y
	end
	print(k .. " : " ..
          x .. ", " ..
          y .. ", " ..
          getMaxZ(x, y))
end

-- modify terrain accordingly to selection release
function love.mousereleased(x, y, k)
	if k == 1 and
       edit == 1 and
       selection[1].x ~= nil then
		if selection[1].x <= selection[2].x then
            smallx = 1
        else
            smallx = 2
        end
		if selection[1].y <= selection[2].y then
            smally = 1
        else
            smally = 2
        end
		for ix = selection[smallx].x,
                 selection[3-smallx].x do
            for iy = selection[smally].y,
                     selection[3-smally].y do
                if getMaxZ(ix, iy) < sz then
                    world[ix][iy][getMaxZ(ix, iy)+1] = 1
                    if ix == p.x and
                       iy == p.y then
                        p.z = p.z + 1
                    end
                end 
            end
        end
	elseif k == 2 and edit == 1 and
           selection[1].x ~= nil then
		if selection[1].x <= selection[2].x then
            smallx = 1
        else
            smallx = 2
        end
		if selection[1].y <= selection[2].y then
            smally = 1
        else
            smally = 2
        end
		for ix = selection[smallx].x,
                 selection[3-smallx].x do
            for iy = selection[smally].y,
                     selection[3-smally].y do
                if getMaxZ(ix, iy) > 0 then
                    world[ix][iy][getMaxZ(ix, iy)] = nil
                    if ix == p.x and
                       iy == p.y then
                        p.z = p.z - 1
                    end
                end
            end
        end
	end
	selection = {{}, {}}
end

function love.keypressed(k)
	if k == "g" then grid = 1-grid end
	if k == "e" then edit = 1-edit end
	if k == "v" then view = 1-view end
	if k == "left" and
       p.x-2 >= camx and
       math.abs(p.z - getMaxZ(p.x-1, p.y)) <= 1 then
		mvScreen(-1, 0)
        p.x = p.x-1
        p.z = getMaxZ(p.x, p.y)
	end
	if k == "right" and
       p.x < camx+15 and
       math.abs(p.z-getMaxZ(p.x+1, p.y)) <= 1 then
		mvScreen(1, 0)
        p.x = p.x+1
        p.z = getMaxZ(p.x, p.y)
	end
	if k == "up" and
       p.y-2 >= camy and
       math.abs(p.z-getMaxZ(p.x, p.y-1)) <= 1 then
		mvScreen(0, -1)
        p.y = p.y-1
        p.z = getMaxZ(p.x, p.y)
	end
	if k == "down" and
       p.y < camy + 15 and
       math.abs(p.z-getMaxZ(p.x, p.y+1)) <= 1 then
		mvScreen(0, 1)
        p.y = p.y+1
        p.z = getMaxZ(p.x, p.y)
	end
end

-- returns z coordinate of highest block (returns 0 if there is no block)
function getMaxZ(x, y)
	if x >= 1 and x <= sx and
       y >= 1 and y <= sy then
		local z = 1
		local hit = 1
		while hit == 1 and z < 6 do
			if world[x][y][z] == nil then
                hit = 0
            end
			z = z + 1
		end
		if z == 6 and
           hit == 1 then
            return 5
        else
            return z - 2
        end
	end
end

-- move camera coordinates by x and y blocks
function mvScreen(x, y)
	if (x == -1 and camx > 1     and p.x <= camx+7) or
	   (x ==  1 and camx < sx-15 and p.x >  camx+7) or
	   (y == -1 and camy > 1     and p.y <= camy+7) or
	   (y ==  1 and camy < sy-15 and p.y >  camy+7) then
		camx = camx + x
		camy = camy + y
	end
end

