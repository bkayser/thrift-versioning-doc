/*
 * This interface has changes to version 1.* which break backward compatibility.
 */
namespace * V2

struct AccountID {
  1: required i64 id,
  2: string name,
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
  AccountID lookup(2:Mode mode, 1:i64 id, 4:string name="*"),
  // Rename update method
  AccountID update_account(1:AccountID account)
}

