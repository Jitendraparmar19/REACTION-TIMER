module entry_system(clk,reset, entrance_button,password, password,green,red, gate_1, gate_2, not_allowed_led);

input clk, reset, entrance_button;//entrance button is used to start entering passowrd.
input[3:0] password;//password 1=4'b1010 is for VIP guests. //password 2=4'b0110 is for normal guests.
output reg green, red, gate_1, gate_2, not_allowed_led;

reg[2:0] password_count=1'b0;

parameter idle        = 3'b000;
parameter  enter      = 3'b001;
parameter wrong       = 3'b010;
parameter correct     = 3'b011;
parameter Not_Allowed = 3'b100;
 
reg[2:0] current_state, next_state;

always @(posedge clk or posedge reset)
begin
 	if(reset) 
 	current_state <= idle;
 	else
 	current_state <= next_state;
end
always @(current_state)
begin
case(current_state)
 	idle: 
	begin
        if(entrance_button == 1)
 	next_state = enter;
 	else
 	next_state = idle;
 	end
 
	enter: 
	begin
	if((password==4'b1010)||(password==4'b0110))
 	next_state = correct;
 	else
 	next_state = wrong;
	end
 
 	wrong: begin
 	if(((password==4'b1010)||(password==4'b110))&&(password_count<=3))
 	next_state = correct;
 	else if(password_count>3)
	begin
	next_state = Not_Allowed;
	red=1'b1;
	end
	else
	begin
 	next_state = wrong;
	password_count=password_count+1;
	red=1'b1;
	end
 	end
 	
	correct: begin
	if(password==4'b1010)
	begin
 	green=1'b1;
	gate_1=1'b1;
	password_count=0;
	next_state=idle;
	end
	else 
	begin
 	green=1'b1;
	gate_2=1'b1;
	password_count=0;
	next_state=idle;
	end
 	end

	Not_Allowed:
	begin
	not_allowed_led=1'b1;
	next_state= idle;
	end
endcase
 end
 


endmodule

