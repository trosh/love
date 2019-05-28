function rotatepiece(right)
	local pr = {}
	local contact = false
	for i = 1, #piece.t do
		block = piece.t[i]
		if right then
			pr[i] = {
				x = 3 - block.y,
				y = block.x
			}
		else
			pr[i] = {
				x = block.y,
				y = 3 - block.x
			}
		end
		--check if anything is sticking out
		if pr[i].x + piece.x < 0 or
		   pr[i].x + piece.x >= width or
		   pr[i].y + piece.y >= height then
			contact = true
			break
		end
		if contact then break end
		--check if anything is sticking into anything else
		for h = 1, #heap do
			if pr[i].y + piece.x == heap[h].x and
			   pr[i].y + piece.y == heap[h].y then
				contact = true
				break
			end
		end
		if contact then break end
	end
	if not contact then
		piece.t = {}
		for i, block in ipairs(pr) do
			piece.t[i] = {
				x = block.x,
				y = block.y
			}
		end
	end
end
