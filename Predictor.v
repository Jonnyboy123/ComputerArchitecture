/* Written by Prof. Aaron Carpenter for Lab 6 */
/* You may use this as is, but fill in getPrediction and updatePrediction */

module Predictor;

	wire pred;
	reg [7:0]PC;
	reg result;
	reg predOrUpdate; //pred = 0; update = 1;

	reg [7:0]branchCounter;
	reg [7:0]mispredictions;

	branchPredictorTwoBit testBP(pred, PC, result);

	initial begin
		branchCounter = 0;
		mispredictions = 0;
	
		repeat(10) begin
		#1	PC = 8'hAC; 	predOrUpdate = 0;
		#1 	result = 1; predOrUpdate = 1;
		#1	PC = 8'hBC; 	predOrUpdate = 0;
		#1	result = 0; predOrUpdate = 1;
		#1 				predOrUpdate = 0;
		#1 	result = 1; predOrUpdate = 1;
		#1 	PC = 8'hAC; 	predOrUpdate = 0;
		#1 	result = 1; predOrUpdate = 1;
		#1 	PC = 8'hBC; 	predOrUpdate = 0;
		#1	result = 0; predOrUpdate = 1;
		#1 	PC = 8'hCA; 	predOrUpdate = 0;
		#1	result = 1; predOrUpdate = 1;
		#1	PC = 8'hAC;	predOrUpdate = 0;
		#1	result = 1; predOrUpdate = 1;
		end

		#1 PC = 8'hBC; 	predOrUpdate = 0;
		#1 result = 1;	predOrUpdate = 1;
		#1 PC = 8'hAC;	predOrUpdate = 0;
		#1 result = 0; 	predOrUpdate = 1;
		#1 PC = 8'hAC;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hAC;	predOrUpdate = 0;
		#1 result = 0; 	predOrUpdate = 1;
		#1 PC = 8'hBC;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hBC;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hBC;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hBC;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hBC;	predOrUpdate = 0;
		#1 result = 0; 	predOrUpdate = 1;
		#1 PC = 8'hCA;	predOrUpdate = 0;
		#1 result = 0; 	predOrUpdate = 1;
		#1 PC = 8'hCA;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hCA;	predOrUpdate = 0;
		#1 result = 0; 	predOrUpdate = 1;
		#1 PC = 8'hCA;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
		#1 PC = 8'hCA;	predOrUpdate = 0;
		#1 result = 1; 	predOrUpdate = 1;
	end

	initial begin
		$monitor("PC=%x, Prediction=%b, Result=%b, Mispred=%d, Counter=%d",PC, pred, result, mispredictions, branchCounter);
	end

	always@ (predOrUpdate) begin //changed to avoid conflict with initial block
		if(predOrUpdate) begin
			if(result != pred)
				mispredictions = mispredictions + 1;
			branchCounter = branchCounter + 1;
		end
	end

endmodule



module branchPredictorOneBit(output reg prediction, input [7:0]PC, input outcome);

reg historyTable[7:0];
reg [2:0]i;
integer k;
initial 
begin
	for(k = 0; k < 8; k = k + 1) //for loop to initialize the history table 
	begin
		historyTable[k] = 0; //set initial vaule to 0
	end
	
end
always@* 
begin
	i = PC[4:2]; // setting the first location of the history table
	historyTable[i] = outcome; //setting what the outcome shoudld be
	prediction = historyTable[i]; //comparing the prediction to the PC 

end


endmodule

module branchPredictorTwoBit(output reg prediction, input [7:0]PC, input outcome);

reg [1:0]historyTable[7:0];
reg [2:0]i;
integer k;
initial 
begin
	for(k = 0; k < 8; k = k + 1)
	begin
		historyTable[k] = 1;
	end
end
always@* 
begin

	i = PC[4:2];
	if(outcome == 1)//initial outcome was set to 1
	begin
		if(historyTable[i] == 0) //if the current state was 0 swtich to state 1 or 3 depending if it was right or wrong
		begin
			historyTable[i] = 1;
		end
		else
			historyTable[i] = 3;
	end
	else
	begin
		if(historyTable[i] == 3) //if the current state was 3 swtich to state 2 or 0 depending if it was right or wrong
		begin
			historyTable[i] = 2;
		end
		else
			historyTable[i] = 0;
	end
	prediction <= historyTable[i][1];
end


endmodule

