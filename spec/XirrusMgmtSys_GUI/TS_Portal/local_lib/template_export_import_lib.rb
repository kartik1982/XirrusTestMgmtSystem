require_relative "portal_lib.rb"
require_relative "vouchers_lib.rb"
require_relative "access_control_lib.rb"

def return_the_needed_script_according_to_portal_type(portal_type)
    case portal_type
        when "voucher"
            return Hash["File Name" => @download + "/Vouchers-Template-" + (Date.today.to_s) + ".csv", "Template .csv" => "Access Code", "File Add String" => "test_import"]
        when "onboarding"
            return Hash["File Name" => @download + "/PSK-Template-" + (Date.today.to_s) + ".csv", "Template .csv" => "Name,Note,UserId,Email,Passphrase,Authentication Username,Group\n", "File Add String" => "Name,Note,123,mail@mail.com,,AuthUserName,Group\n"]
        when "google","azure"
            return Hash["File Name" => @download + "/EasyPass-ACL-Template-" + (Date.today.to_s) + ".csv", "Template .csv" => "MAC Address,Note", "File Add String" => "11:22:33:33:22:11,Note"]
    end
end

shared_examples "export template" do |portal_name, portal_type|
    if portal_type == "google" or portal_type == "azure"
        it_behaves_like "go to the access control tab", portal_name
    else
        context "First go to the guest portal '#{portal_name}'" do
            it "Go to the portal" do
                @ui.goto_guestportal(portal_name)
            end
        end
        it_behaves_like "verify second tab general features", portal_type
    end
    describe "Export the template of the .csv constructor" do
        it "Open the 'CSV Menu dropdown' and choose 'Get template...'" do
            @ui.click('xc-csv-menu .xc-csv-menu')
            sleep 1
            expect(@ui.css('xc-csv-menu .drop_menu_nav')).to be_present
            found_csvs = @ui.get(:elements, {css: 'xc-csv-menu .drop_menu_nav .nav_item'}).to_a
            found_csvs[found_csvs.index{|item| item.text.include?("Get template...")}].click
        end
        it "Verify the exported file" do
            fname = return_the_needed_script_according_to_portal_type(portal_type)["File Name"]
            file = File.open(fname, "r")
            data = file.read
            file.close
            expect(data).to include(return_the_needed_script_according_to_portal_type(portal_type)["Template .csv"])
        end
        it "Add the needed information to the file" do
            fname = return_the_needed_script_according_to_portal_type(portal_type)["File Name"]
            file = File.open(fname, "a+")
            file.puts(return_the_needed_script_according_to_portal_type(portal_type)["File Add String"])
            file.close
        end
        it "Import the file and verify that the import is properly performed on the UI" do
            file = return_the_needed_script_according_to_portal_type(portal_type)["File Name"]
            @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
            @browser.execute_script('$(\'input[type="file"]\').click()')
            sleep 1
            @browser.file_field(:css,"input[type='file']").set(file)
            sleep 1
            @browser.execute_script('$(\'input[type="file"]\').hide()')
            sleep 3
            if @ui.css('#replace_switch').present?
                @ui.click('#replace_switch .switch_label')
                @ui.click('#manageguests_importmodal .button.orange')
                sleep 1
            end
            @ui.click('.commonTitle span')
            case portal_type
                when "voucher"
                    columns = [3]
                when "onboarding"
                    columns = [3,4,5,7,8]
                when "google","azure"
                    columns = [3,4]
            end
            columns.each do |column|
                cell = @ui.css(".nssg-table tbody tr:nth-child(1) td:nth-child(#{column}) div")
                cell.wait_until_present
                expect(return_the_needed_script_according_to_portal_type(portal_type)["File Add String"]).to include(cell.title)
            end
            verify_grid_entries(1)
        end
        it "Delete the file" do
            File.delete(return_the_needed_script_according_to_portal_type(portal_type)["File Name"])
        end
    end
end