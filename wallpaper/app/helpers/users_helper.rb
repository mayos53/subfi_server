module UsersHelper

  def random_number
    1_001+ Random.rand(9_999 - 1_001) 
  end 

  # get phone with country_code
   def get_phone_number(phone,countryCode)
     if phone.start_with?("0")
      phone = phone[1..-1]
     end  
     countryCode.to_s+phone
   end   

end
