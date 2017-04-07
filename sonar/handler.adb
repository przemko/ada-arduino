with AVR; use AVR;
with AVR.MCU;
with AVR.Wait;
with AVR.Timer1;

procedure Handler is
   Buzzer     : Boolean renames MCU.PORTD_Bits (2);
   Buzzer_DD  : Boolean renames MCU.DDRD_Bits  (2);
begin
   Buzzer_DD := DD_Output;
   Buzzer    := High;
   delay 0.1;
   Buzzer    := Low;
   AVR.Timer1.Set_Overflow_At (10000);
end;
