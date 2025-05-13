return {
	decimalToBits = @native function(numba: number): string
		local bits: string = ""
		while numba > 0 do
			local bit: number = numba % 2
			bits = bit..bits
			numba //= 2
		end
		while #bits % 4 ~= 0 do
			bits = "0"..bits
		end
		local formattedBits: string = ""
		for i: number = 1, #bits do
			formattedBits ..= bits:sub(i, i)
			if i % 4 == 0 and i < #bits then
				formattedBits ..= " "
			end
		end
		return formattedBits
	end
}
