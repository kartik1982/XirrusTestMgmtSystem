module Accounts
  def post_add_account(account_load)
    post("apexrest/all-accounts", account_load)
  end
  def delete_account_with_account_name(account_name)
    delete("apexrest/all-accounts", {accountName: account_name})
  end
end