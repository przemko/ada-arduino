with Interfaces; use Interfaces;
with AVR.Strings; use AVR.Strings;
with AVR.Real_Time.Delays;
pragma Unreferenced (AVR.Real_Time.Delays);

with LiquidCrystal; use LiquidCrystal;
with Keypad; use Keypad;

procedure Turing is

   procedure Wait_Until_Key_Pressed is
   begin
      Set_Cursor(2, 1);
      Put("press any key");
      Blink;
      loop
         exit when Key_Pressed;
      end loop;
      loop
         exit when not Key_Pressed;
      end loop;
      No_Blink;
   end Wait_Until_Key_Pressed;

   type Command_Type is (H0, L0, R0, T1, T2, W1);

   type Statement is record
      Command : Command_Type;
      Arg1    : Character;
      Arg2    : Unsigned_8;
   end record;

   type Memory is array (Unsigned_8 range <>) of Statement;

   M : Memory (0 .. 7) :=
     (
      0 => (T2, '1', 5),
      1 => (W1, '1', 0),
      2 => (R0, ' ', 0),
      3 => (T2, ' ', 6),
      4 => (T1, ' ', 2),
      5 => (W1, '0', 0),
      6 => (L0, ' ', 0),
      7 => (T1, ' ', 0)
     );

   T : AVR_String (0 .. 255) := (0 => '0', others => ' ');

   procedure Run (M : Memory; T : in out AVR_String) is

      A : Unsigned_8 := M'First;
      D : Duration := 0.5;
      Pos : Unsigned_8 := 0;

      procedure Print_Tape is
         I : Unsigned_8;
      begin
         Set_Cursor(0, 0);
         I := Pos - 7;
         for K in 1 .. 7 loop
            Put (T (I));
            I := I + 1;
         end loop;
         Put ("|" & T (Pos .. Pos) & "|");
         for K in 1 .. 6 loop
            I := I + 1;
            Put (T (I));
         end loop;
      end Print_Tape;

   begin
      Clear;
      Print_Tape;
      Set_Cursor (0, 1);
      Put ("  0:");
      loop

         if A not in M'Range then
            Put ("SEG-FAULT");
            Blink;
            exit;
         end if;

         Set_Cursor (4, 1);
         case M(A).Command is
            when H0 =>
               Put ("H      ");
            when L0 =>
               Put ("L      ");
            when R0 =>
               Put ("R      ");
            when T1 =>
               Put ("T(");
               Put (Integer (M(A).Arg2));
               Put (")    ");
            when T2 =>
               Put ("T(");
               Put (M(A).Arg1);
               Put (",");
               Put (Integer (M(A).Arg2));
               Put (")  ");
            when W1 =>
               Put ("W(");
               Put (M(A).Arg1);
               Put (")    ");
         end case;

         delay D;

         case M(A).Command is
            when H0 =>
               exit;
            when L0 =>
               Pos := Pos - 1;
               Print_Tape;
               A := A + 1;
            when R0 =>
               Pos := Pos + 1;
               Print_Tape;
               A := A + 1;
            when T1 =>
               A := M(A).Arg2;
            when T2 =>
               if M(A).Arg1 = T(Pos) then
                  A := M(A).Arg2;
               else
                  A := A + 1;
               end if;
            when W1 =>
               T (Pos) := M(A).Arg1;
               Set_Cursor (8, 0);
               Put (T (Pos));
               A := A + 1;
         end case;
         Set_Cursor (0, 1);
         if A < 100 then
            Put (' ');
            if A < 10 then
               Put (' ');
            end if;
         end if;
         Put (Integer (A));
         if Read_Key = Up_Button then
            if D > 0.01 then
               D := D * Duration (0.9);
            else
               D := 0.01;
            end if;
         elsif Read_Key = Down_Button then
            if D < 1.0 then
               D := D * Duration (1.1);
            else
               D := 1.0;
            end if;
         end if;
      end loop;
   end Run;

   Up_Arrow : Bit_Map :=
     (2#00100#,
      2#01110#,
      2#10101#,
      2#00100#,
      2#00100#,
      2#00100#,
      2#00100#,
      2#00100#);

   Down_Arrow : Bit_Map :=
     (2#00100#,
      2#00100#,
      2#00100#,
      2#00100#,
      2#00100#,
      2#10101#,
      2#01110#,
      2#00100#);

begin
   Init (16, 2);
   Clear;
   Set_Cursor (0, 0);
   Put ("-Turing Machine-");
   Wait_Until_Key_Pressed;
   delay 0.1;
   Clear;
   Create_Char (0, Up_Arrow);
   Create_Char (1, Down_Arrow);
   Set_Cursor (0, 0);
   Write (0);
   Put ("faster  ");
   Write (1);
   Put ("slower");
   Wait_Until_Key_Pressed;
   delay 0.1;

   Run (M, T);

   loop
      null;
   end loop;

end Turing;
