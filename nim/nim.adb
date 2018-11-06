with Interfaces; use Interfaces;
with AVR.Real_Time.Delays;

with LiquidCrystal; use LiquidCrystal;
with Keypad; use Keypad;

procedure Nim is
   
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
   
   type Selection is mod 3;
   
   
   function Get_Selection return Selection is
      S : Selection := 0;
      
      procedure Print_Menu  is
      begin
	 Set_Cursor(7, 1);
	 case S is
	    when 0 => Put("[1] 2  3 ");
	    when 1 => Put(" 1 [2] 3 ");
	    when 2 => Put(" 1  2 [3]");
	 end case;
      end Print_Menu;
   
   begin
      loop
	 Print_Menu;
	 exit when Read_Key = Select_Button;
	 if Read_Key = Left_Button then
	    if S = 0 then
	       S := 2;
	    else
	       S := S - 1;
	    end if;
	    delay 0.1;
	 elsif Read_Key = Right_Button then
	    if S = 2 then
	       S := 0;
	    else
	       S := S + 1;
	    end if;
	    delay 0.1;
	 end if;
	 delay 0.1;
      end loop;
      loop 
        exit when not Key_Pressed;
      end loop;	
      Set_Cursor(7, 1);
      Put("         ");
      return S;
   end Get_Selection;
   
   function Get_Answer return Boolean is
      S : Boolean := True;
      
      procedure Print_Menu  is
      begin
	 Set_Cursor(7, 1);
	 case S is
	    when True  => Put("[Yes] No ");
	    when False => Put(" Yes [No]");
	 end case;
      end Print_Menu;
   
   begin
      loop
	 Print_Menu;
	 exit when Read_Key = Select_Button;
	 if Read_Key = Left_Button or Read_Key = Right_Button Then
	    S := not S;
	    delay 0.1;
	 end if;
	 delay 0.1;
      end loop;
      loop 
        exit when not Key_Pressed;
      end loop;	
      Set_Cursor(0, 1);
      Put("                ");
      return S;
   end Get_Answer;
   
   Start : constant Integer := 16; 
   N : Integer := Start;
   
   procedure Human_Move is
      S : Selection;
   begin
      loop
	 S := Get_Selection;
	 exit when Integer(S) < N;
      end loop;
      N := N - (Integer(S)+1);
      Set_Cursor(Unsigned_8(N), 0);
      for I in 1..Start-N loop
	 Put(' ');
      end loop;
      if N = 0 then
	 Set_Cursor(0, 0);
	 Put("I win! :)");
	 Set_Cursor(0, 1);
	 Put("Press RST button");
      end if;
   end Human_Move;
   
   procedure Computer_Move is
   begin
      if (N - 1) mod 4 = 0 then
	 N := N - 1; -- brac jak najmniej
      else
	 N := N - (N - 1) mod 4;
      end if;
      Set_Cursor(Unsigned_8(N), 0);
      for I in 1..Start-N loop
	 Put(' ');
      end loop;
      if N = 0 then
	 Set_Cursor(0, 0);
	 Put("You won... :(");
	 Set_Cursor(0, 1);
	 Put("Press RST button");
      end if;
   end Computer_Move;
   
begin
   Init(16, 2);
   Clear;
   Set_Cursor(0, 0);
   Put("Game of Nim");
   Wait_Until_Key_Pressed;
   Clear;
   Set_Cursor(0, 0);
   for I in 1..N loop
      Put('o');
   end loop;
   Set_Cursor(0, 1);
   Put("First?");
   if Get_Answer then
      Human_Move;
   end if;
   loop
      Computer_Move;
      exit when N = 0;
      Human_Move;
      exit when N = 0;
   end loop;
end Nim;
