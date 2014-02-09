/*
 * This interface has changes to version 1 which are both source and 
 * binary compatible, as noted below.
 */
namespace * AIS

struct Account {
  1: required i64 id,
  2: string name,
  3: string key,
  // Adding another optional field
  4: i64 parent
}

enum Mode {
  ADMIN = 0,
  PARTNER = 1
}

exception InvalidAccountException {
  1: string message
}

service Accounts {
  // Remove the declared exception from the method signature
  Account lookup(1:i64 id, 2:Mode mode, 3:bool active),
  Account update(1:Account account) throws (1:InvalidAccountException ae)
}

