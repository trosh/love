function reload()
	sx = 25
    sy = 25
    sz = 5
    sr = 40
	camx = 5
    camy = 5
	world = {}
	for x = 1, sx do
        world[x] = {}
        for y = 1, sy do
            world[x][y] = {}
            for z = 1, sz do
                world[x][y][z] = nil
            end
        end
    end
	for x = 15, 17 do
        for y = 15, 17 do
            world[x][y][1] = 1
        end
    end
    world[16][16][2] = 1
	grid = 0
    edit = 0
    view = 1
	selection = {{}, {}}
	waitleft = 0
    waitright = 0
    waitup = 0
    waitdown = 0
	love.window.setMode(15*sr, 15*sr)
	love.graphics.setLineWidth(2)
	p = {}
    p.x = math.floor(sx/2)
    p.y = math.floor(sy/2)
    p.z = getMaxZ(p.x, p.y)
	m = {}
    m.x = math.floor(sx/2)+7
    m.y = math.floor(sy/2)+7
    m.z = getMaxZ(m.x, m.y)
end

