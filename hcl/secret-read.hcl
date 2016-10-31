path "secret/staging/*" {
  policy = "read"
}

path "auth/token/lookup-self" {
  policy = "read"
}
