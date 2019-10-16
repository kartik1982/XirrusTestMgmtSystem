require 'testrail-ruby'

# client = TestRail::APIClient.new('https://testrail.camnwk.com')
# client.user = 'kai100'
# client.password = 'Krishna@1982'
client = TestRail::APIClient.new('https://testrail.lab.nbttech.com/core')
client.user = 'kaiyar'
client.password = 'Jessica@1982'

puts client.get_projects
puts client.get_project(1)
# client.get_tests(1)
puts client.get_tests(6816, {})
