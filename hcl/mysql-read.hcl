path "secret/*" {
  policy = "deny"
}

path "mysql/local-docker/creds" {
  policy = "read"
}

path "auth/token/lookup-self" {
  policy = "read"
}
