/**************************

Template provided by Aaron Carpenter for the purposes of being used in 
ELEC 3725 at Wentworth Institute of Technology

***************************/

// ALUOp is extra credit

module Decodercontroller(
	output reg reg2Loc, uncondBranch, branch, memRead, memWrite, memToReg, aluSrc, regWrite, 
	output reg [1:0] aluOp,
	output reg [4:0] Rm, Rn, Rd, 
	input [31:0] inst);

//FILL THIS IN WITH YOUR DECODER
	always @ (inst)
	case(inst[28:26])
		3'b110: //D type
		begin
			if(inst[22] == 1)//Load
			begin
				aluOp = 2'b00; 
				reg2Loc = 1'bx;
				branch = 0;
				uncondBranch = 0;
				memRead = 1;
				memToReg = 1;
				memWrite = 0;
				aluSrc = 1;
				regWrite = 1;
				
			end
			else //Store
			begin
				aluOp = 2'b00;
				reg2Loc = 1;
				branch = 0;
				uncondBranch = 0;
				memRead = 0;
				memToReg = 1'bx;
				memWrite = 1;
				aluSrc = 1;
				regWrite = 0;
			end
			Rm = 1'bx;
			Rd = inst[4:0];
			Rn = inst[9:5];
			
		end
		3'b101: //B type
		begin
			if(inst[31:26] == 6'b000101 | inst [31:26] == 6'b100101)
			begin
				aluOp = 2'b01; 
				reg2Loc = 1;
				branch = 1;
				uncondBranch = 1;
				memRead = 0;
				memWrite = 0;
				memToReg = 1'bx;
				aluSrc = 0;
				regWrite = 0;
			end
			else
			begin
				aluOp = 2'b01; 
				reg2Loc = 1;
				branch = 1;
				uncondBranch = 0;
				memRead = 0;
				memWrite = 0;
				memToReg = 1'bx;
				aluSrc = 0;
				regWrite = 0;
			end
			Rm = 1'bx;
			Rd = 1'bx;
			Rn = 1'bx;
		end
		3'b100:	//I and IM type
		begin
			if(inst[26:24] == 3'b101) //IM type
			begin
				aluOp = 2'b00; 
				reg2Loc = 0;
				branch = 0;
				uncondBranch = 0;
				memRead = 1;
				memToReg = 1;
				memWrite = 0;
				aluSrc = 1;
				regWrite = 1;
			end
			
			else //I type
			begin
				aluOp = 2'b10; 
				reg2Loc = 0;
				branch = 0;
				uncondBranch = 0;
				memRead = 0;
				memToReg = 0;
				memWrite = 0;
				aluSrc = 1;
				regWrite = 1;
			end
			Rm = 1'bx;
			Rd = inst[4:0];
			Rn = inst[9:5];
		end
		3'b010: //R type
		begin
			aluOp = 2'b10; 
			reg2Loc = 0;
			branch = 0;
			uncondBranch = 0;
			memRead = 0;
			memToReg = 0;
			memWrite = 0;
			aluSrc = 0;
			regWrite = 1;
			Rm = inst[19:15];
			Rd = inst[4:0];
			Rn = inst[9:5];
		end
	endcase
endmodule