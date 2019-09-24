require_relative "portal_lib.rb"

def verify_grid_entries(expected_entries)
    tfull = @ui.css('.nssg-table')
    tfull.wait_until_present
    expect(tfull.trs.length).to eq(expected_entries+1)
    if expected_entries == 0
        expect(@ui.css('.nssg-table tbody tr')).not_to exist
    else
        tbody = @ui.css('.nssg-table tbody')
        tbody.wait_until_present
        expect(tbody.trs.length).to eq(expected_entries)
    end
end

shared_examples "add voucher" do |portal_name|
    describe "Generate a voucher for the portal named '#{portal_name}'" do
        it "Generate a Voucher" do
            expected_entries = @ui.css('.nssg-table').trs.length
            @ui.click('#managevouchers_addnew_btn')
            @ui.set_input_val('#voucher_count','1')
            @ui.click('#manageguests_vouchermodal .button.orange')
            sleep 1
            verify_grid_entries(expected_entries)
        end
    end
end

shared_examples "export voucher" do |portal_name| #Changed on 31/05/2017 - due to US 4959
    describe "Export a voucher for the portal named '#{portal_name}'" do
        test_runner_hash = Hash["Export All" => "#managevouchers_exportallcsv", "Export Non-Expired" => "#managevouchers_exportnonexpiredcsv"]
        test_runner_hash.keys.each { |key|
            it "Export the Voucher using '#{key}' and verify that the file properly contains the 'access code'" do
                code = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
                code.wait_until_present
                accesscode = code.title
                #@ui.click('#mn-cl-export-btn-mnu .icon')
                @ui.click('xc-csv-menu .blue')
                sleep 1
                @ui.css('.drop_menu_nav.active').wait_until_present
                #expect(@ui.css('#mn-cl-export-btn-mnu .drop_menu_nav')).to be_present
                @ui.css('.drop_menu_nav.active .items').a(:text => key + "...").click
                sleep 4
                fname = @download + "/Vouchers-" + portal_name + "-" + (Date.today.to_s) + ".csv"
                file = File.open(fname, "r")
                data = file.read
                file.close
                expect(data.include?(accesscode)).to eq(true)
                File.delete(@download +"/Vouchers-" + portal_name + "-" + (Date.today.to_s) + ".csv")
            end
        }
    end
end

shared_examples "import voucher" do |portal_name|
    describe "Import a voucher (.csv file) for the portal named '#{portal_name}'" do
        it "Import a .csv file with one Voucher and verify that the grid contains the 'Import' title voucher line" do
            file = Dir.pwd + "/import_vouchers.csv"
            @browser.execute_script('$(\'input[type="file"]\').css({"opacity":"1"})')
            @browser.execute_script('$(\'input[type="file"]\').click()')
            sleep 1
            @browser.file_field(:css,"input[type='file']").set(file)
            sleep 1
            @browser.execute_script('$(\'input[type="file"]\').hide()')
            sleep 3.0
            @ui.click('#replace_switch .switch_label')
            @ui.click('#manageguests_importmodal .button.orange')
            sleep 1
            code = @ui.css('.nssg-table tbody tr:nth-child(1) td:nth-child(3) div')
            code.wait_until_present
            expect(code.title).to eq('import')
            verify_grid_entries(1)
        end
    end
end

shared_examples "delete voucher" do |portal_name|
    describe "Delete a voucher for the portal named '#{portal_name}'" do
        it "Delete the Voucher" do
            @ui.css('.nssg-table tbody tr:nth-child(1)').hover
            sleep 1
            @ui.click('.nssg-action-delete')
            sleep 1
            @ui.confirm_dialog
            sleep 1
            verify_grid_entries(0)
        end
    end
end

shared_examples "navigate to the portal second page" do |portal_name, scoped|
    describe "Navigate to the second page of the portal named '#{portal_name}'" do
        it "Go to the Vouchers tab" do
          navigate_to_portals_landing_page_and_open_specific_portal("list",portal_name,scoped)
          @ui.click('#profile_tabs a:nth-child(2)')
          sleep 2
        end
    end
end

shared_examples "add, edit and delete vouchers" do |portal_name|
    it_behaves_like "navigate to the portal second page", portal_name
    it_behaves_like "add voucher", portal_name
    it_behaves_like "export voucher", portal_name
    it_behaves_like "import voucher", portal_name
    it_behaves_like "delete voucher", portal_name
end

shared_examples "verify vouchers table" do
    describe "Verify the vouchers table" do
        it "Verify that the Vouchers table contains the following columns: 'Access Code', 'State', 'Registered Devices', 'Activation', 'Expiration" do
            verify_hash = Hash[2 => "Access Code", 3 => "State", 4 => "Registered Devices", 5 => "Activation", 6 => "Expiration"]
            table_headers = @ui.get(:elements , {css: '.nssg-table thead .nssg-thead-tr .nssg-th'})
            table_headers.each_with_index { |table_header, index|
                if index >= 2
                    expect(table_header.element(css: ".nssg-th-text").text).to eq(verify_hash[index])
                end
            }
        end
    end
end
