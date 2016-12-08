for x = 40, 5000, 1 do
--	out = " " ; for ii = 1, math.floor(math.sin(x/5)*20+30) do out = out .. " " end
--	print(out.."[44m [0m")
	print("["..x..";"..math.floor(math.sin(x/5)*20+30).."H[44m [0m\n")
	os.execute("sleep 0.1")
end
