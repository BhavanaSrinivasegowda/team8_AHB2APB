module top_tb;

 // Declare signals
 logic Hclk, Hresetn, Hwrite, Hreadyin;
 logic [31:0] Hwdata, Haddr;
 logic [1:0] Htrans;
 logic Penable, Pwrite, Hreadyout;
 logic [1:0] Hresp;
 logic [2:0] Pselx;
 logic [31:0] Paddr, Pwdata, Hrdata, Prdata;

 // Instantiate the Bridge_Top module
 Bridge_Top bridge (
 .Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hreadyin(Hreadyin),
 .Hwdata(Hwdata), .Haddr(Haddr), .Prdata(Prdata), .Htrans(Htrans),
 .Penable(Penable), .Pwrite(Pwrite), .Hreadyout(Hreadyout),
 .Hresp(Hresp), .Pselx(Pselx), .Paddr(Paddr), .Pwdata(Pwdata), .Hrdata(Hrdata)
 );

 // Clock generator
 always begin
 #5 Hclk = ~Hclk;
 end

 // Testbench stimulus
 initial begin
 // Initialize signals
 Hclk = 0; Hresetn = 0; Hwrite = 0; Hreadyin = 0;
 Hwdata = 0; Haddr = 0; Htrans = 0;
 // Apply reset
 #10 Hresetn = 1;
 // Infinite loop for read and write operations
 forever begin
 // Write operation
 #10 Hwrite = 1; Hreadyin = 1; Htrans = 2'b10; Haddr = 32'h8400_0001; Hwdata = $random();
 #10 Htrans = 2'b00;
 $display("Haddr = %h, Paddr = %h ", Haddr,Paddr);
 #10;
 // Read operation
 #10 Hwrite = 0; Hreadyin = 1; Htrans = 2'b10; Haddr = 32'h8800_0001;
 #10 Htrans = 2'b00;
  $display("Haddr = %h, Paddr = %h", Haddr,Paddr);
  #10;
 end
 end
 initial begin 
 #300 $finish;
end 
endmodule
