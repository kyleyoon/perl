user "my-usr";
password "my-password";
pass_auth;

group myserver => "mywebserver",  "mymailserver",  "myfileserver";

desc "Get the uptime of all server";
task "uptime",  group => "myserver",  
sub {
	say run "uptime";
}
