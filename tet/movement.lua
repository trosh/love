function checkline()
	for y = 0, height - 1 do
		local line = true
		for x = 0, width - 1 do
			local hblock = false
			for i = #heap, 1, -1 do
				if heap[i].x == x and heap[i].y == y then
					hblock = true
					break
				end
			end
			if not hblock then
				line = false
				break
			end
		end
		if line then
			for i = #heap, 1, -1 do
				if heap[i].y == y then
					table.remove(heap, i)
				elseif heap[i].y < y then
					heap[i].y = heap[i].y + 1
				end
			end
		end
	end
end

function movepiecedown()
	local contact = false
	for _, block in ipairs(piece.t) do
		if block.y + piece.y == height - 1 then
			contact = true
			break
		end
		for _, hblock in ipairs(heap) do if hblock ~= nil then
			if block.x + piece.x == hblock.x and
			   block.y + piece.y == hblock.y - 1 then
				contact = true
				break
			end
		end end
		if contact then break end
	end
	if contact then
		for _, block in ipairs(piece.t) do
			table.insert(heap, {
					x = block.x + piece.x,
					y = block.y + piece.y
				}
			)
		end
		newpiece()
		checkline()
	else
		piece.y = piece.y + 1
	end
end

function movepieceleft()
	local contact = false
	for _, block in ipairs(piece.t) do
		if block.x + piece.x == 0 then
			contact = true
			break
		end
		for _, hblock in ipairs(heap) do if hblock ~= nil then
			if block.y + piece.y == hblock.y and
			   block.x + piece.x == hblock.x + 1 then
				contact = true
			end
		end end
		if contact then break end
	end
	if not contact then
		piece.x = piece.x - 1
	end
end

function movepieceright()
	local contact = false
	for _, block in ipairs(piece.t) do
		if block.x + piece.x == width-1 then
			contact = true
			break
		end
		for _, hblock in ipairs(heap) do if hblock ~= nil then
			if block.y + piece.y == hblock.y and
			   block.x + piece.x == hblock.x - 1 then
				contact = true
			end
		end end
		if contact then break end
	end
	if not contact then
		piece.x = piece.x + 1
	end
end
