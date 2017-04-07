with AVR.Real_Time.Delays; pragma Unrefered (AVR.Real_Time.Delays);
with LiquidCrystal;

with AVR; use AVR;
with AVR.MCU;
with AVR.Wait;

procedure Sonar is

   procedure Beep is
      Buzzer     : Boolean renames MCU.PORTD_Bits (2);
      Buzzer_DD  : Boolean renames MCU.DDRD_Bits  (2);
   begin
      Buzzer_DD := DD_Output;
      Buzzer    := High;
      delay 0.1;
      Buzzer    := Low;
   end;
  
   Processor_Speed : constant := 16_000_000;
   
   procedure Wait_2us is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 2);
   
   procedure Wait_10us is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 10);
   
   Trigger    : Boolean renames MCU.PORTD_Bits (0);
   Trigger_DD : Boolean renames MCU.DDRD_Bits  (0);
   Echo_Pin   : Boolean renames MCU.PIND_Bits  (1);
   Echo       : Boolean renames MCU.PORTD_Bits (1);
   Echo_DD    : Boolean renames MCU.DDRD_Bits  (1);
   Counter    : Natural;
   N          : Natural;
   
begin
   LiquidCrystal.Init (16, 2);
   LiquidCrystal.Clear;
   loop
      Beep;
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
      if Counter >= 16000 then
	LiquidCrystal.Put ("                ");
      else
	 N := 1 + (15999 - Counter) / 2000; 
	 for I in 1 .. N loop
	    LiquidCrystal.Put (Character'Val (255));
	 end loop;
	 for I in N+1 .. 16-N loop
	    LiquidCrystal.Put (' ');
	 end loop;
	 for I in 17-N .. 16 loop
	    LiquidCrystal.Put (Character'Val (255));
	 end loop;
      end if;
      case Counter is
         when 00000..01999 => delay 0.05;
         when 02000..03999 => delay 0.10;
         when 04000..05999 => delay 0.15;
         when 06000..07999 => delay 0.20;
         when 08000..09999 => delay 0.25;
         when 10000..11999 => delay 0.30;
         when 12000..13999 => delay 0.35;
         when 14000..15999 => delay 0.40;
         when others => delay 1.0;
      end case;
   end loop;
end Sonar;
