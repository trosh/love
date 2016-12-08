function drawBlock(x, y, z)
	love.graphics.setColor(130-15*z, 130-15*z, 130-15*z)
	love.graphics.rectangle("fill", (x-camx)*sr, (y-camy)*sr-(z-1)*sr/2, -sr, -sr/2)
	love.graphics.setColor(235-15*z, 235-15*z, 235-15*z)
	love.graphics.rectangle("fill", (x-camx)*sr, (y-camy)*sr-z*sr/2, -sr, -sr)
end
