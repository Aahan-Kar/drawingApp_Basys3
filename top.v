`timescale 1ns / 1ps

module top(
    input clk,                
    input [15:0] sw,
    input btnU,
    input btnD,
    input btnL,
    input btnR,
    output [15:0] led,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync
);

    switches sw_mod(
        .sw(sw),
        .led(led)
    );

    Pong pong_mod(
    .clk(clk),
    .btnU(btnU),
    .btnL(btnL),
    .btnR(btnR),
    .btnD(btnD),
    .sw(sw[2:0]),
    .Hsync(Hsync),
    .Vsync(Vsync),
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen)
    );
    
endmodule

module switches(    
    input [15:0] sw,
    output reg [15:0] led
    );
     //some interactivity with the switches, TODO: change clock cycle dynamically, change colors?   
    always @(*) begin
        led = sw;
        end 
    endmodule

module VGA(
    input clk,
    output Hsync,
    output Vsync,   
    output inFrame,
    output reg [9:0] x, 
    output reg [8:0] y
    );

reg [1:0] clk_div = 0;
wire clk_25MHz;

always @(posedge clk)
    clk_div <= clk_div + 1;

assign clk_25MHz = (clk_div == 0);


always @(posedge clk) begin
    if (clk_25MHz) begin
        if (x == 799)
            x <= 0;
        else
            x <= x + 1;
    end
end
        
always @(posedge clk) begin
    if (clk_25MHz && x == 799) begin
        if (y == 524)
            y <= 0;
        else
            y <= y + 1;
    end
end

    assign Hsync = ~(x >= 656 && x < 752);
    assign Vsync = ~(y >= 490 && y < 492);
    assign inFrame = (x < 640 && y < 480);
    
endmodule

module Pong(
    input clk,
    input btnU,
    input btnL,
    input btnR,
    input btnD,
    input [2:0] sw,
    output Hsync,
    output Vsync,
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen
    );

wire inFrame;
wire [9:0] x;
wire [8:0] y;

VGA drawer(.clk(clk), .Hsync(Hsync), .Vsync(Vsync), .inFrame(inFrame), .x(x), .y(y));

reg [9:0] pointX = 10'd100;
reg [8:0] pointY = 10'd100;

//wire point = (x == pointX) & (y == pointY);


reg [9:0] trailX[0:1023];  
reg [8:0]  trailY[0:1023];  
reg [2:0]  trailColor[0:1023]; 
reg [9:0] trailIndex = 0;     
wire [2:0] drawColor = sw[2:0]; 
 

reg[9:0] nextX;
reg[8:0] nextY;


reg [19:0] move_div = 0;
wire move_tick;

always @(posedge clk)
    move_div <= move_div + 1;

assign move_tick = (move_div == 0); 

always @(posedge clk) begin
    if (move_tick) begin
        nextX = pointX;
        nextY = pointY;
    
    if (btnU)
        nextY = nextY - 1;
    if (btnL)
        nextX = nextX - 1;   
    if (btnR) 
        nextX = nextX + 1;
    if (btnD) 
        nextY = nextY + 1;
        
        pointX <= nextX;
        pointY <= nextY;
        
        trailX[trailIndex] <= nextX;
        trailY[trailIndex] <= nextY;
        trailColor[trailIndex] <= drawColor;
        trailIndex <= (trailIndex + 1) % 1024;  
    end
end

reg painted;
reg[2:0] pixelRGB;
integer i;
always @(*) begin
    painted = 0;
    pixelRGB = 3'b000;
    for (i = 0; i < 1024; i = i + 1) begin
        if (x == trailX[i] && y == trailY[i]) begin
            painted = 1;
            pixelRGB = trailColor[i];
            end
    end
end

wire R = painted & pixelRGB[2];
wire G = painted & pixelRGB[1];
wire B = painted & pixelRGB[0];


    assign vgaRed   = {4{R & inFrame}};
    assign vgaGreen = {4{G & inFrame}};
    assign vgaBlue  = {4{B & inFrame}};


endmodule
