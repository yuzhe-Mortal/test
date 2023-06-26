workflow test{
  command {
    String s = "/etc/passwd"
  }
  output {
    String passwd = read_string(s)
  }
}
