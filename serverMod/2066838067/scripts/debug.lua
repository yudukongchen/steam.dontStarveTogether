function PrintTable( tbl ,maxlevel, level)
--return
	if tbl then
		local msg = ""
		level = level or 1
		maxlevel = maxlevel or 2
		if level > maxlevel then
			return 
		end
		local indent_str = ""
		for i = 1, level do
		indent_str = indent_str.."--"
		end
		indent_str = indent_str.."->"
		if level == 1 then
		print("【BEGIN】")
		end
		print(indent_str .."{")
		for k,v in pairs(tbl) do
			local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
			print(item_str)
			if type(v) == "table" then
				PrintTable(v,maxlevel, level + 1)
			end
		end
		print(indent_str .. "}")
		if level == 1 then
		print("【END】")
		end
	else
	print("【TableIsNull】")
	end
end


