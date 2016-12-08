function love.load()
	w = 30 ; h = 30 ; r = 15
	love.graphics.setMode(w*r, h*r)
	love.graphics.setLineWidth(2)
	score = 0 ; high_score = 0
	loader()
	wait = 0
end
function love.update(dt)
	wait = wait + dt
	if wait > speed then wait = 0
		i = 2 ; while m[i] ~= nil do m[i-1] = m[i] ; i = i+1 end ; if i > 2 then m[i-1] = nil end
		sizem = i-1 ; if i > 2 then sizem = sizem - 1 end
		xx = m[1].x ; yy = m[1].y
		for i = size, 2, -1 do
			s[i].x = s[i-1].x
			s[i].y = s[i-1].y
		end
		s[1].x = s[1].x + xx ; if s[1].x == -1 then s[1].x = w-1 elseif s[1].x == w then s[1].x = 0 end
		s[1].y = s[1].y + yy ; if s[1].y == -1 then s[1].y = h-1 elseif s[1].y == h then s[1].y = 0 end
		test = 1
		for ii = 0, 2, 2 do for i = 1, 2 do if s[1].x == warp[i+ii].x and s[1].y == warp[i+ii].y then s[1].x = warp[3+2*ii-i-ii].x ; s[1].y = warp[3+2*ii-i-ii].y ; addw(ii) end end end
		for i = 3, size do
			if test == 1 and s[i].x == s[1].x and s[i].y == s[1].y then test = 0;love.timer.sleep(300) ; loader() end
		end
		for i = 1, sizef do
			if f[i].x == s[1].x and f[i].y == s[1].y then
				score = score + 1
				sizef = sizef - 1
				for ii = i, sizef do f[ii] = f[ii+1] end
				add(s[size].x, s[size].y) ; add(s[size].x, s[size].y) ; add(s[size].x, s[size].y)
				addf()
				speed = speed * 0.97
			end
		end
	end
end
function love.draw()
	love.graphics.setColor(20, 200, 20) ; for i = 1, sizef do
		love.graphics.rectangle("fill", f[i].x*r, f[i].y*r, r, r)
	end
	for i = 1, 2 do for ii = 0, 2, 2 do
		love.graphics.setColor(150+(ii)*30, 0, 150-(ii)*30)
		love.graphics.rectangle("fill", warp[i+ii].x*r, warp[i+ii].y*r, r, r)
	end end
	love.graphics.setColor(255, 255, 255)
	for i = 1, size do love.graphics.rectangle("fill", s[i].x*r, s[i].y*r, r, r) end
	love.graphics.print(score, 10, 10)
	love.graphics.print(high_score, 10, 20)
end
function love.keypressed(k)
	if k == "left"  and not (m[sizem].x==1 or m[sizem].x==-1) then addm(-1, 0) end
	if k == "right" and not (m[sizem].x==1 or m[sizem].x==-1) then addm(1, 0)  end
	if k == "up"    and not (m[sizem].y==1 or m[sizem].y==-1) then addm(0, -1) end
	if k == "down"  and not (m[sizem].y==1 or m[sizem].y==-1) then addm(0, 1)  end
	if k == "r" then loader() end
	if k == "[" and w >= 10 then if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then speed = speed / 0.9 else w = w - 10 ; h = h - 10 ; love.graphics.setMode(w*r, h*r) end end
	if k == "]" then if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then speed = speed * 0.9 else w = w + 10 ; h = h + 10 ; love.graphics.setMode(w*r, h*r) end end
	
end
function add(X, Y)
	size = size + 1
	s[size] = {} ; s[size].x = X ; s[size].y = Y
end
function addf()
	local X = math.random(w-1)
	local Y = math.random(h-1)
	local hit = 0 ; while hit == 0 do
		hit = 1 ; for i = 1, size do
			if s[i].x == X and s[i].y == Y then X = math.random(w-1); Y = math.random(h-1) ; hit = 0 end
		end
		for i = 1, 2 do if warp[i].x == X and warp[i].y == Y then hit = 0 end end
	end
	sizef = sizef + 1
	f[sizef] = {} ; f[sizef].x = X ; f[sizef].y = Y
	if math.floor(math.random()+0.1) == 1 then addf() end
end
function addm(X, Y)
	sizem = 2 ; while m[sizem] ~= nil do sizem = sizem + 1 end
	m[sizem] = {} ; m[sizem].x = X ; m[sizem].y = Y
end
function addw(W)
	for n = 1, 2 do
		local X = math.random(w-1)
		local Y = math.random(h-1)
		local hit = 0 ; while hit == 0 do
			hit = 1
			for i = 1, size do
				if s[i].x == X and s[i].y == Y then X = math.random(w-1); Y = math.random(h-1) ; hit = 0 end
			end
			for i = 1, sizef do
				if f[i].x == X and f[i].y == Y then X = math.random(w-1); Y = math.random(h-1) ; hit = 0 end
			end
		end
		warp[n+W].x = X ; warp[n+W].y = Y
	end
end
function loader()
	size = 0 ; s = {{}}
	add(math.floor(w/2), math.floor(h/2)) ; for i = 1, 5 do add(s[size].x, s[size].y) end
	warp = {{}, {}, {}, {}} ; f = {{}}
	sizef = 0 ; addf()
	m = {{}} ; m[1].x = 1 ; m[1].y = 0
	addw(0) ; addw(2)
	xx = 1 ; yy = 0
	if score > high_score then high_score = score end ; score = 0
	speed = 0.12
end
