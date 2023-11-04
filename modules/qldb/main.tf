resource "aws_qldb_ledger" "main-ledger" {
  name             = "${var.project}-ledger"
  permissions_mode = "STANDARD"
}
