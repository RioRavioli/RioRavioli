class Overworld
	@@map = [["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],  
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "FLT", "FMT", "FM2T", "FRT", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "FLTE", "FMM", "FM2M", "FRTE", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "FLT", "FTRE", "FM2M2", "FMM2", "FM2M2", "FMM2", "FTLE", "FRT", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "FLB", "FBRE", "FM2M", "FMM", "FM2M", "FMM", "FBLE", "FRB", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "FLBE", "FMM2", "FM2M2", "FRBE", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "FLB", "FMB", "FM2B", "FRB", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "G", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"],
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"], 
				["O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O", "O"]] 

	def self.getMap
		return @@map
	end
end
