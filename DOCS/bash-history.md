#### Bash history usage

	!!              - Last command and all arguments
	!-3             - Third-to-last command and all arguments
	!^              - First argument of last command
	!:2             - Second argument of last command
	!:2-5           - Second to fifth argument of last command
	!$              - Last argument of last command
	!*              - All arguments of the last command
	!42             - Expands to the 42nd command in history
	!foo            - Last command beginning with 'foo'
	!?foo           - Last command containing 'foo'
	^foo^bar        - Last command with first instance of 'foo' replaced with 'bar'
	!:gs/foo/bar    - Last command with all instances of 'foo' replaced with 'bar
	`<command>`:p     - Don't execute and print command"
