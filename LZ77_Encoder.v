module LZ77_Encoder(clk,reset,chardata,valid,encode,finish,offset,match_len,char_nxt);
input 				clk;
input 				reset;
input 		[7:0] 	chardata;
output  reg			valid;
output  reg			encode;
output  reg			finish;
output 	reg	[3:0] 	offset;
output 	reg	[2:0] 	match_len;
output 	reg 	[7:0] 	char_nxt;

reg [3:0] count_1;
reg [11:0] count_2;
reg [2:0] match_1;
reg [2:0] match_2;
reg [3:0] now_offset;
reg [7:0] buffer [16:0];
reg [7:0] compare[16:0];
reg [2:0] state, next_state;
reg [7:0] get_data [2048:0];
reg [3:0] a;
reg test;
parameter T1 = 1, T2=2, T3=3, T4=4, T5=5;
always@(*) begin
	case(state)
		T1: begin
			if(count_2 == 'd2048)
				next_state = 3'd2;
			else 
				next_state = 3'd1;
		end
		T2: begin
		  if(a == 4'd0)
			next_state = 3'd3;
			else
			next_state = 3'd2;  
		end
		T3: begin
			if(char_nxt == 8'h24)
				next_state = 3'd5;
			else if (match_2 == 4'b0)
				next_state = 3'd2;
			else
				next_state = 3'd4;
		end
		T4: begin
			if(count_1 == match_2 - 4'b1)
				next_state = 3'd2;
			else
				next_state = 3'd4;
		end
		T5: begin
			next_state = 3'd5;
		end
		default: begin
			next_state = state;
		end
	endcase
end
always@(posedge clk or posedge reset)begin
		if(reset) begin
		   state <= 3'd1;//T1
			 {count_1, count_2} <= 16'b0;
			 buffer[0]<= 'h0;
			 buffer[1]<= 'h0; 
			 buffer[2]<= 'h0; 
			 buffer[3]<= 'h0; 
			 buffer[4]<= 'h0; 
			 buffer[5]<= 'h0; 
			 buffer[6]<= 'h0; 
			 buffer[7] <= 'h0;
			 buffer[8] <= 'h25;
			 buffer[9] <= 'h25;
			 buffer[10] <= 'h25;
			 buffer[11] <= 'h25;
			 buffer[12] <= 'h25;
			 buffer[13] <= 'h25;
			 buffer[14] <= 'h25;
			 buffer[15] <= 'h25;			 
       buffer[16] <= 'h25;
			 match_2 <='d0;
			 now_offset<='d0;
		end
		else begin
		  state <= next_state;
		  case(state)
			T1: begin
			  	 a<=9;
				  get_data[count_2] <= chardata;
				  if(count_2==12'd2048)begin
					count_2 <= 12'd8;
					end
				  else begin
					count_2 <= count_2+12'b1;
					end
				  if(count_2=='d2048) begin
					   buffer[0] <=get_data[7];
					   buffer[1] <=get_data[6];
					   buffer[2] <=get_data[5];
					   buffer[3] <=get_data[4];
					   buffer[4] <=get_data[3];
					   buffer[5] <=get_data[2];
					   buffer[6] <=get_data[1];
					   buffer[7] <=get_data[0];
					   compare[7]<=get_data[0];
					   compare[6]<=get_data[1];
					   compare[5]<=get_data[2];
					   compare[4]<=get_data[3];
					   compare[3]<=get_data[4];
					   compare[2]<=get_data[5];
					   compare[1]<=get_data[6];
					   compare[0]<=get_data[7];
				  end
			end
			T2:begin
	          if(match_2 < match_1) begin
				       match_2  <= match_1;
				       now_offset <=a;	
		        end
		        else begin
				       match_2  <= match_2;
				       now_offset <= now_offset; 
				    end 
		   end
			 T3: begin
			    count_2 <= count_2+12'b1;
				  buffer[0]<=get_data[count_2];
				  buffer[1]<=buffer[0];
				  buffer[2]<=buffer[1];
				  buffer[3]<=buffer[2];
				  buffer[4]<=buffer[3];
			   	buffer[5]<=buffer[4];
			   	buffer[6]<=buffer[5];
			   	buffer[7]<=buffer[6];
				  buffer[8]<=buffer[7];
				  buffer[9]<=buffer[8];
				  buffer[10]<=buffer[9];
				  buffer[11]<=buffer[10];
				  buffer[12]<=buffer[11];
				  buffer[13]<=buffer[12];
				  buffer[14]<=buffer[13];
				  buffer[15]<=buffer[14];
				  buffer[16]<=buffer[14];				
				  compare[0]<=get_data[count_2];
				  compare[1]<=buffer[0];
				  compare[2]<=buffer[1];
				  compare[3]<=buffer[2];
				  compare[4]<=buffer[3];
				  compare[5]<=buffer[4];
				  compare[6]<=buffer[5];
				  compare[7]<=buffer[6];
				  compare[8]<=buffer[7];
				  compare[9]<=buffer[8];
				  compare[10]<=buffer[9];
				  compare[11]<=buffer[10];
				  compare[12]<=buffer[11];
				  compare[13]<=buffer[12];
				  compare[14]<=buffer[13];
				  compare[15]<=buffer[14];
				  compare[16]<=buffer[15];
			end
			T4:begin
				  count_2 <= count_2+12'b1;
				  buffer[0]<=get_data[count_2];
				  buffer[1]<=buffer[0];
				  buffer[2]<=buffer[1];
				  buffer[3]<=buffer[2];
				  buffer[4]<=buffer[3];
			   	buffer[5]<=buffer[4];
			   	buffer[6]<=buffer[5];
			   	buffer[7]<=buffer[6];
				  buffer[8]<=buffer[7];
				  buffer[9]<=buffer[8];
				  buffer[10]<=buffer[9];
				  buffer[11]<=buffer[10];
				  buffer[12]<=buffer[11];
				  buffer[13]<=buffer[12];
				  buffer[14]<=buffer[13];
				  buffer[15]<=buffer[14];
				  buffer[16]<=buffer[14];				
				  compare[0]<=get_data[count_2];
				  compare[1]<=buffer[0];
				  compare[2]<=buffer[1];
				  compare[3]<=buffer[2];
				  compare[4]<=buffer[3];
				  compare[5]<=buffer[4];
				  compare[6]<=buffer[5];
				  compare[7]<=buffer[6];
				  compare[8]<=buffer[7];
				  compare[9]<=buffer[8];
				  compare[10]<=buffer[9];
				  compare[11]<=buffer[10];
				  compare[12]<=buffer[11];
				  compare[13]<=buffer[12];
				  compare[14]<=buffer[13];
				  compare[15]<=buffer[14];
				  compare[16]<=buffer[15];
					if(count_1==match_2 - 4'b1)begin
						   match_2<='d0;
						   now_offset<='d0;
					end
					if(count_1==match_2- 4'b1)
						   count_1 <= 4'b0;
					else
						   count_1 <= count_1 + 4'b1;
			end
		endcase
		end				
end
always@(posedge clk) begin
	if(state == T2)begin
	  if(test)begin 
		   if(buffer[7] == compare[a+7] & buffer[6] == compare[a+6] & buffer[5] == compare[a+5] & buffer[4] == compare[a+4] & buffer[3] == compare[a+3] & buffer[2] == compare[a+2] & buffer[1] == compare[a+1]) begin
			   match_1 <= 3'd7;
		   end
		   else if(buffer[7] == compare[a+7] & buffer[6] == compare[a+6] & buffer[5] == compare[a+5] & buffer[4] == compare[a+4] & buffer[3] == compare[a+3] & buffer[2] == compare[a+2]) begin
			   match_1 <= 3'd6;                            
		   end
		   else if(buffer[7] == compare[a+7] & buffer[6] == compare[a+6] & buffer[5] == compare[a+5] & buffer[4] == compare[a+4] & buffer[3] == compare[a+3]) begin
			   match_1 <= 3'd5;                     
		   end
		   else if(buffer[7] == compare[a+7] & buffer[6] == compare[a+6] & buffer[5] == compare[a+5] & buffer[4] == compare[a+4]) begin
			   match_1 <= 3'd4;         
		   end
		   else if(buffer[7] == compare[a+7] & buffer[6] == compare[a+6] & buffer[5] == compare[a+5]) begin
			   match_1 <= 3'd3;
		   end
		   else if(buffer[7] == compare[a+7] & buffer[6] == compare[a+6]) begin
			   match_1 <= 3'd2;
		   end
		   else if(buffer[7] == compare[a+7]) begin
			   match_1 <= 3'd1;
		   end
		   else  begin   
			   match_1 <= 3'd0;
		   end
		   a<=a-1;	
	   end
	end
	else begin
		match_1 <= 3'd0;
		a<=9;
	end
end

always@(*) begin
  if(a>0) begin
    test = 1'b1;
  end
  else begin
    test = 1'b0;   
  end 
end

always@(*) begin
	offset = now_offset;
	match_len = match_2;
	char_nxt = compare[ 7 - match_2];
	case(state)
		T1: begin
			{encode,finish,valid}=3'b000;			
		end
		T2: begin
			{encode,finish,valid}=3'b100;
		end
		T3: begin
			{encode,finish,valid}=3'b101;
		end
		T4: begin
			{encode,finish,valid}=3'b100;
		end		
		T5: begin
			{encode,finish,valid}=3'b110;			
		end
		default: begin
			{encode,finish,valid}=3'b000;			
		end
	endcase
end
endmodule
