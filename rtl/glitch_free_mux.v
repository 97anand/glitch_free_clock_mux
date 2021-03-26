module glitch_free_mux(
  input     clocka,
  input     clockb,
  input     reset_n,
  input     sel,
  output    clock_out
);

//-----------------------------------------
//  Register Declaration
//-----------------------------------------

wire and_a;
wire and_b;
reg  rega1;
reg  rega2;
reg  regb1;
reg  regb2;


//-----------------------------------------
//  2FF synchronizer for clock A Domain
//-----------------------------------------

always @(posedge clocka or negedge reset_n)
begin
  if(!reset_n)
    begin
      rega1 <= 1'b0;
      rega2 <= 1'b0;
    end
  else 
    begin
      rega1 <= and_a;
      rega2 <= rega1;
    end
end

//-----------------------------------------
//  2FF Synchronizer for Clock B Domain
//-----------------------------------------

always @(posedge clockb or negedge reset_n)
begin
  if(!reset_n)
    begin
      regb1 <= 1'b0;
      regb2 <= 1'b0;
    end
  else 
    begin
      regb1 <= and_b;
      regb2 <= regb1;
    end
end

//-----------------------------------------
//  Assign Statements
//-----------------------------------------

assign and_a     = ~sel && ~regb2 ; 
assign and_a_out = clocka &&  rega2 ; 
assign and_b     = sel && ~rega2;
assign and_b_out = clockb && regb2;
assign clock_out = and_a_out || and_b_out;

endmodule
