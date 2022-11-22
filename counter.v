module counter(out, clk, rst, in);
	input clk;
	input rst; 
	input [1:0] in;
	output reg [3:0] out;
	reg [3:0]next_out;
	reg state;
	reg repeat1;
	reg plus;
//Next state logic
always@(posedge clk)
begin
    if(out == 0)
    begin
        if(repeat1 == 0) next_out = out + in; 
        else
        begin
            next_out = 0;
            repeat1 = 0;
        end
    end
    
    else if(out == 15)
    begin
        if(repeat1 == 0) next_out = out - in; 
        else
        begin
            next_out = 15;
            repeat1 = 0;
        end    
    end
    
    else
    begin
        if(plus == 1)
        begin
            if((out + in)>15)
            begin
                next_out = 15;
                repeat1 = 0;
                plus = 0;
            end
            else if ((out + in)==15)
            begin
            //if out + in equal to 15, the output must repeat once
                next_out = 15;
                repeat1 = 1;
                plus = 0;
            end
            else next_out = out + in;
        end
        else
        begin
            if((out < in) )
            begin
            // if out < in than the resulting output will lower than 0
                next_out = 0;
                repeat1 = 0;
                plus = 1;
            end
            else if ((out - in)==0)
            begin
            //if out - in equal to 0, the output must repeat once
                next_out = 0;
                repeat1 = 1;
                plus = 1;
            end
            else next_out = out - in;
        end
    end
    
end
//State registor
always@(posedge clk or posedge rst)
begin
    if(rst) state = 0;
    else state = 1;
end
//Output logic
always@(*)
begin
    if(state == 0)
    begin
    //initial states, plus=1 --> plus, plus = 0--> minus
        out = 0;
        repeat1 = 0;
        plus = 1;
    end
    else out = next_out;
end

endmodule

