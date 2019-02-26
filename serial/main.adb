with AVR.UART; use AVR.UART;
with AVR.Real_Time.Delays;

procedure Main is

   procedure Welcome is
   begin
      CRLF;
      CRLF;
      Put ("Program drukuje znaki ASCII o kodach od 32 do 126.");
      CRLF;
      Put ("Aby rozpoczac nacisnij dwukrotnie Enter.");
      CRLF;
      Put ("Aby rozpoczac od nowa nacisnij przycisk RST.");
      CRLF;
   end Welcome;

   procedure Enter2 is
      Ch : Character;
   begin
      loop
	 loop
	    Ch := Get;
	    exit when Ch = ASCII.CR;
	 end loop;
	 Ch := Get;
	 exit when Ch = ASCII.CR;
      end loop;
   end Enter2;

begin
   Init (Baud_9600_16MHz);
   Welcome;
   Enter2;
   loop
      for Ch in Character range ' ' .. '~' loop
	 Put (Ch);
	 delay 0.05;
      end loop;
   end loop;
end Main;
