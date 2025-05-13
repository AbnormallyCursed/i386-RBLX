--!strict
--!native

-- TODO: if le fats wants 512, 256, or 128 bit float, we prob need to talk about it
-- XMM registers are 128 bits so I just excluded them until then

-- formatting convention: all caps indicate a direct index into the buffer, all lowercase indicate a table filled with buffers

return {
	register_priority = {
		"gp_reg",
		"r_reg",
		"dr_reg",
		"cr_reg",
		"FP_DP2",
		"SS",
		"TR",
		"FP_OPC",
		"RFLAGS",
		"TW",
		"SW",
		"MXCSR",
		"FP_DP1",
		"FP_IP2",
		"IDTR",
		
		"FP_IP1",
		"CS",
		"GDTR",
		"ES",
		"DS",
		"GS",
		"FS",
		"FP_DS",
		"CW",
		"FP_CS",
		"LDTR",
		"mm_reg",
	},
	registerEncoding = {
		gp_reg = {
			encoding = {0, 7},
			size = 32,
			alias = {
				{"RAX", "RCX", "RDX", "RBX", "RSP", "RBP", "RSI", "RDI"},
				{"EAX", "ECX", "EDX", "EBX", "ESP", "EBP", "ESI", "EDI"},
				{"AX",  "CX",  "DX",  "BX",  "SP",  "BP",  "SI",  "DI"},
				{"AL",  "CL",  "DL",  "BL",  "SPL", "BPL", "SIL", "DIL"},
			},
		},
		r_reg = {
			encoding = {0, 7},
			size = 32,
			alias = {
				{"R8",  "R9",  "R10",  "R11",  "R12",  "R13",  "R14",  "R15"},
				{"R8D", "R9D", "R10D", "R11D", "R12D", "R13D", "R14D", "R15D"},
				{"R8W", "R9W", "R10W", "R11W", "R12W", "R13W", "R14W", "R15W"},
				{"R8B", "R9B", "R10B", "R11B", "R12B", "R13B", "R14B", "R15B"},
			},
		},
		dr_reg = {
			encoding = {0, 15},
			size = 32,
			alias = {
				{"DR0", "DR1", "DR2",  "DR3",  "DR4",  "DR5",  "DR6",  "DR7", "DR8", "DR9", "DR10", "DR11", "DR12", "DR13", "DR14", "DR15"},
			},
		},
		cr_reg = {
			encoding = {0, 15},
			size = 32,
			alias = {
				{"MSW"},
				{"CR0", "CR1", "CR2",  "CR3",  "CR4",  "CR5",  "CR6",  "CR7", "CR8", "CR9", "CR10", "CR11", "CR12", "CR13", "CR14", "CR15"},
			},
		},
		mm_reg = {
			encoding = {0, 15},
			size = 64, -- ST(0-7) is 80 bits
			alias = {
				{"MM0", "MM1", "MM2",  "MM3",  "MM4",  "MM5",  "MM6",  "MM7", "ST0", "ST1", "ST2",  "ST3",  "ST4",  "ST5",  "ST6",  "ST7"},
			},
		},
		
		-- SEGMENTATION:
		CS = {
			encoding = nil,
			size = 16,
		},
		SS = {
			encoding = nil,
			size = 16,
		},
		DS = {
			encoding = nil,
			size = 16,
		},
		ES = {
			encoding = nil,
			size = 16,
		},
		FS = {
			encoding = nil,
			size = 16,
		},
		GS = {
			encoding = nil,
			size = 16,
		},
		
		GDTR = {
			encoding = nil,
			size = 16,
		},
		IDTR = {
			encoding = nil,
			size = 16,
		},
		TR = {
			encoding = nil,
			size = 16,
		},
		LDTR = {
			encoding = nil,
			size = 16,
		},
		
		-- FLOATING POINT MISC REGISTERS:
		CW = {
			encoding = nil,
			size = 16,
		},
		FP_CS = {
			encoding = nil,
			size = 16,
		},
		SW = {
			encoding = nil,
			size = 16,
		},
		TW = {
			encoding = nil,
			size = 16,
		},
		FP_DS = {
			encoding = nil,
			size = 16,
		},
		FP_OPC = {
			encoding = nil,
			size = 16,
		},
		FP_IP1 = {
			encoding = nil,
			size = 16,
		},
		FP_DP1 = {
			encoding = nil,
			size = 16,
		},
		
		FP_DP2 = {
			encoding = nil,
			size = 32,
		},
		FP_IP2 = {
			encoding = nil,
			size = 32,
		},
		
		-- MISC:
		MXCSR = {
			encoding = nil,
			size = 32,
		},
		RFLAGS = {
			encoding = nil,
			size = 32,
			alias = {
				{ "EFLAGS", "FLAGS" },
			},
		},
		--[[RIP = {
			encoding = nil,
			size = 32,
			alias = {
				{ "EIP", "IP" },
			},
		},]]
	},
}
