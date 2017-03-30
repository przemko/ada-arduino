---------------------------------------------------------------------------
-- The AVR-Ada Library is free software;  you can redistribute it and/or --
-- modify it under terms of the  GNU General Public License as published --
-- by  the  Free Software  Foundation;  either  version 2, or  (at  your --
-- option) any later version.  The AVR-Ada Library is distributed in the --
-- hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even --
-- the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR --
-- PURPOSE. See the GNU General Public License for more details.         --
--                                                                       --
-- As a special exception, if other files instantiate generics from this --
-- unit,  or  you  link  this  unit  with  other  files  to  produce  an --
-- executable   this  unit  does  not  by  itself  cause  the  resulting --
-- executable to  be  covered by the  GNU General  Public License.  This --
-- exception does  not  however  invalidate  any  other reasons why  the --
-- executable file might be covered by the GNU Public License.           --
---------------------------------------------------------------------------

with Interfaces; use Interfaces;
with AVR; use AVR;
with AVR.Strings; use AVR.Strings;

package LiquidCrystal is
   
   pragma Preelaborate;
   
   subtype Byte is Unsigned_8;
   
   type Bit_Map is array(0..7) of Byte;
   
   -- Commands:
   CLEARDISPLAY   : constant Byte := 16#01#;
   RETURNHOME     : constant Byte := 16#02#;
   ENTRYMODESET   : constant Byte := 16#04#;
   DISPLAYCONTROL : constant Byte := 16#08#;
   CURSORSHIFT    : constant Byte := 16#10#;
   FUNCTIONSET    : constant Byte := 16#20#;
   SETCGRAMADDR   : constant Byte := 16#40#;
   SETDDRAMADDR   : constant Byte := 16#80#;
   
   -- Flags:
   ---- for display entry mode
   FLAG_ENTRYLEFT           : constant Byte := 16#02#;
   FLAG_ENTRYSHIFTINCREMENT : constant Byte := 16#01#;
   ---- for display on/off control
   FLAG_DISPLAYON           : constant Byte := 16#04#;
   FLAG_CURSORON            : constant Byte := 16#02#;
   FLAG_BLINKON             : constant Byte := 16#01#;
   ---- for display/cursor shift
   FLAG_DISPLAYMOVE         : constant Byte := 16#08#;
   FLAG_MOVERIGHT           : constant Byte := 16#04#;
   ---- for function set
   FLAG_8BITMODE            : constant Byte := 16#10#;
   FLAG_2LINE               : constant Byte := 16#08#;
   FLAG_5x10DOTS            : constant Byte := 16#04#;
   
   -- high level procedures:
   procedure Init(Cols: in Byte; Lines: in Byte);
   procedure Clear;
   procedure Home;
   procedure Set_Cursor(Col: in Byte; Row: in Byte);
   procedure No_Display;
   procedure Display;
   procedure No_Cursor;
   procedure Cursor;
   procedure No_Blink;
   procedure Blink;
   procedure Scroll_Display_Left;
   procedure Scroll_Display_Right;
   procedure Left_To_Right;
   procedure Right_To_Left;
   procedure Auto_Scroll;
   procedure No_Auto_Scroll;
   procedure Create_Char(Location: in Byte; Char_Map: in Bit_Map);
   procedure Put(C: in Character);
   procedure Put(S: in AVR_String);
   procedure Put(I: in Integer);
   
   -- mid level procedures:
   procedure Command(Value: in Byte);
   procedure Write(Value: in Byte);
   
private
   pragma Inline(Command);
   pragma Inline(Write);
   
   Display_Function : Byte := 16#00#;
   Display_Control  : Byte := 16#00#;
   Display_Mode     : Byte := 16#00#;
   Num_Lines        : Byte;
   
   -- low level procedures:
   procedure Send(Value: in Byte; Is_Data: in Boolean);
   procedure Pulse_Enable;
   
end LiquidCrystal;
