require_relative "../../TS_Settings/local_lib/settings_lib.rb"
# require_relative "../../troubleshooting/troubleshooting_examples.rb"
require_relative "../../TS_SupportManagement/local_lib/support_management_lib.rb"
require_relative "../../TS_Mynetwork/local_lib/ap_lib.rb"
require_relative "../../TS_Search_Box/local_lib/search_box_lib.rb"

shared_examples "verify timezone values" do
	describe "Verify that the 'Timezone' control has the proper values" do
		go_to_settings_my_account
		it "Verify the control's entries" do
			expect(@ui.get(:element , {class: "field_heading", :text => "Timezone"})).to be_present
			expect(@ui.css("#firmwareupgrades-timezone")).to be_present and expect(@ui.css("#firmwareupgrades-timezone").attribute_value("class")).to include("ko_dropdownlist")
			@ui.click('#firmwareupgrades-timezone .arrow') and sleep 1
			expect(@ui.css("#firmwareupgrades-timezone").attribute_value("class")).to include("active") and expect(@ui.css(".ko_dropdownlist_list.active")).to be_present and sleep 1
			verify_timezones = ["(GMT-11:00) Midway Island, Samoa","(GMT-10:00) Hawaii-Aleutian","(GMT-10:00) Hawaii","(GMT-09:30) Marquesas Islands","(GMT-09:00) Gambier Islands","(GMT-09:00) Alaska","(GMT-08:00) Tijuana, Baja California","(GMT-08:00) Pitcairn Islands","(GMT-08:00) Pacific Time (US & Canada)","(GMT-07:00) Mountain Time (US & Canada)","(GMT-07:00) Chihuahua, La Paz, Mazatlan","(GMT-07:00) Arizona","(GMT-06:00) Saskatchewan, Central America","(GMT-06:00) Guadalajara, Mexico City, Monterrey","(GMT-06:00) Easter Island","(GMT-06:00) Central Time (US & Canada)","(GMT-05:00) Eastern Time (US & Canada)","(GMT-05:00) Cuba","(GMT-05:00) Bogota, Lima, Quito, Rio Branco","(GMT-04:30) Caracas","(GMT-04:00) Santiago","(GMT-04:00) La Paz","(GMT-04:00) Faukland Islands","(GMT-04:00) Brazil","(GMT-04:00) Atlantic Time (Goose Bay)","(GMT-04:00) Atlantic Time (Canada)","(GMT-03:30) Newfoundland","(GMT-03:00) UTC-3","(GMT-03:00) Montevideo","(GMT-03:00) Miquelon, St. Pierre","(GMT-03:00) Greenland","(GMT-03:00) Buenos Aires","(GMT-03:00) Brasilia","(GMT-02:00) Mid-Atlantic","(GMT-01:00) Cape Verde Is.","(GMT-01:00) Azores","(GMT) Greenwich Mean Time : Belfast","(GMT) Greenwich Mean Time : Dublin","(GMT) Greenwich Mean Time : Lisbon","(GMT) Greenwich Mean Time : London","(GMT) Greenwich Mean Time","(GMT) Monrovia, Reykjavik","(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna","(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague","(GMT+01:00) Brussels, Copenhagen, Madrid, Paris","(GMT+01:00) West Central Africa","(GMT+01:00) Windhoek","(GMT+02:00) Beirut","(GMT+02:00) Cairo","(GMT+02:00) Gaza","(GMT+02:00) Harare, Pretoria","(GMT+02:00) Jerusalem","(GMT+02:00) Syria","(GMT+03:00) Minsk","(GMT+03:00) Moscow, St. Petersburg, Volgograd","(GMT+03:00) Nairobi","(GMT+03:30) Tehran","(GMT+04:00) Abu Dhabi, Muscat","(GMT+04:00) Yerevan","(GMT+04:30) Kabul","(GMT+05:00) Tashkent","(GMT+05:00) Yekaterinburg","(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi","(GMT+05:45) Kathmandu","(GMT+06:00) Astana, Dhaka","(GMT+06:00) Novosibirsk","(GMT+06:30) Yangon (Rangoon)","(GMT+07:00) Bangkok, Hanoi, Jakarta","(GMT+07:00) Krasnoyarsk","(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi","(GMT+08:00) Irkutsk, Ulaan Bataar","(GMT+08:00) Perth","(GMT+08:45) Eucla","(GMT+09:00) Osaka, Sapporo, Tokyo","(GMT+09:00) Seoul","(GMT+09:00) Yakutsk","(GMT+09:30) Adelaide","(GMT+09:30) Darwin","(GMT+10:00) Brisbane","(GMT+10:00) Hobart","(GMT+10:00) Vladivostok","(GMT+10:30) Lord Howe Island","(GMT+11:00) Solomon Is., New Caledonia","(GMT+11:00) Magadan","(GMT+11:30) Norfolk Island","(GMT+12:00) Anadyr, Kamchatka","(GMT+12:00) Auckland, Wellington","(GMT+12:00) Fiji, Kamchatka, Marshall Is.","(GMT+12:45) Chatham Islands","(GMT+13:00) Nuku Alofa","(GMT+14:00) Kiritimati"]
			@ui.css(".ko_dropdownlist_list.active ul").lis.each_with_index do |li, i|
				expect(li.attribute_value("data-value").to_s).to eq(verify_timezones[i])
			end
			@browser.send_keys :escape and sleep 1 and expect(@ui.css("#firmwareupgrades-timezone").attribute_value("class")).not_to include("active") and expect(@ui.css(".ko_dropdownlist_list.active")).not_to be_present
		end
	end
end

def find_difference_in_time_objects(css_of_string)
	time_now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
	time_in_application = Time.parse(@ui.css(css_of_string).text).strftime("%Y-%m-%d %H:%M:%S")
	time_difference = Time.diff(time_now, time_in_application)
	return Hash["Hours" => time_difference[:hour], "Minutes" => time_difference[:minute], "Seconds" => time_difference[:second]]
end


def get_time_zone_difference(timezone, css_of_string)
	if timezone.include?("Marquesas Islands")
		string_for_date = @ui.css(css_of_string).text.gsub("MART","")
	else
		string_for_date = @ui.css(css_of_string).text
	end
	date_in_app = DateTime.parse(string_for_date).strftime("%Y-%m-%d")
	dnow = DateTime.now.beginning_of_day.strftime("%Y-%m-%d %H:%M:%S")
	dapp = DateTime.parse(string_for_date).strftime("%Y-%m-%d %H:%M:%S")
	time_difference = Time.diff(date_in_app, dnow)
	time_difference_2 = Time.diff(dnow, dapp)

	return Hash["Date" => DateTime.now.beginning_of_day.strftime("%Y-%m-%d"), "Days" => time_difference[:day] , "Hours" => time_difference_2[:hour] , "Minutes" => time_difference_2[:minute]]
end

def find_certain_time_zone_entry(expected_string)
	timezones_array = ["(GMT-11:00) Midway Island, Samoa","(GMT-10:00) Hawaii-Aleutian","(GMT-10:00) Hawaii","(GMT-09:30) Marquesas Islands","(GMT-09:00) Gambier Islands","(GMT-09:00) Alaska","(GMT-08:00) Tijuana, Baja California","(GMT-08:00) Pitcairn Islands","(GMT-08:00) Pacific Time (US & Canada)","(GMT-07:00) Mountain Time (US & Canada)","(GMT-07:00) Chihuahua, La Paz, Mazatlan","(GMT-07:00) Arizona","(GMT-06:00) Saskatchewan, Central America","(GMT-06:00) Guadalajara, Mexico City, Monterrey","(GMT-06:00) Easter Island","(GMT-06:00) Central Time (US & Canada)","(GMT-05:00) Eastern Time (US & Canada)","(GMT-05:00) Cuba","(GMT-05:00) Bogota, Lima, Quito, Rio Branco","(GMT-04:30) Caracas","(GMT-04:00) Santiago","(GMT-04:00) La Paz","(GMT-04:00) Faukland Islands","(GMT-04:00) Brazil","(GMT-04:00) Atlantic Time (Goose Bay)","(GMT-04:00) Atlantic Time (Canada)","(GMT-03:30) Newfoundland","(GMT-03:00) UTC-3","(GMT-03:00) Montevideo","(GMT-03:00) Miquelon, St. Pierre","(GMT-03:00) Greenland","(GMT-03:00) Buenos Aires","(GMT-03:00) Brasilia","(GMT-02:00) Mid-Atlantic","(GMT-01:00) Cape Verde Is.","(GMT-01:00) Azores","(GMT) Greenwich Mean Time : Belfast","(GMT) Greenwich Mean Time : Dublin","(GMT) Greenwich Mean Time : Lisbon","(GMT) Greenwich Mean Time : London","(GMT) Greenwich Mean Time","(GMT) Monrovia, Reykjavik","(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna","(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague","(GMT+01:00) Brussels, Copenhagen, Madrid, Paris","(GMT+01:00) West Central Africa","(GMT+01:00) Windhoek","(GMT+02:00) Beirut","(GMT+02:00) Cairo","(GMT+02:00) Gaza","(GMT+02:00) Harare, Pretoria","(GMT+02:00) Jerusalem","(GMT+02:00) Syria","(GMT+03:00) Minsk","(GMT+03:00) Moscow, St. Petersburg, Volgograd","(GMT+03:00) Nairobi","(GMT+03:30) Tehran","(GMT+04:00) Abu Dhabi, Muscat","(GMT+04:00) Yerevan","(GMT+04:30) Kabul","(GMT+05:00) Tashkent","(GMT+05:00) Yekaterinburg","(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi","(GMT+05:45) Kathmandu","(GMT+06:00) Astana, Dhaka","(GMT+06:00) Novosibirsk","(GMT+06:30) Yangon (Rangoon)","(GMT+07:00) Bangkok, Hanoi, Jakarta","(GMT+07:00) Krasnoyarsk","(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi","(GMT+08:00) Irkutsk, Ulaan Bataar","(GMT+08:00) Perth","(GMT+08:45) Eucla","(GMT+09:00) Osaka, Sapporo, Tokyo","(GMT+09:00) Seoul","(GMT+09:00) Yakutsk","(GMT+09:30) Adelaide","(GMT+09:30) Darwin","(GMT+10:00) Brisbane","(GMT+10:00) Hobart","(GMT+10:00) Vladivostok","(GMT+10:30) Lord Howe Island","(GMT+11:00) Solomon Is., New Caledonia","(GMT+11:00) Magadan","(GMT+11:30) Norfolk Island","(GMT+12:00) Anadyr, Kamchatka","(GMT+12:00) Auckland, Wellington","(GMT+12:00) Fiji, Kamchatka, Marshall Is.","(GMT+12:45) Chatham Islands","(GMT+13:00) Nuku Alofa","(GMT+14:00) Kiritimati"]
	timezones_array.each do |timezone|
		if timezone.include?(expected_string)
			return timezone
		end
	end
end

def change_timezone_entry_steps(timezone)
	@ui.set_dropdown_entry("firmwareupgrades-timezone", timezone) and sleep 2
	expect(@ui.css('#firmwareupgrades-timezone .text').text).to eq(timezone)
	@browser.refresh
end

def change_date_format_display_entry_steps(date_format, time_format)
	if date_format != nil
		@ui.set_dropdown_entry("firmwareupgrades-dateformat", date_format) and sleep 2
		expect(@ui.css('#firmwareupgrades-dateformat .text').text).to eq(date_format)
	end
	puts @ui.get(:checkbox, {id: "firmwareupgrades-is24hours_switch"}).set?
	if time_format == "24 hour" and @ui.get(:checkbox, {id: "firmwareupgrades-is24hours_switch"}).set? == false
		@ui.click("#firmwareupgrades-is24hours .switch_label")
		sleep 1
	elsif time_format == "12 hour" and @ui.get(:checkbox, {id: "firmwareupgrades-is24hours_switch"}).set? == true
		@ui.click("#firmwareupgrades-is24hours .switch_label")
		sleep 1
	end
	sleep 1
	@browser.refresh
	@ui.css('#firmwareupgrades-is24hours .switch_label').wait_until_present
end

def rezolve_timezone_string(timezone)
	if timezone.include?("(GMT)")
		timezone_offset = "00:00"
	else
		timezone_offset = timezone[timezone.index("T")+1..timezone.index(")")-1]
	end
	timezone_string = timezone[timezone.index(")")+1..timezone.length].lstrip
	puts timezone_string
	timezones_resolved = Hash["(GMT-11:00) Midway Island, Samoa" => "American Samoa","(GMT-10:00) Hawaii-Aleutian" => "Hawaii","(GMT-10:00) Hawaii" => "Hawaii","(GMT-09:30) Marquesas Islands" => "","(GMT-09:00) Gambier Islands" => "Alaska","(GMT-09:00) Alaska" => "Alaska","(GMT-08:00) Tijuana, Baja California" => "Tijuana","(GMT-08:00) Pitcairn Islands" => "Tijuana","(GMT-08:00) Pacific Time (US & Canada)" => "Pacific Time (US & Canada)","(GMT-07:00) Mountain Time (US & Canada)" => "Mountain Time (US & Canada)","(GMT-07:00) Chihuahua, La Paz, Mazatlan" => "Chihuahua","(GMT-07:00) Arizona" => "Arizona","(GMT-06:00) Saskatchewan, Central America" => "Central America","(GMT-06:00) Guadalajara, Mexico City, Monterrey" => "Guadalajara","(GMT-06:00) Easter Island" => "Saskatchewan","(GMT-06:00) Central Time (US & Canada)" => "Central Time (US & Canada)","(GMT-05:00) Eastern Time (US & Canada)" => "Eastern Time (US & Canada)","(GMT-05:00) Cuba" => "Indiana (East)","(GMT-05:00) Bogota, Lima, Quito, Rio Branco" => "Lima","(GMT-04:30) Caracas" => "Caracas","(GMT-04:00) Santiago" => "Santiago","(GMT-04:00) La Paz" => "La Paz","(GMT-04:00) Faukland Islands" => "Georgetown","(GMT-04:00) Brazil" => "Georgetown","(GMT-04:00) Atlantic Time (Goose Bay)" => "Atlantic Time (Canada)","(GMT-04:00) Atlantic Time (Canada)" => "Atlantic Time (Canada)","(GMT-03:30) Newfoundland" => "Newfoundland","(GMT-03:00) UTC-3" => "","(GMT-03:00) Montevideo" => "Montevideo","(GMT-03:00) Miquelon, St. Pierre" => "","(GMT-03:00) Greenland" => "Greenland","(GMT-03:00) Buenos Aires" => "Buenos Aires","(GMT-03:00) Brasilia" => "Brasilia","(GMT-02:00) Mid-Atlantic" => "Mid-Atlantic","(GMT-01:00) Cape Verde Is." => "Cape Verde Is.","(GMT-01:00) Azores" => "Azores","(GMT) Greenwich Mean Time : Belfast" => "Edinburgh","(GMT) Greenwich Mean Time : Dublin" => "Dublin","(GMT) Greenwich Mean Time : Lisbon" => "Lisbon","(GMT) Greenwich Mean Time : London" => "London","(GMT) Greenwich Mean Time" => "UTC","(GMT) Monrovia, Reykjavik" => "Monrovia","(GMT+01:00) Amsterdam, Berlin, Bern, Rome, Stockholm, Vienna" => "Amsterdam","(GMT+01:00) Belgrade, Bratislava, Budapest, Ljubljana, Prague" => "Belgrade","(GMT+01:00) Brussels, Copenhagen, Madrid, Paris" => "Brussels","(GMT+01:00) West Central Africa" => "West Central Africa","(GMT+01:00) Windhoek" => "Zagreb","(GMT+02:00) Beirut" => "Cairo","(GMT+02:00) Cairo" => "Cairo","(GMT+02:00) Gaza" => "Jerusalem","(GMT+02:00) Harare, Pretoria" => "Pretoria","(GMT+02:00) Jerusalem" => "Jerusalem","(GMT+02:00) Syria" => "Jerusalem","(GMT+03:00) Minsk" => "Minsk","(GMT+03:00) Moscow, St. Petersburg, Volgograd" => "Moscow","(GMT+03:00) Nairobi" => "Nairobi","(GMT+03:30) Tehran" => "Tehran","(GMT+04:00) Abu Dhabi, Muscat" => "Abu Dhabi","(GMT+04:00) Yerevan" => "Yerevan","(GMT+04:30) Kabul" => "Kabul","(GMT+05:00) Tashkent" => "Tashkent","(GMT+05:00) Yekaterinburg" => "Ekaterinburg","(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi" => "New Delhi","(GMT+05:45) Kathmandu" => "Kathmandu","(GMT+06:00) Astana, Dhaka" => "Astana","(GMT+06:00) Novosibirsk" => "Dhaka","(GMT+06:30) Yangon (Rangoon)" => "Rangoon","(GMT+07:00) Bangkok, Hanoi, Jakarta" => "Bangkok","(GMT+07:00) Krasnoyarsk" => "Krasnoyarsk","(GMT+08:00) Beijing, Chongqing, Hong Kong, Urumqi" => "Beijing","(GMT+08:00) Irkutsk, Ulaan Bataar" => "Irkutsk","(GMT+08:00) Perth" => "Perth","(GMT+08:45) Eucla" => "","(GMT+09:00) Osaka, Sapporo, Tokyo" => "Tokyo","(GMT+09:00) Seoul" => "Seoul","(GMT+09:00) Yakutsk" => "Yakutsk","(GMT+09:30) Adelaide" => "Adelaide","(GMT+09:30) Darwin" => "Darwin","(GMT+10:00) Brisbane" => "Brisbane","(GMT+10:00) Hobart" => "Hobart","(GMT+10:00) Vladivostok" => "Vladivostok","(GMT+10:30) Lord Howe Island" => "","(GMT+11:00) Solomon Is., New Caledonia" => "Solomon Is.","(GMT+11:00) Magadan" => "Magadan","(GMT+11:30) Norfolk Island" => "","(GMT+12:00) Anadyr, Kamchatka" => "Kamchatka","(GMT+12:00) Auckland, Wellington" => "Wellington","(GMT+12:00) Fiji, Kamchatka, Marshall Is." => "Marshall Is.","(GMT+12:45) Chatham Islands" => "Chatham Is.","(GMT+13:00) Nuku Alofa" => "Nuku'alofa","(GMT+14:00) Kiritimati" => "Samoa"]
	return Hash["Timezone Name" => timezones_resolved[timezone], "Timezone Offset String" => timezone_offset, "Timezone Offset Float" => timezone_offset.gsub(":",".").to_f]
end

def get_application_date(css_of_string)
	string = @ui.css(css_of_string).text
	puts string
	if string.include?(":")
		application_date = DateTime.strptime(string, "%m/%d/%Y %l:%M %P").strftime("%Y-%m-%d %l:%M %P") # rescue DateTime.strptime(string, "%Y.%m.%d %l:%M %P").strftime("%Y-%m-%d %l:%M %P")
	else
		application_date = Date.strptime(string, "%m/%d/%Y")
	end
	puts "APPLICATION DATE = #{application_date}"
	return application_date
end

def return_date_time_format_for_certain_display_option(date_format, time_format)
	case date_format
		when "DD/MM/YYYY"
			date_format = "%-d/%-m/%Y"
		when "MM/DD/YYYY"
			date_format = "%-m/%-d/%Y"
		when "YYYY/MM/DD"
			date_format = "%Y/%-m/%-d"
		when "DD.MM.YYYY"
			date_format = "%-d.%-m.%Y"
		when "MM.DD.YYYY"
			date_format = "%-m.%-d.%Y"
		when "YYYY.MM.DD"
			date_format = "%Y.%-m.%-d"
		when "DD-MM-YYYY"
			date_format = "%-d-%-m-%Y"
		when "MM-DD-YYYY"
			date_format = "%-m-%-d-%Y"
		when "YYYY-MM-DD"
			date_format = "%Y-%-m-%-d"
	end
	if time_format == "12 hour"
		time_format = "%-l:%M %P"
	elsif time_format == "24 hour"
		time_format = "%H:%M"
	end
	return date_format + " " + time_format
end

def verify_application_date_format(css_of_string, what_format)
	string = @ui.css(css_of_string).text
	if css_of_string == ".report-preview-body .report-cover-info div"
		string = string.gsub("Report generated: ", "")
	elsif css_of_string == ".widgets-list .xc-widget-container-header .timespan"
		string = string.gsub("(", "")[0..string.index(" - ")-2]
	end
	puts "ACI --------"
	puts string
	puts "DISPLAY OPTION CHOSEN ::::: #{what_format}"
	strip_format = what_format.gsub("-m", "m").gsub("-d", "d").gsub("-l", "l")
	puts "STRIP OPTION CHOSEN ::::: #{strip_format}"
	if string.include?(":")
		application_date = DateTime.strptime(string, strip_format) #.strftime(what_format)
		puts application_date
		application_date = application_date.strftime(what_format)
		puts application_date
		puts "UNU"
	else
		strip_format = strip_format[0..8]
		puts "STRIP OPTION CHOSEN 2 ::::: #{strip_format}"
		application_date = Date.strptime(string, strip_format)
		puts application_date
		puts "WHAT FORMAT = #{what_format[0..what_format.index(" ")-1]}"
		application_date = application_date.strftime(what_format[0..what_format.index(" ")-1])
		puts application_date
	end
	puts "APPLICATION DATE = #{application_date}"
	expect(string).to eq(application_date)
	return application_date
end

def find_difference_in_date_objects(application_date, verified_date)
	time_difference = Time.diff(verified_date, application_date)
	return Hash["Days" => time_difference[:day] , "Hours" => time_difference[:hour] , "Minutes" => time_difference[:minute]]
end

shared_examples "set timezone area to specific one" do |timezone|
	describe "Change the timezone to the '#{timezone}' option" do
		it "Change the application timezone to '#{timezone}'" do
			go_to_settings_my_account_method
			change_timezone_entry_steps(timezone)
			sleep 2
		end
	end
end

shared_examples "set timezone area to local" do
	describe "If needed change the timezone to the local one" do
		it "Get the local application date value and change the application timezone to that" do
			go_to_settings_my_account_method
			local_timezone = find_certain_time_zone_entry(DateTime.now.zone.to_s)
			change_timezone_entry_steps(local_timezone)
			sleep 2
		end
	end
end

shared_examples "set date time format to specific" do |date_format, time_format|
	describe "Set the Date / Time format to a specific value" do
		it "Change the display format to '#{date_format}' + '#{time_format}'" do
			go_to_settings_my_account_method
			change_date_format_display_entry_steps(date_format, time_format)
		end
	end
end

shared_examples "verify date time format" do |where, what_area, css_of_string, date_format, time_format|
	describe "Verify the date / time format on the area '#{what_area}' of the application is '#{date_format}' + '#{time_format}'" do
		it "Change the display format to '#{date_format}' + '#{time_format}'" do
			go_to_settings_my_account_method
			change_date_format_display_entry_steps(date_format, time_format)
		end
	end
	if where == "Portal - Guests tab" or where == "Reports - Creation, Edit"
		it_behaves_like "#{what_area[0]}", what_area[1]
	elsif where == "MSP - Access Points"
		it_behaves_like "#{what_area[0]}"
		it_behaves_like "#{what_area[1]}", what_area[2]
	else
		it_behaves_like "#{what_area}"
	end
	describe "Verify the displayed date and time format" do
			it "Verify '#{date_format}, #{time_format}' format properly displayed" do
				if where == "Support Management - Access Points tab"
					go_to_tab_support_management("Access Points")
					sleep 2
					until @ui.css(".nssg-thead tr:first-child th:nth-child(15)").attribute_value("class").include?("nssg-sorted-asc")
						@ui.click(".nssg-thead tr:first-child th:nth-child(15) .nssg-th-text")
						sleep 1
					end
				elsif where == "MSP - Access Points"
					until @ui.css(".nssg-thead tr:first-child th:nth-child(7)").attribute_value("class").include?("nssg-sorted-asc")
						@ui.click(".nssg-thead tr:first-child th:nth-child(7) .nssg-th-text")
						sleep 1
					end
				elsif where == "My Network - Access Points tab"
					@ui.click('#mynetwork_arrays_grid_cp')
				    sleep 1
				    expect(@ui.css('#mynetwork_arrays_grid_cp_modal')).to be_visible
				    sleep 1
				    @ui.click('#column_selector_restore_defaults')
				    sleep 1
				    @ui.css('#mynetwork_arrays_grid_cp_modal .lhs .select_list ul').li(:text => "Last Configured Time").click
				    sleep 1
				    @ui.click('#column_selector_modal_move_btn')
				    sleep 1
				    @ui.click('#column_selector_modal_save_btn')
				    sleep 3
				    until @ui.css(".nssg-thead tr:first-child th:nth-child(11)").attribute_value("class").include?("nssg-sorted-asc")
						@ui.click(".nssg-thead tr:first-child th:nth-child(11) .nssg-th-text")
						sleep 1
					end
				end
				@browser.refresh
				sleep 3
				verify_application_date_format(css_of_string, return_date_time_format_for_certain_display_option(date_format, time_format))
			end
		end
end

shared_examples "settings my account set timezone" do |verify_timezones, timezone, where, what_area, css_of_string, date_format, time_format|
	if verify_timezones == true
		it_behaves_like "verify timezone values"
	end
	if date_format != nil and time_format != nil
		describe "Change the date display format to '#{date_format}' and / or time format '#{time_format}'" do
			it "Change the display format" do
				go_to_settings_my_account_method
				change_date_format_display_entry_steps(date_format, time_format)
			end
		end
	end
	if where == "My Network - Access Points tab"
		describe "If needed change the timezone to the local one" do
			before "Get the local application date value" do
				go_to_settings_my_account_method
				local_timezone = find_certain_time_zone_entry(DateTime.now.zone.to_s)
				change_timezone_entry_steps(local_timezone)
				sleep 2
				go_to_my_network_arrays_tab
				if !@ui.css(css_of_string).exists?
					if_not_already_present_add_certain_column("Last Configured Time")
				end
			    @@local_date = get_application_date(css_of_string)
			  end
			  it "Get the local application date value" do
			  	sleep 1
			  end
		end
	elsif where == "Support Management - Access Points tab"
		describe "If needed change the timezone to the local one" do
			before :all do
				go_to_settings_my_account_method
				local_timezone = find_certain_time_zone_entry(DateTime.now.zone.to_s)
				change_timezone_entry_steps(local_timezone)
				sleep 2
			end
			#it_behaves_like "go to support management new"
			it "Go to the Support Management area" do
				go_to_support_management_new
			end
			it "Go to the 'Access Points' tab" do
				go_to_tab_support_management("Access Points")
				sleep 2
			end
			it "Search for the AP " do
				if $the_environment_used == "test03"
					ap_sn = "X306519043B60"
				elsif $the_environment_used == "test01"
					ap_sn = "X20641902ADDC"
				end
				search_for_a_certain_string_new(ap_sn,1)
			    @@local_date = get_application_date(css_of_string)
			    puts "LOCAL DATE: #{@@local_date}"
			  end
		end
	elsif where == "Support Management - Firmware - Add"
		it_behaves_like "go to support management"
		it_behaves_like "create a new firmware", "99.9.9-99999" , DateTime.now.strftime("%Y-%m-%d"), "https://www.google.co.uk", false, false, false, false
	elsif where == "Portal - Guests tab"
		describe "If needed change the timezone to the local one" do
			before "Get the local application date value" do
				go_to_settings_my_account_method
				local_timezone = find_certain_time_zone_entry(DateTime.now.zone.to_s)
				change_timezone_entry_steps(local_timezone)
				@ui.css('#header_logo').wait_until_present
				navigate_to_portals_landing_page_and_open_specific_portal("list",what_area[1],false)
				sleep 3
	          	@ui.click('#general_show_advanced')
	          	sleep 2
	          	@ui.click('#profile_tabs a:nth-child(2)')
				sleep 3
			    @@local_date = get_application_date(css_of_string)
			  end
			  it "Get the local application date value" do
			  	sleep 1
			  end
		end
	end
	describe "In the SETTINGS area, on the My Account tab, set the Timezone value to '#{timezone}'" do
		go_to_settings_my_account
		it "Set the entry '#{timezone}'" do
			change_timezone_entry_steps(timezone)
		end
	end
	if where == "Portal - Guests tab"
		it_behaves_like "#{what_area[0]}", what_area[1]
	else
		it_behaves_like "#{what_area}"
	end
	describe "Verify that the time difference and time zone (#{timezone}) are properly displayed" do
		case where
			when "Support Management - Firmware", "Support Management - Firmware - Add", "Support Management - Firmware - Delete"
				it "Verify time difference and time zone" do
=begin
					@browser.refresh
					sleep 3
					application_date = get_application_date(css_of_string)
					puts application_date
					puts DateTime.now.beginning_of_day.strftime("%Y-%m-%d").to_date
					time_difference = find_difference_in_date_objects(application_date, DateTime.now.beginning_of_day.strftime("%Y-%m-%d").to_date)
					puts time_difference
					timezone_hash = rezolve_timezone_string(timezone)
					puts timezone_hash

					time_zone_now = Time.now.utc_offset/3600
					puts time_zone_now

					if time_zone_now == timezone_hash["Timezone Offset Float"] or time_zone_now < timezone_hash["Timezone Offset Float"]
						expect(time_difference["Days"]).to eq(0)
					else
						expect(time_difference["Days"]).to eq(1)
					end
=end
				end

			when "Troubleshooting - Audit Trail"
				it "Verify time difference and time zone (#{timezone})" do
					@browser.refresh
					sleep 3
					application_date = get_application_date(css_of_string)
					puts application_date
					log "APPLICATION DATE = #{application_date}"
					#if date_format != nil
					#	puts DateTime.now.strftime("%-d-%-m-%Y %l:%M %P")
					#	log 'DATE NOW = #{DateTime.now.strftime("%-d-%-m-%Y %l:%M %P")}'
					#	time_difference = find_difference_in_date_objects(application_date, DateTime.now.strftime("%-d-%-m-%Y %l:%M %P"))
					#	verify_application_date_format(css_of_string, return_date_time_format_for_certain_display_option(date_format))
					#else
						puts DateTime.now.strftime("%Y-%m-%d %l:%M %P")
						log 'DATE NOW = #{DateTime.now.strftime("%Y-%m-%d %l:%M %P")}'
						time_difference = find_difference_in_date_objects(application_date, DateTime.now.strftime("%Y-%m-%d %l:%M %P"))
					#end
					puts time_difference
					log "TIME DIFFERENCE = #{time_difference}"
					timezone_hash = rezolve_timezone_string(timezone)
					puts timezone_hash
					log "TIMEZONE HASH = #{timezone_hash}"

					time_zone_now = Time.now.utc_offset/3600
					puts time_zone_now
					expect(time_difference["Days"]).to eq(0)

					timezone_daylight_savings = ["", " ", "Saskatchewan", "Marshall Is.", "Chatham Is.", "Wellington", "Kamchatka",  "Solomon Is.", "Hobart", "Adelaide", "Guadalajara", "Caracas", "Santiago", "Georgetown", "Zagreb", "Dhaka"]
					if timezone_daylight_savings.include?(timezone_hash["Timezone Name"])
						puts "TIMEZONE IS INCLUDED IN DAYLIGHT SAVINGS"
						if timezone.include? "Lord Howe Island"
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now
						elsif timezone_hash["Timezone Offset String"].include?("-")
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i + time_zone_now -1
						elsif timezone_hash["Timezone Offset String"] == ("00:00") or timezone_hash["Timezone Offset String"] == ("+01:00")
							hours = (timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now).abs
						else
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now +1
						end
					else
						if timezone_hash["Timezone Offset String"].include?("-")
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i + time_zone_now
						elsif timezone_hash["Timezone Offset String"] == ("00:00") or timezone_hash["Timezone Offset String"] == ("+01:00")
							hours = (timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now).abs
						else
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now
						end
					end
					puts "hours #{hours}"
					if time_difference["Minutes"] > 58 and time_difference["Minutes"] < 60 or time_difference["Minutes"] == 45
						puts "MINUTES ARE NOT AT 0"
						if timezone_hash["Timezone Offset String"].include?("-")
							hours = hours + 1
						elsif timezone_hash["Timezone Offset String"] == ("00:00")
							hours = hours
						else
							hours = hours - 1
						end
					end
					minutes = timezone_hash["Timezone Offset String"][timezone_hash["Timezone Offset String"].index(":")+1..timezone_hash["Timezone Offset String"].index(":")+3].to_i
					if timezone.include? "Lord Howe Island"
						minutes = minutes + 30
						if minutes == 60
							minutes = 0
							hours = hours + 1
						end
					end
					puts "Hours : #{hours}"
					puts "Minutes: #{minutes}"
					expect(time_difference["Hours"]).to eq(hours)
					if time_difference["Minutes"] > 58 and time_difference["Minutes"] < 60
						expect([minutes+58, minutes+59]).to include(time_difference["Minutes"])
					else
						expect([minutes-2, minutes-1, minutes, minutes+1, minutes+2]).to include(time_difference["Minutes"])
					end
				end

			when "My Network - Access Points tab", "Portal - Guests tab"
				it "Verify time difference and time zone" do

				puts @@local_date
				application_date = get_application_date(css_of_string)
					puts application_date
					log "APPLICATION DATE = #{application_date}"
					puts DateTime.now.strftime("%Y-%m-%d %l:%M %P")
					log 'DATE NOW = #{DateTime.now.strftime("%Y-%m-%d %l:%M %P")}'
					time_difference = find_difference_in_date_objects(application_date, DateTime.now.strftime("%Y-%m-%d %l:%M %P"))
					puts time_difference
					log "TIME DIFFERENCE = #{time_difference}"
					timezone_hash = rezolve_timezone_string(timezone)
					puts timezone_hash
					log "TIMEZONE HASH = #{timezone_hash}"

					time_zone_now = Time.now.utc_offset/3600
					puts time_zone_now
					expect(time_difference["Days"]).to eq(0)

					timezone_daylight_savings = ["", " ", "Saskatchewan", "Marshall Is.", "Chatham Is.", "Wellington", "Kamchatka",  "Solomon Is.", "Hobart", "Adelaide", "Guadalajara", "Caracas", "Santiago", "Georgetown", "Zagreb", "Dhaka"]
					if timezone_daylight_savings.include?(timezone_hash["Timezone Name"])
						puts "TIMEZONE IS INCLUDED IN DAYLIGHT SAVINGS"
						if timezone.include? "Lord Howe Island"
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now
						elsif timezone_hash["Timezone Offset String"].include?("-")
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i + time_zone_now -1
						elsif timezone_hash["Timezone Offset String"] == ("00:00") or timezone_hash["Timezone Offset String"] == ("+01:00")
							hours = (timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now).abs
						else
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now +1
						end
					else
						if timezone_hash["Timezone Offset String"].include?("-")
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i + time_zone_now
						elsif timezone_hash["Timezone Offset String"] == ("00:00") or timezone_hash["Timezone Offset String"] == ("+01:00")
							hours = (timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now).abs
						else
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now
						end
					end
					if where == "Portal - Guests tab" and css_of_string.include? ".accessActivationDate"
						case what_area[2]
						when "15 minutes"
							if timezone_hash["Timezone Offset String"].include?("-")
								hours = hours + 1
							elsif timezone_hash["Timezone Offset String"] == ("00:00")
								hours = hours
							else
								hours = hours - 1
							end
						end
					end
					puts "hours #{hours}"
					puts "where = #{where}"
					puts "time_difference['Minutes'] #{time_difference["Minutes"]}"
					if where == "Portal - Guests tab" and time_difference["Minutes"] != 0
						puts "PORTAL GUESTS TAB TIME DIFFERENCE CORRECTION"
						if timezone_hash["Timezone Offset String"].include?("-")
							puts "Subtract ONE HOUR"
							hours = hours - 1
						end
					end
					if time_difference["Minutes"] > 58 and time_difference["Minutes"] < 60 or time_difference["Minutes"] == 45
						puts "MINUTES ARE NOT AT 0"
						if timezone_hash["Timezone Offset String"].include?("-")
							hours = hours + 1
						elsif timezone_hash["Timezone Offset String"] == ("00:00")
							hours = hours
						else
							hours = hours - 1
						end
					end
					minutes = timezone_hash["Timezone Offset String"][timezone_hash["Timezone Offset String"].index(":")+1..timezone_hash["Timezone Offset String"].index(":")+3].to_i
					if timezone.include? "Lord Howe Island"
						minutes = minutes + 30
						if minutes == 60
							minutes = 0
							hours = hours + 1
						end
					end
					puts "Hours : #{hours}"
					puts "Minutes: #{minutes}"
					expect(time_difference["Hours"]).to eq(hours)
					if time_difference["Minutes"] > 58 and time_difference["Minutes"] < 60
						expect([minutes+58, minutes+59]).to include(time_difference["Minutes"])
					elsif where == "Portal - Guests tab"
						if css_of_string.include? ".accessActivationDate"
							if timezone_hash["Timezone Offset String"].include?("-")
								expect(time_difference["Minutes"]).to be_between(25,44)
							else
								expect(time_difference["Minutes"]).to be_between(16,36)
							end
						else
							if timezone_hash["Timezone Offset String"].include?("-")
								expect(time_difference["Minutes"]).to be_between(40,59)
							else
								expect(time_difference["Minutes"]).to be_between(1,20)
							end
						end
					else
						minutes_array = []
						(-30..30).each do |diff|
							minutes_array.push(0, minutes + diff)
						end
						#minutes_array = [minutes-10, minutes-9, minutes-8, minutes-7, minutes-6, minutes-5, minutes-4, minutes-3, minutes-2, minutes-1, minutes, minutes+1, minutes+2, minutes+3, minutes+4, minutes+5, minutes+6, minutes+7, minutes+8, minutes+9 , minutes+10]
						expect(minutes_array).to include(time_difference["Minutes"])
					end
			end

			when "Support Management - Access Points tab"
				it "Go to the 'Access Points' tab" do
					go_to_tab_support_management("Access Points")
					sleep 2
				end
				it "Search for the AP " do
					if $the_environment_used == "test03"
						ap_sn = "X306519043B60"
					elsif $the_environment_used == "test01"
						ap_sn = "X20641902ADDC"
					end
					search_for_a_certain_string_new(ap_sn,1)
				    @@new_date = get_application_date(css_of_string)
				    puts "NEW DATE: #{@@new_date}"
				 end
				it "Verify time difference and time zone" do
					sleep 3
					time_difference = find_difference_in_date_objects(@@new_date, @@local_date)
					puts time_difference
					log "TIME DIFFERENCE = #{time_difference}"
					timezone_hash = rezolve_timezone_string(timezone)
					puts timezone_hash
					log "TIMEZONE HASH = #{timezone_hash}"

					time_zone_now = Time.now.utc_offset/3600
					puts time_zone_now
					expect(time_difference["Days"]).to eq(0)

					timezone_daylight_savings = ["", " ", "Saskatchewan", "Marshall Is.", "Chatham Is.", "Wellington", "Kamchatka",  "Solomon Is.", "Hobart", "Adelaide", "Guadalajara", "Caracas", "Santiago", "Georgetown", "Zagreb", "Dhaka"]
					if timezone_daylight_savings.include?(timezone_hash["Timezone Name"])
						puts "TIMEZONE IS INCLUDED IN DAYLIGHT SAVINGS"
						if timezone.include? "Lord Howe Island"
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now
						elsif timezone_hash["Timezone Offset String"].include?("-")
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i + time_zone_now -1
						elsif timezone_hash["Timezone Offset String"] == ("00:00") or timezone_hash["Timezone Offset String"] == ("+01:00")
							hours = (timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now).abs
						else
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now +1
						end
					else
						if timezone_hash["Timezone Offset String"].include?("-")
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i + time_zone_now
						elsif timezone_hash["Timezone Offset String"] == ("00:00") or timezone_hash["Timezone Offset String"] == ("+01:00")
							hours = (timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now).abs
						else
							hours = timezone_hash["Timezone Offset String"][1..timezone_hash["Timezone Offset String"].index(":")-1].to_i - time_zone_now
						end
					end
					puts "hours #{hours}"
					if time_difference["Minutes"] > 58 and time_difference["Minutes"] < 60 or time_difference["Minutes"] == 45
						puts "MINUTES ARE NOT AT 0"
						if timezone_hash["Timezone Offset String"].include?("-")
							hours = hours - 1
						elsif timezone_hash["Timezone Offset String"] == ("00:00")
							hours = hours - 1
						else
							hours = hours - 1
						end
					end
					minutes = timezone_hash["Timezone Offset String"][timezone_hash["Timezone Offset String"].index(":")+1..timezone_hash["Timezone Offset String"].index(":")+3].to_i
					if timezone.include? "Lord Howe Island"
						minutes = minutes + 30
						if minutes == 60
							minutes = 0
							hours = hours + 1
						end
					end
					puts "Hours : #{hours}"
					puts "Minutes: #{minutes}"
					expect(time_difference["Hours"]).to eq(hours)
					if time_difference["Minutes"] > 58 and time_difference["Minutes"] < 60
						expect([minutes+58, minutes+59]).to include(time_difference["Minutes"])
					else
						expect([minutes-2, minutes-1, minutes, minutes+1, minutes+2]).to include(time_difference["Minutes"])
					end
					#expect(time_difference["Minutes"]).to eq(minutes)
			end
		end # END case
	end # END describe statement
	case where
		when "Support Management - Firmware - Delete"
			it_behaves_like "go to support management"
			it_behaves_like "delete a certain firmware with grid delete button", "99.9.9-99999"
	end
end