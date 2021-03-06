`timescale 1ns / 1ns

module raw_gateway_tb;
parameter jumbo_dw=11;

reg clk;
integer cc;
reg [127:0] packet_file;
integer data_len;
initial begin
	if ($test$plusargs("vcd")) begin
		$dumpfile("raw_gateway.vcd");
		$dumpvars(5,raw_gateway_tb);
	end
	for (cc=0; cc<450; cc=cc+1) begin
		clk=0; #4;  // 125 MHz * 8bits/cycle -> 1 Gbit/sec
		clk=1; #4;
	end
end

reg rx_ready=0, rx_strobe=0, rx_crc=0, tx_ack=0, tx_strobe=0;
reg [7:0]  packet_from_net;
wire [7:0] rx_byte;
wire tx_req, control_strobe, control_rd;
wire [jumbo_dw-1:0] tx_len;
wire [15:0] tx_len_from_net;
wire [63:0] data_to_net;
reg  [63:0] data_from_net=0;
wire [7:0] tx_byte,packet_to_net;
wire data_to_net_gate;
raw_gateway dut(.clk(clk),
	.rx_ready(rx_ready), .rx_gate(rx_strobe), .tx_byte(tx_byte),
	.rx_crc(rx_crc), .tx_ack(tx_ack), .tx_gate(tx_strobe),
	.tx_req(tx_req), .tx_len(tx_len), .rx_byte(rx_byte)
	,.tx_data(data_from_net)
//,.data_to_net(data_to_net), .data_from_net(data_from_net)
//,.read_strobe(read_strobe)
//,.data_to_net_gate(data_to_net_gate),.tx_req_from_net(tx_req_from_net),.tx_len_from_net(tx_len_from_net)
);

reg [575:0] pack=576'h12211221_3456789a_01020304_40302010_11121314_deadbeef_01020304_40302010_11121314_deadbeef_01020304_40302010_11121314_deadbeef_01020304_40302010_11121314_deadbeef;
reg [575:0] reply=0;
reg [575:0] reply_want=576'h12211221_3456789a_01020304_40302010_11121314_01233210_01020304_40302010_11121314_01233210_01020304_40302010_11121314_01233210_01020304_40302010_11121314_01233210;

integer ccc=0;
reg [jumbo_dw-1:0] len=72;  // serial number + 8 transactions
wire rx_push = (ccc>14) & (ccc<(14+len+1));
reg rx_len=0;
reg tx_strobe1=0;
reg fail=0;
always @(posedge clk) begin
	ccc <= cc%150;
	if (ccc==149) begin
		len<=len-0;
		reply<=0;
		tx_ack <= 1;
	end
	rx_ready <= ccc==10;
	rx_len   <= rx_ready;
	rx_strobe <= rx_push;
	packet_from_net <= rx_ready ? len[jumbo_dw-1:8] : rx_len ? len[7:0] : rx_push ? pack[568-(ccc-15)*8+:8] : 8'hxx;
	data_from_net <= 32'h01233210;
	if (data_to_net_gate) $display("data_to_net=0x%x ",data_to_net);

	tx_strobe <= (ccc>64) & (ccc<(64+len+1));
	tx_strobe1 <= tx_strobe;
	if (tx_strobe1) reply <= {reply[567:0],tx_byte};
	if (ccc==(64+len+3)) begin
		fail=reply != reply_want;
		$display("sent  %x",pack);
		$display("want  %x",reply_want);
		$display("reply %x %s",reply, fail ? "FAIL" : "PASS");
	end
end

endmodule
