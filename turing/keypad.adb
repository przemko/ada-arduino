with Interfaces; use Interfaces;
with AVR.ADC; use AVR.ADC;

package body Keypad is

   ADC_Channel : constant ADC_Channel_T := 0;

   function Key_Pressed return Boolean
   is
   begin
      return Convert_10bit(ADC_Channel) < 1000;
   end Key_Pressed;

   function Read_Key return Button
   is
   begin
      case Convert_10bit(ADC_Channel) is
         when   0 ..  49 => return Right_Button;
         when  50 .. 249 => return Up_Button;
         when 250 .. 449 => return Down_Button;
         when 450 .. 649 => return Left_Button;
         when 650 .. 849 => return Select_Button;
         when others     => return None;
      end case;
   end Read_Key;

begin
   Init(Scale_By_128, Is_Vcc);
end Keypad;

