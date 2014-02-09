struct AccountID {
  1:i64 id,
  2:string name
}
exception InvalidAccountException {
  1:string message
}
service AccountIdentity {
  # returns a valid AccountID or throws an error if the account is not found
  AccountID lookup(1:i64 id, 2:option) throws (1:InvalidAccountException ae),

  # returns a collection of accounts with the given ids.  If any ids are missing, nothing
  # is returned for them and no error occurs.
  list<AccountID> bulk_lookup(1:list<i64> ids),

  # returns a valid account or an error if the account name already
  # exists, or there is some other problem with the name.
  AccountID create(1:string name) throws (1:InvalidAccountException ae),

  # Update the name of an account.  
  void update(1:AccountID id) throws (1:InvalidAccountException ae),

  # This is an async operation which returns immediately
  oneway void sync_to_salesforce(1:i64 id)
}

