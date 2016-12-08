for x = 50, 200 do
	print("["..x..";"..math.floor(math.sin(x/5)*20+30).."H[44m [0m\n")
	os.execute("sleep 0.05")
end
