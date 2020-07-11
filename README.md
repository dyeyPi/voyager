Documentation for memory_check script.\

Made using CentsOS 6.10, Virtual Box, Nano editor, and Github.\

Usage: ./memory_check -c 90 -w 60 -e user@host.com\

Parameters:\
	-c critical threshold (percentage 0-100)\
	-w warning threshold (percentage 0-100)\ 
	-e email address to send the report\

Conditions:\
	c and w  ..must be a valid integer with the given range\
	c > w	 ..c must be greater than w for input to be accepted\
	e	 ..a simple heuristic has been applied to check for @ and .com\
	-param<space>arg ..must follow convetional option to value format\

Return Values:\
	format message   ..if input is not valid, the default usage will be shown\
	2  c > usage     ..if usage reached critical threshold value\
	1  c < w > usage ..if usage reached warning but less than critical\
	0 usage < c && w ..if usage less than warning threshold.\
	
Limitations:\
	email	..heuristics must be set in accordance to organization pattern checking\
	restrictions ..depends on the system access\
	processes ..not included with the scope\

Further improvements:\
	 ..message prompt to provided email that can contain logs\
	 ..date format customized to sync with local time\
	 ..automatic system restart, process halts, and node linking\

