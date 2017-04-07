with AVR.Real_Time.Delays;
with AVR.Interrupts;
with LiquidCrystal;

with AVR; use AVR;
with AVR.MCU;
with AVR.Wait;

procedure Sonar is
   
   Trigger    : Boolean renames MCU.PORTD_Bits (0);
   Trigger_DD : Boolean renames MCU.DDRD_Bits  (0);
   Echo_Pin   : Boolean renames MCU.PIND_Bits  (1);
   Echo       : Boolean renames MCU.PORTD_Bits (1);
   Echo_DD    : Boolean renames MCU.DDRD_Bits  (1);
   
   Processor_Speed : constant := 16_000_000;
   
   Counter, N : Natural;
   
   procedure Wait_2us is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 2);
   
   procedure Wait_10us is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 10);
   
begin
   LiquidCrystal.Init (16, 2);
   LiquidCrystal.Clear;
   loop
      Trigger_DD := DD_Output;
      Trigger := Low;
      Wait_2us;
      Trigger := High;
      Wait_10us;
      Trigger := Low;
      Echo_DD := DD_Input;
      Echo := Low;
      
      while Echo_Pin = Low loop
	 null;
      end loop;
      while not Echo_Pin = High loop
	 null;
      end loop;
      Counter := 0;
      while Echo_Pin = High loop
	 exit when Counter = Integer'Last;
	 Counter := Counter + 1;
      end loop;
      
      LiquidCrystal.Set_Cursor (0, 0);
      LiquidCrystal.Put (Counter);
      LiquidCrystal.Put ("     ");
      LiquidCrystal.Set_Cursor (0, 1);
      N := Counter / 2028;
      for I in 1 .. N loop
	 LiquidCrystal.Put (Character'Val (255));
      end loop;
      for I in N+1 .. 16 loop
	 LiquidCrystal.Put (' ');
      end loop;
      delay 1.0;
   end loop;
end Sonar;
