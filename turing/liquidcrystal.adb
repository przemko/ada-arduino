with AVR;
with AVR.Wait;
with LiquidCrystal.Wiring;

package body LiquidCrystal is
   
   Processor_Speed : constant := LiquidCrystal.Wiring.Processor_Speed;
   
   procedure Wait_10ms is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 10_000);
   
   procedure Wait_5ms is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 5_000);
   
   procedure Wait_1ms is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 1_000);
   
   procedure Wait_64us is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 64);
   
   procedure Wait_2ms is new AVR.Wait.Generic_Wait_Usecs
     (Crystal_Hertz => Processor_Speed,
      Micro_Seconds => 2_000);
   
   procedure Init(Cols: in Byte; Lines: in Byte) is
      use LiquidCrystal.Wiring;
   begin
      
      -- FROM LCD.ADB:
      
      --  set data direction registers for output of control and data pins
      Enable_DD         := DD_Output;
      ReadWrite_DD      := DD_Output;
      RegisterSelect_DD := DD_Output;
      
      Data0_DD := DD_Output;
      Data1_DD := DD_Output;
      Data2_DD := DD_Output;
      Data3_DD := DD_Output;
      
      --  wait at least 16ms after power on
      Wait_10ms;
      Wait_10ms;
      
      --  write 1 into pins 0 and 1
      Data0 := True;
      Data1 := True;
      Pulse_Enable;
      
      Wait_5ms;
      --  send last command again (is still in register, just toggle E)
      Pulse_Enable;
      Wait_64us;
      --  send last command a third time
      Pulse_Enable;
      Wait_64us;
      
      --  set 4 bit mode, clear data bit 0
      Data0 := False;
      
      case Lines is
         when 1 => null;
         when 2 => Display_Function := Display_Function or FLAG_2LINE;
         when others => null;
      end case;
      Command(FUNCTIONSET or Display_Function);
      
      Display;
      Clear;
      
      -- FROM liquidcrystal.cpp:
      
      Num_Lines := Lines;
      
      Display_Control := Display_Control or FLAG_DISPLAYON;
      Display;
      Clear;
      Display_Mode := Display_Mode or FLAG_ENTRYLEFT;
      Command(ENTRYMODESET or Display_Mode);
   end Init;
   
   procedure Clear is
   begin
      Command(CLEARDISPLAY);
      Wait_2ms;
   end Clear;
   
   procedure Home is
   begin
      Command(RETURNHOME);
      Wait_2ms;
   end Home;
   
   procedure Set_Cursor(Col: in Byte; Row: in Byte) is
      Local_Row: Byte := Row;
   begin
      Local_Row := Local_Row mod Num_Lines; -- ;)
      
      if Local_Row = 0 then
         Command(SETDDRAMADDR + Col);
      elsif Local_Row = 1 then
         Command(SETDDRAMADDR + 16#40# + Col);
      else
         null; -- !!! FIXME
      end if;
   end Set_Cursor;
   
   procedure No_Display is
   begin
      Display_Control := Display_Control and not FLAG_DISPLAYON;
      Command(DISPLAYCONTROL or Display_Control);
   end No_Display;
   
   procedure Display is
   begin
      Display_Control := Display_Control or FLAG_DISPLAYON;
      Command(DISPLAYCONTROL or Display_Control);
   end Display;
   
   procedure No_Cursor is
   begin
      Display_Control := Display_Control and not FLAG_CURSORON;
      Command(DISPLAYCONTROL or Display_Control);
   end No_Cursor;
   
   procedure Cursor is
   begin
      Display_Control := Display_Control or FLAG_CURSORON;
      Command(DISPLAYCONTROL or Display_Control);
   end Cursor;
   
   procedure No_Blink is
   begin
      Display_Control := Display_Control and not FLAG_BLINKON;
      Command(DISPLAYCONTROL or Display_Control);
   end No_Blink;
   
   procedure Blink is
   begin
      Display_Control := Display_Control or FLAG_BLINKON;
      Command(DISPLAYCONTROL or Display_Control);
   end Blink;
   
   procedure Scroll_Display_Left is
   begin
      Command(CURSORSHIFT or FLAG_DISPLAYMOVE);
   end Scroll_Display_Left;
   
   procedure Scroll_Display_Right is
   begin
      Command(CURSORSHIFT or FLAG_DISPLAYMOVE or FLAG_MOVERIGHT);
   end Scroll_Display_Right;
   
   procedure Left_To_Right is
   begin
      Display_Mode := Display_Mode or FLAG_ENTRYLEFT;
      Command(ENTRYMODESET or Display_Mode);
   end Left_To_Right;
   
   procedure Right_To_Left is
   begin
      Display_Mode := Display_Mode and not FLAG_ENTRYLEFT;
      Command(ENTRYMODESET or Display_Mode);
   end Right_To_Left;
   
   procedure Auto_Scroll is
   begin
      Display_Mode := Display_Mode or FLAG_ENTRYSHIFTINCREMENT;
      Command(ENTRYMODESET or Display_Mode);
   end Auto_Scroll;
   
   procedure No_Auto_Scroll is
   begin
      Display_Mode := Display_Mode and not FLAG_ENTRYSHIFTINCREMENT;
      Command(ENTRYMODESET or Display_Mode);
   end No_Auto_Scroll;
   
   procedure Create_Char(Location: in Byte; Char_Map: in Bit_Map) is
   begin
      Command(SETCGRAMADDR or ((Location and 16#07#) * 8));
      for I in 0..7 loop
         Send(Char_Map(I), Is_Data => True);
      end loop;
   end Create_Char;
   
   -- mid level procedures:
   procedure Command(Value: in Byte) is
   begin
      Send(Value, Is_Data => False);
   end Command;
   
   procedure Write(Value: in Byte) is
   begin
      Send(Value, Is_Data => True);
   end Write;
   
   procedure Put(C: in Character) is
   begin
      Send(Character'Pos(C), Is_Data => True);
   end Put;
   
   procedure Put(S: in AVR_String) is
   begin
      for I in S'Range loop
         Put(S(I));
      end loop;
   end Put;
   
   procedure Put(I: in Integer) is
   
     procedure Put2(N : Integer) is
     begin
       if N > 0 then
         Put2(N / 10);
         Put(Character'Val(48+N mod 10));
       end if;
     end Put2;

   begin
     if I < 0 then
       Put('-');
       Put2(-I);
     elsif I > 0 then
       Put2(I);
     else
       Put('0');
     end if;
   end Put;
   
   -- low level procedures:
   procedure Send(Value: in Byte; Is_Data : in Boolean) is
      use LiquidCrystal.Wiring;
   begin
      ReadWrite := False;
      RegisterSelect := Is_Data;
      
      Data0 := (Value and 16#10#) /= 0;
      Data1 := (Value and 16#20#) /= 0;
      Data2 := (Value and 16#40#) /= 0;
      Data3 := (Value and 16#80#) /= 0;
      Pulse_Enable;
      Data0 := (Value and 16#01#) /= 0;
      Data1 := (Value and 16#02#) /= 0;
      Data2 := (Value and 16#04#) /= 0;
      Data3 := (Value and 16#08#) /= 0;
      Pulse_Enable;
      
      if Is_Data then
         Wait_1ms;
      else
         Wait_10ms;
      end if;
   end Send;
   
   procedure Pulse_Enable is
      use AVR.Wait;
      use LiquidCrystal.Wiring;
   begin
      Enable := True;
      Wait_4_Cycles (1);
      Enable := False;
   end Pulse_Enable;
   
end LiquidCrystal;
