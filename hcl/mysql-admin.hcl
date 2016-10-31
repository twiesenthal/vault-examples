path "secret/*" {
  policy = "deny"
}

path "mysql/local-docker/*" {
  policy = "create"
  policy = "read"
  policy = "update"
  policy = "delete"
  policy = "list"
  policy = "sudo"
}

path "auth/token/lookup-self" {
  policy = "read"
}
