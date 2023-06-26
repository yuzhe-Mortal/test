task readPasswd {
  command {
    cat /etc/passwd
  }
  output {
    String passwd = read_string(stdout())
  }
}
